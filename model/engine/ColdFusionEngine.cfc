<cfcomponent extends="AbstractCFMLEngine" output="false">
	<cfscript>
	
	/* -------------------------- CONTRUCTOR -------------------------- */
	
	any function init(){
		
		super.init();
		
		// ColdFusion specific...
		variables.jAppTracker = CreateObject( 'java', 'coldfusion.runtime.ApplicationScopeTracker' );
		variables.jSessTracker = CreateObject( 'java', 'coldfusion.runtime.SessionTracker' );
		
		var mirror = [];
		variables.class = mirror.getClass().forName( 'coldfusion.runtime.ApplicationScope' );
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	
	/**
	* returns an array of running application names on this server
	**/
	array function getApplicationNames(){
		var result = [];
		var ApplicationKeys = variables.jAppTracker.getApplicationKeys();
		while ( ApplicationKeys.hasMoreElements() ){
			result.add( ApplicationKeys.nextElement() );
		}
		return result;
	}
	
	/* -------------------------- PRIVATE -------------------------- */

	
	</cfscript>
</cfcomponent>