<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getQueries(){
		var result = CUT.getQueries();
		
		debug( result );
		assertIsStruct( result );
		assertTrue( StructCount( result ) >= cachedqueries );
	}
	
	function getQueriesPaged(){
		var result = CUT.getQueriesPaged( 1, 1 );
		debug( result );
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "INFO" ) );
		assertTrue( StructKeyExists( result, "DATA" ) );
		assertTrue( StructKeyExists( result, "RETURNEDITEMS" ) );
		assertTrue( StructKeyExists( result, "TOTALITEMS" ) );
		assertTrue( result.RETURNEDITEMS eq 1 );
		assertTrue( result.TOTALITEMS gte cachedqueries );
		assertIsArray( result.INFO );
		assertIsArray( result.DATA );
	}
	
	function getInfo(){
		var queryKeys = StructKeyList( CUT.getQueries() );
		var result = CUT.getInfo( ListGetAt( queryKeys, 1 ) );
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "CREATION" ) );
		assertTrue( StructKeyExists( result, "DSN" ) );
		assertTrue( StructKeyExists( result, "HASHCODE" ) );
		assertTrue( StructKeyExists( result, "PARAMS" ) );
		assertTrue( StructKeyExists( result, "QUERYNAME" ) );
		assertTrue( StructKeyExists( result, "SQL" ) );
	}
	
	function getItem(){
		makePublic(CUT, "getItem");
		var queryKeys = StructKeyList( CUT.getQueries() );
		var result = CUT.getItem( ListGetAt( queryKeys, 1 ) );
		assertTrue( IsObject( result ) );
	}
	
	function purge(){
		var result = CUT.purge( 'id' );
		debug(result);
		assertTrue( IsBoolean( result ) );
	}
	
	function purgeAll(){
		var result = CUT.purgeAll();
		assertTrue( IsBoolean( result ) );
	}
	
	function getCount(){
		var result = CUT.getCount();
		assertTrue( IsNumeric( result ) );
	}
	
	function getHitRatio(){
		var result = CUT.getHitRatio();
		assertTrue( IsNumeric( result ) );
	}
	
	function refresh(){
		var queryKeys = StructKeyList( CUT.getQueries() );
		var result = CUT.refresh( ListGetAt( queryKeys, 1 ) );
		assertTrue( IsBoolean( result ) );
	}
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function beforeTests(){
		
		// create some queries
		clearCachedQueries();
		cachedqueries = 10;
		generateCachedQueries( cachedqueries );
	}
	
	function setUp(){
		CUT = createObject("component","cftracker.services.cftracker.querycache").init();
	}
	
	function tearDown(){
	}
	
	function afterTests(){
		// clean up
		clearCachedQueries();
	}
	</cfscript>
	
	<cffunction name="generateCachedQueries" access="private">
		<cfargument name="cachedqueries">
		<!---
		<cfset var index = 0>
		<cfloop from="1" to="#arguments.cachedqueries#" index="index">
			
			<cfquery name="test_#index#" cachedwithin="#CreateTimeSpan( 0,0,1,0 )#" datasource="cfartgallery">
				select *
				from Artists as foo_#index#
			</cfquery>
			
		</cfloop>--->
		
	</cffunction>
	
	<cffunction name="clearCachedQueries" access="private">
		<cfobjectcache action="clear">
	</cffunction>
</cfcomponent>