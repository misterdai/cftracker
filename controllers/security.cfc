<cfcomponent><cfscript>

	function init(fw) {
		variables.fw = fw;
	}

	function session(rc) {
		// set up the user's session
		session.auth = {};
		session.auth.isLoggedIn = false;
		session.auth.fullname = 'Guest';
	}
	
	function authorize(rc) {
		// check to make sure the user is logged on
		if (Not StructKeyExists(session, 'auth')) {
			variables.session(arguments.rc);
		}
		if (Not session.auth.isLoggedIn) {
			if ((application.settings.security.password Eq 'password' Or Len(application.settings.security.password) Eq 0) And
					Not ListFindNoCase('login.change', variables.fw.getFullyQualifiedAction())
				) {
				variables.fw.redirect('login.change');
			} else if (not listfindnocase('login', variables.fw.getSection() ) and 
				not listfindnocase( 'main.error', variables.fw.getFullyQualifiedAction() ) ) {
				variables.fw.redirect('login.login');
			}
		}
	}

</cfscript></cfcomponent>