<cfcomponent output="false">
	<cfscript>
		this.name = 'CfTracker-Monitor.1';
		this.sessionManagement = false;
		this.mappings['/cftrackerbase'] = GetDirectoryFromPath(GetCurrentTemplatePath()) & '../services/cftracker';
	</cfscript>
</cfcomponent>