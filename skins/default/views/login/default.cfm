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
	<form action="<cfoutput>#BuildUrl('login.login')#</cfoutput>" method="post">
		<label for="password">Password</label><br />
		<input type="password" name="password" id="password" value="" class="focusFirst" /><br />
		<input type="submit" value="Login" />
	</form>
</div>
