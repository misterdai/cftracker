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
			<cfset successMessage = 'The Config has been saved!' />
		<cfelse>
			<cfset successMessage = 'On no' />
		</cfif>
	</cfif>
	<cfset requiredFields = application.validateThis.getRequiredFields(
		objectType = 'Config'
	) />
	<!--- JS Code --->
	<!---
	<cfset valInit = application.ValidateThis.getInitializationScript() />
	<cfhtmlhead text="#valInit#" />
	<cfsavecontent variable="headJS">
		<script type="text/javascript" src="assets/js/uniform/uni-form.jquery.js"></script>
	</cfsavecontent>	
	<cfhtmlhead text="#headJS#" />
	<cfset ValidationScript = application.ValidateThis.getValidationScript(objectType="Config") />
	<cfhtmlhead text="#ValidationScript#" />--->
</cfsilent>
<div class="span-24 last"><h2>Configuration</h2>
<div style="padding:10px;">
<cfscript>
	config = structNew();
	config.jQuery = "assets/js/jquery-1.4.2.min.js";
	config.renderer = "../renderValidationErrors.cfm";
	config.uniformCSS = "assets/css/uniform/uni-form.css";
	config.uniformCSSie = "assets/css/uniform/uni-form-ie.css";
	config.uniformThemeCSS = "assets/css/uniform/uni-form.default.css";
	config.uniformJS = "assets/js/uniform/uni-form.jquery.js";
	config.validationJS = "assets/js/uniform/jquery.validate-1.6.0.min.js";
	config.dateCSS = "assets/css/uniform/jquery.datepick.css";
	config.dateJS = "assets/js/uniform/jquery.datepick-3.7.5.min.js";
	config.timeCSS = "assets/css/uniform/jquery.timeentry.css";
	config.timeJS = "assets/js/uniform/jquery.timeentry-1.4.6.min.js";
	config.maskJS = "assets/js/uniform/jquery.maskedinput-1.2.2.min.js";
	config.textareaJS = "assets/js/uniform/jquery.prettyComments-1.4.pack.js";
	config.ratingCSS = "assets/css/uniform/jquery.rating.css";
	config.ratingJS = "assets/js/uniform/jquery.rating-3.12.min.js";
</cfscript>
<cf_form action="#BuildUrl('config.default')#" method="post" id="frmMain"
		cancelAction="index.cfm"
		errors="#uniFormErrors#"
		pathConfig="#config#"
		errorMessagePlacement="both"
		loadjQuery="true"
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
</div></div>