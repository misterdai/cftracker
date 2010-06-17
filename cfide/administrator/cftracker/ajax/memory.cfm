<cfsilent>
	<cfcontent reset="true" />
	<cfsetting showdebugoutput="false" />
	<cfset cfcTracker = CreateObject('component', 'cfide.administrator.cftracker.tracker').init() />
	<cfset json = SerializeJson(cfcTracker.getMem()) />
</cfsilent><cfoutput>#json#</cfoutput>