component accessors="true" {

	/* -------------------------- DEPENDANCIES -------------------------- */
	property name="Config" getter="false";
	property name="ValidationService" getter="false";
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	UserService function init(){
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	any function loginUser( required passsword ){
		var ValidationResult = ValidationService.newResult();
		logoutUser();
		if ( hasExceededLoginAttempts() ) {
			ValidationResult.addError( "Too many attempts, logins are currently locked out." );
		}
		else if ( arguments.passsword == '' ) {
			ValidationResult.addError( "Please enter the password." );
		}
		else if ( !variables.Config.isValidPassword( arguments.password ) ) {
			ValidationResult.addError( "Incorrect details, please try again." );
		}
		else {
			// valid user so log in
			setLoggedIn();
		}
		return ValidationResult;
	}
	
	boolean function logoutUser(){
		var result = false;
		lock scope="session" timeout="5"{
			result = StructDelete( session, "loggedin" );
		}
		return result;
	}
	
	boolean function isAuthorised( action ){
		var securearea = true; // secure by default
		var whitelist = variables.Config.getSecureWhitelist;
		if( !isLoggedIn() ){
			for ( var unsecured in whitelist ){
				if( ReFindNoCase( unsecured, arguments.action ) ){
					securearea = false;
					break;
				}
			}
		}
		return securearea;
	}
	
	
	/* -------------------------- PRIVATE -------------------------- */
	private void function setLoggedIn(){
		lock scope="Session" timeout="5"{
			session.loggedin = Now();  
		}
	}

	private boolean function isLoggedIn(){
		return StructKeyExists( session, "loggedin" );
	}

	// track login attempts by IP address, not 100% reliable but better than nothing!
	private boolean function hasExceededLoginAttempts(){
		var result = true;
		lock scope="Session" timeout="5"{  
			if ( !StructKeyExists( session, "loginAttempts" ) ){
				session.loginAttempts = 1;
			}
			else{
				session.loginAttempts++;
			}
			result = variables.Config.getAllowedLoginAttempts() < session.LoginAttempts;
		}
		return result;
	}
	
}