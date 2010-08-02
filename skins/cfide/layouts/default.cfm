<cfsilent>
	<cfset controller = ListFirst(rc.action, '.') />
	<cfsetting showdebugoutput="false" />
</cfsilent><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="author" content="David Boyer" />
	<title>CfTracker</title>
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
			<h1><span class="logoHi">Cf</span>Tracker</h1>
		</div>
		<div class="span-24 last">
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
		<cfoutput>#body#</cfoutput>
		<div id="footer">
			<cfinclude template="../../blocks/footer.cfm" />
		</div>
	</div>
</body>
</html>