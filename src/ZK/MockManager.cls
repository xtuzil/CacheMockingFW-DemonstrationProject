Class ZK.MockManager Extends (%Persistent, ZK.Utils)
{

ClassMethod CreateMock(className As %String)
{

	w "trying create mock", !
	
	set fullClassName = "ZK.Mocks."_className
	
	If (##class(%Dictionary.ClassDefinition).%Exists(fullClassName)) {
		w "Mock s timhle nazvem jiz existuje"
		quit
	}
	
	set classDef=##class(%Dictionary.ClassDefinition).%New()
	set classDef.Name=fullClassName
	set classDef.ProcedureBlock=1
	
	set classDef.Super = "ZK.MockBase"
	
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
	do methodDef.Implementation.WriteLine($$$TAB_" quit ##class(ZK.MockBase).MethodCalled(mockName, methodName, Args...)")

	
	do classDef.Methods.Insert(methodDef)
	
	do classDef.%Save()
   
   	quit ##class(%SYSTEM.OBJ).Compile(fullClassName)
}

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
     	do ##class(ZK.MockBase).SaveMethod(mockName, methodName, params, response, restMethod)                  
     }
   }
}

// mockName = e.g. MyMock

// dirPath = directory where you have folder with Iris docker + /durable/src

ClassMethod ExportMock(mockName As %String, dirPath As %String)
{
	//TODO: Kontrola, jestli existuje trida mocku
	do ..ExportMockData(mockName, dirPath)
	do ..ExportMockClass(mockName, dirPath)
}

ClassMethod ExportMockData(mockName As %String, dirPath As %String)
{
	set global = "MockMat("_mockName
	set filePath = dirPath_"\dataGlobal.gof"
	do ##class(%Library.Global).Export(,global,filePath)
}

ClassMethod ExportMockClass(mockName As %String, dirPath As %String)
{
	set fullClassName = "ZK.Mocks."_mockName_".cls"
	set filePath = dirPath_"\mockClass.xml"
	do $system.OBJ.Export(fullClassName, filePath)
}


/// get all created mocks
ClassMethod GetAllMocks()
{
	//TODO: viz comment
}



/// get all mocked methods from mockName as list
ClassMethod GetAllMethods(mockName As %String)
{
	//TODO:	Metoda by mela vratit seznam vsech mockovanych metod a v nem seznam parametru a odpovedi
}


ClassMethod ExportMockToCSV(mockName As %String) {
	//TODO:
}


ClassMethod DeleteMethod(mockName As %String, methodName As %String) {
	//TODO:
}

ClassMethod DeleteMethodWithParametr(mockName As %String, methodName As %String, params) {
	//TODO:
}


/// clean global from this mock and delete this class definition
ClassMethod DeleteMock(mockName As %String)
{
	
	Kill ^MockMat(mockName)
	quit ##class(%SYSTEM.OBJ).Delete(mockName)
}

/// clean whole global and delete mocks class definition
ClassMethod CleanAll()
{
	Kill ^MockMat
	quit ##class(%SYSTEM.OBJ).DeletePackage("ZK.Mocks")
}

Storage Default
{
<Data name="MockManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^ZK.MockManagerD</DataLocation>
<DefaultData>MockManagerDefaultData</DefaultData>
<IdLocation>^ZK.MockManagerD</IdLocation>
<IndexLocation>^ZK.MockManagerI</IndexLocation>
<StreamLocation>^ZK.MockManagerS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
