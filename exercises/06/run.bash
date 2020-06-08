#!/bin/bash

# https://github.com/SAP-samples/cloud-cap-nodejs-codejam/tree/master/exercises/06

echo EXERCISE 06

cd bookshop


echo 1. Import a collection of HTTP requests into Postman \(NOP\)


echo 2. Test the existing write access to Books and Authors

cat <<EOSERVICE > srv/service.cds
using my.bookshop as my from '../db/schema';

service CatalogService {
  entity Books as projection on my.Books;
  entity Authors as projection on my.Authors;
  entity Orders as projection on my.Orders;
}
EOSERVICE


cds run > run.log 2>&1 &
CDSPID=$!
sleep 2

curl -X DELETE 'http://localhost:4004/catalog/Books(44138)'
curl -X DELETE 'http://localhost:4004/catalog/Authors(162)'

curl \
    -d '{"ID": 162, "name": "Iain M Banks"}' \
    -H 'Content-Type: application/json' \
    http://localhost:4004/catalog/Authors

curl \
    -d '{"ID": 44138, "title": "Consider Phlebas", "stock": 541, "author_ID": 162 }' \
    -H 'Content-Type: application/json' \
    http://localhost:4004/catalog/Books

kill $CDSPID


echo 3. Restrict access to the Books and Authors entities
cat <<EOSERVICEREADONLY > srv/service.cds
using my.bookshop as my from '../db/schema';

service CatalogService {
  @readonly entity Books as projection on my.Books;
  @readonly entity Authors as projection on my.Authors;
  entity Orders as projection on my.Orders;
}
EOSERVICEREADONLY


echo 4. Attempt to modify the Books and Authors entitysets

cds run > run.log 2>&1 &
CDSPID=$!
sleep 2

curl \
    -d '{"ID": 47110, "title": "The Player of Games", "stock": 405, "author_ID": 162 }' \
    -H 'Content-Type: application/json' \
    http://localhost:4004/catalog/Books

curl \
    -X DELETE \
    'http://localhost:4004/catalog/Books(251)'

kill $CDSPID


echo 5. Restrict access to the Orders entityset

cat <<EOSERVICEINSERTONLY > srv/service.cds
using my.bookshop as my from '../db/schema';

service CatalogService {
  @readonly entity Books as projection on my.Books;
  @readonly entity Authors as projection on my.Authors;
  @insertonly entity Orders as projection on my.Orders;
}
EOSERVICEINSERTONLY

cds run > run.log 2>&1 &
CDSPID=$!
sleep 2

curl \
    -d '{"book_ID":201,"quantity":5}' \
    -H 'Content-Type: application/json' \
    http://localhost:4004/catalog/Orders

curl \
    -d '{"ID": "527ef85a-aef2-464b-89f6-6a3ce64f2e14", "book_ID":427,"quantity":9}' \
    -H 'Content-Type: application/json' \
    http://localhost:4004/catalog/Orders

kill $CDSPID


