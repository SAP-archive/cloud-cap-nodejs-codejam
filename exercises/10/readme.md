# Exercise 10


#Check if your signed in to a Cloud Foundry organization
```
cf apps
```

## 1. Add npm scripts
@DJ do you think we should introduce these scripts easier (and use `npm run` commands over `cds` commands)
"deploy:cds": "cds deploy",
"build:mta": "cds build/all && shx cp db/csv/Data.hdbtabledata db/src/gen/csv/ && mbt build -p=cf",
"deploy:cf": "npm run build:mta && cf deploy mta_archives/${npm_package_name}_${npm_package_version}.mtar"

 npx i shx

## 2. Build the app
```
npm run build:mta
```
## 3. Deploy the archive
```
cf deploy mta_archives/bookshop_1.0.0.mtar
```
Note: `npm run deploy:cf` would do the same
