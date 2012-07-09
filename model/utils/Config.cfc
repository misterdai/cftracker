component{

	/* -------------------------- CONSTRUCTOR -------------------------- */
	any function init( required struct settings ){
		variables.settings = arguments.settings;
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	numeric function getAllowedLoginAttempts(){
		return variables.settings.security.maxAttempts;
	}
	
	boolean function isValidPassword( required password ){
		return Compare( Hash( variables.settings.security.password ), Hash( arguments.password )) == 0;
	}

	// returns an array of regular expressions defining what is public
	array function getSecureWhiteList(){
		return [ "login\..*" ];
	}

	/* -------------------------- PUBLIC -------------------------- */

	private struct function getSettings(){
		return variables.settings;
	}
}