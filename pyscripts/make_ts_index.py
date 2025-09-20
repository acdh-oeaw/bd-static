import glob
import os

from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import (
    extract_fulltext,
)
from tqdm import tqdm
from typesense.api_call import ObjectNotFound

files = glob.glob("./data/editions/*.xml")
tag_blacklist = [
    "{http://www.tei-c.org/ns/1.0}abbr",
    "{http://www.tei-c.org/ns/1.0}del",
    "{http://www.tei-c.org/ns/1.0}pc",
]

COLLECTION_NAME = "baedeker"

try:
    client.collections[COLLECTION_NAME].delete()
except ObjectNotFound:
    pass

current_schema = {
    "name": COLLECTION_NAME,
    "enable_nested_fields": True,
    "fields": [
        {"name": "id", "type": "string", "sort": True},
        {"name": "rec_id", "type": "string", "sort": True},
        {"name": "title", "type": "string", "sort": True},
        {"name": "full_text", "type": "string", "sort": True},
        {"name": "band", "type": "string", "facet": True},
        {"name": "concepts", "type": "object[]", "facet": True, "optional": True},
    ],
}


client.collections.create(current_schema)
dates = set()
records = []
cfts_records = []
for x in tqdm(files, total=len(files)):
    cfts_record = {
        "project": COLLECTION_NAME,
    }
    record = {}

    doc = TeiReader(x)
    try:
        body = doc.any_xpath(".//tei:body")[0]
    except IndexError:
        print("foo")
        continue
    try:
        record["band"] = doc.any_xpath(".//tei:title[@level='m']")[0].text
    except IndexError:
        record["band"] = "Nordamerika. Handbuch für Reisende: Digitale Ausgabe"
    record["id"] = os.path.split(x)[-1].replace(".xml", "")
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = (
        f"https://acdh-oeaw.github.io/bd-static/{record['id']}.html"
    )
    record["rec_id"] = os.path.split(x)[-1].replace(".xml", "")
    cfts_record["rec_id"] = record["rec_id"]
    record["title"] = extract_fulltext(
        doc.any_xpath(".//tei:titleStmt/tei:title[@level='a']")[0]
    )
    cfts_record["title"] = record["title"]
    record["full_text"] = extract_fulltext(body, tag_blacklist=tag_blacklist)
    cfts_record["full_text"] = record["full_text"]
    concepts = []
    for y in doc.any_xpath(".//tei:item[@corresp and @n]"):
        concept = {}
        concept["id"] = y.attrib["corresp"].replace("t:", "")
        concept["label"] = y.attrib["n"]
        concepts.append(concept)
    record["concepts"] = concepts
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections[COLLECTION_NAME].documents.import_(records)
print(make_index)
print(f"done with indexing {COLLECTION_NAME}")

make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
print(make_index)
print(f"done with cfts-index {COLLECTION_NAME}")
