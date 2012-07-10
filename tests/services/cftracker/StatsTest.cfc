<cfcomponent extends="mxunit.framework.TestCase" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	Note: Only testing methods called from the service
	---------------------------------------------------------------
	*/
	function getServerInfo(){
		var result = CUT.getServerInfo();
		assertTrue( Isstruct( result ) );
		assertTrue( StructKeyExists( result, "load" ) );
		assertTrue( StructKeyExists( result, "perfmon" ) );
		assertTrue( StructKeyExists( result, "requests" ) );
		assertTrue( StructKeyExists( result.requests, "averageTime" ) );
		assertTrue( StructKeyExists( result.requests, "previousTime" ) );
	}
	
	function getCompilationTime(){
		var result = CUT.getCompilationTime();
		assertTrue( IsNumeric( result ) );
	}
	
	function getClassLoading(){
		var result = CUT.getClassLoading();
		assertTrue( Isstruct( result ) );
		assertTrue( StructKeyExists( result, "current" ) );
		assertTrue( StructKeyExists( result, "total" ) );
		assertTrue( StructKeyExists( result, "unloaded" ) );
	}
		
	function getProcessCpuTime(){
		var result = CUT.getProcessCpuTime();
		assertTrue( IsNumeric( result ) );
	}
		
	function getMemory(){
		var result = CUT.getMemory();
		assertTrue( IsStruct( result ) );
		assertTrue( StructKeyExists( result, "os" ) );
		assertTrue( StructKeyExists( result, "heap" ) );
		assertTrue( StructKeyExists( result, "nonHeap" ) );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getAdobeCf(){
		makePublic( CUT, "getAdobeCf" );
		var result = CUT.getAdobeCf();
		assertTrue( IsStruct( result ) );
		assertTrue( StructKeyExists( result, "running" ) );
		assertTrue( StructKeyExists( result, "queued" ) );
		assertTrue( StructKeyExists( result, "timedout" ) );
		assertTrue( StructKeyExists( result, "limit" ) );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getJdbcStats(){
		makePublic( CUT, "getJbdcStatsAdobe" );
		var result = CUT.getJbdcStatsAdobe();
		assertTrue( IsStruct( result ) );
		assertTrue( StructCount( result ) > 0 );
	}
	
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function beforeTests(){
	}
	
	function setUp(){
		CUT = createObject("component","cftracker.services.cftracker.stats").init();
	}
	
	function tearDown(){
	}
	
	function afterTests(){
	}
	</cfscript>
	
</cfcomponent>