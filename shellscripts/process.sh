#!/bin/bash

echo "adding xml:ids"
uv run add-attributes -g "data/editions/*.xml" -b "https://baedeker-digital.acdh.oeaw.ac.at"