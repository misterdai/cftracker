<cfcomponent output="false">
	<cfscript>
		this.name = 'CfTracker-Demo';
		this.sessionManagement = false;
		this.mappings['/cftracker'] = ExpandPath('../services/cftracker');
	</cfscript>
	
	<cffunction name="onError">
		<cfdump var="#arguments#" />
		<cfdump var="#application#" />
	</cffunction>
</cfcomponent>