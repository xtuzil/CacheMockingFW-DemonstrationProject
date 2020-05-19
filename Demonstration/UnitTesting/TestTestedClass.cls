Class Tests.TestTestedClass Extends (%UnitTest.TestCase, MockFW.MockManager)
{

Property mathService [ Private ];

Property testedClass [ Private ];

Method OnBeforeAllTests(testname) As %Status
{
	
	set ..mathService = ##class(Tests.MathService).%New()
	set ..testedClass = ##class(Tests.TestedClass).%New(..mathService)
	quit $$$OK
}

Method TestFactorial()
{
	
	do $$$AssertEquals(..testedClass.Factorial(3),6)
}

}
