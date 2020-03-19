## intersystems-objectscript-template
This is a template for InterSystems ObjectScript Github repository.
The template goes also with a few files which let you immedietly compile your ObjecScript files in InterSystems IRIS Community Edition in a docker container

## Prerequisites
This needs to have docker installed.

## Instructions for docker mock user 
As a mock user you have two options:
1) Download docker image from DockerHub
    - you just need to run the Docker run command with concrete image:
    ```
    e.g. $ docker run --name mock -d --publish 9091:51773 --publish 9092:52773 mattuz/mockingfw:0.2
    ```
2) Build container with docker-compose from folder which you obtained    
    - open the terminal in the directory of folder with mock       
    ```
    $ cd /dirPath/MockFW
    $ docker-compose build
    $ docker-compose up -d
    ```

## Instructions for FW user in Caché
The main class which take care of the mocks is MockManager. It allows:
- create mock - it generate class definition
    ```
    MOCKFW>do ##class(MockFW.MockManager).CreateMock(NameOfTheMock) 
    ```
- export mock for Docker usage 
    ```
    MOCKFW>do ##class(MockFW.MockManager).ExportMock(NameOfTheMock)
    ```
- create mocks and their mocked methods from .csv file (csv file in format: 'Name of the Mock;Method;Input obj;Response;Rest method' )
    ```
    MOCKFW>do ##class(MockFW.MockManager).MockMethodsFromCSV(FilePath)
    ```
- handling mock
    ```
    MOCKFW>do ##class(MockFW.MockManager).GetAllMocks(), ...GetAllMethods(NameOfTheMock), ...ExportMockToCSV(NameOfTheMock), ...DeleteMock(NameOfTheMock), ...DeleteMethod(NameOfTheMock, ...NameOfTheMethod), ...DeleteMethodWithParametr(NameOfTheMock, NameOfTheMethod, Parameters), ...CleanAll())
    ```

After creating mock, it is generated the class of the mock in 'Mocks' repositary. Now you can add some mocked methods to mock and also get the response which you set up before.
- SaveMethod(NameOfTheMethod, params, returnValue, *restMethod)
    - params and return Value can be string or object
    - restMehod is optionally, you can set mocked method for acces via request
    - if you put "DEFAULT" as a params then whenever you call this method with unknow params, it responses you this returnValue
    ```
    e.g. MOCKFW>do ##class(MockFW.Mocks.Test).SaveMethod("test", "{"Halo":"Ano"}", "return")
    ```
- To get responses from mocked methods of mock, just call name method on the mock with params.
    ```
    e.g. MOCKFW>write ##class(MockFW.Mocks.Test).test("{"Halo":"Ano"}")
    ```

The class REST is responsible for REST inteface of the mocks


## Instructions for FW user to distribute mock via Docker
To distribute mock via Docker, first it is neccessary to prepare directory from the git. 
1) Simple version with only quering the mock. Clone:
    ```
    $ git clone/pull https://github.com/xtuzil/MockFW.git
    ```
2) Complex version with support to user can modify mock and other options. Clone:
    ```
    $ git clone/pull "some other url"
    ```

Second, export mock data:
- in Caché:
    ```
    MOCKFW>do ##class(MockFW.MockManager).ExportMock(mockName, dirPath)
    ```
    - dirPath has to be directory src in folder MockFW from git. Or copy exported files dataGlobal.gof and export.gof to this folder after exporting somewhere there.

Then, there are to option to distribute the mock:
1) Build the container and push it to Docker hub. The user will launch the mock with one command.
    - This needs to have account at https://hub.docker.com and to create repositary there.
    - Build the image and run the container
        ```
        $ docker-compose build
        $ docker-compose up -d
        ```
    - Then save the new image by finding the container ID (using **docker ps**) and then committing it to a new image name.
        ```
        $ docker commit c16378f943fe(ID) mock1
        ```
    - Now, push the image to the registry using the image ID.
        ```
        $ docker tag mock1 registry-host:mock1
        $ docker push registry-host:mock1
        ```
2) Send the directory to mock user. Then the user has to build image from this folder.
    ```
    e.g. $ zip MockFW.zip MockFW
    ```










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

# .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))
