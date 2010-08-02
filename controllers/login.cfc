<cfcomponent output="false">
	<cfset variables.fw = '' />
	<cffunction name="init" access="public" returntype="void">
		<cfargument name="fw" type="any" required="true" />
		<cfset variables.fw = arguments.fw />
	</cffunction>
	
	<cffunction name="login" access="public" output="false">
		<cfargument name="rc" type="struct" required="true" />
		<cfif session.auth.isLoggedIn>
			<cfset variables.fw.redirect('main.default') />
		</cfif>
		<cfif Not StructKeyExists(rc, 'password')>
			<cfset variables.fw.redirect('login') />
		</cfif>
		<cflock name="#application.applicationName#-login" timeout="10" type="exclusive">
			<cfif application.loginAttempts Gte application.settings.security.maxAttempts>
				<cfif DateAdd('s', application.settings.security.lockperiod * 86400, application.loginDate) Gt Now()>
					<cfset rc.message.error = ['Too many attempts, logins are currently locked out.'] />
					<cfset variables.fw.redirect('login', 'message') />
				<cfelse>
					<cfset application.loginAttempts = 0 />
				</cfif>
			</cfif>
			<cfset application.loginDate = Now() />
			<cfif arguments.rc.password Neq application.settings.security.password>
				<cfset application.loginAttempts++ />
				<cfset rc.message.error = ['Incorrect details, please try again.'] />
				<cfset variables.fw.redirect('login', 'message') />
			<cfelse>
				<cfset application.loginAttempts = 0 />
			</cfif>
		</cflock>
		<cfset session.auth.isLoggedIn = true />
		<cfset variables.fw.redirect('main.default') />
	</cffunction>
	
	<cffunction name="change" access="public" output="false">
		<cfargument name="rc" type="struct" required="true" />
		<cfscript>
			if (StructKeyExists(arguments.rc, 'password') And StructKeyExists(arguments.rc, 'password2')
					And arguments.rc.password Eq arguments.rc.password2
					And Len(Trim(arguments.rc.password)) Gt 0) {
				application.settings.security.password = arguments.rc.password;
				FileWrite(application.config, '<cfsavecontent variable="settings">#SerializeJson(application.settings)#</cfsavecontent>');
				session.auth.isLoggedIn = true;
				variables.fw.redirect('main.default');
			} else if (cgi.request_method Eq 'POST') {
				rc.message.error = ['Please make sure you entered password and that they are equal.'];
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="logout" access="public" output="false">
		<cfargument name="rc" type="struct" required="true" />
		<cfset session.auth.isLoggedIn = false />
		<cfset variables.fw.redirect('login.default') />
	</cffunction>
</cfcomponent>