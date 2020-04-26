## MockFW users template
This is a template for MockFW users to create mock in docker. It is build on InterSystems ObjectScript template from: https://github.com/intersystems-community/objectscript-docker-template


#### MockFW.Mocks.*NameOfTheMock*
The generated class definition can be called in order to get predefined response. Also, it can be saved the mock method directly with this class.

**SaveMethod()** -- save mocked method to the class mock 
* *methodName* As %String
* *params* As %String or object
* *response* As %String or object 
* *restMethod* As %String ("GET" | "POST" | "PUT" | "DELETE") = ""
* *returnCode* As %Integer = 200
* *delay* As %Integer in seconds = 0
* *force* As %Integer (1 | 0) = 0  -> 1 to force overwrite the same records 
```c++
MOCKFW>do ##class(MockFW.Mocks.MyMock).SaveMethod("Method", "", "return", "GET", 404)
```

**DispatchMethod()** - call certain method on specific mock class
* *params* As %String or object
```c++
MOCKFW>do ##class(MockFW.Mocks.MyMock).Method("{""name"":""John"""}")
```



## Prerequisites
This needs to have docker installed. (Docker-compose)

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
Let the Docker start the app. App listen on port 9092. In complex version of the mock, it is possible to call method from terminal. Refresh app in VS Code or:\
    ```
    $ docker exec -it onlymock iris session IRIS
    $ USER> zn "MOCKFW"
    ```

    h to exit IRIS
\To log in (e.g. on Postman) use username: 'mockuser' and password:'12345'
\If the version of distribution support managment portal, use: http://localhost:9092/csp/sys/UtilHome.csp

## Instructions for FW user in Caché
The main class which take care of the mocks is MockManager. It allows:
- create mock - it generate class definition
    ```c
    MOCKFW>do ##class(MockFW.MockManager).CreateMock(NameOfTheMock) 
    ```
- export mock for Docker usage 
    ```c++
    MOCKFW>do ##class(MockFW.MockManager).ExportMock(NameOfTheMock)
    ```
- create mocks and their mocked methods from .csv file (csv file in format: 'Name of the Mock;Method;Input obj;Response;Rest method' )
    ```zs
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
    - dirPath has to be directory in folder MockFW/src/Data from git. Or copy exported files dataGlobal.gof and export.gof to this folder after exporting somewhere else.

Then, there are to option to distribute the mock:
1) Build the container and push it to Docker hub. The user will launch the mock with one command.
    - This needs to have account at https://hub.docker.com and to create repositary there.
    - Build the image
        ```
        $ docker-compose build
        ```
    - Then rename the image (tag the image) by finding the container ID or name (using **docker ps**).
        ```
        $ docker tag mock1 registry-host:mock1
        ```
    - Now, push the image to the registry using the image ID.
        ```
        $ docker push registry-host:mock1
        ```
2) Send the directory to mock user. Then the user has to build image from this folder.
    ```
    e.g. $ zip -r MockFW.zip MockFW
    ```



to be in container terminal
docker exec -it onlymock /bin/bash
  
