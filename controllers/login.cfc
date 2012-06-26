<cfcomponent output="false">
	<cfset variables.fw = '' />
	<cffunction name="init" access="public" returntype="void">
		<cfargument name="fw" type="any" required="true" />
		<cfset variables.fw = arguments.fw />
	</cffunction>
	
	<cffunction name="default" access="public" output="false">
		<cfargument name="rc" type="struct" required="true" />
		<cfset var lc = {} />
		<cfif cgi.request_method Eq 'post'>
			<cfset arguments.rc.formData = {} />
			<cfset arguments.rc.formData.uniformerrors = [] />
			<cfset arguments.rc.formData.success = true />
			<cfif application.settings.demo And StructKeyExists(arguments.rc, 'password')>
				<!--- Log anyone in if demo --->
				<cfset session.auth.isLoggedIn = true />
			</cfif>
			<cfif session.auth.isLoggedIn>
				<cfset variables.fw.redirect('main.default') />
			</cfif>
			<cfif Not StructKeyExists(arguments.rc, 'password') Or Len(arguments.rc.password) Eq 0>
				<cfset arguments.rc.formdata.uniFormErrors[1] = {
					field = 'form',
					message = 'Please enter the password.'
				} />
				<cfset arguments.rc.formData.success = false />
				<cfset variables.fw.redirect('login.default', 'formData') />
			</cfif>
			<cflock name="#application.applicationName#-login" timeout="10" type="exclusive">
				<cfif application.loginAttempts Gte application.settings.security.maxAttempts>
					<cfif DateAdd('s', application.settings.security.lockSeconds, application.loginDate) Gt Now()>
						<cfset arguments.rc.formdata.uniFormErrors[1] = {
							field = 'form',
							message = 'Too many attempts, logins are currently locked out.'
						} />
						<cfset arguments.rc.formData.success = false />
						<cfset variables.fw.redirect('login.default', 'formData') />
					<cfelse>
						<cfset application.loginAttempts = 0 />
					</cfif>
				</cfif>
				<cfset application.loginDate = Now() />
				<cfif arguments.rc.password Neq application.settings.security.password>
					<cfset application.loginAttempts++ />
					<cfset arguments.rc.formdata.uniFormErrors[1] = {
						field = 'form',
						message = 'Incorrect details, please try again.'
					} />
					<cfset arguments.rc.formData.success = false />
					<cfset variables.fw.redirect('login.default', 'formData') />
				<cfelse>
					<cfset application.loginAttempts = 0 />
				</cfif>
				<!---
					Don't login just yet
					If Railo, we need the server admin password.
				--->
				<cfif server.coldfusion.productName Eq 'Railo'>
					<cftry>
						<cfset getPageContext().getConfig().getConfigServer(arguments.rc.password) />
						<cfcatch type="any">
							<cfset application.settings.security.password = 'password' />
							<cfset arguments.rc.formdata.uniFormErrors[1] = {
								field = 'form',
								message = 'Password must be the Railo server admin password for CfTracker to access required information.'
							} />
							<cfset arguments.rc.formData.success = false />
							<cfset variables.fw.redirect('login.change', 'formData') />
						</cfcatch>
					</cftry>
				</cfif>
			</cflock>
			
			<cfset session.auth.isLoggedIn = true />
			<cfset variables.fw.redirect('main.default') />
		</cfif>
	</cffunction>
	
	<cffunction name="change" access="public" output="false">
		<cfargument name="rc" type="struct" required="true" />
		<cfset var settings = '' />
		<cfif StructKeyExists(arguments.rc, 'password') And StructKeyExists(arguments.rc, 'password2')
					And arguments.rc.password Eq arguments.rc.password2
					And Len(Trim(arguments.rc.password)) Gt 0>
			<cfif server.coldfusion.productName Eq 'Railo'>
				<cftry>
					<cfset getPageContext().getConfig().getConfigServer(arguments.rc.password) />
					<cfcatch type="any">
						<cfset application.settings.security.password = 'password' />
						<cfset arguments.rc.formdata.uniFormErrors[1] = {
							field = 'form',
							message = 'Password must be the Railo server admin password for CfTracker to access required information.'
						} />
						<cfset arguments.rc.formData.success = false />
						<cfset variables.fw.redirect('login.change', 'formData') />
					</cfcatch>
				</cftry>
			</cfif>
			<cfset application.settings.security.password = arguments.rc.password />
			<cfset FileWrite(application.config, '<cfsavecontent variable="settings">#SerializeJson(application.settings)#</cfsavecontent>') />
			<cfset session.auth.isLoggedIn = true />
			<cfset variables.fw.redirect('main.default') />
		<cfelseif cgi.request_method Eq 'POST'>
			<cfset arguments.rc.formdata.uniFormErrors[1] = {
				field = 'form',
				message = 'Please make sure that the passwords you entered match.'
			} />
			<cfset arguments.rc.formData.success = false />
		</cfif>
	</cffunction>
	
	<cffunction name="logout" access="public" output="false">
		<cfargument name="rc" type="struct" required="true" />
		<cfset session.auth.isLoggedIn = false />
		<cfset variables.fw.redirect('login.default') />
	</cffunction>
</cfcomponent>