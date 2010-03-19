<cfscript>
	cfcTracker = CreateObject('component', 'tracker').init();
	apps = cfcTracker.getApplications();
	sess = cfcTracker.getSessions();
	sessCount = cfcTracker.getSessionCount();
</cfscript><html>
<head>
	<style type="text/css">
		.na {color:red; font-weight:bold;}
		.num {text-align:right;}
		table {border-collapse:collapse;}
		th, td {border: 1px solid #ccc; padding:3px;}
		tbody th {text-align:left;}
	</style>
	<title>CFTracker</title>
</head>
<body>
<h1>CFTracker</h1>
<h2>Server</h2>
<cfdump var="#cfcTracker.getServerInfo()#" />
<cfdump var="#cfcTracker.getAllSessInfo()#" />
<h2>Memory</h2>
Memory Usage: <cfdump var="#cfcTracker.getMem()#" />
<hr />
<h2>Sessions</h2>
Total number of Sessions: <cfoutput>#sessCount#</cfoutput><br />
Array of Session ID's: <cfdump var="#sess#" />
<cfif sessCount Eq 0>
	There are no available sessions to collection information from.
<cfelse>
	<cfset keys = cfcTracker.getSessionKeys(sess[1]) />
	<cfoutput><table>
		<tbody>
			<tr>
				<th scope="row">SessionId</th>
				<td>#HtmlEditFormat(sess[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getSessTimeAlive(SessionId)</th>
				<td class="num">#cfcTracker.getSessTimeAlive(sess[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getSessLastAccessed(SessionId)</th>
				<td class="num">#cfcTracker.getSessLastAccessed(sess[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getSessIdleTimeout(SessionId)</th>
				<td class="num">#cfcTracker.getSessIdleTimeout(sess[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getSessIdlePercent(SessionId)</th>
				<td class="num">#cfcTracker.getSessIdlePercent(sess[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.isSessExpired(SessionId)</th>
				<td>#cfcTracker.isSessExpired(sess[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getSessionKeys(SessionId)</th>
				<td><cfdump var="#keys#" />
			</tr>
			<tr>
				<cfif Not StructKeyExists(cfcTracker, 'getSessionValue')>
					<th scope="row">cfcTracker.getSessionValue(SessionId, x)</th>
					<td style="color:red">Not supported this version of ColdFusion.</td>
				<cfelseif ArrayLen(keys) Eq 0>
					<th scope="row">cfcTracker.getSessionValue(SessionId, x)</th>
					<td style="color:red">No keys in the session.</td>
				<cfelse>
					<th scope="row">cfcTracker.getSessionValue(SessionId, '#HtmlEditFormat(keys[ArrayLen(keys)])#')</th>
					<td>#HtmlEditFormat(keys[ArrayLen(keys)])# = <cfdump var="#cfcTracker.getSessionValue(sess[1], keys[ArrayLen(keys)])#" /></td>
				</cfif>
			</tr>
		</tbody>
	</table></cfoutput>
</cfif>

<hr />
<h2>Applications</h2>
Array of Application names: <cfdump var="#apps#" />

<cfif ArrayLen(apps) Eq 0>
	There are no available applications to collection information from.
<cfelse>
	<cfset keys = cfcTracker.getApplicationKeys(apps[1]) />
	<cfoutput><table>
		<tbody>
			<tr>
				<th scope="row">App</th>
				<td>#HtmlEditFormat(apps[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getAppTimeAlive(app)</th>
				<td class="num">#cfcTracker.getAppTimeAlive(apps[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getAppLastAccessed(app)</th>
				<td class="num">#cfcTracker.getAppLastAccessed(apps[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getAppIdleTimeout(app)</th>
				<td class="num">#cfcTracker.getAppIdleTimeout(apps[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getAppIdlePercent(app)</th>
				<td class="num">#cfcTracker.getAppIdlePercent(apps[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.isAppExpired(app)</th>
				<td>#cfcTracker.isAppExpired(apps[1])#</td>
			</tr>
			<tr>
				<th scope="row">cfcTracker.getApplicationKeys(app)</th>
				<td><cfdump var="#keys#" />
			</tr>
			<tr>
				<cfif Not StructKeyExists(cfcTracker, 'getApplicationValue')>
					<th scope="row">cfcTracker.getApplicationValue(app, x)</th>
					<td class="na">Not supported this version of ColdFusion.</td>
				<cfelseif ArrayLen(keys) Eq 0>
					<th scope="row">cfcTracker.getApplicationValue(app, x)</th>
					<td class="na">No keys in the applicaton scope.</td>
				<cfelse>
					<th scope="row">cfcTracker.getApplicationValue(app, '#HtmlEditFormat(keys[ArrayLen(keys)])#')</th>
					<td>#HtmlEditFormat(keys[ArrayLen(keys)])# = <cfdump var="#cfcTracker.getApplicationValue(apps[1], keys[ArrayLen(keys)])#" /></td>
				</cfif>
			</tr>
		</tbody>
	</table></cfoutput>
</cfif>