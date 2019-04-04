# Exercise 07 - Defining a second service

In this exercise you'll enhance the service definition by introducing a second service that sits on top of the same underlying data model. You'll see that you can define as many services on the same data model as you need, either in the same service definition file, or in separate files. In this exercise you'll define the second service in the same file.

The scenario is that a service is required to provide an analysis frontend with basic statistics on book orders, and nothing else - so there's no need (or desire) to expose the rest of the data model to this frontend.


## Steps

At the end of these steps, you'll have two OData services both exposing different views on the same underlying data model.


### 1. Add a new service definition

Service definitions can live alongside each other in the same CDS file.

:point_right: In `srv/cat-service.cds`, add a second service definition thus:

```cds
service Stats {
    @readonly entity OrderInfo as projection on my.Orders excluding {
        createdAt,
        createdBy,
        modifiedAt,
        modifiedBy,
        book,
        country
    }
}
```

Here the `Stats` service exposes the Orders entity in a read-only fashion as in the `CatalogService`, but uses the `excluding` clause to omit specific properties. These properties are not of interest to the analysis UI so are explicitly left out. Note that it also exposes the information as an entity called `OrderInfo`.

:point_right: Now redeploy and start serving the services (`cds deploy && cds serve all`) and check the root document at [http://localhost:4004/](http://localhost:4004/). You should see something like this:

![two services](two-services.png)


### 2. Create multiple orders

Now let's create a number of orders, and see what the `OrderInfo` entityset shows us. We can do this quickly using another Postman collection, and using Postman's "Collection Runner" feature.

Note: If you want to do this using `curl`, jump to the [using curl](#curl) section.

**Using Postman**

:point_right: Import another collection into Postman from the URL to this resource: [postman-07.json](https://raw.githubusercontent.com/qmacro/codejam-cap-nodejs/master/exercises/07/postman-07.json).

This screenshot shows what the collection looks like (it contains multiple POST requests to create orders for various books) and also shows the extra options which allows all the requests in the collection to be executed in one go:

![Postman collection](postman-collection-07.png)

:point_right: After importing this collection, click the arrow to the right of the collection name to expand the options as shown, and select the small blue "Run" button which will open up the "Collection Runner" window:

![Collection Runner window](collection-runner.png)

:point_right: Use the large blue "Run ..." button to execute all the requests - a results window should appear.

<a name="curl"></a>**Using curl**

Order 2 copies of Wuthering Heights:
```
curl \
  -d '{"book_ID":201,"quantity":2}' \
  -H 'Content-Type: application/json' \
  http://localhost:4004/catalog/Orders
```

Order 7 copies of Eleonora:
```
curl \
  -d '{"book_ID":252,"quantity":7}' \
  -H 'Content-Type: application/json' \
  http://localhost:4004/catalog/Orders
```

Order 42 copies of The Hitch Hiker's Guide To The Galaxy (obviously!):
```
curl \
  -d '{"book_ID":421,"quantity":42}' \
  -H 'Content-Type: application/json' \
  http://localhost:4004/catalog/Orders
```


Now it's time to take a look at what the service will show us for these orders. We know we can't look at the `Orders` entityset as it has a `@insertonly` annotation shortcut based restriction, so we turn to our new service `Stats`.

:point_right: Look at the [http://localhost:4004/stats/OrderInfo](http://localhost:4004/stats/OrderInfo) entityset in the `Stats` service. You should see something like this:

![OrderInfo entityset](orderinfo-entityset.png)

It shows us only the quantity statistics for the orders, just what we want for our simple analysis frontend.


## Summary

It's easy to explore building different views on the same underlying data model, views that are focused and appropriate for different consumers, whether they are user interfaces or API clients.


## Questions

1. Why might it be better to specify properties to _exclude_, rather than properties to _include_?

1. What did the order creation HTTP requests look like - which service was used, and why?
