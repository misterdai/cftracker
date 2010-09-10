<cfsilent>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			var table = {
				sort: [[1, 'asc']],
				cols: [
					{bSortable: false},
					null,
					{bSortable: false}
					<cfscript>
						sortable = ',{bSortable: false}';
						if (application.cftracker.support.sess.data.expired) {
							WriteOutput(sortable);
						}
						if (application.cftracker.support.sess.data.lastAccessed) {
							WriteOutput(sortable);
						}
						if (application.cftracker.support.sess.data.idleTimeout) {
							WriteOutput(sortable);
						}
						if (application.cftracker.support.sess.data.timeAlive) {
							WriteOutput(sortable);
						}
						if (application.cftracker.support.sess.data.isJ2eeSession) {
							WriteOutput(sortable);
						}
						if (application.cftracker.support.sess.data.clientIp) {
							WriteOutput(sortable);
						}
						if (application.cftracker.support.sess.data.idFromUrl) {
							WriteOutput(sortable);
						}
					</cfscript>
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
		<script type="text/javascript" src="assets/js/datatable.js"></script>
	</cfsavecontent>
	<cfhtmlhead text="#js#" />
</cfsilent>

<cfif Not StructKeyExists(rc, 'name')>
<div class="span-24 last">
	<h2>Sessions</h2>
</cfif>

<cfoutput>
<h3>Filter by application</h3>
<select id="apps">
	<option value="#BuildUrl('sessions.default?all=true')#">-All Applications-</option>
	<cfloop collection="#rc.apps#" item="wc">
		<optgroup label="#HtmlEditFormat(wc)#">
		<cfloop array="#rc.apps[wc]#" index="app">
			<option value="#BuildUrl('sessions.application?name=' & UrlEncodedFormat(app) & '&wc=' & UrlEncodedFormat(wc))#" <cfif StructKeyExists(rc, 'name') And rc.name Eq app>selected="selected"</cfif>>#HtmlEditFormat(app)#</option>
		</cfloop>
		</optgroup>
	</cfloop>
</select>
<button id="goApp">Go</button>
</cfoutput>


<h3>Sessions</h3>

<div id="displayCols" title="Table columns">3</div>

<button id="selectCols"> Select columns</button>

<cfoutput>
<form action="" method="post">
	<cfif StructKeyExists(rc, 'name')>
		<input type="hidden" name="name" value="#HtmlEditFormat(rc.name)#" />
	</cfif>
	<cfif StructKeyExists(rc, 'wc')>
		<input type="hidden" name="wc" value="#HtmlEditFormat(rc.wc)#" />
	</cfif>
	<input type="hidden" name="action" value="" />
<table class="display dataTable">
	<thead>
		<tr>
			<th scope="col"></th>
			<th scope="col">ID</th>
			<th scope="col">View</th>
			<cfif application.cftracker.support.sess.data.expired><th scope="col">Expired</th></cfif>
			<cfif application.cftracker.support.sess.data.lastAccessed><th scope="col">Accessed</th></cfif>
			<cfif application.cftracker.support.sess.data.idleTimeout><th scope="col">Timeout</th></cfif>
			<cfif application.cftracker.support.sess.data.timeAlive><th scope="col">Created</th></cfif>
			<cfif application.cftracker.support.sess.data.isJ2eeSession><th scope="col">Type</th></cfif>
			<cfif application.cftracker.support.sess.data.clientIp><th scope="col">Client IP</th></cfif>
			<cfif application.cftracker.support.sess.data.idFromUrl><th scope="col">ID From URL</th></cfif>
		</tr>
	</thead>
	<tfoot> 
		<tr> 
			<th></th>
			<th><input type="text" value="" /></th> 
			<th></th>
			<cfif application.cftracker.support.sess.data.expired><th><select>
				<option value=""></option>
				<option value="YES">Yes</option>
				<option value="NO">No</option>
			</select></th></cfif>
			<cfif application.cftracker.support.sess.data.lastAccessed><th></th></cfif>
			<cfif application.cftracker.support.sess.data.idleTimeout><th></th></cfif>
			<cfif application.cftracker.support.sess.data.timeAlive><th></th></cfif>
			<cfif application.cftracker.support.sess.data.isJ2eeSession><th><select>
				<option value=""></option>
				<option value="CF">CF</option>
				<option value="J2ee">J2ee</option>
			</select></th></cfif>
			<cfif application.cftracker.support.sess.data.clientIp><th><input type="text" value="" /></th></cfif>
			<cfif application.cftracker.support.sess.data.idFromUrl><th><select>
				<option value=""></option>
				<option value="YES">Yes</option>
				<option value="NO">No</option>
			</select></th></cfif>
		</tr> 
	</tfoot> 
	<cfset i = 1 />
	<tbody><cfloop collection="#rc.data#" item="wc">
		<cfloop collection="#rc.data[wc]#" item="app">
		<cfloop collection="#rc.data[wc][app]#" item="sess">
		<tr>
			<cfif rc.data[wc][app][sess].exists>
				<td><input type="checkbox" name="sess_#i#" value="#HtmlEditFormat(wc)##chr(9)##HtmlEditFormat(app)##chr(9)##HtmlEditFormat(sess)#" /></td>
				<td>#HtmlEditFormat(sess)#</td>
				<td><cfif application.cftracker.support.sess.data.scope><a alt="zoomin" title="View the session scope." class="button detail" href="#BuildUrl('sessions.getscope?name=' & UrlEncodedFormat(sess) & '&wc=' & UrlEncodedFormat(wc) & '&app=' & UrlEncodedFormat(app))#">&nbsp;</a></cfif></td>
				<cfif application.cftracker.support.sess.data.expired><td>#HtmlEditFormat(rc.data[wc][app][sess].expired)#</td></cfif>
				<cfif application.cftracker.support.sess.data.lastAccessed><td>#LsDateFormat(rc.data[wc][app][sess].lastAccessed, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app][sess].lastAccessed, application.settings.display.timeformat)#</td></cfif>
				<cfif application.cftracker.support.sess.data.idleTimeout><td>#LsDateFormat(rc.data[wc][app][sess].idleTimeout, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app][sess].idleTimeout, application.settings.display.timeformat)#</td></cfif>
				<cfif application.cftracker.support.sess.data.timeAlive><td>#LsDateFormat(rc.data[wc][app][sess].timeAlive, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app][sess].timeAlive, application.settings.display.timeformat)#</td></cfif>
				<cfif application.cftracker.support.sess.data.isJ2eeSession><td><cfif rc.data[wc][app][sess].isJ2eeSession>J2ee<cfelse>CF</cfif></td></cfif>
				<cfif application.cftracker.support.sess.data.clientIp><td>#HtmlEditFormat(rc.data[wc][app][sess].clientIp)#</td></cfif>
				<cfif application.cftracker.support.sess.data.idFromUrl><td>#HtmlEditFormat(rc.data[wc][app][sess].idFromUrl)#</td></cfif>
			<cfelse>
				<td></td>
				<td>#HtmlEditFormat(sess)#</td>
				<td>No longer exists</td>
			</cfif>
		</tr><cfset i++ />
	</cfloop></cfloop></cfloop></tbody>
</table>
<div class="actions">
	<cfif application.cftracker.support.sess.actions.stop><button class="ui-icon-stop" value="sessions.stop">Stop</button></cfif>
	<cfif application.cftracker.support.sess.actions.refresh><button class="ui-icon-refresh" value="sessions.refresh">Refresh</button></cfif>
</div>
</form>
</cfoutput>
<cfif application.cftracker.support.sess.form>
<hr />
<h3>Action <cfif StructKeyExists(rc, 'name')>application<cfelse>all</cfif> sessions by:</h3>
<cfoutput>
<form action="" method="post">
	<input type="hidden" name="action" value="" />
	<fieldset>
		<legend>Filters</legend>
		<p><label for="id">ID (regex)</label><br />
		<input type="text" name="id" id="id" /></p>
		<p><label for="expired">Expired</label><br />
		<select name="expired" id="expired"><option value=""></option><option value="YES">Yes</option><option value="NO">No</option></select></p>
		<p><label for="lastaccessed">Last accessed</label><br />
		<select name="lastaccessedOp">
			<option value="before">Before</option>
			<option value="on">On</option>
			<option value="after">After</option>
		</select>
		<input type="text" name="lastaccessedOp" id="lastaccessedOp" /></p>
		<p><label for="timeout">Timeout</label><br />
		<select name="timeoutOp">
			<option value="before">Before</option>
			<option value="on">On</option>
			<option value="after">After</option>
		</select>
		<input type="text" name="timeout" id="timeout" /></p>
		<p><label for="created">Created</label><br />
		<select name="createdOp">
			<option value="before">Before</option>
			<option value="on">On</option>
			<option value="after">After</option>
		</select>
		<input type="text" name="created" id="created" /></p>
		<p><label for="clientIp">Client IP (regex)</label><br />
		<input type="text" name="clientIp" id="clientIp" /></p>
		<p><label for="idFromUrl">ID from URL</label><br />
		<select name="idFromUrl" id="idFromUrl"><option value=""></option><option value="YES">Yes</option><option value="NO">No</option></select></p>
	</fieldset>
	<div class="actions">
		<button class="ui-icon-stop" value="sessions.stopby">Stop</button>
		<button class="ui-icon-refresh" value="queries.refreshby">Refresh</button>
	</div>
</form>
</cfoutput>
</cfif>
</div>
