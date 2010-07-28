<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.queryTracker = CreateObject('component', 'cftracker.querycache').init();
			}
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var lc = {};
			lc.data = {};
			return lc.data;
		</cfscript> 
	</cffunction>

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
		<cfscript>
			var lc = {};
			if (application.settings.demo) {
				return application.data.queries[arguments.name].metadata;
			} else {
				return variables.queryTracker.getInfo(arguments.name);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getResult" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			if (application.settings.demo) {
				return application.data.queries[arguments.name].results;
			} else {
				return variables.queryTracker.getResult(arguments.name);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="purge" output="false">
		<cfargument name="queries" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.queries#" index="lc.q">
				<cfset variables.queryTracker.purge(lc.q) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="queries" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.queries#" index="lc.q">
				<cfset variables.queryTracker.refresh(lc.q) />
			</cfloop>
		</cfif>
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
			if (Not application.settings.demo) {
				lc.queries = filter(argumentCollection = arguments);
				for (lc.q in lc.queries) {
					variables.queryTracker.purge(lc.q);
				}
			}
		</cfscript>
	</cffunction>

	<cffunction name="purgeAll" output="false">
		<cfscript>
			variables.queryTracker.purgeAll();
		</cfscript>
	</cffunction>

	<cffunction name="refreshBy" output="false">
		<cfargument name="sql" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="creation" type="string" required="false" default="" />
		<cfargument name="creationOp" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			if (Not application.settings.demo) {
				lc.queries = filter(argumentCollection = arguments);
				for (lc.q in lc.queries) {
					variables.queryTracker.refresh(lc.q);
				}
			}
		</cfscript>
	</cffunction>
</cfcomponent>