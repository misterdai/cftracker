<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.appTracker = CreateObject('component', 'cftracker.applications').init();
				variables.queryTracker = CreateObject('component', 'cftracker.querycache').init();
				variables.sessTracker = CreateObject('component', 'cftracker.sessions').init();
				variables.statTracker = CreateObject('component', 'cftracker.stats').init();
				variables.templateTracker = CreateObject('component', 'cftracker.templatecache').init();
				variables.threadTracker = CreateObject('component', 'cftracker.threads').init();
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
				local.data.mem = variables.statTracker.getMemory();
				local.data.server = variables.statTracker.getServerInfo();
			}
			return local.data;
		</cfscript> 
	</cffunction>

<!---	<cffunction name="graphs" output="false">
		<cfscript>
			var local = {};
			local.graphs = {};
			// Application sessions
			local.graphs.appSess = [];
			if (application.settings.demo) {
				local.apps = StructKeyArray(application.data.apps);
			} else {
				local.apps = variables.appTracker.getApps();
			}
			local.count = ArrayLen(local.apps);
			for (local.a = 1; local.a Lte local.count; local.a++) {
				local.info = {};
				local.info.label = local.apps[local.a];
				local.info.description = local.apps[local.a];
				if (application.settings.demo) {
					local.info.data = [GetTickCount(), application.data.apps[local.apps[local.a]].metadata.sessionCount];
				} else {
					local.info.data = [GetTickCount(), variables.appTracker.getSessionCount(local.apps[local.a]).sessionCount];
				}
				ArrayAppend(local.graphs.appSess, local.info);
			}
			// Memory
			local.graphs.memory = [];
			if (application.settings.demo) {
				local.mem = application.data.stats.mem;
			} else {
				local.mem = variables.statTracker.getMemory();
			}
			// Divide all values into MB for easier graphical display
			local.structUsed.label='Used';
			local.structUsed.description='Currently used';
			local.structUsed.data=[GetTickCount(), local.mem.heap.usage.used / 1024^2];
			local.structMax.label='Max';
			local.structMax.description='Maximum allowed';
			local.structMax.data=[GetTickCount(), local.mem.heap.usage.max / 1024^2];
			local.structAllocated.label='Allocated';
			local.structAllocated.description='Current allocated';
			local.structAllocated.data=[GetTickCount(), local.mem.heap.usage.committed / 1024^2];
			local.graphs.memory = [local.structUsed, local.structMax, local.structAllocated];
			// Cache hits
			local.graphs.caches = [];
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
			local.graphs.caches = [local.structTemplate,local.structQuery];
			// Threads
			local.graphs.threads = [];
			if (application.settings.demo) {
				local.items = application.data.threadGroups;
			} else {
				local.items = variables.threadTracker.countByGroup();
			}
			for (local.key in local.items) {
				local.info = {
					label = local.key,
					description = local.key & ' thread group',
					data = [GetTickCount(), local.items[local.key]]
				};
				ArrayAppend(local.graphs.threads, local.info);
			}
			// Return data
			return local.graphs;
		</cfscript>
	</cffunction>--->

	<cffunction name="graphs" output="false">
		<cfscript>
			var local = {};
			local.graphs = {};
			local.graphs.ts = DateFormat(Now(), 'yyyy-mm-dd ') & TimeFormat(Now(), 'hh:mm:ss');
			// Application sessions
			local.graphs['appsess'] = {};
			if (application.settings.demo) {
				local.apps = StructKeyArray(application.data.apps);
			} else {
				local.apps = variables.appTracker.getApps();
			}
			local.count = ArrayLen(local.apps);
			for (local.a = 1; local.a Lte local.count; local.a++) {
				if (application.settings.demo) {
					//local.graphs.appsess[local.apps[local.a]] = application.data.apps[local.apps[local.a]].metadata.sessionCount;
				} else {
					local.graphs.appsess[Replace(local.apps[local.a], '\', '\\', 'all')] = variables.sessTracker.getCount(local.apps[local.a]);
				}
			}
			// Memory
			local.graphs['memory'] = ';';
			if (application.settings.demo) {
				local.mem = application.data.stats.mem;
			} else {
				local.mem = variables.statTracker.getMemory();
			}
			// Divide all values into MiB for easier graphical display
			local.graphs.memory &= NumberFormat(local.mem.heap.usage.used / 1024^2, '.00');
			local.graphs.memory &= ';' & NumberFormat(local.mem.heap.usage.max / 1024^2, '.00');
			local.graphs.memory &= ';' & NumberFormat(local.mem.heap.usage.committed / 1024^2, '.00');
			// Cache hits
			local.graphs['caches'] = '';
			if (application.settings.demo) {
				local.graphs.caches &= ';' & NumberFormat(application.data.templateCache.hitRatio, '.000');
				local.graphs.caches &= ';' & NumberFormat(application.data.queryCache.hitRatio, '.000');
			} else {
				local.graphs.caches &= ';' & NumberFormat(variables.templateTracker.getClassHitRatio(), '.000');
				local.graphs.caches &= ';' & NumberFormat(variables.queryTracker.getHitRatio(), '.000');
			}
			// Threads
			local.graphs['threads'] = {};
			if (application.settings.demo) {
				local.items = application.data.threadGroups;
			} else {
				local.items = variables.threadTracker.countByGroup();
			}
			for (local.key in local.items) {
				local.graphs.threads[local.key] = local.items[local.key];
			}
			// Return data
			return local.graphs;
		</cfscript>
	</cffunction>
</cfcomponent>