<cfcomponent output="false">
	<cfscript>
		this.name = 'CfTracker-Monitor';
		this.sessionManagement = false;
		this.mappings['/cftracker'] = ExpandPath('../services/cftracker');
	</cfscript>
</cfcomponent>