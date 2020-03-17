## intersystems-objectscript-template
This is a template for InterSystems ObjectScript Github repository.
The template goes also with a few files which let you immedietly compile your ObjecScript files in InterSystems IRIS Community Edition in a docker container

## Prerequisites
This needs to have docker installed.

## Instructions for docker mock user 
As a mock user you have two options:
1) Download docker image from DockerHub
    - you just need to run the Docker run command, e.g. docker run --name mock -d --publish 9091:51773 --publish 9092:52773 mattuz/mockingfw:0.2
2) Build container with docker-compose from folder
    - open the terminal in the directory of folder with mock
    - docker-compose build
    - docker compose up -d

## Instructions for FW user in Caché
The main class which take care of the mocks is MockManager. It allows:
- create mock - it generate class definition
    ```
    CreateMock(NameOfTheMock) 
    ```
- export mock for Docker usage 
```
ExportMock(NameOfTheMock)
```
- create mocks and their mocked methods from .csv file (csv file in format: 'Name of the Mock;Method;Input obj;Response;Rest method' ) -> MockMethodsFromCSV(FilePath)
- handling mock -> GetAllMocks(), GetAllMethods(NameOfTheMock), ExportMockToCSV(NameOfTheMock), DeleteMock(NameOfTheMock), DeleteMethod(NameOfTheMock, NameOfTheMethod), DeleteMethodWithParametr(NameOfTheMock, NameOfTheMethod, Parameters), CleanAll())

After creating mock, it is generated the class of the mock in 'Mocks' repozitary. Now you can add some mocked methods to mock and also get the response which you set up before.
    - SaveMethod(NameOfTheMethod, params, returnValue, *restMethod)
        - params and return Value can be string or object
        - restMehod is optionally, you can set mocked method for acces via request
        - if you put "DEFAULT" as a params then whenever you call this method with unknow params, it responses you this returnValue
        - e.g. do ##class(ZK.Mocks.Test).SaveMethod("test", "{"Halo":"Ano"}", "return")
    - To get responses from mocked methods of mock, just call name method on the mock with params.
        - e.g. write ##class(ZK.Mocks.Test).test("{"Halo":"Ano"}")

The class REST is responsible for REST inteface of the mocks


## Instructions for FW user to distribute mock via Docker












## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/your-repository.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test it

Open IRIS terminal:

```
$ docker-compose exec iris iris session iris
USER>zn "IRISAPP"
IRISAPP>write ##class(PackageSample.ObjectScript).Test()
```
## How to start coding
This repository is ready to code in VSCode with ObjectScript plugin.
Install [VSCode](https://code.visualstudio.com/) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.
Open /src/cls/PackageSample/ObjectScript.cls class and try to make changes - it will be compiled in running IRIS docker container.

Feel free to delete PackageSample folder and place your ObjectScript classes in a form
/src/cls/Package/Classname.cls

The script in Installer.cls will import everything you place under /src/cls into IRIS.

## What's insde the repo

# Dockerfile

The simplest dockerfile which starts IRIS and imports Installer.cls and then runs the Installer.setup method, which creates IRISAPP Namespace and imports ObjectScript code from /src folder into it.
Use the related docker-compose.yml to easily setup additional parametes like port number and where you map keys and host folders.
Use .env/ file to adjust the dockerfile being used in docker-compose.

# Dockerfile-zpm

Dockerfile-zpm builds for you a container which contains ZPM package manager client so you are able to install packages from ZPM in this container.
As an example of usage in installs webterminal

# Dockerfile-web

Dockerfile-web starts IRIS does the same what Dockerfile does and also sets up the web app programmatically


# .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

# .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript
# MockFW
