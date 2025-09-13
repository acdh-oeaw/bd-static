import glob
import os

import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from rdflib import RDF, SKOS, Graph
from tqdm import tqdm

files = sorted(glob.glob("./data/editions/*xml"))
domain = "https://vocabs.acdh.oeaw.ac.at/traveldigital/"

g = Graph()
skos_file = os.path.join("data", "indices", "skos.rdf")
g.parse(skos_file)

concepts = set()
for s, p, o in g.triples((None, RDF.type, SKOS.Concept)):
    concepts.add(s)

concept_info = {}
for concept in concepts:
    prefLabel = g.value(subject=concept, predicate=SKOS.prefLabel)
    definition = g.value(subject=concept, predicate=SKOS.definition)

    # Get broader concepts with their labels
    broader_concepts = []
    for obj in g.objects(subject=concept, predicate=SKOS.broader):
        broader_label = g.value(subject=obj, predicate=SKOS.prefLabel)
        broader_concepts.append(
            {
                "uri": str(obj),
                "label": str(broader_label) if broader_label else str(obj),
            }
        )

    # Get narrower concepts with their labels
    narrower_concepts = []
    for obj in g.objects(subject=concept, predicate=SKOS.narrower):
        narrower_label = g.value(subject=obj, predicate=SKOS.prefLabel)
        narrower_concepts.append(
            {
                "uri": str(obj),
                "label": str(narrower_label) if narrower_label else str(obj),
            }
        )

    key = str(concept)
    value = {
        "prefLabel": str(prefLabel) if prefLabel else None,
        "definition": str(definition) if definition else None,
        "broader": broader_concepts,
        "narrower": narrower_concepts,
    }
    item = ET.Element(
        "{http://www.tei-c.org/ns/1.0}item",
        attrib={
            "{http://www.w3.org/XML/1998/namespace}id": key,
            "n": value["prefLabel"],
        },
    )
    term = ET.SubElement(item, "{http://www.tei-c.org/ns/1.0}term")
    term.text = value["prefLabel"]
    note = ET.SubElement(item, "{http://www.tei-c.org/ns/1.0}note")
    note.text = (
        value["definition"] if value["definition"] else "No definition available."
    )
    if value["broader"]:
        list_relation = ET.SubElement(
            item,
            "{http://www.tei-c.org/ns/1.0}listRelation",
            attrib={"type": "broader"},
        )
        for broader in value["broader"]:
            relation = ET.SubElement(
                list_relation,
                "{http://www.tei-c.org/ns/1.0}relation",
                attrib={
                    "active": key,
                    "passive": broader["uri"],
                    "n": broader["label"],
                },
            )
    if value["narrower"]:
        list_relation = ET.SubElement(
            item,
            "{http://www.tei-c.org/ns/1.0}listRelation",
            attrib={"type": "narrower"},
        )
        for narrower in value["narrower"]:
            relation = ET.SubElement(
                list_relation,
                "{http://www.tei-c.org/ns/1.0}relation",
                attrib={
                    "active": key,
                    "passive": narrower["uri"],
                    "n": narrower["label"],
                },
            )
    value["tei"] = item
    concept_info[key] = value

for x in tqdm(files):
    doc = TeiReader(x)
