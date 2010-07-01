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
			local.structTemplate.data = [GetTickCount(), variables.templateTracker.getClassHitRatio()];
			local.structQuery.label = 'Query';
			local.structQuery.description = 'Query Cache hit ratio';
			local.structQuery.data = [GetTickCount(), variables.queryTracker.getHitRatio()];
			local.data = [local.structTemplate,local.structQuery];
			return local.data;
		</cfscript>
	</cffunction>
	
</cfcomponent>