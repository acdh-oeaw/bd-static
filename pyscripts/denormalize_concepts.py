import glob
import os

import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash
from rdflib import RDF, SKOS, Graph, Literal
from tqdm import tqdm

print("creating schlagworte.xml")
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
    prefLabel = None
    for label in g.objects(subject=concept, predicate=SKOS.prefLabel):
        if isinstance(label, Literal) and label.language == "de":
            prefLabel = label
            break

    definition = None
    for d in g.objects(subject=concept, predicate=SKOS.definition):
        if isinstance(d, Literal) and d.language == "de":
            definition = d
            break

    # Get broader concepts with their labels; would bloat the TEIs for very little added value
    broader_concepts = []
    # for obj in g.objects(subject=concept, predicate=SKOS.broader):
    #     broader_label = g.value(subject=obj, predicate=SKOS.prefLabel, lang="de")
    #     broader_concepts.append({
    #         'uri': str(obj),
    #         'label': str(broader_label) if broader_label else str(obj)
    #     })

    # Get narrower concepts with their labels
    narrower_concepts = []
    # for obj in g.objects(subject=concept, predicate=SKOS.narrower):
    #     narrower_label = g.value(subject=obj, predicate=SKOS.prefLabel, lang="de")
    #     narrower_concepts.append({
    #         'uri': str(obj),
    #         'label': str(narrower_label) if narrower_label else str(obj)
    #     })

    key = str(concept)
    value = {
        "prefLabel": str(prefLabel) if prefLabel else None,
        "definition": str(definition) if definition else None,
        "broader": broader_concepts,
        "narrower": narrower_concepts,
    }
    item = ET.Element(
        "{http://www.tei-c.org/ns/1.0}item",
        attrib={"corresp": key.replace(domain, "t:"), "n": value["prefLabel"]},
    )
    term = ET.SubElement(item, "{http://www.tei-c.org/ns/1.0}term")
    term.text = value["prefLabel"]
    note = ET.SubElement(
        item, "{http://www.tei-c.org/ns/1.0}note", attrib={"type": "definition"}
    )
    note.text = (
        value["definition"] if value["definition"] else "No definition available."
    )
    # if value["broader"]:
    #     list_relation = ET.SubElement(
    #         item,
    #         "{http://www.tei-c.org/ns/1.0}listRelation",
    #         attrib={"type": "broader"},
    #     )
    #     for broader in value["broader"]:
    #         relation = ET.SubElement(
    #             list_relation,
    #             "{http://www.tei-c.org/ns/1.0}relation",
    #             attrib={
    #                 "active": key,
    #                 "passive": broader["uri"],
    #                 "n": broader["label"],
    #             },
    #         )
    # if value["narrower"]:
    #     list_relation = ET.SubElement(
    #         item,
    #         "{http://www.tei-c.org/ns/1.0}listRelation",
    #         attrib={"type": "narrower"},
    #     )
    #     for narrower in value["narrower"]:
    #         relation = ET.SubElement(
    #             list_relation,
    #             "{http://www.tei-c.org/ns/1.0}relation",
    #             attrib={
    #                 "active": key,
    #                 "passive": narrower["uri"],
    #                 "n": narrower["label"],
    #             },
    #         )
    value["tei"] = item
    concept_info[key] = value

template = """
<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:base="https://baedeker-digital.acdh.oeaw.ac.at" xml:id="schlagworte.xml">
    <teiHeader>
        <fileDesc>
            <titleStmt>
                <title>Schlagwortverzeichnis</title>
            </titleStmt>
            <publicationStmt>
                <p>Publication Information</p>
            </publicationStmt>
            <sourceDesc>
                <p>Genereated with `pyscripts/denormalize_concepts.py` from https://vocabs.acdh.oeaw.ac.at/traveldigital/ConceptScheme</p>
            </sourceDesc>
      </fileDesc>
  </teiHeader>
  <text>
        <body>
            <list type="concepts">
                <item></item>
            </list>
        </body>
  </text>
</TEI>
"""  # noqa: E501


skos_tei = TeiReader(template)
skos_tei_list = skos_tei.any_xpath(".//tei:list")[0]
for key, value in concept_info.items():
    skos_tei_list.append(value["tei"])
skos_tei.tree_to_file(f"{os.path.join('data', 'indices', 'schlagworte.xml')}")

print("write skos:Concepts as tei:term into back element")

for x in tqdm(files):
    doc = TeiReader(x)
    text_node = doc.any_xpath(".//tei:text")[0]
    for back in doc.any_xpath(".//tei:back"):
        back.getparent().remove(back)
    back_node = ET.SubElement(text_node, "{http://www.tei-c.org/ns/1.0}back")
    skos_refs = set()
    for ref in doc.any_xpath(".//tei:rs[@ref]/@ref"):
        for skos_id in ref.split():
            skos_uri = check_for_hash(skos_id).replace("t:", domain)
            skos_refs.add(skos_uri)
    if skos_refs:
        term_list = ET.SubElement(
            back_node, "{http://www.tei-c.org/ns/1.0}list", attrib={"type": "concepts"}
        )
        for ref in skos_refs:
            try:
                match = concept_info[ref]
            except KeyError:
                continue
            term_list.append(match["tei"])
    doc.tree_to_file(x)

print("done")
