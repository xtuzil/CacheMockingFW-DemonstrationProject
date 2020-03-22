Class MockFW.MockManager Extends (%RegisteredObject, MockFW.Utils)
{

/// Creates new mock class if does not exist already. 
/// Generates class definition in 'MockFW.Mocks' to be possible calling methods on this class.
ClassMethod CreateMock(className As %String) As %Status
{
	set fullClassName = "MockFW.Mocks."_className
	
	If (##class(%Dictionary.ClassDefinition).%Exists(fullClassName)) {
		w "Mock with this name already exists!"
		quit '$$$OK
	}
	
	set classDef=##class(%Dictionary.ClassDefinition).%New()
	set classDef.Name=fullClassName
	set classDef.ProcedureBlock=1
	
	set classDef.Super = "MockFW.MockBase"
	
	set methodDef = ##class(%Dictionary.MethodDefinition).%New()
	set methodDef.Name = "SaveMethod"	
	
	set methodDef.ClassMethod = "1"
	set methodDef.FormalSpec="methodName:%String,params,return,restMethod:%String="""""	
	do methodDef.Implementation.WriteLine($$$TAB_" set mockName = $PIECE($CLASSNAME(),""."",3) ")
	do methodDef.Implementation.WriteLine($$$TAB_" do ##super(mockName, methodName, params, return, restMethod)")
	
	do classDef.Methods.Insert(methodDef)
	
	set methodDef = ##class(%Dictionary.MethodDefinition).%New()
	set methodDef.Name = "%DispatchClassMethod"	
	set methodDef.ClassMethod = "1"
	set methodDef.FormalSpec="Class:%String,methodName:%String,Args..."
	do methodDef.Implementation.WriteLine($$$TAB_" set mockName = $PIECE(Class,""."",3) ")
	do methodDef.Implementation.WriteLine($$$TAB_" quit ##class(MockFW.MockBase).MethodCalled(mockName, methodName, Args...)")

	
	do classDef.Methods.Insert(methodDef)
	
	do classDef.%Save()
   
   	quit ##class(%SYSTEM.OBJ).Compile(fullClassName)
}

/// Import mock and mocks data from .csv file
/// Import proccess from the second line with format 'Name of the Mock; Method; parameters; Response; Rest method'
ClassMethod MockMethodsFromCSV(filePath As %String)
{
   	set stream=##class(%Stream.FileCharacter).%New()
   	set sc=stream.LinkToFile(filePath)
   	do stream.Rewind()
   	while 'stream.AtEnd {
		set line=stream.ReadLine()
     	set mockName = $PIECE(line,";",1)
     	set methodName = $PIECE(line,";",2)
     	set params = $PIECE(line,";",3)
     	set response = $PIECE(line,";",4)
     	set restMethod = $PIECE(line,";",5)
     
     	//Convert to objects because of way how we are saving
     	set params =  ..CutExtraQuotes(params)
     	set response =  ..CutExtraQuotes(response)
     	if ..CanConvertToJSON(params) {
     		set params={}.%FromJSON(params)
     	}
     	if ..CanConvertToJSON(response) = 1 {
     		set response={}.%FromJSON(response)
     	}
     
     	if mockName'= "Name of the Mock" { // We do not want to take first line
     		return ##class(MockFW.MockBase).SaveMethod(mockName, methodName, params, response, restMethod)                  
     	}
   	}
	quit $$$OK
}

/// Is used when closing REST API into Docker
/// Export Mock class and Mock data as a two files (.xml a .gof)
/// dirPath = directory where you have folder with Iris docker + /durable/src
/// mockName = e.g. MyMock
ClassMethod ExportMock(mockName As %String, dirPath As %String) As %Status
{
	set className = "MockFW.Mocks."_mockName
	set exist=##class(%Dictionary.CompiledClass).%ExistsId(className)
	if 'exist {
		quit '$$$OK
	}

	do ..ExportMockData(mockName, dirPath)
	do ..ExportMockClass(mockName, dirPath)

	quit $$$OK
}

/// Auxiliary method, exports Mocks data
ClassMethod ExportMockData(mockName As %String, dirPath As %String) As %Status
{
	set global = "MockMat("_mockName
	set filePath = dirPath_"\dataGlobal.gof"
	quit ##class(%Library.Global).Export(,global,filePath)
}

/// Auxiliary method, exports Mock class
ClassMethod ExportMockClass(mockName As %String, dirPath As %String) As %Status
{
	set fullClassName = "MockFW.Mocks."_mockName_".cls"
	set filePath = dirPath_"\mockClass.xml"
	quit $system.OBJ.Export(fullClassName, filePath)
}

/// Return all mocks as a %ListOfDataTypes and also write the list
ClassMethod GetAllMocks()
{
	#dim listMocks = ##class(%ListOfDataTypes).%New()
	set key = $Order(^MockMat(""))
 	while (key '= "") {
		 do listMocks.Insert(key)
     	s key = $Order(^MockMat(key)) // next subscript
 	}
	zwrite listMocks 
	quit listMocks
}

/// Return all Mock methods as a %ListOfDataTypes and also write the list
ClassMethod GetAllMethods(mockName As %String)
{
	#dim listMethods = ##class(%ListOfDataTypes).%New()
	set key = $Order(^MockMat(mockName,""))
 	while (key '= "") {
		 do listMethods.Insert(key)
     	s key = $Order(^MockMat(mockName,key)) // next subscript
 	}
	zwrite listMethods
	quit listMethods
}

/// Delete specific method from specific mock (All records with different parameters)
ClassMethod DeleteMethod(mockName As %String, methodName As %String)
{
	kill ^MockMat(mockName, methodName)
	quit $$$OK
}

/// Delete specific method from specific mock with specific parameters
ClassMethod DeleteMethodWithParametr(mockName As %String, methodName As %String, params, restMethod As %String = "")
{
	if ($ISOBJECT(params)) {
		set params = params.%ToJSON()
	}

	if restMethod="" {
		kill ^MockMat(mockName, methodName, params)
	} else {
		kill ^MockMat(mockName, methodName, restMethod, params)
	}
}

/// Delete Mock class definition and also clean global from this Mock (Mocks data)
ClassMethod DeleteMock(mockName As %String)
{
	Kill ^MockMat(mockName)
	quit ##class(%SYSTEM.OBJ).Delete(mockName)
}

/// Delete all of the records and data
ClassMethod CleanAll()
{
	Kill ^MockMat
	quit ##class(%SYSTEM.OBJ).DeletePackage("MockFW.Mocks")
}

}
