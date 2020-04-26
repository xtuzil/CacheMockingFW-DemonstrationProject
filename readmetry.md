## Instructions for FW user in Caché
The framework needs to be imported to the Caché/IRIS as a package.
The main class from which can be controlled the mock is **MockFW.MockManager**.

#### MockFW.MockManager
It allows:
**CreateMock()** -- create mock (generate class definition)
* *nameOfTheMock* As %String
```c++
MOCKFW>do ##class(MockFW.MockManager).CreateMock("MyMock") 
```

After creating mock, it is generated the class of the mock in 'MockFW.Mocks' repositary. Now you can add some mocked methods to mock and also get the response which you set up before.
    
**SaveMethod()** -- save mocked method to the mock 
* *nameOfTheMock* As %String
* *methodName* As %String
* *params* As %String or object
* *response* As %String or object 
* *restMethod* As %String ("GET" | "POST" | "PUT" | "DELETE") = ""
* *returnCode* As %Integer = 200
* *delay* As %Integer in seconds = 0
* *force* As %Integer (1 | 0) = 0  -> 1 to force overwrite the same records 
```c++
MOCKFW>do ##class((MockFW.MockManager)).SaveMethod("MyMock", "Method", "{""name"":""John"""}", "return", "POST", 204, 5, 1)
```
Saving the method to the mock can be done also by direcly calling the class of the mock, see bellow.

**MockMethodsFromCSV()** -- save multiple mocks and their mocked methods from .csv file 
* columns in CSV are the same as parameters for SaveMethod()
* *filePath* As %String -> relative or absolute path to the file 
```c++
MOCKFW>do ##class(MockFW.MockManager).MockMethodsFromCSV("C:\Users\user\Desktop\mockData.csv")
```

**GenerateDocumentation()** -- generate documentation for certain mock in XML format
* *nameOfTheMock* As %String
* *dirPath* As %String -> directory, where the documentation will be generated
* *inContainer* As %Integer (1 | 0) = 0 -> dirPath is ignored and the file is generated to the Export folder in Docker project folder
```c++
MOCKFW>do ##class(MockFW.MockManager).GenerateDocumentation("MyMock", "C:\Users\user\Desktop\, 1)
```

**ExportMock()** -- export mock for Docker usage 
* *nameOfTheMock* As %String
* *dirPath* As %String -> directory, where the files *dataGlobal.gof* and *mockClass.xml* will be generated
* *inContainer* As %Integer (1 | 0) = 0 -> dirPath is ignored and the file is generated to the Export folder in Docker project folder
```c++
MOCKFW>do ##class(MockFW.MockManager).ExportMock("MyMock", "C:\Users\user\Desktop")
```
This needs to be done before distribution the mock. See **Instructions for FW user to distribute mock via Docker**

**GetAllMocks()** -- return all mocks
```c++
MOCKFW>do ##class(MockFW.MockManager).GetAllMocks()
```

**GetAllMethods()** -- return all methods of certain mock
* *nameOfTheMock* As %String
```c++
MOCKFW>do ##class(MockFW.MockManager).GetAllMethods("MyMock")
```

**DeleteMethod()** -- delete specific method from certain mock
* *nameOfTheMock* As %String
* *methodName* As %String
```c++
MOCKFW>do ##class(MockFW.MockManager).DeleteMethod("MyMock", "Method")
```

**DeleteMethod()** -- delete specific method from certain mock with selected parameters
* *nameOfTheMock* As %String
* *methodName* As %String
* *params* As %String or object
* *restMethod* As %String ("GET" | "POST" | "PUT" | "DELETE") = ""
```c++
MOCKFW>do ##class(MockFW.MockManager).DeleteMethodWithParameter("MyMock", "Method")
```

**DeleteMock()** -- delete certain mock (data global and class definition)
* *nameOfTheMock* As %String
```c++
MOCKFW>do ##class(MockFW.MockManager).DeleteMock("MyMock")
```

**CleanAll()** -- delete all stored framework data
```c++
MOCKFW>do ##class(MockFW.MockManager).CleanAll()
```

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

#### Instruction to calll the mock via request
The mock can be called via HTTP request through company web server. To use this, it is necessary to create web applications in Managament Portal:
```
 System > Security Management > Web Applications > Create New Web Application
```
Fill up :
* Name: /api/mocks
* Description: Web application for mocking FW
* Namespace: Namespace, where you import MOCKFW package
* Allowed Authentication Methods: Password
* Dispatch Class: MockFW.REST


## Instructions for docker mock user 
As a mock user in Docker you have two options how you can obtain the mock:
1. Obtain the mock via compressed folder
    Setup:
    * unwrap the project folder 
    * open the project directory in terminal 
    * build docker image and run the container
    ```sh
    $ docker-compose build
    $ docker-compose up -d
    ```
    Let the Docker start the app. By default, the container runs on port 9092 (can be changed in docker-compose.yml):
    * use credential to log in -> username: mockuser, password:12345
    * call the mock 
    ```sh
    http://localhost:9092/api/mocks/MyMock/MethodUrl
    ```
    * launch Management Portal
    ```sh
    http://localhost:9092/csp/sys/UtilHome.csp
    ```
    The mock can be called from a terminal. To launch the IRIS terminal:
    ```sh
    $ docker exec -it onlymock iris session IRIS
    $ USER>zn "MOCKFW"
    ...
    MOCKFW>h  #to exit from terminal
    ```
    If you wish to add some changes to the mock, you can, just keep in mind that you have to export the edited mock before the container stop to relaunch the container with changes. Look for the ExportMock() function and copy exported file from folder Export to folder src/ImportData: 
    * **ExportMock()** -- export mock for Docker usage 
        * *nameOfTheMock* As %String
        * *dirPath* As %String -> directory, where the files *dataGlobal.gof* and *mockClass.xml* will be generated
        * *inContainer* As %Integer (1 | 0) = 0 -> dirPath is ignored and the file is generated to the Export folder in Docker project folder
        ```c++
        MOCKFW>do ##class(MockFW.MockManager).ExportMock("MyMock", "", 1)
        ```
    
    
    
2. Download docker image from DockerHub
    - you just need to run the Docker command with concrete image, which you received:
    ```sh
    $ docker run --name onlymock -d --publish 9091:51773 --publish 9092:52773 mattuz/mockingfw:0.2
    ```
    The app listen on port 9092 (or whatever is in command above), call the mock for example via Postman app.
    * use credential to log in -> username: mockuser, password:12345
    * call the mock 
    ```sh
    http://localhost:9092/api/mocks/MyMock/MethodUrl
    ```
    But beware, this approach does not allow to call the mock from IRIS terminal and so the change in the mock is not possible. Also, this requires almost double downloaded amount of the data
    
Look at the dockbook documentation to see all mocked methods in the mock!





## Instructions for FW user to distribute mock via Docker
1. To distribute mock via Docker, first it is neccessary to prepare template directory of the project from the git. 
```sh
$ git clone https://github.com/xtuzil/MockFW.git  # or pull
```
2. Export mock data from Caché:
    * *nameOfTheMock* As %String
    * *dirPath* As %String -> directory, where the files *dataGlobal.gof* and *mockClass.xml* will be generated
    * *inContainer* As %Integer (1 | 0) = 0 -> dirPath is ignored and the file is generated to the Export folder in Docker project folder
```c++
MOCKFW>do ##class(MockFW.MockManager).ExportMock("MyMock", "C:\Users\user\Desktop")
```
3. Copy exported file *dataGlobal.gof* and optionally *mockClass.xml* (necessary only for calling the mock from IRIS terminal) to the project folder **src/ImportData**

Then, there are to option to distribute the mock:
* Send straightaway the directory to mock user
    4. Send the compressed directory of the mock project to the user. Then the user has to build image from project folder.
        ```sh
        e.g. $ zip -r MyMock.zip MockFW
        ```
    * this approach **allows** user to call the mock from IRIS terminal an also to edit the distributed mock

* Build the container and push it to Docker hub. The user will launch the mock with one command.
    - This needs to have account at https://hub.docker.com and to create repositary there.
    4. Build the image
        ```sh
        $ docker-compose build
        ```
    5. Then rename the image (tag the image) by finding the container ID or name (using **docker ps**).
        ```sh
        $ docker tag mock1 myrepozitary/imagename:version
        ```
    6. Now, push the image to the registry using the image ID.
        ```sh
        $ docker push myrepozitary/imagename:version
        ```
    7. Send the name of tag to the user. He can run the container only by one docker command
    * this approach **does not allow** user to call the mock from IRIS terminal an also to edit the distributed mock










# Dillinger

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Dillinger is a cloud-enabled, mobile-ready, offline-storage, AngularJS powered HTML5 Markdown editor.

  - Type some Markdown on the left
  - See HTML in the right
  - Magic

# New Features!

  - Import a HTML file and watch it magically convert to Markdown
  - Drag and drop images (requires your Dropbox account be linked)


You can also:
  - Import and save files from GitHub, Dropbox, Google Drive and One Drive
  - Drag and drop markdown and HTML files into Dillinger
  - Export documents as Markdown, HTML and PDF

Markdown is a lightweight markup language based on the formatting conventions that people naturally use in email.  As [John Gruber] writes on the [Markdown site][df1]

> The overriding design goal for Markdown's
> formatting syntax is to make it as readable
> as possible. The idea is that a
> Markdown-formatted document should be
> publishable as-is, as plain text, without
> looking like it's been marked up with tags
> or formatting instructions.

This text you see here is *actually* written in Markdown! To get a feel for Markdown's syntax, type some text into the left window and watch the results in the right.

### Tech

Dillinger uses a number of open source projects to work properly:

* [AngularJS] - HTML enhanced for web apps!
* [Ace Editor] - awesome web-based text editor
* [markdown-it] - Markdown parser done right. Fast and easy to extend.
* [Twitter Bootstrap] - great UI boilerplate for modern web apps
* [node.js] - evented I/O for the backend
* [Express] - fast node.js network app framework [@tjholowaychuk]
* [Gulp] - the streaming build system
* [Breakdance](https://breakdance.github.io/breakdance/) - HTML to Markdown converter
* [jQuery] - duh

And of course Dillinger itself is open source with a [public repository][dill]
 on GitHub.

### Installation

Dillinger requires [Node.js](https://nodejs.org/) v4+ to run.

Install the dependencies and devDependencies and start the server.

```sh
$ cd dillinger
$ npm install -d
$ node app
```

For production environments...

```sh
$ npm install --production
$ NODE_ENV=production node app
```

### Plugins

Dillinger is currently extended with the following plugins. Instructions on how to use them in your own application are linked below.

| Plugin | README |
| ------ | ------ |
| Dropbox | [plugins/dropbox/README.md][PlDb] |
| GitHub | [plugins/github/README.md][PlGh] |
| Google Drive | [plugins/googledrive/README.md][PlGd] |
| OneDrive | [plugins/onedrive/README.md][PlOd] |
| Medium | [plugins/medium/README.md][PlMe] |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] |


### Development

Want to contribute? Great!

Dillinger uses Gulp + Webpack for fast developing.
Make a change in your file and instantaneously see your updates!

Open your favorite Terminal and run these commands.

First Tab:
```sh
$ node app
```

Second Tab:
```sh
$ gulp watch
```

(optional) Third:
```sh
$ karma test
```
#### Building for source
For production release:
```sh
$ gulp build --prod
```
Generating pre-built zip archives for distribution:
```sh
$ gulp build dist --prod
```
### Docker
Dillinger is very easy to install and deploy in a Docker container.

By default, the Docker will expose port 8080, so change this within the Dockerfile if necessary. When ready, simply use the Dockerfile to build the image.

```sh
cd dillinger
docker build -t joemccann/dillinger:${package.json.version} .
```
This will create the dillinger image and pull in the necessary dependencies. Be sure to swap out `${package.json.version}` with the actual version of Dillinger.

Once done, run the Docker image and map the port to whatever you wish on your host. In this example, we simply map port 8000 of the host to port 8080 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8000:8080 --restart="always" <youruser>/dillinger:${package.json.version}
```

Verify the deployment by navigating to your server address in your preferred browser.

```sh
127.0.0.1:8000
```

#### Kubernetes + Google Cloud

See [KUBERNETES.md](https://github.com/joemccann/dillinger/blob/master/KUBERNETES.md)


### Todos

 - Write MORE Tests
 - Add Night Mode

License
----

MIT


**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
