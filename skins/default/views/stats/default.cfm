<div class="span-24 last">
	<h2>Statistics</h2>

	<cfif application.cftracker.support.stats.cfmservlet>
	<h3>CFM Servlet</h3>
	<table class="styled narrow rightValues">
		<thead>
			<tr>
				<th scope="col">Aspect</th>
				<th scope="col">Value</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<th scope="row">Running Requests</th>
				<td>#NumberFormat(rc.data.cf.running)#</td>
			</tr>
			<tr>
				<th scope="row">Queued Requests</th>
				<td>#NumberFormat(rc.data.cf.queued)#</td>
			</tr>
			<tr>
				<th scope="row">Timedout Requests</th>
				<td>#NumberFormat(rc.data.cf.queued)#</td>
			</tr>
			<tr>
				<th scope="row">Request Limit</th>
				<td>#NumberFormat(rc.data.cf.limit)#</td>
			</tr>
		</cfoutput></tbody>
	</table>
	</cfif>

	<cfif application.cftracker.support.stats.jdbc>
	<h3>JDBC</h3>
	<table class="styled narrow">
		<thead>
			<tr>
				<th scope="col">Datasource</th>
				<th scope="col">Database</th>
				<th scope="col">Description</th>
				<th scope="col">Open Connections</th>
				<th scope="col">Total Connections</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<cfloop collection="#rc.data.jdbc#" item="ds">
			<tr>
				<th scope="row">#HtmlEditFormat(ds)#</th>
				<td>#HtmlEditFormat(rc.data.jdbc[ds].database)#</td>
				<td>#HtmlEditFormat(rc.data.jdbc[ds].description)#</td>
				<td>#NumberFormat(rc.data.jdbc[ds].open)#</td>
				<td>#NumberFormat(rc.data.jdbc[ds].total)#</td>
			</tr>
			</cfloop>
		</cfoutput></tbody>
	</table>
	</cfif>
	
	<h3>Other stats</h3>
	<table class="styled narrow">
		<tbody><cfoutput>
			<tr>
				<th scope="col" colspan="2">Compilation Time</th>
				<th scope="col" colspan="2">CPU Process Time</th>
			</tr>
			<tr>
				<td colspan="2">
					<cfif FileExists(application.base & 'tools/monitor/images/compilation-day.png')>
						<img src="tools/monitor/images/compilation-day.png?ts=#rc.ts#" />
					<cfelse>
						<img src="assets/images/norrd.png" />
					</cfif>
				</td>
				<td colspan="2">
					<cfif FileExists(application.base & 'tools/monitor/images/cpu-day.png')>
						<img src="tools/monitor/images/cpu-day.png?ts=#rc.ts#" />
					<cfelse>
						<img src="assets/images/norrd.png" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th scope="row">Compilation Time</th><td>#SiPrefix(rc.data.compilation / 1000)#s</td>
				<th scope="row">CPU Process Time</th><td>#SiPrefix(rc.data.cputime / 1000000000)#s</td>
			</tr>
			<tr>
				<th scope="col" colspan="2">Classes currently loaded</th>
				<th scope="col" colspan="2">Classes loading activity</th>
			</tr>
			<tr>
				<td colspan="2">
					<cfif FileExists(application.base & 'tools/monitor/images/class-total-day.png')>
						<img src="tools/monitor/images/class-total-day.png?ts=#rc.ts#" />
					<cfelse>
						<img src="assets/images/norrd.png" />
					</cfif>
				</td>
				<td colspan="2">
					<cfif FileExists(application.base & 'tools/monitor/images/class-activity-day.png')>
						<img src="tools/monitor/images/class-activity-day.png?ts=#rc.ts#" />
					<cfelse>
						<img src="assets/images/norrd.png" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th scope="row" rowspan="2">Classes currently loaded</th><td rowspan="2">#NumberFormat(rc.data.classLoading.current)#</td>
				<th scope="row">Classes loaded total</th><td>#NumberFormat(rc.data.classLoading.total)#</td>
			</tr>
			<tr>
				<th scope="row">Classes unloaded total</th>
				<td>#NumberFormat(rc.data.classLoading.unloaded)#</td>
			</tr>
		</cfoutput></tbody>
	</table>

	<h3>Performance Statistics</h3>
	
	If the table below doesn't show any information, you are probably running in multiserver mode which is currently unsupported for stats.
	
	<table class="styled narrow">
		<thead>
			<tr>
				<th scope="col">Aspect</th>
				<th scope="col">Value</th>
				<th scope="col">Description</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<cfif StructKeyExists(rc.data.server, 'load')>
			<tr>
				<th colspan="3" class="cellBlueTopAndBottom rowHeader">GetMetricData('simple_load')</th>
			</tr>
			<tr>
				<th scope="row">Load</th>
				<td class="numeric">#rc.data.server.load#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructCount(rc.data.server.requests) Gt 0>
			<tr>
				<th colspan="3" class="cellBlueTopAndBottom rowHeader">GetMetricData('avg_req_time')</th>
			</tr>
			<tr>
				<th scope="row">Average Request Time</th>
				<td class="numeric">#rc.data.server.requests.averageTime#</td>
				<td></td>
			</tr>
			<tr>
				<th colspan="3" class="cellBlueTopAndBottom rowHeader">GetMetricData('prev_req_time')</th>
			</tr>
			<tr>
				<th scope="row">Previous Request Time</th>
				<td class="numeric">#NumberFormat(rc.data.server.requests.previousTime)#</td>
				<td></td>
			</tr>
			<tr>
				<th colspan="3" class="cellBlueTopAndBottom rowHeader">GetMetricData('perf_monitor')</th>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'avgDbTime')>
			<tr>
				<th scope="row">Average DB Time</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.avgDbTime)#</td>
				<td>This is a running average of the amount of time, in milliseconds, an individual database operation, lauched by CF, took to complete.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'avgQueueTime')>
			<tr>
				<th scope="row">Average Queue Time</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.avgQueueTime)#</td>
				<td>This is a running average of the amount of time, in milliseconds, requests spent waiting in the CF input queue before CF began to process that request.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'avgReqTime')>
			<tr>
				<th scope="row">Average Request Time</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.avgReqTime)#</td>
				<td>This is a running average of the total amount of time, in milliseconds, it took CF to process a request.  In addition to general page processing time, this value includes both queue time and database processing time.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'bytesIn')>
			<tr>
				<th scope="row">Bytes In</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.bytesIn / 1024, '_.99')#</td>
				<td>(KiB) This is the number of bytes received by the ColdFusion Server.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'bytesOut')>
			<tr>
				<th scope="row">Bytes Out</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.bytesOut / 1024, '_.99')#</td>
				<td>(KiB) This is the number of bytes returned by the ColdFusion Server.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'cachepops')>
			<tr>
				<th scope="row">Cache Pops</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.cachepops)#</td>
				<td>If the ColdFusion template becomes full, the cache will "pop" off the first cached template to make room for the new cached template.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'cfcReqQueued')>
			<tr>
				<th scope="row">CFC Requests Queued</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.cfcReqQueued)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'cfcReqRunning')>
			<tr>
				<th scope="row">CFC Requests Running</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.cfcReqRunning)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'cfcReqTimedOut')>
			<tr>
				<th scope="row">CFC Requests Timed out</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.cfcReqTimedOut)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'dbHits')>
			<tr>
				<th scope="row">DB Hits</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.dbHits)#</td>
				<td>The number of database operations performed by the ColdFusion Server.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'flashReqQueued')>
			<tr>
				<th scope="row">Flash Requests Queued</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.flashReqQueued)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'flashReqRunning')>
			<tr>
				<th scope="row">Flash Requests Running</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.flashReqRunning)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'flashReqTimedOut')>
			<tr>
				<th scope="row">Flash Requests Timed out</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.flashReqTimedOut)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'instanceName')>
			<tr>
				<th scope="row">Instance Name</th>
				<td>#HtmlEditFormat(rc.data.server.perfMon.instanceName)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'pageHits')>
			<tr>
				<th scope="row">Page Hits</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.pageHits)#</td>
				<td>The number of web pages processedd by the ColdFusion Server.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'reqQueued')>
			<tr>
				<th scope="row">Requests Queued</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.reqQueued)#</td>
				<td>This is the number of requests currently waiting to be processed by the ColdFusion Server.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'reqRunning')>
			<tr>
				<th scope="row">Requests Running</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.reqRunning)#</td>
				<td>This is the number of requests currently being actively processed by the ColdFusion Server.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'reqTimedOut')>
			<tr>
				<th scope="row">Requests Timed out</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.reqTimedOut)#</td>
				<td>This is the number of request that timed out waiting to be processed by the ColdFusion Server.  These requests never got to run.</td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'templateReqQueued')>
			<tr>
				<th scope="row">Template Requests Queued</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.templateReqQueued)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'templateReqRunning')>
			<tr>
				<th scope="row">Template Requests Running</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.templateReqRunning)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'templateReqTimedOut')>
			<tr>
				<th scope="row">Template Requests Timed out</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.templateReqTimedOut)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'wsReqQueued')>
			<tr>
				<th scope="row">Web Service Requests Queued</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.wsReqQueued)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'wsReqRunning')>
			<tr>
				<th scope="row">Web Service Requests Running</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.wsReqRunning)#</td>
				<td></td>
			</tr>
			</cfif>
			<cfif StructKeyExists(rc.data.server.perfMon, 'wsReqTimedOut')>
			<tr>
				<th scope="row">Web Service Requests Timed out</th>
				<td class="numeric">#NumberFormat(rc.data.server.perfMon.wsReqTimedOut)#</td>
				<td></td>
			</tr>
			</cfif>
		</cfoutput></tbody>
	</table>
</div>