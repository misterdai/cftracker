<cfsilent>
	<cfcontent reset="true" />
	<cfsetting showdebugoutput="false" />
	<cfparam name="url.sessId" type="string" default="" />
	<cfset cfcTracker = CreateObject('component', 'cfide.administrator.cftracker.tracker').init() />
	<cfset output = cfcTracker.getAllSessionValues(url.sessId) />
</cfsilent><cfif StructCount(output) Eq 0>Session has expired or is empty.<cfelse><cfdump var="#output#" /></cfif>