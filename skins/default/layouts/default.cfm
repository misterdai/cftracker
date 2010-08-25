<cfsilent>
	<cfset controller = ListFirst(rc.action, '.') />
	<cfsetting showdebugoutput="false" />
</cfsilent><cfinclude template="../../blocks/header.cfm" />
	<script type="text/javascript">
		$(function() {
			$('.progress').each(function() {
				$(this).progressbar({value: parseFloat(this.title)}).attr('title', '');
			});
			$('[title]').tooltip({
				position: {
					my: 'left top',
					at: 'left bottom'
				}
			});
			$('.styled').each(function() {
				$(this).addClass('ui-widget');
				$('th', this).addClass('ui-widget-header');
				$('td', this).addClass('ui-widget-content');
			});
		});
	</script>
</head>
<body>
	<div class="container">
		<div id="header" class="span-24 last">
			<h1><img src="assets/images/loginlogo.png" width="400" height="98" alt="CfTracker" /></h1>
		</div>
		<div class="span-24 last">
			<div class="navbar">
				<ul><cfoutput>
					<li><a class="ui-corner-top <cfif controller Eq 'main'>ui-state-active<cfelse>ui-state-default</cfif>" href="#buildURL('main.default')#"><img src="assets/images/icons/dashboard_32x32-32.png" width="32" height="32" />Dashboard</a></li>
					<cfif application.cftracker.support.apps.enabled><li><a class="ui-corner-top <cfif controller Eq 'applications'>ui-state-active<cfelse>ui-state-default</cfif>" href="#buildURL('applications.default')#"><img src="assets/images/icons/applications_32x32-32.png" width="32" height="32" />Applications</a></li></cfif>
					<cfif application.cftracker.support.sess.enabled><li><a class="ui-corner-top <cfif controller Eq 'sessions'>ui-state-active<cfelse>ui-state-default</cfif>" href="#buildURL('sessions.default')#"><img src="assets/images/icons/contact_32x32-32.png" width="32" height="32" />Sessions</a></li></cfif>
					<cfif application.cftracker.support.qc.enabled><li><a class="ui-corner-top <cfif controller Eq 'queries'>ui-state-active<cfelse>ui-state-default</cfif>" href="#buildURL('queries.default')#"><img src="assets/images/icons/calculator_32x32-32.png" width="32" height="32" />Query Cache</a></li></cfif>
					<cfif application.cftracker.support.mem.enabled><li><a class="ui-corner-top <cfif controller Eq 'memory'>ui-state-active<cfelse>ui-state-default</cfif>" href="#buildURL('memory.default')#"><img src="assets/images/icons/memory_32x32-32.png" width="32" height="32" />Memory</a></li></cfif>
					<cfif application.cftracker.support.stats.enabled><li><a class="ui-corner-top <cfif controller Eq 'stats'>ui-state-active<cfelse>ui-state-default</cfif>" href="#buildURL('stats.default')#"><img src="assets/images/icons/gear_32x32-32.png" width="32" height="32" />Statistics</a></li></cfif>
					<cfif application.cftracker.support.threads.enabled><li><a class="ui-corner-top <cfif controller Eq 'threads'>ui-state-active<cfelse>ui-state-default</cfif>" href="#buildURL('threads.default')#"><img src="assets/images/icons/search_32x32-32.png" width="32" height="32" />Threads</a></li></cfif>
					<cfif Not application.settings.demo><li><a class="ui-corner-top <cfif controller Eq 'config'>ui-state-active<cfelse>ui-state-default</cfif>" href="#BuildUrl('config.default')#"><img src="assets/images/icons/wrench_32x32-32.png" width="32" height="32" />Configuration</a></li></cfif>
					<cfif Not application.cfide>
						<li class="logout"><a class="ui-corner-top ui-state-default" href="#buildURL('login.logout')#"><img src="assets/images/icons/power_32x32-32.png" width="32" height="32" />Logout</a></li>
					</cfif>
				</ul></cfoutput>
				</div>
		</div>
		<div class="span-24 last backcolour">
	
			<div class="ui-corner-top whiteBk">	<br />
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
			</div>
		</div>
		<cfoutput>#body#</cfoutput>

		<div id="footer">
			<cfinclude template="../../blocks/footer.cfm" />
		</div>
	</div>
</body>
</html>