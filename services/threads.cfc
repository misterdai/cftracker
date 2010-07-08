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
	
	<cffunction name="graphgroups" output="false">
		<cfscript>
			var local = {};
			if (application.settings.demo) {
				local.items = application.data.threadGroups;
			} else {
				local.items = variables.threadTracker.countByGroup();
			}
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