# Exercise 10 - Deploy the app to Cloud Foundry


In this exercise you'll make your project cloud-ready. In a cloud deployment, all modules will run as independent (but linked) applications. Therefore you need make add a couple of files to define the individual applications.


## Steps

At the end of these steps, your project will be deployed to SAP Cloud Platform Cloud Foundry Environment.

### 1. Sign in to Cloud Foundry

:point_right: Run the following command from your command line to log in to the referenced Cloud Foundry endpoint. When prompted use your SAP Cloud Platform credentials.

```
user@host:~/bookshop
=> cf login -a https://api.cf.eu10.hana.ondemand.com
```

### 2. Add a module descriptor file for the srv module

You might have noticed that there is no module descriptor for the `srv` module defined. For local development, such a descriptor is not needed as CAP knows how to parse those files. For the deployment to Cloud Foundry, on the other hand, a descriptor is required, to define the module dependencies and start commands.

:point_right: Create a new descriptor file `package.json` in the `srv/` directory, and add the following content representing the server module, to make it cloud-ready:

```json
{
    "name": "project-srv",
    "version": "1.0.0",
    "dependencies": {
        "@sap/cds": "^3.16.3",
        "express": "^4.17.1",
        "@sap/hana-client": "^2.4.144"
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



### 3. Add the app router configuration

Similar to the `srv` module, we need to add a module descriptor for the `app` module as well. We will embed the UI source files into an app router, to be able to connect to the `srv` module and to forward requests to it.

:point_right: Create a new `package.json` file in the `app/` directory with the following content, to start this module as an independent app router application within Cloud Foundry:

```json
{
  "name": "bookshop-ui",
  "dependencies": {
    "@sap/approuter": "^6.0.1"
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
        "destination": "srv_api"
    }]
}

```

This file not only defines the welcome page, but also defines which requests are forwarded to which Cloud Foundry application.

### 4. Add files to your db directory

Since we didn't define that we want to to run our application in the SAP Cloud Platform, we need to add a descriptor how to initiate loading CSV files for SAP HANA in SAP Cloud Platform. This would have been created automatically by providing `--db-technology hana` and `--mta` to `cds init`.

:point_right: Create a new file called `package.json` in the `db/` directory and paste the following content: 

```
{
  "name": "deploy",
  "dependencies": {
    "@sap/hdi-deploy": "^3.8.2"
  },
  "engines": {
    "node": "^8"
  },
  "scripts": {
    "postinstall": "node .build.js",
    "start": "node node_modules/@sap/hdi-deploy/deploy.js"
  }
}

```

_Note: If you use `--db-technology hana` to create your project, you can also use `cds deploy --to hana` to at least deploy the database artefacts to a HDI container automatically.

:point_right: Create a new file called `build.js` in the `db/` directory and paste the following content: 

```JavaScript
const fs = require('fs');
const childproc = require('child_process');

if (fs.existsSync('../package.json')) {
    // true at build-time, false at CF staging time
    childproc.execSync('npm install && npm run build', {
        cwd: '..',
        stdio: 'inherit'
    });
}
 
```

_Note: Both the `package.json` and `build.js` file would have been created automatically by adding `--db-technology hana` to the `cds init` command. Since deployment to SAP HANA and SQLite was somewhat buggy at the time of our CodeJam, you have to do that now manually. 

### 5. Add npm scripts to trigger the deployment

So far, the `package.json` file in your project root only defines scripts for local project execution.


:point_right: Add the following script definitions to the `"scripts"` section of the project's root `package.json` for build and deploy step processes:

```
"build:mta": "cds build/all && mbt build -p=cf",
"deploy:cf": "npm run build:mta && cf deploy mta_archives/${npm_package_name}_${npm_package_version}.mtar"
```

You might have noticed, that the `mbt` command isn't a typical shell command. This is actually a command from another Node module. This tool allows you to package your project into a deployable archive, which you'll need in order to get the app  onto the SAP Cloud Platform.

:point_right: Install this module in your project to allow its usage in the npm scripts, like this:

```
user@host:~/bookshop
=> npm install mbt
```

### 6. Build the project
We're almost there. To make our project ready for deployment, we need to package it into a single archive which can be used a delivery unit.

:point_right: Trigger the build process with the following command.
```
user@host:~/bookshop
=> npm run build:mta
```
### 7. Deploy the archive
Now you should see a new directory `mta_archives/` which contains an archive file named with the `ID` and `version` we defined in the `mta.yaml` descriptor. One command is all it takes to deploy your project to the cloud.

:point_right: Execute the following command to trigger the deployment process:

```
user@host:~/bookshop
=> cf deploy mta_archives/bookshop_1.0.0.mtar
```

> Note: You can also use `npm run deploy:cf` to trigger both, the build and deploy steps


### . Check the apps and services in Cloud Foundry

You can and should check the status of what you've deployed to your trial Cloud Foundry environment on the SAP Cloud Platform. 

Use the following commands do to this:

```
cf apps
cf services
```

## Summary

You have learned the basic commands to interact with the Cloud Foundry Command Line Interface to check the state of the deployed applications. You also added the necessary scripts to your project to automate the build and deploy steps via the command line.

## Questions

1. Can you guess what the script `deploy:cf` does? Is there anything special to this script (compared to the other scripts)?

1. When you run the commands to check the apps and services, what do you see? Are all apps in the "Running" state?
