<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.statTracker = CreateObject('component', 'cftracker.stats').init();
				variables.templateTracker = CreateObject('component', 'cftracker.templatecache').init();
				variables.queryTracker = CreateObject('component', 'cftracker.querycache').init();
			}
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var local = {};
			local.data = {};
			if (application.settings.demo) {
				local.data = application.data.stats;
			} else {
				local.data.mem = variables.statTracker.getMemInfo();
				local.data.server = variables.statTracker.getServerInfo();
			}
			return local.data;
		</cfscript> 
	</cffunction>

	<cffunction name="graphmem" output="false">
		<cfscript>
			var local = {};
			if (application.settings.demo) {
				local.mem = application.data.stats.mem;
			} else {
				local.mem = variables.statTracker.getMemInfo();
			}
			local.structUsed.label='Used';
			local.structUsed.description='Currently used';
			local.structUsed.data=[GetTickCount(), local.mem.used];
			local.structMax.label='Max';
			local.structMax.description='Maximum allowed';
			local.structMax.data=[GetTickCount(), local.mem.max];
			local.structAllocated.label='Allocated';
			local.structAllocated.description='Current allocated';
			local.structAllocated.data=[GetTickCount(), local.mem.allocated];
			local.data = [local.structUsed, local.structMax, local.structAllocated];
			return local.data;
		</cfscript>
	</cffunction>

	<cffunction name="graphcache" output="false">
		<cfscript>
			var local = {};
			local.structTemplate.label = 'Template';
			local.structTemplate.description = 'Template Cache Class hit ratio';
			local.structQuery.label = 'Query';
			local.structQuery.description = 'Query Cache hit ratio';
			if (application.settings.demo) {
				local.structTemplate.data = [GetTickCount(), application.data.templateCache.hitRatio];
				local.structQuery.data = [GetTickCount(), application.data.queryCache.hitRatio];
			} else {
				local.structTemplate.data = [GetTickCount(), variables.templateTracker.getClassHitRatio()];
				local.structQuery.data = [GetTickCount(), variables.queryTracker.getHitRatio()];
			}
			local.data = [local.structTemplate,local.structQuery];
			return local.data;
		</cfscript>
	</cffunction>
	
</cfcomponent>