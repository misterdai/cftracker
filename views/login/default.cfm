<cfsilent>
	<cfparam name="form.password" default="" />
	
	<cfset successMessage = '' />
	<cfset uniFormErrors = {} />
	<cfif StructKeyExists(rc, 'formdata') And StructKeyExists(rc.formdata, 'uniFormErrors')>
		<cfset uniFormErrors = rc.formdata.uniFormErrors />
	</cfif>
</cfsilent>
<div>
	<cfscript>
		if (StructKeyExists(rc, 'message')) {
			types = ['error', 'info'];
			for (t = 1; t Lte 2; t++) {
				type = types[t];
				if (StructKeyExists(rc.message, type)) {
					WriteOutput('<div class="' & type & '">');
					len = ArrayLen(rc.message[type]);
					for (i = 1; i Lte len; i++) {
						WriteOutput(HtmlEditFormat(rc.message[type][i]) & '<br />');
					}
					WriteOutput('</div>');
				}
			}
		}
	</cfscript>
	<cfif application.settings.demo>
		<p>Demo mode: Any password accepted.</p>
	</cfif>
	<div>
		<cf_form action="" method="post" id="frmMain"
				errors="#uniFormErrors#"
				pathConfig="#application.cftracker.uniform#"
				errorMessagePlacement="both"
				loadjQuery="false"
				jsLoadVar="cfuniform"
				okMsg="#successMessage#"
				submitValue="Login">
			<cf_fieldset legend="">
				<cf_field label="Password" name="password" type="password" required="true" />
			</cf_fieldset>
		</cf_form>
		<cfset rc.cfuniform = cfuniform />
	</div>
</div>
