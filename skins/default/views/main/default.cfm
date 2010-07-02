<!--[if IE]><script type="text/javascript" src="assets/js/flot/excanvas.min.js"></script><![endif]--> 
<script type="text/javascript" src="assets/js/flot/jquery.flot.js"></script> 
<script type="text/javascript">
	var pollers = {};
	$(function() {

		var graphs = [
			{
				placeholder: $('#appsess .graph'),
				tbody: $('#appsess .keytable tbody').get(0),
				tab: $('#appsess'),
				url: '<cfoutput>#BuildUrl('applications.graph')#</cfoutput>&ts=' + new Date().getTime(),
				data: [],
				keys: {}
			},
			{
				placeholder: $('#mem .graph'),
				tbody: $('#mem .keytable tbody').get(0),
				tab: $('#mem'),
				url: '<cfoutput>#BuildUrl('stats.graphmem')#</cfoutput>&ts=' + new Date().getTime(),
				data: [],
				keys: {}
			},
			{
				placeholder: $('#threads .graph'),
				tbody: $('#threads .keytable tbody').get(0),
				tab: $('#threads'),
				url: '<cfoutput>#BuildUrl('threads.graphgroups')#</cfoutput>&ts=' + new Date().getTime(),
				data: [],
				keys: {}
			},
			{
				placeholder: $('#cache .graph'),
				tbody: $('#cache .keytable tbody').get(0),
				tab: $('#cache'),
				url: '<cfoutput>#BuildUrl('stats.graphcache')#</cfoutput>&ts=' + new Date().getTime(),
				data: [],
				keys: {}
			}
		];
		var options = {
			lines: {show: true},
			xaxis: {
				mode: 'time',
				minTickSize: [30, 'second']
			},
			legend: {position:'nw'}
		};

		var getGraphData = function () {
			$(graphs).each(function(id, graph) {
				$.ajax({
					url: graph.url,
					method: 'GET',
					dataType: 'json',
					success: function (series) {
						$(series).each(function(key, value) {
							if (typeof(graph.keys[value.LABEL]) == 'undefined') {
								graph.keys[value.LABEL] = graph.data.length;
								label = (value.LABEL == value.DESCRIPTION) ? 'App ' + graph.data.length : value.LABEL;
								graph.data[graph.keys[value.LABEL]] = {
									label: label,
									fullLabel: value.DESCRIPTION,
									data: [value.DATA]
								};
							} else {
								graph.data[graph.keys[value.LABEL]].data.push(value.DATA);
							}
						});
										
						if (graph.tab.tabs('option', 'selected') == 0) {
							plot = $.plot(graph.placeholder, graph.data, options);
							var pData = plot.getData();
						}
						

						$(graph.data).each(function(key, value) {
							if (key >= graph.tbody.rows.length) {
								$(graph.tbody).append('<tr><th class="ui-widget-header" scope="row"></th><td class="ui-widget-content"></td><td class="ui-widget-content"></td></tr>');
							}
							graph.tbody.rows[key].cells[0].innerHTML = value.label;
							graph.tbody.rows[key].cells[1].innerHTML = value.fullLabel;
							graph.tbody.rows[key].cells[2].innerHTML = value.data[value.data.length - 1][1];
							if (pData && pData[key]) {
								$(graph.tbody.rows[key].cells[2]).css({
									backgroundColor: pData[key].color,
									backgroundImage: 'none'
								});
							}
						});
						
					}
				});
			});
		};

		$(graphs).each(function(id, graph) {
			graph.tab.bind('tabsshow', function(event, ui) {
				if (ui.index == 0) {
					$.plot(graph.placeholder, graph.data, options);
				}
			});
		});

		getGraphData();
		setInterval(getGraphData, 5000);
		
	});
</script>

<script type="text/javascript">
	$(function() {
		$('.tabs').tabs();
	});
</script>
<div class="span-12">
	<h3>App Sessions</h3>
	<div class="tabs" id="appsess">
		<ul>
			<li><a href="#appTab-1">Graph</a></li>
			<li><a href="#appTab-2">Table + Key</a></li>
		</ul>
		<div id="appTab-1">
			<div class="graph"></div>	
		</div>
		<div id="appTab-2">
			<table class="styled keytable">
				<thead>
					<tr>
						<th scope="col">Key</th>
						<th scope="col">Application</th>
						<th scope="col">Sessions</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="span-12 last">
	<h3>Memory</h3>
	<div class="tabs" id="mem">
		<ul>
			<li><a href="#memTab-1">Graph</a></li>
			<li><a href="#memTab-2">Table</a></li>
		</ul>
		<div id="memTab-1">
			<div class="graph"></div>	
		</div>
		<div id="memTab-2">
			<table class="styled keytable">
				<thead>
					<tr>
						<th scope="col">Key</th>
						<th scope="col">Description</th>
						<th scope="col">MiB</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<hr />
<div class="span-12">
	<h3>Cache's</h3>
	<div class="tabs" id="cache">
		<ul>
			<li><a href="#cacheTab-1">Graph</a></li>
			<li><a href="#cacheTab-2">Table</a></li>
		</ul>
		<div id="cacheTab-1">
			<div class="graph"></div>	
		</div>
		<div id="cacheTab-2">
			<table class="styled keytable">
				<thead>
					<tr>
						<th scope="col">Key</th>
						<th scope="col">Description</th>
						<th scope="col">Value</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="span-12 last">
	<h3>Thread Groups</h3>
	<div class="tabs" id="threads">
		<ul>
			<li><a href="#threadsTab-1">Graph</a></li>
			<li><a href="#threadsTab-2">Table</a></li>
		</ul>
		<div id="threadsTab-1">
			<div class="graph"></div>	
		</div>
		<div id="threadsTab-2">
			<table class="styled keytable">
				<thead>
					<tr>
						<th scope="col">Key</th>
						<th scope="col">Description</th>
						<th scope="col">Value</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>