<cfcomponent output="false">
	<cffunction name="init" access="public" output="false">
		<cfscript>
			variables.jDsServ = CreateObject('java', 'coldfusion.server.ServiceFactory').getDataSourceService();
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getQueries" access="public" output="false">
		<cfscript>
			var lc = {};
			lc.queries = variables.jDsServ.getCachedQueries();
			lc.count = ArrayLen(lc.queries);
			lc.data = {};
			for (lc.q = 1; lc.q Lte lc.count; lc.q++) {
				lc.id = lc.queries[lc.q].getKey().hashCode();
				lc.data[lc.id] = variables.getInfoFromQuery(lc.queries[lc.q]);
			}
			return lc.data;
		</cfscript>
	</cffunction>

	<cffunction name="getQueriesPaged" access="public" output="false">
		<cfargument name="start" type="numeric" required="true" />
		<cfargument name="amount" type="numeric" required="true" />
		<cfargument name="dataName" type="string" required="false" default="data" />
		<cfscript>
			var lc = {};
			lc.queries = variables.jDsServ.getCachedQueries();
			lc.count = ArrayLen(lc.queries);
			lc.keychain = {};
			for (lc.q = 1; lc.q Lte lc.count; lc.q++) {
				lc.keychain[lc.queries[lc.q].getKey().hashCode()] = lc.q;
			}
			lc.keys = StructKeyArray(lc.keychain);
			ArraySort(lc.keys, 'numeric', 'asc');
			lc.records = {};
			lc.records[arguments.dataName] = [];
			lc.records['totalItems'] = lc.count;
			lc.end = arguments.start + arguments.amount;
			lc.records.info = [arguments.start + 1, lc.count, lc.end];
			for (lc.q = arguments.start + 1; lc.q Lte lc.count And lc.q Lte lc.end; lc.q++) {
				lc.info = variables.getInfoFromQuery(lc.queries[lc.keychain[lc.keys[lc.q]]]);
				lc.temp = [
					lc.info.hashCode,
					ArrayLen(lc.info.params),
					lc.info.queryName,
					lc.info.creation,
					lc.info.sql
				];
				ArrayAppend(lc.records[arguments.dataName], lc.temp);
			}
			lc.records['returnedItems'] = ArrayLen(lc.records[arguments.dataName]);
			return lc.records;
		</cfscript>
	</cffunction>
	
	<cffunction name="getInfoFromQuery" access="private" output="false">
		<cfargument name="query" required="true" />
		<cfscript>
			var lc = {};
			lc.id = arguments.query.getKey().hashCode();
			lc.data = {};
			lc.data.creation = DateAdd('s', arguments.query.getCreationTime() / 1000, CreateDate(1970, 1, 1));
			lc.data.dsn = arguments.query.getKey().getDsname();
			lc.data.queryName = arguments.query.getKey().getName();
			lc.data.sql = arguments.query.getKey().getSql();
			lc.data.hashCode = lc.id;
			lc.data.params = [];
			lc.params = arguments.query.getKey().getParamList();
			if (IsDefined('lc.params')) {
				lc.params = lc.params.getAllParameters();
				lc.pCount = ArrayLen(lc.params);
				for (lc.p = 1; lc.p Lte lc.pCount; lc.p++) {
					lc.param.scale = lc.params[lc.p].getScale();
					lc.param.type = lc.params[lc.p].getSqltypeName();
					lc.param.statement = lc.params[lc.p].getStatement();
					lc.param.value = lc.params[lc.p].getObject().toString();
					// Have to use Duplicate() otherwise previous values are used
					ArrayAppend(lc.data.params, Duplicate(lc.param));
					// Not 100% sure on the getObject(), may need conversion?
				}
			}
			lc.stats = arguments.query.getStats();
			if (IsDefined('lc.stats')) {
				lc.data.stats.executionCount = lc.stats.getExecutionCount();
				lc.data.stats.executionTime = lc.stats.getExecutionTime();
				lc.data.stats.functionName = lc.stats.getFunctionName();
				lc.data.stats.hitCount = lc.stats.getHitCount();
				lc.data.stats.lineNo = lc.stats.getLineNo();
				lc.data.stats.size = lc.stats.getSize();
				lc.data.stats.templatePath = lc.stats.getTemplatePath();
				lc.data.stats.isCached = lc.stats.isCached();
				lc.data.stats.isStored = lc.stats.isStored();
			}
			return lc.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getInfo" access="public" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.query = variables.getItem(arguments.id);
			if (lc.query Eq false) {
				return false;
			} else {
				return variables.getInfoFromQuery(lc.query);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getResult" access="public" output="false"> 
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.query = variables.getItem(arguments.id);
			if (lc.query Eq false) {
				return false;
			} else {
				return lc.query.getResult();
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getItem" access="private" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.queries = variables.jDsServ.getCachedQueries();
			lc.count = ArrayLen(lc.queries);
			for (lc.q = 1; lc.q Lte lc.count; lc.q++) {
				if (lc.queries[lc.q].getKey().hashCode() Eq arguments.id) {
					return lc.queries[lc.q];
				}
			}
			return false;
		</cfscript>
	</cffunction>
	
	<cffunction name="purge" access="public" output="false" returntype="boolean">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.query = variables.getItem(arguments.id);
			if (lc.query Eq false) {
				return false;
			} else {
				variables.jDsServ.removeCachedQuery(lc.query.getKey());
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
		<cfreturn variables.jDsServ.getMaxQueryCount() />
	</cffunction>

	<cffunction name="getHitRatio" access="public" output="false" returntype="numeric">
		<cfreturn variables.jDsServ.getCacheHitRatio() />
	</cffunction>
	
	<cffunction name="refresh" access="public" output="false" returntype="boolean">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.query = variables.getItem(arguments.id);
			if (lc.query Eq false) {
				return false;
			} else {
				lc.query.refresh();
				return true;
			}
		</cfscript>
	</cffunction>
</cfcomponent>