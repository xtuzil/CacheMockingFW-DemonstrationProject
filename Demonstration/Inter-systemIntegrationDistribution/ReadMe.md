## Instructions for distribution demonstration for inter-system integration
This is tutorial for demonstration of distribution for inter-system integration. This tutorial takes you through distribution the mock Restaurant which was mocked in *Server-sideMocking* section.


1. To distribute mock via Docker, first it is neccessary to prepare template directory of the project from the git. 
   In this case, this project folder can server as template, so there is no needs to download following template from git.
```sh
$ git clone https://github.com/xtuzil/CacheMockingFW-DockerIRIS-template-for-distribution  # or pull
```
  

2. Next is necessary to export mock data. If you doing this from container, you can put third parameter to '1'. That means the path is ignored and data are exported to *Export* folder in this project.
```c++
MOCKFW>do ##class(MockFW.MockManager).ExportMock("Restaurant", "opt/mockfw/export", 1)
```
  
    
2. Copy exported file *mockGlobal.gof* and optionally *mockClass.xml* (necessary only for calling the mock from IRIS terminal) to the project folder **src/ImportData**

Then, there are two option to distribute the mock:  

a) Send straightaway the directory to mock user  

   4. Send the compressed directory of the mock project to the user. Then the user has to build image from project folder.
        ```sh
        e.g. $ zip -r MyMock.zip MockFW
        ```
   * this approach **allows** user to call the mock from IRIS terminal an also to edit the distributed mock  
    

b) Build the container and push it to Docker hub. The user will launch the mock with one command.  
   * This needs to have account at https://hub.docker.com and to create repositary there.  
  
   4. Build the image
         ```sh
        $ docker-compose build
        ```
        
   5. Then rename the image (tag the image) by finding the container ID or name (using **docker ps**).  
        ```sh
        $ docker tag mock1 myrepository/imagename:version
         ```
   6. Now, push the image to the registry using the image ID.  
        ```sh
        $ docker push myrepository/imagename:version
        ```
   7. Send the name of tag to the user. He can run the container only by one docker command
   
   * this approach allow user to call the mock from IRIS terminal an also to edit the distributed mock but **does not allow** to save changes to the mock for later usage!