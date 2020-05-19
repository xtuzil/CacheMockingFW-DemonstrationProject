Class Tests.TestedClass Extends %RegisteredObject
{

Property multiplyService [ Private ];

Method %OnNew(mathservice = {##class(Tests.MathService).%New()}) As %Status
{
	set ..multiplyService = mathservice
	quit $$$OK
}

Method Factorial(number As %Integer)
{
	
	set result = 1
	for i=1:1:number {
		set obj = {}
		set obj.first = result
		set obj.second = i	
		set result = ..multiplyService.Multiply(obj) 
	}
	quit result
}

}
