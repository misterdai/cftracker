<cfcomponent output="false">
	<cffunction name="default" output="false">
		<cfscript>
			var lc = {};
			var settings = '';
			lc.settings = application.settings;
			if (StructKeyExists(arguments, 'display.dateformat')) {
				lc.settings.display.dateformat = arguments.display.dateformat;
			}
			if (StructKeyExists(arguments, 'display.timeformat')) {
				lc.settings.display.timeformat = arguments.display.timeformat;
			}
			if (
				StructKeyExists(arguments, 'security.password')
				And StructKeyExists(arguments, 'security.password2')
				And arguments.security.password Eq arguments.security.password2
				And Len(arguments.security.password) Gt 0
			) {
				lc.settings.security.password = arguments.security.password;
			}
			if (StructKeyExists(arguments, 'security.lockSeconds')) {
				lc.settings.security.lockSeconds = arguments.security.lockSeconds;
			}
			if (StructKeyExists(arguments, 'security.maxAttempts')) {
				lc.settings.security.maxAttempts = arguments.security.maxAttempts;
			}
		</cfscript>
		<cflock name="cftracker-settings" type="exclusive" timeout="10">
			<cfset application.settings = lc.settings />
			<cfset FileWrite(application.config, '<cfsavecontent variable="settings">#SerializeJson(lc.settings)#</cfsavecontent>') />
		</cflock>
	</cffunction>
</cfcomponent>