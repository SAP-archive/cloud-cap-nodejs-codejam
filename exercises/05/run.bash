#!/bin/bash

# https://github.com/SAP-samples/cloud-cap-nodejs-codejam/tree/master/exercises/05

echo EXERCISE 05

cd bookshop


echo 1. Add a new entity Orders

cat <<EOORDERS > db/schema.cds
namespace my.bookshop;

entity Books {
  key ID : Integer;
  title  : String;
  stock  : Integer;
  author : Association to Authors;
}
entity Authors {
  key ID : Integer;
  name   : String;
  books  : Association to many Books on books.author = \$self;
}
entity Orders {
  key ID   : UUID;
  book     : Association to Books;
  quantity : Integer;
}
EOORDERS

cat <<EOORDERSSERVICE > srv/service.cds
using my.bookshop as my from '../db/schema';

service CatalogService {
  entity Books as projection on my.Books;
  entity Authors as projection on my.Authors;
  entity Orders as projection on my.Orders;
}
EOORDERSSERVICE

cds deploy


echo 2. Explore generic CDS features \(NOP\)


echo 3. Enhance the Orders entity

cat <<EOORDERSMOD > db/schema.cds
namespace my.bookshop;
using { cuid, managed, Country } from '@sap/cds/common';

entity Books {
  key ID : Integer;
  title  : String;
  stock  : Integer;
  author : Association to Authors;
}
entity Authors {
  key ID : Integer;
  name   : String;
  books  : Association to many Books on books.author = \$self;
}
entity Orders : cuid, managed {
  key ID   : UUID;
  book     : Association to Books;
  quantity : Integer;
  country  : Country;
}
EOORDERSMOD


echo 4. Restart the service manually and check the output
cds deploy


echo 5. Examine what the Orders entity looks like now \(NOP\)


echo 6. Create some entries in the Orders entity

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


echo 7. Examine the data in the Orders entityset \(NOP\)
