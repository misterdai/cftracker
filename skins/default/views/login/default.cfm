<div class="span-24 last">
	<form action="<cfoutput>#BuildUrl('login.login')#</cfoutput>" method="post">
		<fieldset>
			<legend>Login</legend>
			<label for="password">Password</label><br />
			<input type="password" name="password" id="password" value="" /><br />
			<input type="submit" value="Login" />
		</fieldset>
	</form>
</div>
