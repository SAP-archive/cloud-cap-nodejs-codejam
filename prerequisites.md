# Prerequisites

There are hardware and software prerequisites for participating in this CodeJam. There are also some optional, recommended items that you might like to have too. **Administration rights are an essential requirement due to the installation of some local tools**. 

## Hardware

Each participant should have their own laptop with enough admin privileges to be able to install software. You should also be able to access a command line shell (e.g. `cmd.exe` on Windows). The laptop should also be able to connect to the host organization's guest network for Internet access, and have enough power for the whole day.

## SAP Cloud Platform

Each attendee should have an SAP Cloud Platform trial account, and specifically a Cloud Foundry environment with an organization and a space defined. See the following tutorials for more details:

- [Get a Free Trial Account on SAP Cloud Platform](https://developers.sap.com/tutorials/hcp-create-trial-account.html)
- [Create a Cloud Foundry Account](https://developers.sap.com/tutorials/cp-cf-create-account.html)
- [Log in via the Cloud Foundry Command Line Interface](https://developers.sap.com/tutorials/cp-cf-download-cli.html)

## Software

There are some mandatory and optional requirements with respect to software. The installation instructions are dependent on the operating system. Before the CodeJam day, participants must ensure they have the following installed on their laptops:

### Windows 

Please install the following tools manually:

- Chrome (latest version): <https://www.google.com/chrome/>
- Visual Studio Code (also known as VS Code): <https://code.visualstudio.com/download>
- Postman : <https://www.getpostman.com/downloads/>

1. Install Chocolatey (Package Manager) by executing this as an **Administrator**:

  ```bash
  @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
  ```

2. Now use Chocolatey to install Node.js (LTS):
  ```bash
  choco install nodejs-lts
  ```
  
3. Now use Chocolatey to install SQLite:
  ```bash
  choco install sqlite
  ```

4. Use Chocolatey to install make:
  ```bash
  choco install make
  ```

5. Use Chocolatey to install the Cloud Foundry CLI:
  ```bash
  choco install cloudfoundry-cli
  ```
  
6. Use the Cloud Foundry CLI to install a plugin to deploy your MultiTarget Application (MTA) to Cloud Foundry:
  ```bash
  cf install-plugin multiapps
  ```
  
Once you're done installing, please ensure you can successfully start the executables `sqlite3`, `make`, `cf` and `node` from the command line, and check that you can successfully install packages with the `npm` command that also gets installed with Node.js.

### macOS/Linux 

Please install the following tools manually:

- Chrome (latest version): https://www.google.com/chrome/
- Visual Studio Code (also known as VS Code): https://code.visualstudio.com/download
- Node.js (latest LTS version 10): https://nodejs.org/en/download/
- Postman : https://www.getpostman.com/downloads/
- The Cloud Foundry command line tool: https://github.com/cloudfoundry/cli/releases

Furthermore, use the Cloud Foundry CLI to install a plugin to enable the Cloud Foundry CLI to later deploy your Multi-Target Application (MTA) to Cloud Foundry:
  ```bash
  cf install
  ```
  
### Recommended

Some of the exercises require you to make HTTP requests, and for this you can use Postman (a mandatory software requirement above). Alternatively you can also use cURL, a command line HTTP client. Instructions for the HTTP requests in each exercise are given for both Postman and cURL. So you may want to install cURL; you can do so by visiting [https://curl.haxx.se/](https://curl.haxx.se/).


Further to the software prerequisites described above, we also recommend:

- The [JSON Formatter extension](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa?hl=en) for Google Chrome
- The [XML Tree extension](https://chrome.google.com/webstore/detail/xml-tree/gbammbheopgpmaagmckhpjbfgdfkpadb) for Google Chrome


## Attendees

Some familiarity with JavaScript is strongly recommended. Existing familiarity with Core Data Services (CDS) concepts is an advantage, as is experience with working with command line tools.

Attendees wishing to prepare themselves for the day can take advantage of the tutorial [Create a Basic Node.js App](https://developers.sap.com/tutorials/cp-node-create-basic-app.html) in the SAP Developer Center.
