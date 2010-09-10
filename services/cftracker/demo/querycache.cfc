<cfcomponent output="false">
	<cffunction name="init" access="public" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="getQueries" access="public" output="false">
		<cfscript>
			var lc = {};
			lc.data = {};
			for (lc.q in application.demo.queries.items) {
				lc.data[lc.q] = Duplicate(application.demo.queries.items[lc.q].metadata);
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
			lc.count = StructCount(application.demo.queries.items);
			lc.records = {};
			lc.records[arguments.dataName] = [];
			lc.records['totalItems'] = lc.count;
			lc.end = arguments.start + arguments.amount;
			lc.records.info = [arguments.start + 1, lc.count, lc.end];
			for (lc.q in application.demo.queries.items) {
				lc.info = application.demo.queries.items[lc.q].metadata;
				lc.temp = [
					lc.info.hashCode,
					ArrayLen(lc.info.params),
					lc.info.queryName,
					lc.info.creation,
					lc.info.sql
				];
				ArrayAppend(lc.records[arguments.dataName], lc.temp);
			}
			lc.records['returnedItems'] = lc.count;
			return lc.records;
		</cfscript>
	</cffunction>
	
	<cffunction name="getInfoFromQuery" access="private" output="false">
		<cfargument name="query" required="true" />
		<cfscript>
			var lc = {};
			lc.id = arguments.query.metadata.hashcode;
			lc.data = {};
			lc.data.creation = arguments.query.metadata.creation;
			lc.data.queryName = arguments.query.metadata.queryName;
			lc.data.sql = arguments.query.metadata.sql;
			lc.data.hashCode = arguments.query.metadata.hashcode;
			lc.data.params = Duplicate(arguments.query.metadata.params);
			return lc.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getInfo" access="public" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.query = variables.getItem(arguments.id);
			if (IsSimpleValue(lc.query) And lc.query Eq false) {
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
			if (IsSimpleValue(lc.query) And lc.query Eq false) {
				return false;
			} else {
				return lc.query.results;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getItem" access="private" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(application.demo.queries.items, arguments.id)) {
				return application.demo.queries.items[arguments.id];
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="purge" access="public" output="false" returntype="boolean">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(application.demo.queries.items, arguments.id)) {
				StructDelete(application.demo.queries.items, arguments.id);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="purgeAll" access="public" output="false" returntype="boolean">
		<cfset StructClear(application.demo.queries.items) />
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getCount" access="public" output="false" returntype="any">
		<cfreturn ArrayLen(variables.jDsServ.getCachedQueries()) />
	</cffunction>

	<cffunction name="getMaxCount" access="public" output="false" returntype="any">
		<cfreturn 10 />
	</cffunction>

	<cffunction name="getHitRatio" access="public" output="false" returntype="numeric">
		<cfreturn application.demo.queries.hitRatio />
	</cffunction>
	
	<cffunction name="refresh" access="public" output="false" returntype="boolean">
		<cfargument name="id" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.query = variables.getItem(arguments.id);
			if (IsSimpleValue(lc.query) And lc.query Eq false) {
				return false;
			} else {
				lc.query.metadata.creation = Now();
				return true;
			}
		</cfscript>
	</cffunction>
</cfcomponent>