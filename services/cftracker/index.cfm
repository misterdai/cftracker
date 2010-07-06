<cfif cgi.request_method Eq 'POST' And StructKeyExists(form, 'password')>
	<h2>Applications.cfc</h2>
	<cfset cfcApps = CreateObject('component', 'applications').init(password = form.password) />
<cfelseif ListFirst(server.coldfusion.productName, ' ') Eq 'ColdFusion'>
	<h2>Applications.cfc</h2>
	<cfset cfcApps = CreateObject('component', 'applications').init() />
</cfif>

<cfif StructKeyExists(variables, 'cfcApps')><cfoutput>
	<cfdump var="#cfcApps#" />
	<h3>.getApps()</h3>
	<cfset apps = cfcApps.getApps() />
	<cfdump var="#apps#" />
	<cfset i = 2 />
	<h3>.getScope('#apps[i]#')</h3>
	<cfdump var="#cfcApps.getScope(apps[i])#" />
	<h3>.getScopeKeys('#apps[i]#')</h3>
	<cfdump var="#cfcApps.getScopeKeys(apps[i])#" />
	<cfset aspects = ['applicationName'] />
	<h3>.getScopeValues('#apps[i]#', '#aspects[1]#')</h3>
	<cfdump var="#cfcApps.getScopeValues(apps[i], aspects)#" />
</cfoutput></cfif>

<cfif server.coldfusion.productName Eq 'Railo'>
	<p>To access the required information the server administrator password is required.
		Feel free to check the code first.
	</p>
	<form method="post" action="index.cfm">
		<label for="password">Server password</label><br />
		<input type="password" name="password" id="password" value="" /><br />
		<input type="submit" value="Submit" />
	</form>
</cfif>
