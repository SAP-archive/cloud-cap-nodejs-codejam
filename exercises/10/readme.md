# Exercise 10 - Deploy the app to Cloud Foundry


In this exercise you'll make your project cloud-ready. In a cloud deployment, all modules will run as independent (but linked) applications. The modules, and the relationships between them, are described in the `mta.yaml` file in the project's root. There's one already there that's been generated because of the use of `--add mta` when the project was initialized in [exercise 02](../exercises/02/). In this exercise you'll make some modifications and additions to that file, and add a couple more resources too.


## Steps

At the end of these steps, your project will be cloud ready, built and deployed to SAP Cloud Platform Cloud Foundry Environment.

### 1. Sign in to Cloud Foundry

:point_right: Run the following command from your command line to log in to the referenced Cloud Foundry endpoint. When prompted use your SAP Cloud Platform credentials.

```
user@host:~/bookshop
=> cf login -a https://api.cf.eu10.hana.ondemand.com
```

### 2. Tailor the HDI container declaration to the trial landscape

We need to ensure that the correct HDI container will be used in the trial landscape. To do this, we need to make sure that the appropriate parameter is specified in the corresponding resource in `mta.yaml`.

:point_right: Edit the `mta.yaml` file, and to the `parameters` section (which should be at the end of the file), add a line "`service: hanatrial`". Here's what the section should look like after the edit:

```yaml
##############  RESOURCES  ##################################
resources:
 ##### Services extracted from CAP configuration  ####
 ##### 'service-plan' can be configured via 'cds.requires.<name>.vcap.plan'
 - name: bookshop-db
   type: com.sap.xs.hdi-container

   parameters:
     service: hanatrial
   properties:
     hdi-service-name: ${service-name}   # required for Java case
############################################################
```

> Take care to get the whitespace and indentation right, and remember that there are no tabs allowed in YAML files!

This step is only necessary when you want to deploy the project to the trial landscape.


### 3. Add a module definition to `mta.yaml` for the UI

The `mta.yaml` file contains module definitions for the service and the database, but not (yet) for the Fiori-based UI. You'll do that now in this step.

:point_right: Edit `mta.yaml` and add the following module definition, directly below the `modules:` line, and before the server module definition (`bookshop-srv`) which starts with a "#### SERVER MODULE ####" style comment line:

```yaml
modules:
 ##############    UI MODULE   ##########################
 - name: bookshop-ui
   type: nodejs
   path: app
   parameters:
     memory: 256M
     disk-quota: 256M
   requires:
     - name: srv-binding
       group: destinations
       properties:
         forwardAuthToken: true
         strictSSL: true
         name: srv-binding
         url: ~{srv-url}

 ##############    SERVER MODULE   ##########################
 - name: bookshop-srv
   type: nodejs
   [...]
```

> The `bookshop-ui` module is shown here in context so you can see where to insert it - make sure you only add the lines for this module, and again, make sure you get the whitespace right.


### 4. Add a module descriptor file for the srv module

You might have noticed that there is no descriptor for the `srv` module defined. For local development, such a descriptor is not needed as CAP knows how to parse those files. For the deployment to Cloud Foundry, on the other hand, a descriptor is required, to define the module dependencies and start commands.

:point_right: Create a new `package.json` file in the `srv/` directory, and add the following content representing the server module, to make it cloud-ready:

```json
{
    "name": "bookshop-srv",
    "version": "1.0.0",
    "dependencies": {
        "@sap/cds": "^3.18.4",
        "express": "^4.17.1",
        "@sap/hana-client": "^2.4.167"
    },
    "engines": {
        "node": "^10"
    },
    "scripts": {
        "start": "cds serve gen/csn.json"
    },
    "cds": {
        "requires": {
            "db": {
                "kind": "hana",
                "model": "gen/csn.json"
            }
        }
    }
}
```

### 5. Add the app router configuration

Similar to the `srv` module, we need to add a descriptor file for the `app` module as well. We will embed the UI source files into an app router, to be able to connect to the `srv` module and to forward requests to it.

:point_right: Create a new `package.json` file in the `app/` directory with the following content, to start this module as an independent app router application within Cloud Foundry:

```json
{
    "name": "bookshop-ui",
    "dependencies": {
        "@sap/approuter": "^6.6.0"
    },
    "engines": {
        "node": "^10"
    },
    "scripts": {
        "start": "node node_modules/@sap/approuter/approuter.js"
    }
}
```

:point_right: Add a new file `xs-app.json` to the same directory (`app/`), with the following content, to configure the app router:

```json
{
    "welcomeFile": "webapp/",
    "authenticationMethod": "none",
    "routes": [{
        "source": "^/webapp/(.*)$",
        "target": "$1",
        "localDir": "webapp/"
    }, {
        "source": "^(.*)$",
        "destination": "srv-binding"
    }]
}

```

This file not only defines the welcome page, but also defines which requests are forwarded to which Cloud Foundry application.


### 6. Specify HANA as a database in the configuration

We're about to deploy to HANA in the form of an HDI container on the trial landscape of SAP Cloud Platform Cloud Foundry. This means we need to ensure we have the right configuration for the database, so that things get built correctly. This can be done in the `package.json` file. 

:point_right: In the root level `package.json` file, find the `cds -> requires -> db` node and add another section for `[production]`, like this:

```cds
"[production]": {
  "kind": "hana"
},
```

'
so it then looks like this:

```cds
  "cds": {
    "requires": {
      "db": {
        "kind": "sqlite",
        "model": [
          "db/",
          "srv/",
          "app/"
        ],
        "[production]": {
          "kind": "hana"
        },
        "credentials": {
          "database": "db.db"
        }
      }
    }
  },
```

The "hana" value of "kind" will now be used in place of "sqlite" when the "production" profile is used. See the [Runtime Configuration for Node.js](https://cap.cloud.sap/docs/advanced/config) section of the CAP documentation for more details.


### 7. Add npm scripts to trigger the deployment

So far, the `package.json` file in your project root only defines scripts for local project execution.


:point_right: Add the following script definition to the `"scripts"` section of the **project's root `package.json`** for build step processes:

```json
"build:mta": "cds build/all && mbt build -p=cf"
```

You might have noticed, that the `mbt` command isn't a typical shell command. This is actually a command from another Node.js package. `mbt` allows you to package your project into a deployable archive, which you'll need in order to get the app onto the SAP Cloud Platform.

:point_right: Install this package locally in your project to allow its usage in the npm scripts, like this:

```
user@host:~/bookshop
=> npm install mbt
```

### 8. Build the project
We're almost there. To make our project ready for deployment, we need to package it into a single archive which can be used a delivery unit.

:point_right: Trigger the build process with the following command, specifying "production" for the `NODE_ENV` environment variable:

```
NODE_ENV=production npm run build:mta
```

If you're running Windows then you'll need to set the environment variable first with `set` and then run the command, like this:

```
set NODE_ENV production
npm run build:mta
```

> If you want to run the two commands (`cds build/all` and `mbt build -p=cf`) manually, one after the other, to see what they do, note that you'll have to use `npx` to run the `mbt` command, like this: `npx mbt build -p=cf`. In fact, the latest version of `mbt` has the value `cf` as the default for the `-p` ('platform') flag, so you don't actually need to specify this explicitly.


### 9. Deploy the archive

Now you should see a new directory `mta_archives/` which contains an archive file named with the `ID` and `version` we defined in the `mta.yaml` descriptor. One command is all it takes to deploy your project to the cloud.

:point_right: Execute the following command to trigger the deployment process:

```
user@host:~/bookshop
=> cf deploy mta_archives/bookshop_1.0.0.mtar
```


### 10. Check the apps and services in Cloud Foundry

You can and should check the status of what you've deployed to your trial Cloud Foundry environment on the SAP Cloud Platform.

Use the following commands do to this:

```
cf apps
cf services
```

## Summary

You have learned the basic commands to interact with the Cloud Foundry Command Line Interface to check the state of the deployed applications. You also added the necessary scripts to your project to automate the build and deploy steps via the command line.

## Questions

1. Can you guess what the second subcommand of the `build:mta` script does? Are you able to run this command (`mbt build -p=cf`) straight from the terminal?
<!-- no bc it's installed locally, but works with npx prefix -->

2. When you run the commands to check the apps and services, what do you see? Are all apps in the "Running" state?
<!-- db is stopped-->

