<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			var lc = {};
			lc.cfcPath = 'cftracker.';
			if (application.settings.demo) {
				lc.cfcPath &= 'demo.';
			}
			variables.queryTracker = CreateObject('component', lc.cfcPath & 'querycache').init();
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false"></cffunction>

	<cffunction name="items" output="false">
		<cfscript>
			var lc = {};
			lc.data = variables.queryTracker.getQueriesPaged(arguments.iDisplayStart, arguments.iDisplayLength, 'aaData');
			lc.data['iTotalRecords'] = lc.data.totalItems;
			lc.data['iTotalDisplayRecords'] = lc.data.totalItems;
			lc.data['sEcho'] = arguments.sEcho;
			return lc.data;
		</cfscript>
	</cffunction>

	<cffunction name="getparams" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset var lc = {} />
		<cfset lc.data = variables.queryTracker.getInfo(arguments.name) />
		<cfif IsBoolean(lc.data)>
			<cfset lc.data = {
				params = ArrayNew(1)
			} />
		</cfif>
		<cfreturn lc.data />
	</cffunction>
	
	<cffunction name="getResult" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfreturn variables.queryTracker.getResult(arguments.name) />
	</cffunction>
	
	<cffunction name="purge" output="false">
		<cfargument name="queries" />
		<cfset var lc = {} />
		<cfloop array="#arguments.queries#" index="lc.q">
			<cfset variables.queryTracker.purge(lc.q) />
		</cfloop>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="queries" />
		<cfset var lc = {} />
		<cfloop array="#arguments.queries#" index="lc.q">
			<cfset variables.queryTracker.refresh(lc.q) />
		</cfloop>
	</cffunction>

	<cffunction name="filter" output="false" access="private">
		<cfargument name="sql" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="creation" type="string" required="false" default="" />
		<cfargument name="creationOp" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			lc.queries = variables.queryTracker.getQueries();
			for (lc.q in lc.queries) {
				if (Len(arguments.sql) Gt 0) {
					if (Not ReFindNoCase(arguments.sql, lc.queries[lc.q].sql)) {
						StructDelete(lc.queries, lc.q);
					}
				}
				if (Len(arguments.name) Gt 0) {
					if (Not ReFindNoCase(arguments.name, lc.queries[lc.q].sql)) {
						StructDelete(lc.queries, lc.q);
					}
				}
				if (Len(arguments.creation) Gt 0 And Len(arguments.creationOp) Gt 0) {
					if (arguments.creationOp Eq 'before' And ParseDateTime(arguments.creation) Lte lc.queries[lc.q].creation) {
						StructDelete(lc.queries, lc.q);
					} else if (arguments.creationOp Eq 'on' And ParseDateTime(arguments.creation) Neq lc.queries[lc.q].creation) {
						StructDelete(lc.queries, lc.q);
					} else if (arguments.creationOp Eq 'after' And ParseDateTime(arguments.creation) Gte lc.queries[lc.q].creation) {
						StructDelete(lc.queries, lc.q);
					}
				}
			}
			return lc.queries;
		</cfscript>
	</cffunction>

	<cffunction name="purgeBy" output="false">
		<cfargument name="sql" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="creation" type="string" required="false" default="" />
		<cfargument name="creationOp" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(arguments, 'Processing')) {
				lc.result = application.validateThis.validate(
					objectType = 'Query',
					theObject = form
				);
				if (lc.result.getIsSuccess()) {
					lc.queries = filter(argumentCollection = arguments);
					for (lc.q in lc.queries) {
						variables.queryTracker.purge(lc.q);
					}
				}
				lc.resultData = {
					uniFormErrors = lc.result.getFailuresForUniForm(),
					success = lc.result.getIsSuccess()
				};
				return lc.resultData;
			}
		</cfscript>
	</cffunction>

	<cffunction name="purgeAll" output="false">
		<cfset variables.queryTracker.purgeAll() />
	</cffunction>

	<cffunction name="refreshBy" output="false">
		<cfargument name="sql" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="creation" type="string" required="false" default="" />
		<cfargument name="creationOp" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(arguments, 'Processing')) {
				lc.result = application.validateThis.validate(
					objectType = 'Query',
					theObject = form
				);
				if (lc.result.getIsSuccess()) {
					lc.queries = filter(argumentCollection = arguments);
					for (lc.q in lc.queries) {
						variables.queryTracker.refresh(lc.q);
					}
				}
				lc.resultData = {
					uniFormErrors = lc.result.getFailuresForUniForm(),
					success = lc.result.getIsSuccess()
				};
				return lc.resultData;
			}
		</cfscript>
	</cffunction>
</cfcomponent>