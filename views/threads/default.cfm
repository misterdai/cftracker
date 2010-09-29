<script type="text/javascript">
	var table = {
		sort: [[0, 'asc']],
		cols: [
			null,
			null,
			null,
			null,
			null,
			{bVisible: false},
			{bVisible: false},
			{bVisible: false},
			{bVisible: false},
			{bVisible: false},
			{bVisible: false},
			{bVisible: false},
			{bVisible: false},
			{bVisible: false}
		]
	};
	$(function() {
		$('#goApp').button({
			icons: {
				primary: 'ui-icon-search'
			}
		}).click(function(e) {
			e.preventDefault();
			app = $('#apps').val();
			window.location.href = app;
		});
	});
</script>
<cfoutput><script type="text/javascript" src="#this.assetbegin#assets/js/datatable.js#this.assetend#"></script></cfoutput>

<div class="span-24 last">
	<h2>Threads</h2>


<div id="displayCols" title="Table columns">2</div>
<button id="selectCols"> Select columns</button>

<cfoutput>
<table class="display dataTable">
	<thead>
		<tr>
			<th scope="col">ID</th>
			<th scope="col">Name</th>
			<th scope="col">State</th>
			<th scope="col">CF Trace</th>
			<th scope="col">CPU Time</th>
			<th scope="col">User Time</th>
			<th scope="col">Native</th>
			<th scope="col">Suspended</th>
			<th scope="col">Waited Count</th>
			<th scope="col">Waited Time</th>
			<th scope="col">Blocked Count</th>
			<th scope="col">Blocked Time</th>
			<th scope="col">Lock Name</th>
			<th scope="col">Lock Owner</th>
		</tr>
	</thead>
	<tbody><cfloop array="#rc.data#" index="thread">
		<tr>
			<td>#HtmlEditFormat(thread.threadId)#</td>
			<td>#HtmlEditFormat(thread.threadName)#</td>
			<td>#HtmlEditFormat(thread.threadState)#</td>
			<td><cfif ArrayLen(thread.cfFiles) Gt 0><a alt="zoomin" title="View the ColdFusion trace." class="button nextDetail">&nbsp;</a><div style="display:none" title="ColdFusion thread trace">#ArrayToList(thread.cfFiles, '<br />')#</div></cfif></td>
			<td>#HtmlEditFormat(thread.threadCpuTime)#</td>
			<td>#HtmlEditFormat(thread.threadUserTime)#</td>
			<td>#HtmlEditFormat(thread.isInNative)#</td>
			<td>#HtmlEditFormat(thread.isSuspended)#</td>
			<td>#HtmlEditFormat(thread.waitedCount)#</td>
			<td>#HtmlEditFormat(thread.waitedTime)#</td>
			<td>#HtmlEditFormat(thread.blockedCount)#</td>
			<td>#HtmlEditFormat(thread.blockedTime)#</td>
			<td>#HtmlEditFormat(thread.lockName)#</td>
			<td>#HtmlEditFormat(thread.lockOwnerId)#</td>
		</tr>
	</cfloop></tbody>
</table>
</cfoutput>
