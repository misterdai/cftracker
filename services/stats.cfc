<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			var lc = {};
			lc.cfcPath = 'cftracker.';
			if (application.settings.demo) {
				lc.cfcPath &= 'demo.';
			}
			variables.appTracker = CreateObject('component', lc.cfcPath & 'applications').init(application.settings.security.password, request.AdminType);
			variables.queryTracker = CreateObject('component', lc.cfcPath & 'querycache').init();
			variables.sessTracker = CreateObject('component', lc.cfcPath & 'sessions').init(application.settings.security.password, request.AdminType);
			variables.statTracker = CreateObject('component', lc.cfcPath & 'stats').init();
			variables.templateTracker = CreateObject('component', lc.cfcPath & 'templatecache').init();
			variables.threadTracker = CreateObject('component', lc.cfcPath & 'threads').init();
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var lc = {};
			lc.data = {};
			lc.data.server = variables.statTracker.getServerInfo();
			lc.data.compilation = variables.statTracker.getCompilationTime();
			lc.data.classLoading = variables.statTracker.getClassLoading();
			lc.data.cpuTime = variables.statTracker.getProcessCpuTime();
			if (StructKeyExists(variables.statTracker, 'getCf')) {
				lc.data.cf = variables.statTracker.getCf();
			}
			if (StructKeyExists(variables.statTracker, 'getJdbcStats')) {
				lc.data.jdbc = variables.statTracker.getJdbcStats();
			}
			return lc.data;
		</cfscript> 
	</cffunction>
	
	<cffunction name="gc" output="false">
		<cfargument name="rc" />
		<cfset variables.statTracker.runGarbageCollection() />
	</cffunction>

	<cffunction name="graphs" output="false">
		<cfscript>
			var lc = {};
			lc.graphs = {};
			lc.graphs.ts = DateFormat(Now(), 'yyyy-mm-dd ') & TimeFormat(Now(), 'hh:mm:ss');
			// Application sessions
			if (application.cftracker.support.dashboard.appsess) {
				lc.graphs['appsess'] = {};
				lc.apps = variables.appTracker.getApps();
				for (lc.wc in lc.apps) {
					lc.len = ArrayLen(lc.apps[lc.wc]);
					for (lc.i = 1; lc.i Lte lc.len; lc.i++) {
						lc.app = lc.apps[lc.wc][lc.i];
						lc.graphs.appsess[Replace(lc.wc & ' --- ' & lc.app, '\', '\\', 'all')] = variables.sessTracker.getCount(lc.app, lc.wc);
					}
				}
			}
			// Memory
			if (application.cftracker.support.dashboard.memory) {
				lc.graphs['memory'] = ';';
				lc.mem = variables.statTracker.getMemory();
				// Divide all values into MiB for easier graphical display
				lc.graphs.memory &= NumberFormat(lc.mem.heap.usage.used / 1024^2, '.00');
				lc.graphs.memory &= ';' & NumberFormat(lc.mem.heap.usage.max / 1024^2, '.00');
				lc.graphs.memory &= ';' & NumberFormat(lc.mem.heap.usage.committed / 1024^2, '.00');
			}
			// Cache hits
			if (application.cftracker.support.dashboard.cacheHitRatios) {
				lc.graphs['caches'] = '';
				lc.graphs.caches &= ';' & NumberFormat(variables.templateTracker.getClassHitRatio(), '.000');
				lc.graphs.caches &= ';' & NumberFormat(variables.queryTracker.getHitRatio(), '.000');
			}
			// Threads
			if (application.cftracker.support.dashboard.threadGroups) {
				lc.graphs['threads'] = {};
				lc.items = variables.threadTracker.countByGroup();
				for (lc.key in lc.items) {
					lc.graphs.threads[lc.key] = lc.items[lc.key];
				}
			}
			// Return data
			return lc.graphs;
		</cfscript>
	</cffunction>
</cfcomponent>