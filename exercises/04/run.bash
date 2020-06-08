#!/bin/bash

# https://github.com/SAP-samples/cloud-cap-nodejs-codejam/tree/master/exercises/04

echo EXERCISE 04

cd bookshop

echo 1. Bring sample CSV files in the project
mkdir db/csv
cat <<EOAUTHORS > db/csv/my.bookshop-Authors.csv
ID,NAME
42,Douglas Adams
101,Emily Brontë
107,Charlote Brontë
150,Edgar Allen Poe
170,Richard Carpenter
EOAUTHORS

cat <<EOBOOKS > db/csv/my.bookshop-Books.csv
ID,TITLE,AUTHOR_ID,STOCK
421,The Hitch Hiker's Guide To The Galaxy,42,1000
427,"Life, The Universe And Everything",42,95
201,Wuthering Heights,101,12
207,Jane Eyre,107,11
251,The Raven,150,333
252,Eleonora,150,555
271,Catweazle,170,22
EOBOOKS

echo 2. Redeploy to the persistence layer
cds deploy

echo 3. Restart the service \(NOP\)

echo 4. Try out some OData Query operations \(NOP\)
