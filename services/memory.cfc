<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.statsTracker = CreateObject('component', 'cftracker.stats').init();
			}
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