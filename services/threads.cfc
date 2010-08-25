<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			var lc = {};
			lc.cfcPath = 'cftracker.';
			if (application.settings.demo) {
				lc.cfcPath &= 'demo.';
			}
			variables.threadTracker = CreateObject('component', lc.cfcPath & 'threads').init();
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="default" output="false">
		<cfreturn variables.threadTracker.getThreads() />
	</cffunction>
</cfcomponent>