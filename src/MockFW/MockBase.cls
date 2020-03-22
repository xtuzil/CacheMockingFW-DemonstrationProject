Class MockFW.MockBase Extends (%RegisteredObject, MockFW.Utils)
{

/// Save method of Mock to the global if does not already exist
ClassMethod SaveMethod(mockName, methodName As %String, params, response, restMethod As %String = "")
{
		
	if (restMethod="GET") {
		set params = "GET"
	}
	
	if (mockName="") || (methodName="") || (params="") || (response="") {
		w !, "ERROR: One of the compulsory parameters is missing."
		quit '$$$OK
	}
	
	if ($ISOBJECT(params)) {
		set params = params.%ToJSON()
	}
	
	if ($ISOBJECT(response)) {
		set response = response.%ToJSON()
	}
	
	if (restMethod="") {
		if ($DATA(^MockMat(mockName, methodName, params))) {
				w !, "ERROR: The record with same parameters already exists."
				quit '$$$OK
		} 
		set tSC = ..GetMockedResponse(mockName, methodName, params, .res)
		if (tSC=1) {
			w !, "ERROR: The record with same parameters already exists."
			quit '$$$OK
		}
		
		set ^MockMat(mockName, methodName, params) = response
		
	} else {
		
		if ($DATA(^MockMat(mockName, methodName, restMethod, params))) {
				w !, "ERROR: The record with same parameters already exists."
				quit '$$$OK
		} 
		set tSC = ..GetMockedResponseREST(mockName, methodName, restMethod, params, .res) 
		if (tSC=1) {
			w !, "ERROR: The record with same parameters already exists."
			quit '$$$OK
		}
		
		set ^MockMat(mockName, methodName, restMethod, params) = response
	}
	
	w !, "Saved!"
	quit $$$OK
}

/// Return right data when specific method is called
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
	
	return response
}

/// Retrieve right data from global if the method with specific parameters is mocked
ClassMethod GetMockedResponse(mockName As %String, methodName As %String, params, Output response)
{
	set response=""
	set key = $Order(^MockMat(mockName, methodName,""))
 	while (key '= "") {
     	set sc = ..Compare(key, params)
     	if sc=1 {
     		set response = ^MockMat(mockName, methodName, key)
     		return $$$OK
     	}
     	s key = $Order(^MockMat(mockName, methodName, key)) // next subscript
 	}
 	if $Data(^MockMat(mockName, methodName, "DEFAULT")) {
 		set response = ^MockMat(mockName, methodName, "DEFAULT")
 		quit $$$OK
 	}
 	quit '$$$OK
}

/// Retrieve right data from global if the method with specific parameters is mocked. REST version.
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
     		return $$$OK
     	}
     	s key = $Order(^MockMat(mockName, methodName, method,key)) // next subscript
 	}
 	if $Data(^MockMat(mockName, methodName, method, "DEFAULT")) {
 		set response = ^MockMat(mockName, methodName, method, "DEFAULT")
 		quit $$$OK
 	}
 	quit '$$$OK
}

}
