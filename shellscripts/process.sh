#!/bin/bash

echo "adding xml:ids"
uv run add-attributes -g "data/editions/*.xml" -b "https://baedeker-digital.acdh.oeaw.ac.at"
uv run pyscripts/remove_new_lines.py
uv run denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/listperson*.xml" -m ".//tei:persName/@ref" -x ".//tei:titleStmt/tei:title[@level='a'][1]/text()"
uv run pyscripts/denormalize_concepts.py