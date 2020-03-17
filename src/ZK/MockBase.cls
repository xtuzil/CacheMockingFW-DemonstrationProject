Class ZK.MockBase Extends (%Persistent, ZK.Utils)
{

ClassMethod SaveMethod(mockName, methodName As %String, params, response, restMethod As %String = "")
{
		
	if (restMethod="GET") {
		set params = "GET"
	}
	
	if (mockName="") || (methodName="") || (params="") || (response="") {
		w !, "ERROR: Neco chybi"
		return 0
	}
	
	
	if ($ISOBJECT(params)) {
		set params = params.%ToJSON()
	}
	
	if ($ISOBJECT(response)) {
		set response = response.%ToJSON()
	}
	
	
	if (restMethod="") {
		
		if ($DATA(^MockMat(mockName, methodName, params))) {
				w !, "Zaznam jiz existuje"
				return 0
		} 
		set tSC = ..GetMockedResponse(mockName, methodName, params, .res)
		if (tSC=1) {
			w !, "Zaznam jiz existuje - pokrocilejsi"
			return 0
		}
		
		set ^MockMat(mockName, methodName, params) = response
		
	} else {
		
		if ($DATA(^MockMat(mockName, methodName, restMethod, params))) {
				w !, "Zaznam jiz existuje"
				return 0
		} 
		set tSC = ..GetMockedResponseREST(mockName, methodName, restMethod, params, .res) 
		if (tSC=1) {
			w !, "Zaznam jiz existuje - pokrocilejsi"
			return 0
		}
		
		set ^MockMat(mockName, methodName, restMethod, params) = response
	}
	
	w !, "Done!"
	return 1
}

ClassMethod MethodCalled(class As %String, methodName As %String, Args...)
{
	set response = {}
	set args = ..TransformArgsToList(Args...)
	
	// pokud neni prazdnej
	// beru jen prvni paramtr, mozna by chtelo vsechny (pocitam s tim, ze vzdy dostanu object)
	set json = {}
	set params = args.GetAt(1)
	
	if ($ISOBJECT(params)) {
		set params = params.%ToJSON()
	}
	
	set sc = ..GetMockedResponse(class, methodName, params, .response)
	
	q response
}

ClassMethod GetMockedResponse(mockName As %String, methodName As %String, params, Output response)
{
	set response=""
	set key = $Order(^MockMat(mockName, methodName,""))
 	while (key '= "") {
     	set sc = ..Compare(key, params)
     	if sc=1 {
     		set response = ^MockMat(mockName, methodName, key)
     		return 1
     	}
     	s key = $Order(^MockMat(mockName, methodName, key)) // next subscript
 	}
 	if $Data(^MockMat(mockName, methodName, "DEFAULT")) {
 		set response = ^MockMat(mockName, methodName, "DEFAULT")
 		return 1
 	}
 	return 0
}

ClassMethod GetMockedResponseREST(mockName As %String, methodName As %String, method As %String, body, Output response)
{
	set response=""
	if method="GET" {
		set body = "GET"
	}
	
	set key = $Order(^MockMat(mockName, methodName, method,""))
 	while (key '= "") {
     	set sc = ..Compare(key, body)
     	if sc=1 {
     		set response = ^MockMat(mockName, methodName, method, key)
     		return 1
     	}
     	s key = $Order(^MockMat(mockName, methodName, method,key)) // next subscript
 	}
 	if $Data(^MockMat(mockName, methodName, method, "DEFAULT")) {
 		set response = ^MockMat(mockName, methodName, method, "DEFAULT")
 		return 1
 	}
 	return 0
}

ClassMethod TransformArgsToList(args...) As %List
{
   // Create a %ListOfDataTypes even though it may contain objects. This has been tested and works.
   #dim listArgs = ##class(%ListOfDataTypes).%New()
   #dim i AS %Integer
   for i = 1 : 1 : $get(args, 0)
   {
      do listArgs.Insert($get(args(i)))
   }
   
   quit listArgs
}

Storage Default
{
<Data name="MockBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^ZK.MockBaseD</DataLocation>
<DefaultData>MockBaseDefaultData</DefaultData>
<IdLocation>^ZK.MockBaseD</IdLocation>
<IndexLocation>^ZK.MockBaseI</IndexLocation>
<StreamLocation>^ZK.MockBaseS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
