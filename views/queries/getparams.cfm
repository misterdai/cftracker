<cfsilent>
	<cfset request.layout = false />
	<cfsetting showdebugoutput="false" />
</cfsilent><cfdump var="#rc.data.params#" expand="false" /><cfabort>