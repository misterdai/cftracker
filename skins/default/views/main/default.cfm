<script type="text/javascript" src="assets/js/swfobject.js"></script> 
<script type="text/javascript">
	var graphs = {
		memory: {
			data: '',
			fm: '',
			addItems: ''
		},
		caches: {
			data: '',
			fm: '',
			addItems: ''
		},
		appsess: {
			data: '',
			fm: '',
			keys: [],
			keynums: {},
			addItems: '',
			options: {
				selected: {},
				displayed: {}
			}
		},
		threads: {
			data: '',
			fm: '',
			keys: [],
			keynums: {},
			addItems: '',
			options: {
				selected: {},
				displayed: {}
			}
		}
	};
	
	$(function() {
		for (var key in graphs) {
			var flashvars = {
				path: 'assets/flash/amline',
				settings_file: 'assets/flash/amline/' + encodeURIComponent(key + '.xml'),
				data_file: 'assets/flash/amline/' + encodeURIComponent('empty.csv')
			};
			var flashparams = {
				wmode: 'opaque'
			};
			swfobject.embedSWF('assets/flash/amline/amline.swf', key + 'Graph', '0', '0', '8', 'assets/flash/expressInstall.swl', flashvars, flashparams);
		}
		
		var getGraphData = function() {
			$.ajax({
				url: '<cfoutput>#BuildUrl('stats.graphs')#</cfoutput>&ts=' + new Date().getTime(),
				method: 'GET',
				dataType: 'json',
				success: function (series) {
					ts = series.TS;
					delete series.TS;
					for (var key in series) {
						if (typeof(series[key]) == 'string') {
							graphs[key].data += ts + series[key] + '\n';
						} else {
							for (var item in series[key]) {
								if (typeof(graphs[key].keynums[item]) == 'undefined') {
									graphs[key].keys.push(item);
									graphs[key].keynums[item] = graphs[key].keys.length - 1;
									graphs[key].addItems += '<graph gid="' + graphs[key].keys.length + '"><title>' + item + '</title><balloon_text>{value} | {title}</balloon_text><selected>0</selected></graph>';
									graphs[key].options.selected[graphs[key].keynums[item]] = false;
									graphs[key].options.displayed[graphs[key].keynums[item]] = true;
								}
							}
							data = ts;
							for (var i = 0; i < graphs[key].keys.length; i++) {
								if (typeof(series[key][graphs[key].keys[i]]) == 'undefined') {
									data += ';0';
								} else {
									data += ';' + series[key][graphs[key].keys[i]];
								}
							}
							graphs[key].data += data + '\n';
						}
						if (graphs[key].fm.nodeName != 'OBJECT') {
							graphs[key].fm = $('#' + key + 'Graph').get(0);
						}
						if (graphs[key].fm.setData) {
							if (graphs[key].addItems.length > 0) {
								graphs[key].addItems = '<settings><graphs>' + graphs[key].addItems + '</graphs></settings>';
								graphs[key].fm.setSettings(graphs[key].addItems);
								graphs[key].addItems = '';
							}
							graphs[key].fm.setData(graphs[key].data);
						}
					}
				}
			});
		};
		
		getGraphData();
		poller = setInterval(getGraphData, 5000);

		var graphConfig = function(e) {
			e.preventDefault();
			el = $(this);
			graphId = $('object', el.parent()).attr('id');
			graphId = graphId.substring(0, graphId.length - 5);
			var dialog = '<div title="Configure chart"><input type="hidden" name="chart" value="' + graphId + '"><table><thead><tr><th>Select</th><th>Display</th><th>Application</th></tr></thead><tbody>';
			for (var i = 0; i < graphs[graphId].keys.length; i++) {
				dis = (graphs[graphId].options.displayed[i]) ? 'checked="checked"' : '';
				sel = (graphs[graphId].options.selected[i]) ? 'checked="checked"' : '';
				dialog += '<tr><td><input type="checkbox" name="sel_' + i + '" ' + sel + ' /></td><td><input type="checkbox" name="dis_' + i + '" ' + dis + ' /></td><td>' + graphs[graphId].keys[i] + '</td></tr>';
			}
			dialog += '</tbody></table>';
			$(dialog).dialog({
				modal: true,
				buttons: {
					Ok: function() {$(this).dialog('close');}
				},
				beforeclose: function(e, ui) {
					var el = $(this);
					var graphId = $('input[name=chart]', el).val();
					$('input', el).each(function(num, el) {
						if (el.name.match(/^sel_\d+$/)) {
							id = el.name.split('_').pop();
							if (graphs[graphId].options.selected[id] != el.checked) {
								if (el.checked) {
									graphs[graphId].fm.selectGraph(id);
								} else {
									graphs[graphId].fm.deselectGraph(id);
								}
								graphs[graphId].options.selected[id] = el.checked;
							}
						} else if (el.name.match(/^dis_\d+$/)) {
							id = el.name.split('_').pop();
							if (graphs[graphId].options.displayed[id] != el.checked) {
								if (el.checked) {
									graphs[graphId].fm.showGraph(id);
								} else {
									graphs[graphId].fm.hideGraph(id);
								}
								graphs[graphId].options.displayed[id] = el.checked;
							}
						}
					});
					
				}
			});
		};
		
		var ajaxForm = function(e) {
			e.preventDefault();
			var el = $(this);
			var form = el.parent();
			if (!el.button('option', 'disabled')) {
				el.button({disabled: true});
				jQuery.post(
					form.attr('action'),
					function (data) {
						el.button({disabled: false});
					}
				);
			}
		};

		$('.button[alt]').each(function(num, el) {
			el = $(el);
			el.button({
				icons: {
					primary: 'ui-icon-' + el.attr('alt')
				}
			})
			.attr('alt', null);
			if (el.hasClass('graphConfig'))
				el.click(graphConfig);
			else
				el.click(ajaxForm);
		});
		
	});
</script>

<div class="span-12">
	<div class="ui-widget ui-widget-content">
		<div class="ui-widget-header">App Sessions</div>
		<div id="appsessGraph" class="graph ui-widget-content"></div>	
		<button class="button graphConfig" alt="wrench">Options</button>
	</div>
</div>
<div class="span-12 last">
	<div class="ui-widget ui-widget-content">
		<div class="ui-widget-header">Memory</div>
		<div id="memoryGraph" class="graph ui-widget-content"></div>	
		<form action="<cfoutput>#BuildUrl(action = 'stats.gc')#</cfoutput>" method="post">
			<button class="button" alt="trash">Run Garbage Collection</button>
		</form>
	</div>
</div>
<hr />
<div class="span-12">
	<div class="ui-widget ui-widget-content">
		<div class="ui-widget-header">Cache's</div>
		<div id="cachesGraph" class="graph ui-widget-content"></div>	
		<form action="<cfoutput>#BuildUrl(action = 'queries.purgeAll')#</cfoutput>" method="post">
			<button class="button" alt="trash">Purge Query Cache</button>
		</form>
	</div>
</div>
<div class="span-12 last">
	<div class="ui-widget ui-widget-content">
		<div class="ui-widget-header">Thread Groups</div>
		<div id="threadsGraph" class="graph ui-widget-content"></div>	
		<button class="button graphConfig" alt="wrench">Options</button>
	</div>
</div>