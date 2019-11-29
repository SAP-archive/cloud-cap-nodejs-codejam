# Frequently Reported Issues

This document describes issues that have been encountered during previous instances of this CodeJam, with their solutions.

## Node.js related

### EACCES permissions errors

Did you encounter the following error during the installation of global node module (with the `npm install -g` command)?
```
user:~/bookshop$ npm i -g @sap/cds-dk

npm WARN deprecated fsevents@1.2.9: One of your dependencies needs to upgrade to fsevents v2: 1) Proper nodejs v10+ support 2) No more fetching binaries from AWS, smaller package size
npm WARN checkPermissions Missing write access to /usr/local/lib/node_modules
npm ERR! path /usr/local/lib/node_modules
npm ERR! code EACCES
npm ERR! errno -13
npm ERR! syscall access
npm ERR! Error: EACCES: permission denied, access '/usr/local/lib/node_modules'
npm ERR!  { Error: EACCES: permission denied, access '/usr/local/lib/node_modules'
npm ERR!   stack: 'Error: EACCES: permission denied, access \'/usr/local/lib/node_modules\'',
npm ERR!   errno: -13,
npm ERR!   code: 'EACCES',
npm ERR!   syscall: 'access',
npm ERR!   path: '/usr/local/lib/node_modules' }
npm ERR!
npm ERR! The operation was rejected by your operating system.
npm ERR! It is likely you do not have the permissions to access this file as the current user
npm ERR!
npm ERR! If you believe this might be a permissions issue, please double-check the
npm ERR! permissions of the file and its containing directories, or try running
npm ERR! the command again as root/Administrator (though this is not recommended).

npm ERR! A complete log of this run can be found in:
npm ERR!     /home/user/.npm/_logs/2019-11-25T12_55_47_445Z-debug.log
```

**Solution**

Change npm’s default directory to solve this issue. You can find more information [here](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally).

## Build related

### Python error on Windows

Is your build command `mbt build -p=cf` (or `npm run build:mta`) failing, as shown below?

Error log:
```
> @sap/hana-client@2.3.123 install C:\Users\user\bookshop\db\node_modules\@sap\hdi-deploy\node_modules\@sap\hana-client
> node build.js

..{ Error: Command failed: node-gyp configure
gyp ERR! configure error
gyp ERR! stack Error: Can't find Python executable "python", you can set the PYTHON env variable.
gyp ERR! stack     at PythonFinder.failNoPython (C:\Program Files\nodejs\node_modules\npm\node_modules\node-gyp\lib\configure.js:484:19)
gyp ERR! stack     at PythonFinder.<anonymous> (C:\Program Files\nodejs\node_modules\npm\node_modules\node-gyp\lib\configure.js:509:16)
gyp ERR! stack     at C:\Program Files\nodejs\node_modules\npm\node_modules\graceful-fs\polyfills.js:282:31
gyp ERR! stack     at FSReqWrap.oncomplete (fs.js:153:21)
gyp ERR! System Windows_NT 10.0.17763
gyp ERR! command "C:\\Program Files\\nodejs\\node.exe" "C:\\Program Files\\nodejs\\node_modules\\npm\\node_modules\\node-gyp\\bin\\node-gyp.js" "configure"
gyp ERR! cwd C:\Users\user\bookshop\db\node_modules\@sap\hdi-deploy\node_modules\@sap\hana-client
gyp ERR! node -v v10.16.0
gyp ERR! node-gyp -v v3.8.0
gyp ERR! not ok

    at ChildProcess.exithandler (child_process.js:294:12)
    at ChildProcess.emit (events.js:198:13)
    at maybeClose (internal/child_process.js:982:16)
    at Process.ChildProcess._handle.onexit (internal/child_process.js:259:5)
  killed: false,
  code: 1,
  signal: null,
  cmd: 'node-gyp configure' } '\r\nC:\\Users\\user\\bookshop\\db\\node_modules\\@sap\\hdi-deploy\\node_modules\\@sap\\hana-client>if not defined npm_config_node_gyp (node "C:\\Program Files\\nodejs\\node_modules\\npm\\node_modules\\npm-lifecycle\\node-gyp-bin\\\\..\\..\\node_modules\\node-gyp\\bin\\node-gyp.js" configure )  else (node "C:\\Program Files\\nodejs\\node_modules\\npm\\node_modules\\node-gyp\\bin\\node-gyp.js" configure ) \r\n'
npm WARN deploy@ No description
npm WARN deploy@ No repository field.
npm WARN deploy@ No license field.

npm ERR! code ELIFECYCLE
npm ERR! errno 4294967295
npm ERR! @sap/hana-client@2.3.123 install: `node build.js`
npm ERR! Exit status 4294967295
npm ERR!
npm ERR! Failed at the @sap/hana-client@2.3.123 install script.
npm ERR! This is probably not a problem with npm. There is likely additional logging output above.

npm ERR! A complete log of this run can be found in:
npm ERR!     C:\Users\user\AppData\Roaming\npm-cache\_logs\2019-06-11T14_05_28_281Z-debug.log
[2019-06-11 14:05:28] ERROR build of the "bookshop-db" module failed when executing commands: execution of the "C:\Program Files\nodejs\npm.cmd" command failed while waiting for finish: exit status 4294967295
make: *** [Makefile_tmp.mta:39: bookshop-db] Error 1
Error: execution of the "Makefile_tmp.mta" file failed
```

**Solution**

Install the [Windows build tools](https://github.com/felixrieseberg/windows-build-tools) via `npm install -g windows-build-tools`.


## Error on Windows_NT

Is your build command `mbt build -p=cf` (or `npm run build:mta`) failing, as shown below (this has only been seen to occur on Azure based Windows VMs)?

Error log:
```
> @sap/hana-client@2.3.123 install C:\Users\user\bookshop\db\node_modules\@sap\hdi-deploy\node_modules\@sap\hana-client
> node build.js

C:\Users\user\bookshop\db\node_modules\@sap\hdi-deploy\node_modules\@sap\hana-client\lib\index.js:135
        throw ex;
        ^

Error: The module '\\?\C:\Users\user\bookshop\db\node_modules\@sap\hdi-deploy\node_modules\@sap\hana-client\prebuilt\ntamd64-msvc2010\hana-client.node'
was compiled against a different Node.js version using
NODE_MODULE_VERSION 48. This version of Node.js requires
NODE_MODULE_VERSION 64. Please try re-compiling or re-installing
the module (for instance, using `npm rebuild` or `npm install`).
    at Object.Module._extensions..node (internal/modules/cjs/loader.js:805:18)
    at Module.load (internal/modules/cjs/loader.js:653:32)
    at tryModuleLoad (internal/modules/cjs/loader.js:593:12)
    at Function.Module._load (internal/modules/cjs/loader.js:585:3)
    at Module.require (internal/modules/cjs/loader.js:690:17)
    at require (internal/modules/cjs/helpers.js:25:18)
    at Object.<anonymous> (C:\Users\user\bookshop\db\node_modules\@sap\hdi-deploy\node_modules\@sap\hana-client\lib\index.js:127:14)
    at Module._compile (internal/modules/cjs/loader.js:776:30)
    at Object.Module._extensions..js (internal/modules/cjs/loader.js:787:10)
    at Module.load (internal/modules/cjs/loader.js:653:32)
```

**Solution**

Install the dependencies of the `db` module manually and suppress the npm scripts:

```bash
cd db
npm install --ignore-scripts
```
