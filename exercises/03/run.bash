#!/bin/bash

# https://github.com/SAP-samples/cloud-cap-nodejs-codejam/tree/master/exercises/03

echo EXERCISE 03

cd bookshop

echo 1. Use cds watch to have the service restart on changes \(NOP\)

echo 2. Add a new Authors entity to the model
cat <<EOSCHEMA > db/schema.cds
namespace my.bookshop;

entity Books {
  key ID : Integer;
  title  : String;
  stock  : Integer;
}
entity Authors {
  key ID : Integer;
  name   : String;
}
EOSCHEMA

echo 3. Expose the Authors entity in the service
cat <<EOSERVICE > srv/service.cds
using my.bookshop as my from '../db/schema';

service CatalogService {
  entity Books as projection on my.Books;
  entity Authors as projection on my.Authors;
}
EOSERVICE

echo 4. Add a relationship between the Books and Authors entities
cat <<EORELATIONS > db/schema.cds
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
EORELATIONS

echo 5. Deploy the service to a persistence layer
npm install -D sqlite3
cds deploy --to sqlite:bookshop.db

echo 6. Explore the new database \(NOP\)

echo 7. Dig into the link between the CDS definitions and the artefacts in the database \(NOP\)

