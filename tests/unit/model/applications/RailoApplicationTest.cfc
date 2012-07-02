<cfcomponent extends="mxunit.framework.TestCase" output="false" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests (only for Railo Server)
	---------------------------------------------------------------
	*/
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getInfo(){
		var result = CUT.getInfo(); // gets information about the application's life
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "EXISTS" ) );
		assertTrue( StructKeyExists( result, "IDLEPERCENT" ) );
		assertTrue( StructKeyExists( result, "EXPIRED" ) );
		assertTrue( StructKeyExists( result, "IDLETIMEOUT" ) );
		assertTrue( StructKeyExists( result, "ISINITED" ) );
		assertTrue( StructKeyExists( result, "LASTACCESSED" ) );
		assertTrue( StructKeyExists( result, "TIMEALIVE" ) );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getScope(){
		var result = CUT.getScope(); // gets the application scope
		debug(result);
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "applicationname" ) );
		assertTrue( StructKeyExists( result, key ) );
	}
	
	/*
	function getScopeValues(){
		var result = CUT.getScopeValues();
		debug(result);
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "applicationname" ) );
	}
	*/
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getSettings(){
		var result = CUT.getSettings(); // gets the application settings
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "name" ) );
		assertTrue( StructKeyExists( result, "sessiontimeout" ) );
		assertTrue( StructKeyExists( result, "sessionmanagement" ) );
		assertTrue( StructKeyExists( result, "applicationtimeout" ) );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getSessionCount(){
		var result = CUT.getSessionCount();
		assertTrue( isNumeric( result ) );
		assertTrue( result gt 0 );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getExpired(){
		var result = CUT.getExpired();
		debug(result);
		assertFalse( result );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getIdlePercent(){
		var result = CUT.getIdlePercent();
		assertTrue( IsNumeric( result ) );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getIdleTimeout(){
		var result = CUT.getIdleTimeout();
		assertTrue( IsDate( result ) );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getLastAccessed(){
		var result = CUT.getLastAccessed();
		assertTrue( IsDate( result ) );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function touch(){
		var result = CUT.touch();
		assertTrue( IsBoolean( result ) );	
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function stop(){
		var result = CUT.stop();
		assertTrue( IsBoolean( result ) );	
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getSessions(){ 
		var result = CUT.getSessions(); // gets all sessions for this application
		debug( result );
		assertIsStruct( result );	
	}
	
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function beforeTests(){
		key = "getScopeKeys_" & RandRange(1000,9999);
		application[ key ] = Now();
	}
	
	function setUp(){
		thisApplicationName = application.metadata.name;
		
		// load the correct subclass for the engine
		cfmlengine = ListFirst( server.coldfusion.productname, " " );
		CUT = createObject( "component","cftracker.model.applications.RailoApplication" ).init( thisApplicationName );
	}
	
	function tearDown(){
	}
	
	function afterTests(){
		StructDelete( application, key );
	}
	</cfscript>
</cfcomponent>