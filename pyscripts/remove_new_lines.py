import glob

from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

files = sorted(glob.glob("./data/editions/*.xml"))
ns = {"tei": "http://www.tei-c.org/ns/1.0"}

print(f"removing whitespaces in body in {len(files)} files")

for x in tqdm(files, total=len(files)):
    doc = TeiReader(x)

    body = doc.any_xpath(".//tei:body")[0]
    if body is None:
        continue
    for el in body.iter():
        if el is body:
            continue
        if el.tail and el.tail.strip() == "":
            el.tail = None
    doc.tree_to_file(x)
