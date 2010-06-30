<cfsilent>
	<cfcontent reset="true">
	<cfset request.layout = false />
	<cfsetting showdebugoutput="false" />
</cfsilent><cfoutput>#SerializeJson(rc.data)#</cfoutput>