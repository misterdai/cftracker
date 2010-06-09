<cfsilent>
	<cfset cfcTracker = CreateObject('component', 'tracker').init() />
	<cfif StructKeyExists(url, 'expireSession') And Len(url.expireSession) Gt 0>
		<cfset otherSession = cfcTracker.getSession(url.expireSession) />
		<!--- In case Java returns a nulled variable --->
		<cfif StructKeyExists(variables, 'otherSession')>
			<cfset variables.otherSession.setMaxInactiveInterval(1) />
		</cfif>
		<cflocation url="summary.cfm" addtoken="false" />
	</cfif>
	
	
	<cfset qSessions = cfcTracker.getAllSessInfo() />
	<cfsetting showdebugoutput="false" />

	<cffunction name="DateDiffAll" access="public" returntype="any" output="false">
		<cfargument name="date1"	type="date"		required="true" />
		<cfargument name="date2"	type="date"		required="true" />
		<cfargument name="all"		type="boolean"	required="false"	default="false" />
		<cfargument name="string"	type="boolean"	required="false"	default="true" />
		<cfargument name="capital"	type="boolean"	required="false"	default="true" />
		<cfscript>
			var local = StructNew();
			if (arguments.date1 Gt arguments.date2) {
				local.start = arguments.date2;
				local.end = arguments.date1;
			} else {
				local.start = arguments.date1;
				local.end = arguments.date2;
			}
			local.parts = StructNew();
			local.parts.years = DateDiff('yyyy', local.start, local.end);
			local.end = DateAdd('yyyy', -local.parts.years, local.end);
			local.parts.epochs = Fix(local.parts.years / 1000000);
			local.parts.years = local.parts.years - local.parts.epochs * 1000000;
			local.parts.millennia = Fix(local.parts.years / 1000);
			local.parts.years = local.parts.years - local.parts.millennia * 1000;
			local.parts.centuries = Fix(local.parts.years / 100);
			local.parts.years = local.parts.years - local.parts.centuries * 100;
			local.parts.decades = Fix(local.parts.years / 10);
			local.parts.years = local.parts.years - local.parts.decades * 10;
			local.parts.months = DateDiff('m', local.start, local.end);
			local.end = DateAdd('m', -local.parts.months, local.end);
			local.parts.weeks = DateDiff('ww', local.start, local.end);
			local.end = DateAdd('ww', -local.parts.weeks, local.end);
			local.parts.days = DateDiff('d', local.start, local.end);
			local.end = DateAdd('d', -local.parts.days, local.end);
			local.parts.hours = DateDiff('h', local.start, local.end);
			local.end = DateAdd('h', -local.parts.hours, local.end);
			local.parts.minutes = DateDiff('n', local.start, local.end);
			local.end = DateAdd('n', -local.parts.minutes, local.end);
			local.parts.seconds = DateDiff('s', local.start, local.end);
			local.end = DateAdd('s', -local.parts.seconds, local.end);
			
			if (Not arguments.string) {
				return local.parts;
			}
			
			local.order = 'epochs,millennia,centuries,decades,years,months,weeks,days,hours,minutes,seconds';
			local.orderLength = ListLen(local.order);
			
			local.output = ArrayNew(1);
			for (local.p = 1; local.p Lte local.orderLength; local.p = local.p + 1) {
				local.part = ListGetAt(local.order, local.p);
				if (local.parts[local.part] Gt 0 Or (ArrayLen(local.output) Gt 0 And arguments.all)) {
					if (local.parts[local.part] Gt 1 Or local.parts[local.part] Eq 0) {
						ArrayAppend(local.output, local.parts[local.part] & ' ' & local.part);
					} else if (local.part Eq 'centuries') {
						ArrayAppend(local.output, local.parts[local.part] & ' century');
					} else if (local.part Eq 'millennia') {
						ArrayAppend(local.output, local.parts[local.part] & ' millenium');
					} else {
						ArrayAppend(local.output, local.parts[local.part] & ' ' & Left(local.part, Len(local.part) - 1));
					}
				}
			}
			
			local.length = ArrayLen(local.output);
			if (local.length Eq 0) {
				if (arguments.capital) {
					return 'Less than a second';
				} else {
					return 'less than a second';
				}
			} else if (local.length Eq 1) {
				return local.output[1];
			} else {
				local.last = local.output[local.length];
				ArrayDeleteAt(local.output, local.length);
				return ArrayToList(local.output, ', ') & ' and ' & local.last;
			}
		</cfscript>
	</cffunction>
</cfsilent><!DOCTYPE html>
<head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
	<title>CFTracker</title>
	<link type="text/css" href="css/custom-theme/jquery-ui-1.7.2.custom.css" rel="stylesheet" />	
	<link type="text/css" href="css/default.css" rel="stylesheet" />
	<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#applications').accordion({
				header: 'h3',
				fillSpace: true
			});
			$('.progress').each(function(key, val) {
				$(val).progressbar({
					value: val.title
				});
			});
			$(window).resize(function() {
				$('#applications').accordion('resize');
			});
		});
	</script>
</head>
<body>
	<div class="box">
	<div id="applications">
		<cfoutput query="qSessions" group="applicationName">
			<h3><a href="##">#HtmlEditFormat(applicationName)#</a></h3>
			<div>
				<div class="ui-grid ui-widget ui-widget-content ui-corner-all">
					<div class="ui-grid-header ui-widget-header ui-corner-top">Sessions</div>
					<table class="ui-grid-content ui-widget-content">
						<thead>
							<tr>
								<th scope="col" class="ui-state-default">Session ID</th>
								<th scope="col" class="ui-state-default">Created</th>
								<th scope="col" class="ui-state-default">Time Alive</th>
								<th scope="col" class="ui-state-default">Last accessed</th>
								<th scope="col" class="ui-state-default">Idle timeout</th>
								<th scope="col" class="ui-state-default">Idle Percentage</th>
							</tr>
						</thead>
						<cfset sessionCount = 0 />
						<tbody><cfoutput>
							<cfscript>
								sessionCount = sessionCount + 1;
								created = DateAdd('l', -timeAlive, Now());
								last = DateAdd('l', -lastAccessed, Now());
								timeout = DateAdd('l', +idleTimeout, last);
							</cfscript>
							<tr>
								<th scope="row" class="ui-widget-content">#HtmlEditFormat(sessionId)#</th>
								<td class="ui-widget-content">#DateFormat(created, 'dd/mm/yyyy')# #TimeFormat(created, 'HH:mm:ss')#</td>
								<td class="ui-widget-content" title="#DateDiffAll(Now(), created)# (#DateFormat(created, 'dd/mm/yyyy')# #TimeFormat(created, 'HH:mm:ss')#)">#NumberFormat(timeAlive / 1000)#s</td>
								<td class="ui-widget-content" title="#DateDiffAll(Now(), last)# (#DateFormat(last, 'dd/mm/yyyy')# #TimeFormat(last, 'HH:mm:ss')#)">#NumberFormat(lastAccessed / 1000)#s</td>
								<td class="ui-widget-content" title="#DateDiffAll(Now(), timeout)# (#DateFormat(timeout, 'dd/mm/yyyy')# #TimeFormat(timeout, 'HH:mm:ss')#)">#NumberFormat(DateDiff('s', Now(), timeout))#s</td>
								<td class="ui-widget-content"><div class="progress" title="#idlePercent#"></div><cfif expired>Expired<cfelse>(<a href="summary.cfm?expireSession=#UrlEncodedFormat(sessionId)#">Expire</a>)</cfif></td>
							</tr>
						</cfoutput></tbody>
					</table>
					<div class="ui-grid-footer ui-widget-header ui-corner-bottom ui-helper-clearfix">
						<div class="ui-grid-results">Showing #sessionCount# session<cfif sessionCount Neq 1>s</cfif>.</div>
					</div>
				</div>
			</div>
		</cfoutput>
	</div>
	</div>
</body>
</html>