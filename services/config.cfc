<cfcomponent output="false">
	<cffunction name="default" output="false">
		<cfset var lc = {} />
		<cfif StructKeyExists(arguments, 'Processing')>
			<cfset lc.result = application.validateThis.validate(
				objectType = 'Config',
				theObject = form
			) />
			<cfif lc.result.getIsSuccess()>
				<cfset lc.settings = {} />
				<cfset lc.settings.display = {
					dateformat = arguments.dateformat,
					timeformat = arguments.timeformat
				} />
				<cfset lc.settings.security = {
					lockSeconds = arguments.lockSeconds,
					maxAttempts = arguments.maxAttempts
				} />
				<cfif StructKeyExists(arguments, 'password') And Len(arguments.password) Gt 0>
					<cfset lc.settings.security.password = arguments.password />
				</cfif>
				<cflock name="cftracker-settings" type="exclusive" timeout="10">
					<cfscript>
						StructAppend(application.settings.display, lc.settings.display, true);
						StructAppend(application.settings.security, lc.settings.security, true);
						FileWrite(application.config, '<cfsavecontent variable="settings">#SerializeJson(application.settings)#</cfsavecontent>');
					</cfscript>
				</cflock>
			</cfif>
			<cfreturn lc.result />
		</cfif>
	</cffunction>
</cfcomponent>