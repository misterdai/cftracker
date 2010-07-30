<cfsilent>
	<cfparam name="form.security.maxAttempts" default="#application.settings.security.maxAttempts#" />
	<cfparam name="form.security.lockPeriod" default="#application.settings.security.lockPeriod#" />
	<cfparam name="form.display.dateformat" default="#application.settings.display.dateformat#" />
	<cfparam name="form.display.timeformat" default="#application.settings.display.timeformat#" />
	<cfparam name="form.dashboard.updateInterval" default="#application.settings.dashboard.updateInterval#" />
</cfsilent>
<div class="span-24 last"><h2>Configuration</h2></div>

<cfoutput><form action="#BuildUrl('config.default')#" method="post">
	<div class="span-12">
		<fieldset>
			<legend>Display</legend>
			<label for="display.dateformat">Date Format</label><br />
			<input name="display.dateformat" id="display.dateformat" type="text" value="#HtmlEditFormat(form.display.dateformat)#" /><br />
			<label for="display.timeformat">Time Format</label><br />
			<input name="display.timeformat" id="display.timeformat" type="text" value="#HtmlEditFormat(form.display.timeformat)#" />
		</fieldset>
		<fieldset>
			<legend>Dashboard</legend>
			<label for="dashboard.updateInterval">Update Interval</label><br />
			<input name="dashboard.updateInterval" id="dashboard.updateInterval" type="text" value="#HtmlEditFormat(form.dashboard.updateInterval)#" />
		</fieldset>
	</div>
	<div class="span-12 last">
		<fieldset>
			<legend>Security</legend>
			<label for="security.password">Password</label><br />
			<input name="security.password" id="security.password" type="password" /><br />
			<label for="security.password2">Confirm password</label><br />
			<input name="security.password2" id="security.password2" type="password" /><br />
			<label for="security.maxAttempts">Maximum Login Attempts</label><br />
			<input name="security.maxAttempts" id="security.maxAttempts" type="text" value="#HtmlEditFormat(form.security.maxAttempts)#" /><br />
			<label for="security.lockPeriod">Lock Period</label><br />
			<input name="security.lockPeriod" id="security.lockPeriod" type="text" value="#HtmlEditFormat(form.security.lockPeriod)#" />
		</fieldset>
	</div>
	<div class="span-24 last">
		<input type="submit" value="Save" />
	</div>
</form></cfoutput>
