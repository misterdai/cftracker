<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfset variables.threadTracker = CreateObject('component', 'cftracker.threads').init() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="default" output="false">
		<cfreturn variables.threadTracker.getThreads() />
	</cffunction>
	
	<cffunction name="graphgroups" output="false">
		<cfscript>
			var local = {};
			local.items = variables.threadTracker.countByGroup();
			local.data = [];
			for (local.key in local.items) {
				local.info = {
					label = local.key,
					description = local.key & ' thread group',
					data = [GetTickCount(), local.items[local.key]]
				};
				ArrayAppend(local.data, local.info);
			}
			return local.data;
		</cfscript>
	</cffunction>
</cfcomponent>