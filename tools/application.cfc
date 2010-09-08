<cfcomponent output="false">
	<cfscript>
		this.name = 'CfTracker-Monitor.20100908';
		this.sessionManagement = false;
		this.base = GetDirectoryFromPath(GetCurrentTemplatePath());
		this.mappings['/cftrackerbase'] = this.base & '../services/cftracker';
		this.mappings['/javaloader'] = this.base & '../javaloader';
	</cfscript>
	
	<cffunction name="onApplicationStart" output="false" returntype="boolean">
		<cfset application.uuid = 'Q2ZUcmFja2VyIChodHRwOi8vd3d3LmNmdHJhY2tlci5uZXQp' />
		<cfset lc.paths = [this.base & 'monitor/rrd4j-2.0.5.jar'] />
		<cfif NOT StructKeyExists(server, application.uuid)>
			<cflock name="CfTracker.server.JavaLoader" throwontimeout="true" timeout="60">
				<cfif Not StructKeyExists(server, application.uuid)>
					<cfset server[application.uuid] = CreateObject("component", "javaloader.JavaLoader").init(lc.paths) />
				</cfif>
			</cflock>
		</cfif>
		<cfreturn true />
	</cffunction>
</cfcomponent>