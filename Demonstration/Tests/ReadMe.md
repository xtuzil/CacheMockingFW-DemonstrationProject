## Instructions for mocking server-side demonstration
This is tutorial for demonstration of unit testing. Before start make sure the IRIS (Caché) is started in MOCKFW namespace. More detailed tutorial how to work with %UnitTest is on https://docs.intersystems.com/irislatest/csp/docbook/Doc.View.cls?KEY=TUNT_Part2. First copy this folder *Tests* to src folder and compile it.

1) Export Test classes as a XML file. If you are in Docker container, use dirPath */opt/mockfw/export/*, the files will be exported to *Expory* folder in project.
```c++
MOCKFW>do $system.OBJ.Export("Tests.TestTestedClass.cls", "/opt/mockfw/export/UnitTests/testFactorial.xml")
MOCKFW>do $system.OBJ.Export("Tests.TestTestedClassWithMock.cls", "/opt/mockfw/export/UnitTests/testFactorialWithMock.xml")
```

1) Set the value of the ^UnitTestRoot global to the parent of the directory containing your exported test class
```c++
MOCKFW>Set ^UnitTestRoot="/opt/mockfw/export"
```

3) Execute the test using the method %UnitTest.Manager.RunTest.
```c++
MOCKFW>do ##class(%UnitTest.Manager).RunTest("UnitTests")
```

4) IRIS (Caché) loads the test class from the XML file, compiles the class, executes the test, deletes the test code from the server, and delivers a report to the terminal. 