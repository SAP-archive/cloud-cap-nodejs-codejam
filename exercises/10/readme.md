# Exercise 10


## 1. Sign in to Cloud Foundry

:point_right: Run the following command from your command line to log in to the referenced Cloud Foundry endpoint. When prompted use your SAP Cloud Platform credentials
```
cf login -a https://api.cf.eu10.hana.ondemand.com
```

## 2. Explore the artefacts in Cloud Foundry
:point_right: Run the following commands to see all deployed apps and provisioned backing services.
```
cf apps
cf services
```

## 3. Add npm scripts
So far, the `package.json` file in your project root only defines scripts to test the project locally.


:point_right: Add the following script definitions to the `"scripts"` section of `package.json` for build and deploy step processes:
```
"deploy:cds": "cds deploy",
"build:mta": "cds build/all && shx cp db/csv/Data.hdbtabledata db/src/gen/csv/ && mbt build -p=cf",
"deploy:cf": "npm run build:mta && cf deploy mta_archives/${npm_package_name}_${npm_package_version}.mtar"
```

You might have noticed, that the `shx` command isn't a typical shell command. This is actually a command from another node module.

:point_right: Install this module in your project via the command line to allow its usage in the npm scripts.
```
npm install shx
```

## 4. Build the app
:point_right: Trigger the build process with the following command.
```
npm run build:mta
```
## 5. Deploy the archive

:point_right: One command is all it takes to deploy your project to the cloud. Execute the following command to trigger the deployment process.
```
cf deploy mta_archives/bookshop_1.0.0.mtar
```

> Note: You can also use `npm run deploy:cf` to trigger both, the build and deploy steps

## Summary

You have learned the basic commands to interact with the Cloud Foundry Command Line Interface to check the state of the deployed applications. You also added the necessary scripts to your project to automate the build and deploy steps via the command line.

## Questions

1. Can you guess what the script `deploy:cf` does? Is there anything special to this script (compared to the other scripts)?

1. When you run the commands from step 2 again, what do you see now?

1. Check the SAP Cloud Platform Cockpit to see the same information. Are all apps in the `running` state now?
