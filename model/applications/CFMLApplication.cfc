<cfcomponent output="false">
	<cfscript>
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	
	private any function init( required appname ){
		variables.appname = arguments.appname;
		return this;
	} 
	
	/* -------------------------- PUBLIC -------------------------- */
	
	struct function getScope(){
		throw( message="abstract method" );
	}
	
	struct function getInfo(){
		throw( message="abstract method" );
	}
	
	/* -------------------------- PRIVATE -------------------------- */
	
	
	</cfscript>
</cfcomponent>