<cfcomponent extends="mxunit.framework.TestCase" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	Note: Only testing methods called from the service
	---------------------------------------------------------------
	*/
	
	/**
	* @excludeEngine RAILO
	*/
	function getClassHitRatioAdobe(){
		makePublic( CUT, "getClassHitRatioAdobe" );
		var result = CUT.getClassHitRatioAdobe();
		assertTrue( IsNumeric( result ) );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function beforeTests(){
	}
	
	function setUp(){
		CUT = createObject("component","cftracker.services.cftracker.templateCache").init();
	}
	
	function tearDown(){
	}
	
	function afterTests(){
	}
	</cfscript>
	
</cfcomponent>