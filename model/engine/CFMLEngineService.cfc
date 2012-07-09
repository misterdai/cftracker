<cfcomponent output="false">
	<cfscript>
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	CFMLEngineService function init(){
		
		variables.CFMLEngine = new CFMLEngine();
		
		// decorate with engine specific behaviour 
		switch ( UCase( variables.CFMLEngine.getProductName() ) ){
			case "COLDFUSION":
				variables.CFMLEngine = new ColdFusionEngine( variables.CFMLEngine );
				break;
			case "RAILO":
				variables.CFMLEngine = new RailoEngine( variables.CFMLEngine );
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