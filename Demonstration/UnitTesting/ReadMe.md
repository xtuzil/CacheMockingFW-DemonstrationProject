## Instructions for unit testing demonstration
This is tutorial for demonstration of unit testing. More detailed tutorial how to work with %UnitTest is on https://docs.intersystems.com/irislatest/csp/docbook/Doc.View.cls?KEY=TUNT_Part2. 


Classes in this package *Tests* needs to compile. It can be done before running the container by only copy this package **without ReadMe.md** to the *src* file of project folder or when the container is already running by copy this folder *UnitTesting* to *src* file in project folder. The second case requires VS Code and compiling every class separately (ctr+S for every class in *UnitTesting* folder). If you do not have VS Code, stop container, copy the folder and run container again.
  

Don't forget to launch correctly the IRIS terminal and switch to MOCKFW namespace:
```sh
$ docker exec -it onlymock iris session IRIS
```
To change to MOCKFW namespace:
```c++
USER>zn "MOCKFW"
```


You can test whether the classes are compiled by (should write '1' if the class *Tests.MathService* is right compiled):
```c++
w ##class(%Dictionary.CompiledClass).%ExistsId("Tests.MathService")
```
  
  
1) In order to execute unit tests in Caché (IRIS), you must first export test classes as a XML file. If you are in Docker container, use dirPath */opt/mockfw/export/*, the files will be exported to *Export* folder in project.
```c++
MOCKFW>do $system.OBJ.Export("Tests.TestTestedClass.cls", "/opt/mockfw/export/UnitTests/testFactorial.xml")
MOCKFW>do $system.OBJ.Export("Tests.TestTestedClassWithMock.cls", "/opt/mockfw/export/UnitTests/testFactorialWithMock.xml")
```

2) Set the value of the ^UnitTestRoot global to the parent of the directory containing your exported test class
```c++
MOCKFW>Set ^UnitTestRoot="/opt/mockfw/export"
```

3) Execute the test using the method %UnitTest.Manager.RunTest.
```c++
MOCKFW>do ##class(%UnitTest.Manager).RunTest("UnitTests")
```

IRIS (Caché) loads the test class from the XML file, compiles the class, executes the test, deletes the test code from the server, and delivers a report to the terminal. 