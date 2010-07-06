<cfif cgi.request_method Eq 'POST' And StructKeyExists(form, 'password')>
	<h2>Applications.cfc</h2>
	<cfset cfcApps = CreateObject('component', 'applications').init(password = form.password) />
<cfelseif ListFirst(server.coldfusion.productName, ' ') Eq 'ColdFusion'>
	<h2>Applications.cfc</h2>
	<cfset cfcApps = CreateObject('component', 'applications').init() />
</cfif>

<cfif StructKeyExists(variables, 'cfcApps')>
	<cfdump var="#cfcApps#" />
	<h3>.getApps()</h3>
	<cfdump var="#cfcApps.getApps()#" />
</cfif>


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
