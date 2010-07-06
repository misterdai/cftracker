<cfcomponent output="false">
	<cfscript>
		this.name = 'CfTracker-Components';
		this.applicationTimeout = CreateTimeSpan(0, 1, 0, 0);
	</cfscript>
	
	<cffunction name="onError">
		<cfdump var="#arguments#" />
		<cfabort>
	</cffunction>
</cfcomponent>