<cfsavecontent variable="header">
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="author" content="David Boyer" />
	<title>CfTracker</title>
	<cfoutput>
	<link rel="shortcut icon" type="image/vnd.microsoft.icon" href="#this.assetBegin#assets/images/favicon.ico#this.assetEnd#" /> 
    <link rel="icon" type="image/vnd.microsoft.icon" href="#this.assetBegin#assets/images/favicon.ico#this.assetEnd#" /> 
	<cfif Not application.railoplugin>
		<link rel="stylesheet" type="text/css" media="screen, projection" href="#this.assetBegin#assets/css/blueprint/screen.css#this.assetEnd#" />
		<link rel="stylesheet" type="text/css" media="print" href="#this.assetBegin#assets/css/blueprint/print.css#this.assetEnd#" />
		<!--[if lt IE 8]><link rel="stylesheet" href="#this.assetBegin#assets/css/blueprint/ie.css#this.assetEnd#" type="text/css" media="screen, projection"><![endif]--> 
	</cfif>
	<link rel="stylesheet" type="text/css" href="#this.assetBegin#assets/css/custom-theme/jquery-ui-1.8.4.custom.css#this.assetEnd#" />
	<link rel="stylesheet" type="text/css" href="#this.assetBegin#assets/css/demo_page.css#this.assetEnd#" />
	<link rel="stylesheet" type="text/css" href="#this.assetBegin#assets/css/demo_table_jui.css#this.assetEnd#" />
	<link rel="stylesheet" type="text/css" href="#this.assetBegin#assets/css/default.css#this.assetEnd#" />
	<cfif application.railoplugin>
		<link rel="stylesheet" type="text/css" href="#this.assetBegin#assets/css/default.rp.css#this.assetEnd#" />
	</cfif>
	<script type="text/javascript" src="#this.assetBegin#assets/js/jquery-1.4.2.min.js#this.assetEnd#"></script>
	<script type="text/javascript" src="#this.assetBegin#assets/js/jquery-ui-1.8.4.custom.min.js#this.assetEnd#"></script>
	<script type="text/javascript" src="#this.assetBegin#assets/js/jquery.ui.tooltip.js#this.assetEnd#"></script>
	<script type="text/javascript" src="#this.assetBegin#assets/js/jquery.dataTables.min.js#this.assetEnd#"></script>
	<cfif StructKeyExists(rc, 'cfuniform')>
		#rc.cfuniform#
	</cfif>
	</cfoutput>
	<script type="text/javascript">
		$(function() {
			$('.navbar a').mouseenter(function() {$(this).addClass('ui-state-hover');}).mouseleave(function() {$(this).removeClass('ui-state-hover');});
			$('.focusFirst').focus();
		});
	</script>
	
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
</cfsavecontent>
<cfif application.railoPlugin>
	<cfhtmlhead text="#header#" />
<cfelse>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<cfoutput>#header#</cfoutput>
	</head>
	<body>
</cfif>