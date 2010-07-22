<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.threadTracker = CreateObject('component', 'cftracker.threads').init();
			}
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="default" output="false">
		<cfscript>
			if (application.settings.demo) {
				return application.data.threads;
			} else {
				return variables.threadTracker.getThreads();
			}
		</cfscript>
	</cffunction>
	
</cfcomponent>