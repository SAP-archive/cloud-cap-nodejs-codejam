# Exercise 10

Core changes:
*  SAP HANA deployment option
*  `npx` over global module
*  leverage npm scripts
*  capitalize table columns in csv

#Local vs global modules
```
npm view @sap/cds
npm view @sap/cds versions
```

#Check if your signed in to a Cloud Foundry organization
```
cf apps
```

## 1. Create the project
```
npx @sap/cds init --modules db,srv --insecure --mta --db-technology hana sitFra
code sitFra/
```

## 2. Add npm scripts to
In `package.json`
```
"setup": "npm install && mbt init",
"start": "cds run",
"build": "cds build/all",
"deploy:cds": "cds deploy",
"build:cf": "cds build/all && npm run build:cf:workarounds",
"build:cf:workarounds": "shx cp db/csv/Data.hdbtabledata db/src/gen/csv/",
"build:mta": "npm run build:cf && make -f Makefile.mta p=cf",
"deploy:cf": "npm run build:mta && cf deploy mta_archives/${npm_package_name}_${npm_package_version}.mtar"
```
## 3. Add SQLite as a local DB
In `package.json`, note: not really required: would be replaced by `npx cds deploy --to sqlite:bookshop.db` anyway
```
"db": {
    "kind": "sqlite",
    "model": ["db", "srv"],
    "credentials": {
        "database": "bookshop.db"
    },
    "[production]": {
        "kind": "hana"
    }
}
```
## 4. Add required node modules
```
npm install shx
npm install sqlite3  --save-dev
```

## 5. Add content to the CSV folder
`db/csv/my.bookshop-Books.csv`
```
ID,TITLE,STOCK
421,The Hitch Hiker's Guide To The Galaxy,1000
427,"Life, The Universe And Everything",95
201,Wuthering Heights,12
207,Jane Eyre,11
251,The Raven,333
252,Eleonora,555
271,Catweazle,22
```
`db/csv/Data.hdbtabledata`
```
{
	"format_version": 1,
	"imports": [
		{
			"target_table": "MY_BOOKSHOP_BOOKS",
			"source_data": {
			"data_type": "CSV",
				"file_name": "my.bookshop-Books.csv",
				"has_header": true
			},
			"import_settings": {
			"import_columns": [
					"ID",
					"TITLE",
					"STOCK"
				]
			}
		}
	]
}

```


## 6. Install the MTA build tool
Unfortunately not yet available as local module
```
npm i -g mbt
```

## 7. Run the project locally (as before)
```
npm run setup
npm run deploy:cds
npm start
```

## 8. Add package.json to srv
`srv/package.json`
```
{
    "name": "project-srv",
    "description": "",
    "version": "1.0.0",
    "dependencies": {
        "@sap/cds": "^3.7.1",
        "express": "^4.16.4",
        "hdb": "^0.17.0"
    },
    "engines": {
        "node": "^8.9",
        "npm": "^6"
    },
    "scripts": {
        "postinstall": "npm dedupe",
        "start": "cds serve gen/csn.json",
        "watch": "nodemon -w . -i node_modules/**,.git/** -e cds -x npm run build"
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

## 9. Update the plugin version
`db/src/.hdiconfig`
```
"plugin_version": "12.1.0",
```


## 10. Deploy the project to SAP Cloud Platform
```
npm run deploy:cf
```
