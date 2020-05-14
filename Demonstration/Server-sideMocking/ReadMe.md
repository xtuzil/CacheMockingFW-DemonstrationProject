## Instructions for mocking server-side demonstration
This is tutorial for demonstration of mocking server-side in client-server applications. This tutorial takes you through . Prepared endpoints for **Restaurant** mock are defined in file *mock_data.csv*. 

Before start make sure the IRIS (Caché) is started in MOCKFW namespace. After the container is ready, switch to IRIS terminal:
```sh
$ docker exec -it onlymock iris session IRIS
```
To change to MOCKFW namespace:
```c++
USER>zn "MOCKFW"
```

Creating the class definition of the mock is appropriate only when you want to call the mock from Caché. To create class definiton execute:
```c++
MOCKFW>do ##class(MockFW.MockManager).CreateMock("Restaurant")
```


1) Saving methods to the certain mock can be done one by one or in bulk from one CSV file.
   * Saving one by one:
    ```c++
    MOCKFW>do ##class(MockFW.MockManager).SaveMethod("Restaurant", "orders", "", "{""Orders"":[{""id"":1},{""id"":2},{""id"":4},{""id"":5}]}", "GET", 200, 0, 1)
    ```
    or
    ```c++
    MOCKFW>do ##class(MockFW.Mocks.Restaurant).SaveMethod("orders", , "{""Orders"":[{""id"":1},{""id"":2},{""id"":4},{""id"":5}]}", "GET", 200)
    ```
   * Saving methods (endpoints) from file. If you are in Docker container, copy the CSV file to *Export* folder and fill path */opt/mockfw/export/mock_data.csv*.
    ```c++
    MOCKFW>do ##class(MockFW.MockManager).SaveMethodsFromCSV("/opt/mockfw/export/mock_data.csv")
    ```


2) Generate the documentation to the mock. If you are in Docker container, you can left parameter *dirPath* empty and set parameter *inContainer* on *1* or fill *dirPath* with */opt/mockfw/export/mock_data.csv*. The documentation will be generated to *Export* folder.
```c++
MOCKFW>do ##class(MockFW.MockManager).GenerateDocumentation("Restaurant", "", 1)
```
Transformed DocBook documentation by XMLmind from generated XML file is in this folder for showcase (both PDF version and also Web Help)

3) Done! The mock is available on your application port. In container is default port 9092. To send request, try this this URL in web browser (better in Postman app) :
login: mockuser
password: 12345
```
http://localhost:9092/api/mocks/Restaurant/orders
```