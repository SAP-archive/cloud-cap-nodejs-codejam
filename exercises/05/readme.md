# Exercise 05 - Adding a further entity, using generic features

In this exercise you'll add a further entity to the data model and expose it through the service. In defining this entity you'll make use of some [generic features](https://cap.cloud.sap/docs/cds/common) available for all CAP projects.


## Steps

At the end of these steps you'll have a third entity `Orders`, and will have performed some OData Create operations upon it.


### 1. Add a new entity Orders

If this is a bookshop service, we need to be able to place orders. So you should now add a third entity to the data model, for those orders.

:point_right: Open the `db/schema.cds` file and first of all add this third entity (not forgetting to save the file when you're done):

```cds
entity Orders {
  key ID   : UUID;
  book     : Association to Books;
  quantity : Integer;
}
```

We're not quite done with this entity, but for now, you're about to have a first look at the fruits of your labor by adding a new entry to the service definition for this entity.

:point_right: Add the entry to the `CatalogService` service definition in the `srv/service.cds` file:

```
service CatalogService {
    entity Books as projection on my.Books;
    entity Authors as projection on my.Authors;
    entity Orders as projection on my.Orders;    // <-- new
}
```

Observe that the CDS Language Service extension picks up the new `Orders` entity straight away (as long as you've saved the `db/schema.cds` file) and offers it as a suggestion in the code completion feature.

:point_right: Noting that your service has been automatically restarted (by `cds watch`) already, take a look at the new `Orders` entity: <http://localhost:4004/catalog/Orders>.

You should see an error both in the response returned, and in the service log output, that looks something like this:

```
SQLITE_ERROR: no such table: CatalogService_Orders
```

That's because we still need to deploy the changes to the persistence layer, to have a new table and view created there for the `Orders` entity.

:point_right: Do this now (note that the CSV data will be used again to seed the tables):

```sh
user@host:~/bookshop
=> cds deploy
 > filling my.bookshop.Authors from db/csv/my.bookshop-Authors.csv
 > filling my.bookshop.Books from db/csv/my.bookshop-Books.csv
/> successfully deployed database to bookshop.db
user@host:~/bookshop
=>
```

> If you want to make sure that the new table and view are there now, you can check with `sqlite3 bookshop.db .tables`.

:point_right: Once you've redeployed, restart `cds watch`:

```sh
user@host:~/bookshop
=> cds watch
```

The `Orders` entity is now available in the service (but there is [no data](http://localhost:4004/catalog/Orders) as yet).


### 2. Explore generic CDS features

When a new order comes in we want to capture the date and time. If we were running in an authenticated environment (in this CodeJam we're not, but CAP supports it) we also want to capture the user associated with the creation. Similarly we want to capture modification information.

We can use some [common CDS definitions](https://cap.cloud.sap/docs/guides/domain-models#use-common-reuse-types) that are available to us, built into `@sap/cds` itself. These definitions can be found in the file `@sap/cds/common.cds` in the `node_modules/` directory.

:point_right: Use the Explorer view in VS Code to open up the directories under `node_modules/` in the project, to find the `common.cds` file and open it up. In particular, find and examine the `managed` [aspect](https://cap.cloud.sap/docs/cds/common#aspect-managed), as well as the abstract entity `cuid`.

![looking at common.cds](common-cds.png)


### 3. Enhance the Orders entity

You will now enhance the `Orders` entity using some of the common features made available in `@sap/cds/common.cds`:

- using the canonical universal ID field
- adding creation and modification information
- adding a country property referring to the `Country` type

:point_right: First, import the common features to the data model file by adding the following line to `db/schema.cds`, on the line below the `namespace` declaration:

```cds
using { cuid, managed, Country } from '@sap/cds/common';
```

These features are now available to use in our entity definitions.

:point_right: Now remove the explicit key property definition (`ID`), and instead, add the `cuid` aspect as shown:

```
entity Orders : cuid {
  book     : Association to Books;
  quantity : Integer;
}
```

The use of `cuid` in this position will cause a key property of type `UUID` to be added implicitly to this entity definition.

:point_right: Now also add the `managed` aspect to the entity thus:

```
entity Orders : cuid, managed {
  book     : Association to Books;
  quantity : Integer;
}
```

This will cause the implicit inclusion of four properties in this entity (these are the `createdAt`, `createdBy`, `modifiedAt` and `modifiedBy` properties from the `managed` type definition in `@sap/cds/common.cds` we examined earlier in this exercise).

:point_right: Finally add a new explicit property `country`, described by the `Country` type which you imported from `@sap/cds/common`:

```
entity Orders : cuid, managed {
  book     : Association to Books;
  quantity : Integer;
  country  : Country;
}
```

Note the difference in capitalization here. The property name is `country` which is described by the type `Country`.


### 4. Restart the service manually and check the output

While the `cds watch` is useful, it supresses various messages to keep the noise down. But there's something in those suppressed messages that you should pay attention to.

:point_right: Terminate any running `cds watch` process, and run `cds deploy && npm start` manually:

```sh
user@host:~/bookshop
=> cds deploy && npm start
 > filling my.bookshop.Authors from db/csv/my.bookshop-Authors.csv
 > filling my.bookshop.Books from db/csv/my.bookshop-Books.csv
/> successfully deployed to ./bookshop

> bookshop@1.0.0 start /tmp/codejam/bookshop
> npx cds run

[cds] - connect to datasource - sqlite:bookshop
[cds] - serving CatalogService at /catalog
[cds] - service definitions loaded from:

  srv/service.cds
  db/schema.cds
  node_modules/@sap/cds/common.cds

[cds] - launched in: 875.646ms
[cds] - server listening on http://localhost:4004 ...
[ terminate with ^C ]
```

> If your operating system command line doesn't support `&&` then just run the two commands one after the other.

Notice the extra line in the output of the "service definitions loaded from" message. It shows us that not only are definitions being loaded from what we've defined explicitly (i.e. our `srv/service.cds` and `db/schema.cds` files) but also, implicitly, from `node_modules/@sap/cds/common.cds` because of our reference to it in `db/schema.cds` in the `using` statement.



### 5. Examine what the Orders entity looks like now

Following the enhancements, it's worth taking a look at what the `Orders` entity looks like now.

Open the [metadata document](http://localhost:4004/catalog/$metadata) and find the specific definition of the `Orders` entity within the XML. It should look like this:

![Orders entity definition](orders-entity.png)

Note the type of the `ID` property, the properties resulting from the use of the `managed` aspect, and the navigation property between the `Orders` entity and a new `Countries` entity.


### 6. Create some entries in the Orders entity

Put the new entity through its paces by performing some OData Create operations to insert orders. An OData Create operation is carried out with an HTTP POST request. If you're confident on the command line and have `curl` installed, you can do this with those tools. Otherwise, you can use Postman (which you will have installed as part of the software [prerequisites](../../prerequisites.md)).

An OData Create operation (request and response) to insert a new order looks in raw form like this:

> This specific request/response pair is just for illustration - you do not have to enter it yourself

Request:
```
POST /catalog/Orders HTTP/1.1
Host: localhost:4004
Content-Type: application/json
Content-Length: 29

{"book_ID":421, "quantity":5}
```

Response:
```
HTTP/1.1 201 Created
X-Powered-By: Express
OData-Version: 4.0
content-type: application/json;odata.metadata=minimal
Location: Orders(d9a2ffd5-ecc4-47aa-a91f-e88f70b7adf9)
Date: Mon, 25 Mar 2019 13:47:38 GMT
Connection: keep-alive
Content-Length: 306

{"@odata.context":"$metadata#Orders/$entity","@odata.metadataEtag":"W/\"s2St6s/UTUxSfYEFAcOmOIuoSKQn7qxgEm65c/QqjAs=\"","ID":"d9a2ffd5-ecc4-47aa-a91f-e88f70b7adf9","modifiedAt":null,"createdAt":"2019-03-25T13:47:38Z","createdBy":"anonymous","modifiedBy":null,"quantity":5,"book_ID":421,"country_code":null}
```

If you want to create the Orders entities using the command line with `curl`, here's what you can do. Otherwise, skip to the [Using Postman](#postman) section.

<a name="curl"></a>**Using `curl` on the command line**

:point_right: Order 5 copies of Wuthering Heights (no order ID specified):

```sh
curl \
  -d '{"book_ID":201,"quantity":5}' \
  -H 'Content-Type: application/json' \
  http://localhost:4004/catalog/Orders
```

For Windows users, this is the equivalent command (basically you have to use double quotes throughout, and therefore some must be escaped with `\`, and the line continuation character is `^` rather than `\`):

```sh
curl ^
  -d "{\"book_ID\":201,\"quantity\":5}" ^
  -H "Content-Type: application/json" ^
  http://localhost:4004/catalog/Orders
```

:point_right: Order 9 copies of Life, The Universe And Everything (specifying an order ID):

```sh
curl \
  -d '{"ID": "527ef85a-aef2-464b-89f6-6a3ce64f2e14", "book_ID":427,"quantity":9}' \
  -H 'Content-Type: application/json' \
  http://localhost:4004/catalog/Orders
```

For Windows users:
```sh
curl ^
  -d "{\"ID\": \"527ef85a-aef2-464b-89f6-6a3ce64f2e14\", \"book_ID\":427,\"quantity\":9}" ^
  -H "Content-Type: application/json" ^
  http://localhost:4004/catalog/Orders
```

<a name="postman"></a>**Using Postman**

Instead of using `curl` you can use Postman. There are some OData Create operations for this Orders entity prepared for you in a form that can be imported into Postman. Do that now.

:point_right: Launch Postman and import a collection using the "Import From Link" feature in this dialogue box:

![importing a collection into Postman](import-collection.png)

For the URL, use the link to this [postman-05.json](https://raw.githubusercontent.com/SAP/cloud-cap-nodejs-codejam/master/exercises/05/postman-05.json) resource.

:point_right: Use the two requests in the 'exercise 05' folder in this imported collection to order books, noting how one request specifies an order ID and the other does not.

![Postman request collection](postman-collection.png)


### 7. Examine the data in the Orders entityset

Once you've made a few OData Create operations, have a look at the results in the `Orders` entityset.

:point_right: Open up the [Orders entityset](http://localhost:4004/catalog/Orders) and confirm that orders have been created, noting in particular the values in the `createdAt` properties, as well as the values for the `ID` properties where you didn't specify values when making the requests.


## Summary

At this point you have a meaningful OData service with data and against which you are now confidently performing various read and write OData operations.



## Questions

1. We added a field `country` described by the type `Country`. What exactly is this type, and what does it bring about in the resulting service's metadata?
<!--- string(3), code list --->

2. Are there any issues with the way we have set up the service definition right now?
<!--- all public, still just effectively a "pass-through" from schema up through service, no separation or differences at the service end. No real point at this stage in having these two separate layers (that will change though) --->
