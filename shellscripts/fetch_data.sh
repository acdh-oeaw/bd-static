# bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data/
curl -LO https://github.com/acdh-oeaw/bd-data/archive/refs/heads/main.zip
unzip main

mv ./bd-data-main/data/ .

rm main.zip
rm -rf ./bd-data-main

echo "fetch imprint"
./shellscripts/dl_imprint.sh
