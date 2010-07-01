<cfcomponent output="false">
	<cffunction name="init" access="public" output="false">
		<cfscript>
			variables.jDsServ = CreateObject('java', 'coldfusion.server.ServiceFactory').getDataSourceService();
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getQueries" access="public" output="false">
		<cfscript>
			var local = {};
			local.queries = variables.jDsServ.getCachedQueries();
			local.count = ArrayLen(local.queries);
			local.data = {};
			for (local.q = 1; local.q Lte local.count; local.q++) {
				local.id = local.queries[local.q].getKey().hashCode();
				local.data[local.id] = variables.getInfoFromQuery(local.queries[local.q]);
			}
			return local.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getInfoFromQuery" access="private" output="false">
		<cfargument name="query" required="true" />
		<cfscript>
			var local = {};
			local.id = arguments.query.getKey().hashCode();
			local.data.creation = DateAdd('s', arguments.query.getCreationTime() / 1000, CreateDate(1970, 1, 1));
			local.data.dsn = arguments.query.getKey().getDsname();
			local.data.queryName = arguments.query.getKey().getName();
			local.data.sql = arguments.query.getKey().getSql();
			local.data.hashCode = local.id;
			local.data.params = [];
			local.params = arguments.query.getKey().getParamList();
			if (IsDefined('local.params')) {
				local.params = local.params.getAllParameters();
				local.pCount = ArrayLen(local.params);
				for (local.p = 1; local.p Lte local.pCount; local.p++) {
					local.param.scale = local.params[local.p].getScale();
					local.param.type = local.params[local.p].getSqltypeName();
					local.param.statement = local.params[local.p].getStatement();
					local.param.value = local.params[local.p].getObject();
					ArrayAppend(local.data.params, local.param);
					// Not 100% sure on the getObject(), may need conversion?
				}
			}
			local.stats = arguments.query.getStats();
			if (IsDefined('local.stats')) {
				local.data.stats.executionCount = local.stats.getExecutionCount();
				local.data.stats.executionTime = local.stats.getExecutionTime();
				local.data.stats.functionName = local.stats.getFunctionName();
				local.data.stats.hitCount = local.stats.getHitCount();
				local.data.stats.lineNo = local.stats.getLineNo();
				local.data.stats.size = local.stats.getSize();
				local.data.stats.templatePath = local.stats.getTemplatePath();
				local.data.stats.isCached = local.stats.isCached();
				local.data.stats.isStored = local.stats.isStored();
			}
			return local.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getInfo" access="public" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var local = {};
			local.query = variables.getItem(arguments.id);
			if (local.query Eq false) {
				return false;
			} else {
				return variables.getInfoFromQuery(local.query);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getResult" access="public" output="false"> 
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var local = {};
			local.query = variables.getItem(arguments.id);
			if (local.query Eq false) {
				return false;
			} else {
				return local.query.getResult();
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getItem" access="private" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var local = {};
			local.queries = variables.jDsServ.getCachedQueries();
			local.count = ArrayLen(local.queries);
			for (local.q = 1; local.q Lte local.count; local.q++) {
				if (local.queries[local.q].getKey().hashCode() Eq arguments.id) {
					return local.queries[local.q];
				}
			}
			return false;
		</cfscript>
	</cffunction>
	
	<cffunction name="purge" access="public" output="false" returntype="boolean">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var local = {};
			local.query = variables.getItem(arguments.id);
			if (local.query Eq false) {
				return false;
			} else {
				variables.jDsServ.removeCachedQuery(local.query.getKey());
				return true;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="purgeAll" access="public" output="false" returntype="boolean">
		<cfset variables.jDsServ.purgeQueryCache() />
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getCount" access="public" output="false" returntype="any">
		<cfreturn ArrayLen(variables.jDsServ.getCachedQueries()) />
	</cffunction>

	<cffunction name="getMaxCount" access="public" output="false" returntype="any">
		<cfdump var="#variables.jDsServ.getMaxQueryCount()#"><cfabort>
		<cfreturn variables.jDsServ.getMaxQueryCount() />
	</cffunction>

	<cffunction name="getHitRatio" access="public" output="false" returntype="numeric">
		<cfreturn variables.jDsServ.getCacheHitRatio() />
	</cffunction>
	
	<cffunction name="refresh" access="public" output="false" returntype="boolean">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var local = {};
			local.query = variables.getItem(arguments.id);
			if (local.query Eq false) {
				return false;
			} else {
				local.query.refresh();
				return true;
			}
		</cfscript>
	</cffunction>
</cfcomponent>