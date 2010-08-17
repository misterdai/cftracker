<cfsilent>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			$(function() {
				var detailLinks = function(e) {
					e.preventDefault();
					var el = $(this);
					var win = $(window);
					var winPos = {
						height: win.height(),
						width: win.width()
					};
					$('<div title="Details" class="detailDialog"><img src="assets/images/ajax.gif" width="220" height="19" alt="Loading..." /></div>').dialog({
						buttons: {
							Ok: function() {
								$(this).dialog('close');
							}
						},
						close: function(event, ui) {
							$(this).remove();
						},
						height: winPos.height - 100,
						width: winPos.width - 100,
						maxHeight: winPos.height - 50,
						maxWidth: winPos.width - 50,
						modal: true
					})
					.load(el.attr('href') + '&ts=' + new Date().getTime());
				};
			
				oTable = $('.dataTable').dataTable({
					bProcessing: true,
					bServerSide: true,
					sAjaxSource: '<cfoutput>#BuildUrl('queries.items')#</cfoutput>',
					bJQueryUI: true,
					sPaginationType: 'full_numbers',
					bAutoWidth: true,
					bSort: false,
					bFilter: false,
					fnDrawCallback: function() {
						$('.button[alt]:not(.ui-button)').each(function() {
							$(this).button({
								icons: {primary: 'ui-icon-' + $(this).attr('alt')},
								text: !(this.innerHTML.length == 0 || this.innerHTML == '&nbsp;'),
								disabled: (this.innerHTML.match(/^0$/))
							}).attr('alt', '');
						});
						$('.detail').click(detailLinks);
					},
					fnServerData: function ( sSource, aoData, fnCallback ) {
$.ajax( {"dataType": 'json',"type": "POST","url": sSource,"data": aoData,"success": fnCallback} );
}
				});
			
				function fnShowHide(iCol) {
					var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
					oTable.fnSetColumnVis( iCol, bVis ? false : true );
				}
			
				$('#displayCols').dialog({
					autoOpen: false,
					modal: true,
					buttons: {
						Ok: function() {
							$(this).dialog('close');
						}
					}
				});
			
				$('#selectCols').button({
					icons: {
						primary: 'ui-icon-wrench'
					}
				}).click(function() {
					$('#displayCols').dialog('open');
				});
				
				var RowRemover = function(e) {
					e.preventDefault();
					$(this).parent().animate({
						height: 'hide',
						opacity: 'hide'
					}, function() {
						$(this).remove()
					});
				};
				
				$('.actions button').each(function(num, el) {
					$(el).button({
						icons: {
							primary: el.className
						}
					}).click(function(e) {
						var form = $(this).parents('form');
						$('input[name=action]', form).val(this.value);
					});
				});
			});
		</script>
	</cfsavecontent>
	<cfhtmlhead text="#js#" />
	
</cfsilent>
<div class="span-24 last">

<h2>Query Cache</h2>

<form action="<cfoutput>#BuildUrl(action = 'queries.purgeAll', queryString = 'return=queries.default')#</cfoutput>" method="post">
	<button class="button" alt="trash">Purge Query Cache</button>
</form>

<div id="displayCols" title="Table columns">
<p>Please select the table columns you would like displayed.</p>
<ul>
	<li><label for="col3"><input type="checkbox" name="display" value="3" id="col3" /> Query Name</label></li>
	<li><label for="col5"><input type="checkbox" name="display" value="4" id="col4" /> Creation Date</label></li>
	<li><label for="col6"><input type="checkbox" name="display" value="5" id="col5" /> SQL</label></li>
</ul>
</div>

<button id="selectCols"> Select columns</button>
<cfoutput>
<form action="" method="post">
	<input type="hidden" name="action" value="" />
<table class="display dataTable">
	<thead>
		<tr>
			<th scope="col"></th>
			<th scope="col">Hash Code</th>
			<th scope="col">View</th>
			<th scope="col">QueryName</th>
			<th scope="col">Creation</th>
			<th scope="col">SQL</th>
		</tr>
	</thead>
	<tbody><cfloop collection="#rc.data#" item="query">
		<tr>
			<td><input type="checkbox" name="queries" value="#HtmlEditFormat(query)#" /></td>
			<td>#HtmlEditFormat(query)#</td>
			<td><a alt="zoomin" title="View the result set for this query." class="button detail" href="#BuildUrl('queries.getresult?name=' & UrlEncodedFormat(query))#">&nbsp;</a>
				<a alt="wrench" title="View the parameters for this query." class="button detail" href="#BuildUrl('queries.getparams?name=' & UrlEncodedFormat(query))#">#ArrayLen(rc.data[query].params)#</a>
			</td>
			<td>#HtmlEditFormat(rc.data[query].queryName)#</td>
			<td>#LsDateFormat(rc.data[query].creation, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[query].creation, application.settings.display.timeformat)#</td>
			<td>#HtmlEditFormat(rc.data[query].sql)#</td>
		</tr>
	</cfloop></tbody>
</table>
<div class="actions">
	<button class="ui-icon-stop" value="queries.purge">Purge</button>
	<button class="ui-icon-refresh" value="queries.refresh">Reset creation time</button>
</div>
</form>
</cfoutput>
<hr />
<h3>Action all queries by:</h3>
<cfoutput>
<form action="" method="post">
	<input type="hidden" name="action" value="" />
	<fieldset>
		<legend>Filters</legend>
		<p><label for="sql">SQL (regex)</label><br />
		<input type="text" name="sql" id="sql" /></p>
		<p><label for="name">Query name (regex)</label><br />
		<input type="text" name="name" id="name" /></p>
		<p><label for="creation">Creation date</label><br />
		<select name="creationOp">
			<option value="before">Before</option>
			<option value="on">On</option>
			<option value="after">After</option>
		</select>
		<input type="text" name="creation" id="creation" /></p>
	</fieldset>
	<div class="actions">
		<button class="ui-icon-stop" value="queries.purgeby">Purge</button>
		<button class="ui-icon-refresh" value="queries.refreshby">Reset creation time</button>
	</div>
</form>
</cfoutput>

</div>