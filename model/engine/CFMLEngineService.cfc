<cfcomponent output="false">
	<cfscript>
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	CFMLEngineService function init(){
		
		variables.CFMLEngine = new CFMLEngine();
		
		// load specialised version...
		switch ( UCase( variables.CFMLEngine.getProductName() ) ){
			case "COLDFUSION":
				variables.CFMLEngine = new ColdFusionEngine();
				break;
			case "RAILO":
				variables.CFMLEngine = new RailoEngine();
				break;
		}
		
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	CFMLEngine function getCFMLEngine(){
		return variables.CFMLEngine;
	}
	
	array function getApplicationNames(){
		return variables.CFMLEngine.getApplicationNames();
	}
	
	/* -------------------------- PRIVATE -------------------------- */
	
	</cfscript>
</cfcomponent>