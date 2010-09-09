<cfsilent>
	<cfset request.layout = false />
	<cfsetting showdebugoutput="false" />
	<cfscript>
		len = ArrayLen(rc.data['aaData']);
		for (i = 1; i Lte len; i++) {
			ArrayPrepend(rc.data['aaData'][i], '<input type="checkbox" name="query_#i#" value="' & rc.data["aaData"][i][1] & '" />');
			rc.data['aaData'][i][3] = '<a alt="zoomin" title="View the result set for this query." class="button detail" href="#BuildUrl("queries.getresult?name=" & rc.data["aaData"][i][2])#">&nbsp;</a><a alt="wrench" title="View the parameters for this query." class="button detail" href="#BuildUrl("queries.getparams?name=" & rc.data["aaData"][i][2])#">#rc.data["aaData"][i][3]#</a>';
		}
	</cfscript>
</cfsilent><cfoutput>#SerializeJson(rc.data)#</cfoutput>