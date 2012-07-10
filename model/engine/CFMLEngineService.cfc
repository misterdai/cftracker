<cfcomponent output="false">
	<cfscript>
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	CFMLEngineService function init(){
		
		variables.CFMLEngine = new CFMLEngine();
		
		// decorate with engine specific behaviour 
		if ( variables.CFMLEngine.isColdFusion() ){
			variables.CFMLEngine = new ColdFusionEngine( variables.CFMLEngine );
		}
		else if ( variables.CFMLEngine.isRailo() ){
			variables.CFMLEngine = new RailoEngine( variables.CFMLEngine );
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