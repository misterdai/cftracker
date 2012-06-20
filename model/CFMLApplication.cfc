<cfcomponent hint="I am an abstract class to be extended but not instantiated" output="false" colddoc:abstract="true">
	<cfscript>
	// ------------------------------------------- PUBLIC ------------------------------------------ //
	
	private function init( CFMLEngine ){
		variables.cfmlengine = arguments.CFMLEngine;
		return this;
	}
	
	function getCFMLApplication( applicationname ){
		
	}
	
	
	// ------------------------------------------- PRIVATE ------------------------------------------ //
	</cfscript>
	
</cfcomponent>
