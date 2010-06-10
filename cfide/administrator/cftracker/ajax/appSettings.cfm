<cfsilent>
	<cfsetting showdebugoutput="false" />
	<cfparam name="url.appName" type="string" default="" />
	<cfset cfcTracker = CreateObject('component', 'cfide.administrator.cftracker.tracker').init() />
	<cfset output = cfcTracker.getAppSettings(url.appName) />
</cfsilent><cfif StructCount(output) Eq 0>Application has expired or is empty.<cfelse><cfdump var="#output#" label="Application Settings" /></cfif>