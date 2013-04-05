<cfSilent>
	<cfif thisTag.executionMode EQ "end"><cfExit /></cfif>

	<cfif not structKeyExists(attributes, "processor") >
		<cfParam name="attributes.processorName" type="variableName" />
		<cfset attributes.Processor = createObject("component", attributes.processorName) />
	</cfif>
	<cfParam name="attributes.Processor" type="any" />

	<cfScript>
		local=structNew();

		local.clientInputStruct = duplicate(url);
		structAppend(local.clientInputStruct, duplicate(form));

		attributes.Processor.setClientInputStruct(local.clientInputStruct);

		local.output = attributes.Processor.getOutput();
	</cfScript>
	<cfif structKeyExists( attributes , "returnVariable" ) >
		<cfParam name="attributes.returnVariable" type="variableName" />
		<cfset "caller.#attributes.returnVariable#" = local.output />
		<cfExit />
	</cfif>
</cfSilent><cfOutput>#local.output#</cfOutput>