Class Tests.TestTestedClassWithMock Extends (%UnitTest.TestCase, MockFW.MockManager)
{

Property mathService [ Private ];

Property testedClass [ Private ];

Method OnBeforeAllTests(testname) As %Status
{
	do ..CreateMock("MathService")
	set ..mathService = ##class(MockFW.Mocks.MathService).%New()
	
	set ..testedClass = ##class(Tests.TestedClass).%New(..mathService)
	quit $$$OK
}

Method TestFactorial()
{
	set className = ..InitMockForTest(..mathService)
	
	do ..SaveMethod(className, "Multiply", "{""first"":1,""second"":1}", 1)
	do ..SaveMethod(className, "Multiply", "{""first"":1,""second"":2}", 2)
	do ..SaveMethod(className, "Multiply", "{""first"":2,""second"":3}", 6)
	
	
	do $$$AssertEquals(..testedClass.Factorial(3),6)
}

Method OnAfterAllTests() As %Status
{
	do ..DeleteMock("MathService")
	quit $$$OK
}

}
