<cfsilent>
	<cfparam name="form.maxAttempts" default="#application.settings.security.maxAttempts#" />
	<cfparam name="form.lockSeconds" default="#application.settings.security.lockSeconds#" />
	<cfparam name="form.dateformat" default="#application.settings.display.dateformat#" />
	<cfparam name="form.timeformat" default="#application.settings.display.timeformat#" />
	<cfparam name="successMessage" default="" />
	<cfset uniFormErrors = {} />
	<cfif StructKeyExists(rc, 'data')>
		<cfset uniFormErrors = rc.data.getFailuresForUniForm() />
		<cfif rc.data.getIsSuccess()>
			<cfset successMessage = 'The Configuration has been saved.' />
		</cfif>
	</cfif>
	<cfset requiredFields = application.validateThis.getRequiredFields(
		objectType = 'Config'
	) />
</cfsilent>
<div class="span-24 last"><h2>Configuration</h2>
<div style="padding:10px;">

<cf_form action="#BuildUrl('config.default')#" method="post" id="frmMain"
		errors="#uniFormErrors#"
		pathConfig="#application.cftracker.uniform#"
		errorMessagePlacement="both"
		loadjQuery="false"
		jsLoadVar="cfuniform"
		okMsg="#successMessage#"
		requiredFields="#requiredFields#"
		submitValue="Save">
	<input type="hidden" name="Processing" id="Processing" value="true" />
	<cf_fieldset legend="Security">
		<cf_field label="Password" name="password" type="password" />
		<cf_field label="Confirm password" name="password2" type="password" hint="Make sure the passwords match." />
		<cf_field label="Max Login Attempts" name="maxAttempts" type="text" value="#form.maxAttempts#" hint="The maximum number of incorrect login attempts allowed before being locked." />
		<cf_field label="Lock Seconds" name="lockSeconds" type="text" value="#form.lockSeconds#" hint="Number of seconds that logins will be locked if the max attempts number is hit." />
	</cf_fieldset>
	<cf_fieldset legend="Display">
		<cf_field label="Date Format" name="dateformat" type="text" value="#form.dateformat#" hint="Format used when dealing with dates (see DateFormat())." />
		<cf_field label="Time Format" name="timeformat" type="text" value="#form.timeformat#" hint="Format used when dealing with times (see TimeFormat())." />
	</cf_fieldset>
</cf_form>
<cfset rc.cfuniform = cfuniform />
</div></div>