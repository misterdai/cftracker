<cfsavecontent variable="jQuery">
	<link type="text/css" href="css/ui-lightness/jquery-ui-1.8.2.custom.css" rel="stylesheet" />	
	<link type="text/css" href="css/default.css" rel="stylesheet" />	
	<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.2.custom.min.js"></script>
	<script type="text/javascript" src="js/jquery.ui.tooltip.js"></script>
	<script type="text/javascript">
		$(function() {
			$('.progress').each(function() {
				$(this).progressbar({value: parseFloat(this.title)});
			});
			$('[title]').tooltip({
				position: {
					my: 'left top',
					at: 'left bottom'
				}
			});
		});
	</script>
</cfsavecontent>
<cfhtmlhead text="#jQuery#" />