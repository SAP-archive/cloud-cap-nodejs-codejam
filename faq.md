# Frequently Reported Issues

In this section we would like to highlight a couple of issues which have been reported by several event Attendees

## Node.js issues

### EACCES permissions errors

Did you encounter a error during the installation of global node module (with the `npm install -g` command)?

Error log:
```
NA
```

Solution:
Change npm’s default directory to solve this issue. You can find more information [here](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally).



## Build issues

### Python error on windows

Is you build command `mbt build -p=cf` (or `npm run build:mta`) failing?

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

Solution:
Install the [windows build tools](https://github.com/felixrieseberg/windows-build-tools) via `npm install -g windows-build-tools`.
