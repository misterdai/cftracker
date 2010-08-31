<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			var lc = {};
			lc.cfcPath = 'cftracker.';
			if (application.settings.demo) {
				lc.cfcPath &= 'demo.';
			}
			variables.statsTracker = CreateObject('component', lc.cfcPath & 'stats').init();
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="default" output="false">
		<cfscript>
			var lc = {};
			lc.data = {
				memory = variables.statsTracker.getMemory(),
				garbage = variables.statsTracker.getGarbage()
			};
			return lc.data;
		</cfscript>
	</cffunction>
</cfcomponent>