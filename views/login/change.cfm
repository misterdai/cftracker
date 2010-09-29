<cfsilent>
	<cfparam name="form.password" default="" />
	<cfparam name="form.password2" default="" />
	
	<cfset successMessage = '' />
	<cfset uniFormErrors = {} />
	<cfif StructKeyExists(rc, 'formdata') And StructKeyExists(rc.formdata, 'uniFormErrors')>
		<cfset uniFormErrors = rc.formdata.uniFormErrors />
	</cfif>
</cfsilent>
<div>
	<p>No password has been set, please enter one.</p>
	<cfif server.coldfusion.productName Eq 'Railo'>
		<p>Railo detected: For CfTracker to access the information it requires, you will have to set the password to match your Railo Server admin one.</p>
		<p>A Railo admin plugin version is planned for a future release that will avoid this requirement.</p>
	</cfif>
	<cf_form action="#BuildUrl('login.change')#" method="post" id="frmMain"
			errors="#uniFormErrors#"
			pathConfig="#application.cftracker.uniform#"
			errorMessagePlacement="both"
			loadjQuery="false"
			jsLoadVar="cfuniform"
			okMsg="#successMessage#"
			submitValue="Login">
		<cf_fieldset legend="">
			<cf_field label="Password" name="password" type="password" required="true" />
			<cf_field label="Confirm password" name="password2" type="password" required="true" />
		</cf_fieldset>
	</cf_form>
	<cfset rc.cfuniform = cfuniform />
</div>
