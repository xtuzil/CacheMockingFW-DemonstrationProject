Class ZK.REST Extends (ZK.REST.Base, ZK.REST.Utils, %CSP.REST)
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/:name" Method="GET" Call="HelloWorld" Cors="false" />
<Route Url="/:mockName/:methodName" Method="POST" Call="Dispatch" Cors="false" />
<Route Url="/:mockName/:methodName" Method="GET" Call="Dispatch" Cors="false" />
<Route Url="/:mockName/:methodName" Method="PUT" Call="Dispatch" Cors="false" />
<Route Url="/:mockName/:methodName" Method="DELETE" Call="Dispatch" Cors="false" />
</Routes>
}

ClassMethod HelloWorld(name)
{
	w "Hello World "_name
	q $$$OK
}

ClassMethod Dispatch(mockName, methodName)
{
	set SC=$$$OK
	set response={}
	set obj="" 
	try{
		$$$ThrowOnError(..ReadRequestToObject(.obj))
		set method = %request.Method
		set tSC = ##class(ZK.MockBase).GetMockedResponseREST(mockName, methodName, method, obj, .response)
		if (response="") || (tSC=0) {
			    return ..WriteErrorResponse(mockName,methodName,SC)
		}
		return ..WriteResponse(response,SC)
	}catch exc{
		set SC=exc.AsStatus()
		return ..WriteErrorResponse(mockName,methodName,SC)
	}
	
	return SC
}

}
