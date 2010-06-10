<cfinclude template="../header.cfm" />
<cfsilent>
	<cfsavecontent variable="jQuery">
		<link type="text/css" href="css/overcast/jquery-ui-1.8.2.custom.css" rel="stylesheet" />	
		<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.2.custom.min.js"></script>
		<script type="text/javascript">
			$(function() {
				$('.progress').each(function() {
					$(this).progressbar({value: parseFloat(this.title)});
				});
				
			});
		</script>
	</cfsavecontent>
	<cfhtmlhead text="#jQuery#" />

	<cfset cfcTracker = CreateObject('component', 'tracker').init() />
	<cfset memInfo = cfcTracker.getMem() />
	<cfset srvInfo = cfcTracker.getServerInfo() />
	<cfscript>
		uptime = cfcTracker.getUptime();
		update = server.coldfusion.expiration;
		temp = update;
		splitUptime = StructNew();
		splitUptime.years = DateDiff('yyyy', temp, Now());
		temp = DateAdd('yyyy', splitUptime.years, temp);
		splitUptime.months = DateDiff('m', temp, Now());
		temp = DateAdd('m', splitUptime.months, temp);
		splitUptime.days = DateDiff('d', temp, Now());
		temp = DateAdd('d', splitUptime.days, temp);
		splitUptime.hours = DateDiff('h', temp, Now());
		temp = DateAdd('h', splitUptime.hours, temp);
		splitUptime.minutes = DateDiff('n', temp, Now());
		temp = DateAdd('n', splitUptime.minutes, temp);
		splitUptime.seconds = DateDiff('s', temp, Now());
	</cfscript>
</cfsilent>

<style type="text/css">
	.pageSection {font-size:13px; font-family:Arial, Helvetica; padding:3px; background-color:#E2E6E7}
	.action {background-color:#f3f7f7; padding:3px;}
	table.styled {border-collapse:collapse; width:100%; border:none;}
	table.narrow {width:auto !important;}
	table.styled th {background-color:#F3F7F7; white-space:nowrap;}
	table.styled td, table.styled th {padding:3px;}
	table.styled .highlight th {background-color:#e3f7f7 !important;}
	table.styled .highlightRed th {background-color:#f7e3e3 !important;}
	.detail {padding-right: 20px;}
	.rowHeader {text-align:center; font-weight:normal;}
	.numeric {text-align:right;}
</style>
<br />
<h2 class="pageHeader">CFTracker > Server Status</h2>

<h3 class="cellBlueTopAndBottom pageSection">Uptime</h3>

<cfoutput>
	<strong>Up since #LsDateFormat(update)# #LsTimeFormat(update)#</strong>
	<table class="styled narrow"> 
		<thead>
			<tr>
				<th class="cellBlueTopAndBottom" scope="col">Years</th>
				<th class="cellBlueTopAndBottom" scope="col">Months</th>
				<th class="cellBlueTopAndBottom" scope="col">Days</th>
				<th class="cellBlueTopAndBottom" scope="col">Hours</th>
				<th class="cellBlueTopAndBottom" scope="col">Minutes</th>
				<th class="cellBlueTopAndBottom" scope="col">Seconds</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="cell4BlueSides numeric">#splitUptime.years#</td>
				<td class="cell4BlueSides numeric">#splitUptime.months#</td>
				<td class="cell4BlueSides numeric">#splitUptime.days#</td>
				<td class="cell4BlueSides numeric">#splitUptime.hours#</td>
				<td class="cell4BlueSides numeric">#splitUptime.minutes#</td>
				<td class="cell4BlueSides numeric">#splitUptime.seconds#</td>
			</tr>
		</tbody>
	</table>
</cfoutput>

<h3 class="cellBlueTopAndBottom pageSection">Memory</h3>

<cfoutput>
	<table class="styled"> 
		<thead>
			<tr>
				<th class="cellBlueTopAndBottom" scope="col">Aspect</th>
				<th class="cellBlueTopAndBottom" scope="col">MiB</th>
				<th class="cellBlueTopAndBottom" scope="col">Description</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th class="cellBlueTopAndBottom" scope="row">Maximum</th>
				<td class="cell4BlueSides numeric">#NumberFormat(memInfo.max, '_.99')#</td>
				<td class="cell4BlueSides">This is the maximum amount of memory available to ColdFusion's JVM.</td>
			</tr>
			<tr>
				<th class="cellBlueTopAndBottom" scope="row">Used</th>
				<td class="cell4BlueSides numeric">#NumberFormat(memInfo.used, '_.99')#</td>
				<td class="cell4BlueSides">Memory that is current in use.</td>
			</tr>
			<tr>
				<th class="cellBlueTopAndBottom" scope="row">Allocated</th>
				<td class="cell4BlueSides numeric">#NumberFormat(memInfo.allocated, '_.99')#</td>
				<td class="cell4BlueSides">Amount of memory allocated for use.  This will adjust itself based on the current amount of used memory and the maximum allowed.</td>
			</tr>
			<tr>
				<th class="cellBlueTopAndBottom" scope="row">Free Allocated</th>
				<td class="cell4BlueSides numeric">#NumberFormat(memInfo.freeAllocated, '_.99')#</td>
				<td class="cell4BlueSides">How much memory that is free in the allocated amount.</td>
			</tr>
			<tr>
				<th class="cellBlueTopAndBottom" scope="row">Free Total</th>
				<td class="cell4BlueSides numeric">#NumberFormat(memInfo.free, '_.99')#</td>
				<td class="cell4BlueSides">Free memory available when compared to the maximum allowed.</td>
			</tr>
		</tbody>
	</table>
	
	<br /><cfset percent = NumberFormat(memInfo.used / memInfo.max * 100, '_.99') />
	<strong>Used #percent# % out of maximum (#NumberFormat(memInfo.used, '_.99')# MB of #NumberFormat(memInfo.max, '_.99')# MB).</strong>
	<div class="progress" title="#percent#"></div>
	<br /><cfset percent = NumberFormat(memInfo.used / memInfo.allocated * 100, '_.99') />
	<strong>Used #percent# % out of current allocation (#NumberFormat(memInfo.used, '_.99')# MB of #NumberFormat(memInfo.allocated, '_.99')# MB).</strong>
	<div class="progress" title="#percent#"></div>
	<br />
</cfoutput>

<h3 class="cellBlueTopAndBottom pageSection">Server Info</h3>

<table class="styled narrow">
	<thead>
		<tr>
			<th class="cellBlueTopAndBottom" scope="col">Aspect</th>
			<th class="cellBlueTopAndBottom" scope="col">Value</th>
			<th class="cellBlueTopAndBottom" scope="col">Description</th>
		</tr>
	</thead>
	<tbody><cfoutput>
		<tr>
			<th colspan="3" class="cellBlueTopAndBottom rowHeader">GetMetricData('simple_load')</th>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Load</th>
			<td class="cell4BlueSides numeric">#srvInfo.load#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th colspan="3" class="cellBlueTopAndBottom rowHeader">GetMetricData('avg_req_time')</th>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Average Request Time</th>
			<td class="cell4BlueSides numeric">#srvInfo.requests.averageTime#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th colspan="3" class="cellBlueTopAndBottom rowHeader">GetMetricData('avg_req_time')</th>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Previous Request Time</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.requests.previousTime)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th colspan="3" class="cellBlueTopAndBottom rowHeader">GetMetricData('perf_monitor')</th>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Average DB Time</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.avgDbTime)#</td>
			<td class="cell4BlueSides">This is a running average of the amount of time, in milliseconds, an individual database operation, lauched by CF, took to complete.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Average Queue Time</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.avgQueueTime)#</td>
			<td class="cell4BlueSides">This is a running average of the amount of time, in milliseconds, requests spent waiting in the CF input queue before CF began to process that request.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Average Request Time</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.avgReqTime)#</td>
			<td class="cell4BlueSides">This is a running average of the total amount of time, in milliseconds, it took CF to process a request.  In addition to general page processing time, this value includes both queue time and database processing time.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Bytes In</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.bytesIn / 1024, '_.99')#</td>
			<td class="cell4BlueSides">(KiB) This is the number of bytes received by the ColdFusion Server.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Bytes Out</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.bytesOut / 1024, '_.99')#</td>
			<td class="cell4BlueSides">(KiB) This is the number of bytes returned by the ColdFusion Server.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Cache Pops</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.avgDbTime)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">CFC Requests Queued</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.cfcReqQueued)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">CFC Requests Running</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.cfcReqRunning)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">CFC Requests Timed out</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.cfcReqTimedOut)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">DB Hits</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.dbHits)#</td>
			<td class="cell4BlueSides">The number of database operations performed by the ColdFusion Server.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Flash Requests Queued</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.flashReqQueued)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Flash Requests Running</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.flashReqRunning)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Flash Requests Timed out</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.flashReqTimedOut)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Instance Name</th>
			<td class="cell4BlueSides">#HtmlEditFormat(srvInfo.perfMon.instanceName)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Page Hits</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.pageHits)#</td>
			<td class="cell4BlueSides">The number of web pages processedd by the ColdFusion Server.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Requests Queued</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.reqQueued)#</td>
			<td class="cell4BlueSides">This is the number of requests currently waiting to be processed by the ColdFusion Server.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Requests Running</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.reqRunning)#</td>
			<td class="cell4BlueSides">This is the number of requests currently being actively processed by the ColdFusion Server.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Requests Timed out</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.reqTimedOut)#</td>
			<td class="cell4BlueSides">This is the number of request that timed out waiting to be processed by the ColdFusion Server.  These requests never got to run.</td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Template Requests Queued</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.templateReqQueued)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Template Requests Running</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.templateReqRunning)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Template Requests Timed out</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.templateReqTimedOut)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Web Service Requests Queued</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.wsReqQueued)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Web Service Requests Running</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.wsReqRunning)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
		<tr>
			<th class="cellBlueTopAndBottom" scope="row">Web Service Requests Timed out</th>
			<td class="cell4BlueSides numeric">#NumberFormat(srvInfo.perfMon.wsReqTimedOut)#</td>
			<td class="cell4BlueSides"></td>
		</tr>
	</cfoutput></tbody>
</table>

<cfinclude template="myfooter.cfm" />

<cfinclude template="../footer.cfm" />