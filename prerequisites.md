# Prerequisites

There are hardware and software prerequisites for participating in this CodeJam. There are also some optional, recommended items that you might like to have too.

## Hardware

Each participant should have their own laptop with enough admin privileges to be able to install software. You should also be able to access a command line shell (e.g. `cmd.exe` on Windows). The laptop should also be able to connect to the host organization's guest network for Internet access, and have enough power for the whole day.

## Software

There are some mandatory and optional requirements with respect to software.

### Mandatory

Before the CodeJam day, participants must ensure they have the following installed on their laptops:

- Chrome (latest version) : <https://www.google.com/chrome/>
- Visual Studio Code (also known as VS Code): <https://code.visualstudio.com/download>
- Node.js : <https://nodejs.org/en/download/>
- Postman : <https://www.getpostman.com/downloads/>
- SQLite : <https://sqlite.org/index.html>
- Make : <https://www.gnu.org/software/make/>
- The Cloud Foundry command line tool cf : <https://docs.cloudfoundry.org/cf-cli/install-go-cli.html>
- The Multi-Target Application Cloud Foundry CLI Plugin (CF MTA Plugin) : <https://github.com/cloudfoundry-incubator/multiapps-cli-plugin>
    ```
    cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
    cf install-plugin multiapps
    ```

With regards to `SQLite` and `Make`: if you are running macOS or Linux it's likely that you'll already have SQLite installed. For Windows users, please follow the installation instructions that are available (you may find this four-minute video useful: [Codible SQLite video 1: How to install sqlite (SQLite3) on windows 10 - YouTube](https://www.youtube.com/watch?v=zOJWL3oXDO8)). Alternatively, you can use the [Chocolatey](https://chocolatey.org/) package manager to install both, [SQLite](https://chocolatey.org/packages/sqlite). and [make](https://chocolatey.org/packages/make). After installation, please check you can start the executables (`sqlite3` and `make`) from the command line.

With regards to Node: Please install the latest LTS (long term support) version v10. After installation, please check that you can start node from the command line, and also successfully install packages with the included `npm` command.

### Optional

Some of the exercises require you to make HTTP requests, and for this you can use Postman (a mandatory software requirement above). Alternatively you can also use cURL, a command line HTTP client. Instructions for the HTTP requests in each exercise are given for both Postman and cURL. So you may want to install cURL; you can do so by visiting [https://curl.haxx.se/](https://curl.haxx.se/).

## Attendees

Some familiarity with JavaScript is strongly recommended. Existing familiarity with Core Data Services (CDS) concepts is an advantage, as is experience with working with command line tools.

Each attendee should have an SAP Cloud Platform trial account, and specifically a Cloud Foundry environment with an organization and a space defined. See the [Getting started with Cloud Foundry](https://developers.sap.com/uk/tutorials/hcp-cf-getting-started.html) tutorial for more details.

Attendees wishing to prepare themselves for the day can take advantage of the tutorial [Create a Basic Node.js App](https://developers.sap.com/tutorials/cp-node-create-basic-app.html) in the SAP Developer Center.

## Recommendations

Further to the software prerequisites described above, we also recommend:

- The [JSON Formatter extension](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa?hl=en) for Google Chrome
- The [XML Tree extension](https://chrome.google.com/webstore/detail/xml-tree/gbammbheopgpmaagmckhpjbfgdfkpadb) for Google Chrome
