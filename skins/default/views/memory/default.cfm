<script src="assets/js/highcharts.js" type="text/javascript"></script>
<div class="span-24 last">
<h3>JVM Memory</h3>
</div>
<div class="span-12">
	<h4>Heap</h4>
	<script type="text/javascript">
		<cfscript>
			pools = StructKeyArray(rc.data.memory.heap.pools);
			ArraySort(pools, 'textnocase');
			cats = Duplicate(pools);
			ArrayPrepend(cats, 'Heap');
			cats = SerializeJson(cats);
			limit = [NumberFormat(rc.data.memory.heap.usage.max / 1024^2, '.00')];
			allo = [NumberFormat(rc.data.memory.heap.usage.committed / 1024^2, '.00')];
			used = [NumberFormat(rc.data.memory.heap.usage.used / 1024^2, '.00')];
			free = [NumberFormat(rc.data.memory.heap.usage.free / 1024^2, '.00')];
			pLen = ArrayLen(pools);
			for (i = 1; i Lte pLen; i++) {
				ArrayAppend(limit, NumberFormat(rc.data.memory.heap.pools[pools[i]].usage.max / 1024^2, '.00'));
				ArrayAppend(allo, NumberFormat(rc.data.memory.heap.pools[pools[i]].usage.committed / 1024^2, '.00'));
				ArrayAppend(free, NumberFormat(rc.data.memory.heap.pools[pools[i]].usage.free / 1024^2, '.00'));
				ArrayAppend(used, NumberFormat(rc.data.memory.heap.pools[pools[i]].usage.used / 1024^2, '.00'));
			}
		</cfscript>
		$(function() {
		   chart = new Highcharts.Chart({
		      chart: {
		         renderTo: 'heapChart',
		         defaultSeriesType: 'column'
		      },
		       title: {
    	    	 text: 'Heap and heap pools',
				},
		      xAxis: {
		         categories: <cfoutput>#cats#</cfoutput>
		      },
		      yAxis: {
		         min: 0,
		         max: <cfoutput>#limit[1]#</cfoutput>,
		         title: {
		            text: ''
		         }
		      },
		      tooltip: {
		         formatter: function() {
		            return ''+
		               this.x +': '+ this.y +' MB ' + this.series.name;
		         }
		      },
		      plotOptions: {
		         column: {
		            pointPadding: 0.2,
		            borderWidth: 0
		         }
		      },
	           series: [{
		         name: 'Max',
		         data: <cfoutput>#SerializeJson(limit)#</cfoutput>
		      }, {
		         name: 'Allocated',
		         data: <cfoutput>#SerializeJson(allo)#</cfoutput>
		      }, {
		         name: 'Used',
		         data: <cfoutput>#SerializeJson(used)#</cfoutput>
		      }, {
		         name: 'Free',
		         data: <cfoutput>#SerializeJson(free)#</cfoutput>
		      }]
		   });
		   
		   
		});
	</script>
	<div id="heapChart"></div>
	<table>
		<thead>
			<tr>
				<th scope="col">Name</th>
				<th scope="col">Max</th>
				<th scope="col">Allocated</th>
				<th scope="col">Used</th>
				<th scope="col">Free</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<th scope="row">Heap</th>
				<td>#SiPrefix(rc.data.memory.heap.usage.max, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.usage.committed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.usage.used, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.usage.free, 1024)#B</td>
			</tr>
			<tr>
				<th scope="row">Heap (Peak)</th>
				<td>#SiPrefix(rc.data.memory.heap.peakusage.max, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.peakusage.committed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.peakusage.used, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.heap.peakusage.free, 1024)#B</td>
			</tr>
			<cfloop collection="#rc.data.memory.heap.pools#" item="pool">
				<tr>
					<th scope="row">#HtmlEditFormat(pool)#</th>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].usage.max, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].usage.committed, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].usage.used, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].usage.free, 1024)#B</td>
				</tr>
				<tr>
					<th scope="row">#HtmlEditFormat(pool)# (Peak)</th>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].peakusage.max, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].peakusage.committed, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].peakusage.used, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.heap.pools[pool].peakusage.free, 1024)#B</td>
				</tr>
			</cfloop>
		</cfoutput></tbody>
	</table>
</div>
<div class="span-12 last">
	<h4>Non-heap</h4>
	<script type="text/javascript">
		<cfscript>
			pools = StructKeyArray(rc.data.memory.nonheap.pools);
			ArraySort(pools, 'textnocase');
			cats = Duplicate(pools);
			ArrayPrepend(cats, 'Heap');
			cats = SerializeJson(cats);
			limit = [NumberFormat(rc.data.memory.nonheap.usage.max / 1024^2, '.00')];
			allo = [NumberFormat(rc.data.memory.nonheap.usage.committed / 1024^2, '.00')];
			used = [NumberFormat(rc.data.memory.nonheap.usage.used / 1024^2, '.00')];
			free = [NumberFormat(rc.data.memory.nonheap.usage.free / 1024^2, '.00')];
			pLen = ArrayLen(pools);
			for (i = 1; i Lte pLen; i++) {
				ArrayAppend(limit, NumberFormat(rc.data.memory.nonheap.pools[pools[i]].usage.max / 1024^2, '.00'));
				ArrayAppend(allo, NumberFormat(rc.data.memory.nonheap.pools[pools[i]].usage.committed / 1024^2, '.00'));
				ArrayAppend(free, NumberFormat(rc.data.memory.nonheap.pools[pools[i]].usage.free / 1024^2, '.00'));
				ArrayAppend(used, NumberFormat(rc.data.memory.nonheap.pools[pools[i]].usage.used / 1024^2, '.00'));
			}
		</cfscript>
		$(function() {
		   chart = new Highcharts.Chart({
		      chart: {
		         renderTo: 'nonheapChart',
		         defaultSeriesType: 'column'
		      },
		       title: {
    	    	 text: 'Non-heap and non-heap pools',
				},
		      xAxis: {
		         categories: <cfoutput>#cats#</cfoutput>
		      },
		      yAxis: {
		         min: 0,
		         max: <cfoutput>#limit[1]#</cfoutput>,
		         title: {
		            text: ''
		         }
		      },
		      tooltip: {
		         formatter: function() {
		            return ''+
		               this.x +': '+ this.y +' MB ' + this.series.name;
		         }
		      },
		      plotOptions: {
		         column: {
		            pointPadding: 0.2,
		            borderWidth: 0
		         }
		      },
	           series: [{
		         name: 'Max',
		         data: <cfoutput>#SerializeJson(limit)#</cfoutput>
		      }, {
		         name: 'Allocated',
		         data: <cfoutput>#SerializeJson(allo)#</cfoutput>
		      }, {
		         name: 'Used',
		         data: <cfoutput>#SerializeJson(used)#</cfoutput>
		      }, {
		         name: 'Free',
		         data: <cfoutput>#SerializeJson(free)#</cfoutput>
		      }]
		   });
		   
		   
		});
	</script>
	<div id="nonheapChart"></div>
	<table>
		<thead>
			<tr>
				<th scope="col">Name</th>
				<th scope="col">Max</th>
				<th scope="col">Allocated</th>
				<th scope="col">Used</th>
				<th scope="col">Free</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<th scope="row">Non-heap</th>
				<td>#SiPrefix(rc.data.memory.nonheap.usage.max, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.usage.committed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.usage.used, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.usage.free, 1024)#B</td>
			</tr>
			<tr>
				<th scope="row">Non-heap (Peak)</th>
				<td>#SiPrefix(rc.data.memory.nonheap.peakusage.max, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.peakusage.committed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.peakusage.used, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.nonheap.peakusage.free, 1024)#B</td>
			</tr>
			<cfloop collection="#rc.data.memory.nonheap.pools#" item="pool">
				<tr>
					<th scope="row">#HtmlEditFormat(pool)#</th>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].usage.max, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].usage.committed, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].usage.used, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].usage.free, 1024)#B</td>
				</tr>
				<tr>
					<th scope="row">#HtmlEditFormat(pool)# (Peak)</th>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].peakusage.max, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].peakusage.committed, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].peakusage.used, 1024)#B</td>
					<td>#SiPrefix(rc.data.memory.nonheap.pools[pool].peakusage.free, 1024)#B</td>
				</tr>
			</cfloop>
		</cfoutput></tbody>
	</table>
</div>

<div class="span-24 last"><h3>Garbage Collection</h3></div>
<cfset num = 1 />
<cfoutput>
<cfloop array="#rc.data.garbage#" index="gc">
	<div class="span-12 <cfif num Mod 2 Eq 0>last</cfif>">
		<h4>#HtmlEditFormat(gc.name)#</h4>
		<table>
			<caption>Information</caption>
			<thead>
				<tr>
					<th scope="col">Aspect</th>
					<th scope="col">Value</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th scope="row">Collections</th>
					<td>#NumberFormat(gc.collections)#</td>
				</tr>
				<tr>
					<th scope="row">Total duration</th>
					<td>#SiPrefix(gc.totalDuration / 1000)#s</td>
				</tr>
				<tr>
					<th scope="row">Average duration</th>
					<td>#SiPrefix(gc.totalDuration / gc.collections / 1000)#s</td>
				</tr>
				<tr>
					<th scope="row">Pools collecting</th>
					<td>#ArrayToList(gc.pools, ', ')#</td>
				</tr>
			</tbody>
		</table>
		<h5>Last collection</h5>
		<table>
			<caption>Last collection</caption>
			<thead>
				<tr>
					<th scope="col">Aspect</th>
					<th scope="col">Value</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th scope="row">Start time</th>
					<td>#DateFormat(gc.starttime, application.settings.display.dateformat)# #TimeFormat(gc.starttime, application.settings.display.timeformat)#</td>
				</tr>
				<tr>
					<th scope="row">End time</th>
					<td>#DateFormat(gc.endtime, application.settings.display.dateformat)# #TimeFormat(gc.endtime, application.settings.display.timeformat)#</td>
				</tr>
				<tr>
					<th scope="row">Duration</th>
					<td>#SiPrefix(gc.duration / 1000)#s</td>
				</tr>
			</tbody>
		</table>
		<table>
			<caption>Pool usage</caption>
			<thead>
				<tr>
					<th scope="col">Pool</th>
					<th scope="col">When</th>
					<th scope="col">Allocated</th>
					<th scope="col">Used</th>
					<th scope="col">Free</th>
				</tr>
			</thead>
			<tbody>
				<cfloop collection="#gc.usage#" item="pName">
					<tr>
						<th scope="row" rowspan="2">#HtmlEditFormat(pName)#</th>
						<th scope="row">Before</th>
						<td>#siPrefix(gc.usage[pName].before.committed, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].before.used, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].before.free, 1024)#B</td>
					</tr>
					<tr>
						<th scope="row">After</th>
						<td>#siPrefix(gc.usage[pName].after.committed, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].after.used, 1024)#B</td>
						<td>#siPrefix(gc.usage[pName].after.free, 1024)#B</td>
					</tr>	
				</cfloop>
			</tbody>
		</table>
	</div>
	<cfset num++ />
</cfloop>
</cfoutput>

<div class="span-24 last"><h3>Operating System</h3></div>
<div class="span-12">
	<h4>Physical</h4>
	<div class="graph"></div>
	<table>
		<thead>
			<tr>
				<th scope="col">Max</th>
				<th scope="col">Used</th>
				<th scope="col">Free</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<td>#SiPrefix(rc.data.memory.os.physicalTotal, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.os.physicalUsed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.os.physicalFree, 1024)#B</td>
			</tr>
		</cfoutput></tbody>
	</table>
</div>
<div class="span-12 last">
	<h4>Swap</h4>
	<div class="graph"></div>
	<table>
		<thead>
			<tr>
				<th scope="col">Max</th>
				<th scope="col">Used</th>
				<th scope="col">Free</th>
			</tr>
		</thead>
		<tbody><cfoutput>
			<tr>
				<td>#SiPrefix(rc.data.memory.os.swapTotal, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.os.swapUsed, 1024)#B</td>
				<td>#SiPrefix(rc.data.memory.os.swapFree, 1024)#B</td>
			</tr>
		</cfoutput></tbody>
	</table>
</div>