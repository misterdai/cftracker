<cfsilent>
	<cfcontent reset="true" />
	<cfsetting showdebugoutput="false" />
	<cfset cfcTracker = CreateObject('component', 'cfide.administrator.cftracker.tracker').init() />
	<cfset appSessions = [] />
	<cfset apps = cfcTracker.getApplications() />
	<cfloop array="#apps#" index="app">
		<cfset data = {
			label = app,
			data = [GetTickCount(), cfcTracker.getAppSessionCount(app)]
		} />
		<cfset ArrayAppend(appSessions, data) />
	</cfloop>
	<cfset json = SerializeJson(appSessions) />
</cfsilent><cfoutput>#json#</cfoutput>