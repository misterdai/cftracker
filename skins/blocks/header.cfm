<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="author" content="David Boyer" />
	<title>CfTracker</title>
	<link rel="shortcut icon" type="image/vnd.microsoft.icon" href="assets/images/favicon.ico" /> 
    <link rel="icon" type="image/vnd.microsoft.icon" href="assets/images/favicon.ico" /> 
	<link rel="stylesheet" type="text/css" media="screen, projection" href="assets/css/blueprint/screen.css" />
	<link rel="stylesheet" type="text/css" media="print" href="assets/css/blueprint/print.css" />
	<!--[if lt IE 8]><link rel="stylesheet" href="assets/css/blueprint/ie.css" type="text/css" media="screen, projection"><![endif]--> 
	<link rel="stylesheet" type="text/css" href="assets/css/custom-theme/jquery-ui-1.8.4.custom.css" />
	<link rel="stylesheet" type="text/css" href="assets/css/demo_page.css" />
	<link rel="stylesheet" type="text/css" href="assets/css/demo_table_jui.css" />
	<link rel="stylesheet" type="text/css" href="assets/css/uniform.default.css" />
	<link rel="stylesheet" type="text/css" href="assets/css/default.css" />
	<script type="text/javascript" src="assets/js/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="assets/js/jquery-ui-1.8.4.custom.min.js"></script>
	<script type="text/javascript" src="assets/js/jquery.ui.tooltip.js"></script>
	<script type="text/javascript" src="assets/js/jquery.uniform.min.js"></script>
	<script type="text/javascript" src="assets/js/jquery.dataTables.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("input, textarea, select").not('tfoot input, tfoot select').uniform();
			$('.navbar a').mouseenter(function() {$(this).addClass('ui-state-hover');}).mouseleave(function() {$(this).removeClass('ui-state-hover');});
			$('.focusFirst').focus();
		});
	</script>