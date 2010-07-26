<cfsilent>
	<cfsetting showdebugoutput="false" />
</cfsilent><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="author" content="David Boyer" />
	<title>CFTracker</title>
	<link rel="stylesheet" type="text/css" media="screen, projection" href="assets/css/blueprint/screen.css" />
	<link rel="stylesheet" type="text/css" media="print" href="assets/css/blueprint/print.css" />
	<!--[if lt IE 8]><link rel="stylesheet" href="assets/css/blueprint/ie.css" type="text/css" media="screen, projection"><![endif]--> 
	<link rel="stylesheet" type="text/css" href="assets/css/demo_page.css" />
	<link rel="stylesheet" type="text/css" href="assets/css/demo_table_jui.css" />
	<link rel="stylesheet" type="text/css" href="assets/css/custom-theme/jquery-ui-1.8.2.custom.css" />
	<link rel="stylesheet" type="text/css" href="assets/css/default.css" />
	<script type="text/javascript" src="assets/js/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="assets/js/jquery-ui-1.8.2.custom.min.js"></script>
	<script type="text/javascript" src="assets/js/jquery.ui.tooltip.js"></script>
	<script type="text/javascript" src="assets/js/jquery.dataTables.min.js"></script>
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
			<img src="assets/images/logo.png" height="150" width="400" />
		</div>
		<div class="span-24 last">
			<div id="menu_wrapper" class="grey">
				<div class="left"></div>
				<ul id="menu"><cfoutput><cfset controller = ListFirst(rc.action, '.') />
					<cfif controller Eq 'login'>
						<li class="active"><a href="#BuildUrl('login.default')#">Login</a></li>
					<cfelse>
						<li <cfif controller Eq 'main'>class="active"</cfif>><a href="#buildURL('main.default')#">Dashboard</a></li>
						<li <cfif controller Eq 'applications'>class="active"</cfif>><a href="#buildURL('applications.default')#">Applications</a></li>
						<li <cfif controller Eq 'sessions'>class="active"</cfif>><a href="#buildURL('sessions.default')#">Sessions</a></li>
						<li <cfif controller Eq 'queries'>class="active"</cfif>><a href="#buildURL('queries.default')#">Query Cache</a></li>
						<li <cfif controller Eq 'memory'>class="active"</cfif>><a href="#buildURL('memory.default')#">Memory</a></li>
						<li <cfif controller Eq 'stats'>class="active"</cfif>><a href="#buildURL('stats.default')#">Statistics</a></li>
						<li <cfif controller Eq 'threads'>class="active"</cfif>><a href="#buildURL('threads.default')#">Threads</a></li>
						<cfif Not application.cfide>
							<li><a href="#buildURL('login.logout')#">Logout</a></li>
						</cfif>
					</cfif>
				</ul></cfoutput>
			</div>
		</div>
		<div class="span-24 last">
			<cfif StructKeyExists(rc, 'message')>
				<cfoutput><div class="error">#HtmlEditFormat(rc.message[1])#</div></cfoutput>
			</cfif>
		</div>
		<cfoutput>#body#</cfoutput>

		<div id="footer">
			<cfinclude template="../../blocks/footer.cfm" />
		</div>
	</div>
</body>
</html>