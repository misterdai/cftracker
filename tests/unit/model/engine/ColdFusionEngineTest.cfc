<cfcomponent extends="mxunit.framework.TestCase" output="false" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests (only for Coldfusion Server)
	---------------------------------------------------------------
	*/
	
	/**
	* @excludeEngine RAILO
	*/
	function getApplicationNames()  {
		var result = CUT.getApplicationNames();
		debug( result );
		assertIsArray( result );
		assertTrue( ArrayContains( result, thisApplicationName ) );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getFullProductname(){
		assertEquals( "ColdFusion", ListFirst( CUT.getProductName(), " " ) );
	}

	/**
	* @excludeEngine RAILO
	*/
	function getApplicationServer(){
		assertEquals( true, ListFindNoCase( "JRUN4,J2EE", CUT.getApplicationServer() ) > 0 );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getMajorVersion(){
		debug( CUT.getMajorVersion() );
		assertEquals( true, ReFind( "^(9|10)$", CUT.getMajorVersion() ) > 0 );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getVersion(){
		assertEquals( true, ReFind( "^(9|10),.+", CUT.getVersion() ) > 0 );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	/**
	* @excludeEngine RAILO
	*/
	function setUp(){
		var enginename = UCase( ListFirst( server.coldfusion.productname, " " ) );
		var $CFMLEngine = mock().getProductName().returns( enginename );
		if ( enginename == "COLDFUSION" ){
			CUT = createObject( "component","cftracker.model.engine.ColdFusionEngine" ).init( $CFMLEngine );
		}
		thisApplicationName = application.metadata.name;
	}
	function tearDown(){
	}
	</cfscript>
	
</cfcomponent>