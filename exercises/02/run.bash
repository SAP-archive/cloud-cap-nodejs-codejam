#!/bin/bash

# https://github.com/SAP-samples/cloud-cap-nodejs-codejam/tree/master/exercises/02

echo EXERCISE 02

echo 1. Initialize a new CAP project
cds init bookshop --add hana,mta && cd bookshop

echo 2. Open the project in VS Code \(NOP\)

echo 3. Explore the initialized project structure \(NOP\)

echo 4. Create a simple data model and service definition
cat <<EOSCHEMA > db/schema.cds
namespace my.bookshop;

entity Books {
  key ID : Integer;
  title  : String;
  stock  : Integer;
}
EOSCHEMA

cat <<EOSERVICE > srv/service.cds
using my.bookshop as my from '../db/schema';

service CatalogService {
  entity Books as projection on my.Books;
}
EOSERVICE

echo 5. Examine the data model and service definition \(NOP\)

echo 6. Install the dependencies
npm install

echo 7. Start up the service \(NOP\)

echo 8. Explore the OData service \(NOP\)
