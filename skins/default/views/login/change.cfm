<div class="span-24 last">
	<p>No password has been set, please enter one.</p>
	<cfif server.coldfusion.productName Eq 'Railo'>
		<p>Railo detected: For CfTracker to access the information it requires, you will have to set the password to match your Railo Server admin one.</p>
		<p>A Railo admin plugin version is planned for a future release that will avoid this requirement.</p>
	</cfif>
	<form action="<cfoutput>#BuildUrl('login.change')#</cfoutput>" method="post">
		<fieldset>
			<legend>Change password</legend>
			<label for="password">Password</label><br />
			<input type="password" name="password" id="password" value="" /><br />
			<label for="password2">Confirm password</label><br />
			<input type="password" name="password2" id="password2" value="" /><br />
			<input type="submit" value="Change" />
		</fieldset>
	</form>
</div>
