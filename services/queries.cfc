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
			var local = {};
			if (application.settings.demo) {
				local.data = {};
				for (local.q in application.data.queries) {
					local.data[local.q] = application.data.queries[local.q].metadata;
				}
			} else {
				local.data = variables.queryTracker.getQueries();
			}
			return local.data;
		</cfscript> 
	</cffunction>

	<cffunction name="getparams" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			var local = {};
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
		<cfset var local = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.queries#" index="local.q">
				<cfset variables.queryTracker.purge(local.q) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="queries" />
		<cfset var local = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.queries#" index="local.q">
				<cfset variables.queryTracker.refresh(local.q) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="filter" output="false" access="private">
		<cfargument name="sql" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="creation" type="string" required="false" default="" />
		<cfargument name="creationOp" type="string" required="false" default="" />
		<cfscript>
			var local = {};
			local.queries = variables.queryTracker.getQueries();
			for (local.q in local.queries) {
				if (Len(arguments.sql) Gt 0) {
					if (Not ReFindNoCase(arguments.sql, local.queries[local.q].sql)) {
						StructDelete(local.queries, local.q);
					}
				}
				if (Len(arguments.name) Gt 0) {
					if (Not ReFindNoCase(arguments.name, local.queries[local.q].sql)) {
						StructDelete(local.queries, local.q);
					}
				}
				if (Len(arguments.creation) Gt 0 And Len(arguments.creationOp) Gt 0) {
					if (arguments.creationOp Eq 'before' And ParseDateTime(arguments.creation) Lte local.queries[local.q].creation) {
						StructDelete(local.queries, local.q);
					} else if (arguments.creationOp Eq 'on' And ParseDateTime(arguments.creation) Neq local.queries[local.q].creation) {
						StructDelete(local.queries, local.q);
					} else if (arguments.creationOp Eq 'after' And ParseDateTime(arguments.creation) Gte local.queries[local.q].creation) {
						StructDelete(local.queries, local.q);
					}
				}
			}
			return local.queries;
		</cfscript>
	</cffunction>

	<cffunction name="purgeBy" output="false">
		<cfargument name="sql" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="creation" type="string" required="false" default="" />
		<cfargument name="creationOp" type="string" required="false" default="" />
		<cfscript>
			var local = {};
			if (Not application.settings.demo) {
				local.queries = filter(argumentCollection = arguments);
				for (local.q in local.queries) {
					variables.queryTracker.purge(local.q);
				}
			}
		</cfscript>
	</cffunction>

	<cffunction name="refreshBy" output="false">
		<cfargument name="sql" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="creation" type="string" required="false" default="" />
		<cfargument name="creationOp" type="string" required="false" default="" />
		<cfscript>
			var local = {};
			if (Not application.settings.demo) {
				local.queries = filter(argumentCollection = arguments);
				for (local.q in local.queries) {
					variables.queryTracker.refresh(local.q);
				}
			}
		</cfscript>
	</cffunction>
</cfcomponent>