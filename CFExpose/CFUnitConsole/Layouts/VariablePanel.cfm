<cfScript>
	local.defaultNodeList = "Client,CGI,Cookie,Form,Request,Server,URL,Variables";

	if(isDefined('Session') AND structCount(Session))
		local.defaultNodeList = 'Session,' & local.defaultNodeList;

	if(isDefined('Application') AND structKeyExists(application, "applicationname") AND len(application.applicationname))
		local.defaultNodeList = 'Application,' & local.defaultNodeList;

	local.defaultNodeList = listSort(local.defaultNodeList, "textnocase", "asc", chr(44));

	/* remove unavailable scope items */
		for(locals.listIndex=listLen(local.defaultNodeList); locals.listIndex GT 0; --locals.listIndex)
		{
			locals.loop = listGetAt(local.defaultNodeList, locals.listIndex);

			if( NOT isDefined(locals.loop) )
				local.defaultNodeList = listDeleteAt(local.defaultNodeList, locals.listIndex);
		}
	/* end */
</cfScript>
<div class="VariablePanel">
	<div class="NextNodePickerWrap">
		<!--- default nodes --->
			<cfOutput>
				<cfLoop array="#getDefaultVariableArray()#" index="local.item">
					#local.item.htmlOutputString#
				</cfLoop>
				<cfLoop list="#local.defaultNodeList#" index="local.item">
					<a href="" nodesyntax="#local.item#" class="selectable">#local.item#</a>
				</cfLoop>
			</cfOutput>
		<!--- end : default nodes --->
	</div>
	<div class="SearchWrap">
		<div>search</div><input type="text" class="SearchVariablePanel" />
	</div>
</div>