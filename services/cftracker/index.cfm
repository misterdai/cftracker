<cfif cgi.request_method Eq 'POST' And StructKeyExists(form, 'password')>
	<h2>Applications.cfc</h2>
	<cfset cfcSess = CreateObject('component', 'sessions').init(password = form.password) />
<cfelse>
	<h2>Applications.cfc</h2>
	<cfset cfcSess = CreateObject('component', 'sessions').init() />
</cfif>

<cfif StructKeyExists(variables, 'cfcSess')><cfoutput>
	<cfdump var="#cfcSess#" expand="false" />
	<h3>.getSessions()</h3>
	<cfset sess = cfcSess.getSessions() />
	<cfdump var="#sess#" expand="false" />
	<h3>.getSessions('cftracker-20100804')</h3>
	<cfset sess = cfcSess.getSessions('cftracker-20100804') />
	<cfdump var="#sess#" expand="false" />
	<h3>.getInfo(cfcSess.getSessions())</h3>
	<cfset info = cfcSess.getInfo(cfcSess.getsessions())>
	<cfdump var="#info#" expand="false" />
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
