<cfcomponent extends="mxunit.framework.TestCase" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	Note: Only testing methods called from the service
	---------------------------------------------------------------
	*/
	
	function getThreads(){
		var result = CUT.getThreads();
		assertTrue( IsArray( result ) );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function beforeTests(){
	}
	
	function setUp(){
		CUT = createObject("component","cftracker.services.cftracker.threads").init();
	}
	
	function tearDown(){
	}
	
	function afterTests(){
	}
	</cfscript>
	
</cfcomponent>