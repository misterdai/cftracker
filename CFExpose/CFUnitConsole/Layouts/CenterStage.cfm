<div class="DumpOuterWrap">
	<div class="RefreshIcon"></div>
	<div class="DumpWrap">
		<cfset initDumpVar = getInitDumpVar() />
		<cfif structKeyExists(variables, "initDumpVar") >
			<cfDump var="#initDumpVar#" label="#getInitDumpVarLabel()#" expand="yes" />
		<cfElse>
			<div class="TempMessage">
				<h4>Content Will Appear Here as Variables are Inspected</h4>
			</div>
		</cfif>
		<cfif isDebug() >
			<p><small><cfOutput>Processor Url : #getRemoteProcessorUrlAddress().getString()#</cfOutput></small></p>
		</cfif>
	</div>
</div>
