<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfset variables.statTracker = CreateObject('component', 'cftracker.stats').init() />
		<cfset variables.templateTracker = CreateObject('component', 'cftracker.templatecache').init() />
		<cfset variables.queryTracker = CreateObject('component', 'cftracker.querycache').init() />
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var local = {};
			local.data = {};
			local.data.mem = variables.statTracker.getMemInfo();
			local.data.server = variables.statTracker.getServerInfo();
			return local.data;
		</cfscript> 
	</cffunction>

	<cffunction name="graphmem" output="false">
		<cfscript>
			var local = {};
			local.mem = variables.statTracker.getMemInfo();
			local.data = [
				{
					label = 'Used',
					description = 'Currently used',
					data = [GetTickCount(), local.mem.used]
				},
				{
					label = 'Max',
					description = 'Maximum allowed',
					data = [GetTickCount(), local.mem.max]
				},
				{
					label = 'Allocated',
					description = 'Current allocated',
					data = [GetTickCount(), local.mem.allocated]
				}
			];
			return local.data;
		</cfscript>
	</cffunction>

	<cffunction name="graphcache" output="false">
		<cfscript>
			var local = {};
			local.data = [
				{
					label = 'Template',
					description = 'Template Cache Class hit ratio',
					data = [GetTickCount(), variables.templateTracker.getClassHitRatio()]
				},
				{
					label = 'Query',
					description = 'Query Cache hit ratio',
					data = [GetTickCount(), variables.queryTracker.getHitRatio()]
				}
			];
			return local.data;
		</cfscript>
	</cffunction>
	
</cfcomponent>