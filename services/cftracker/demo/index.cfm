<cfset cfcDemo = CreateObject('component', 'demo').init() />
<cfif StructKeyExists(url, 'reset')>
	<cfset cfcDemo.reset() />
</cfif>
<cfset cfcDemo.tick() />

<cfdump var="#application.demo#" />
