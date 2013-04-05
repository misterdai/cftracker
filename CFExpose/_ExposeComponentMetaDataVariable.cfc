<cfComponent
	Hint		= ""
	output		= "no"
	extends		= "ExposeVariable"
>
	<cfset setVarValidateByTypeName('struct') />

	<cfFunction
		name		= "ExposeComponentMetaData"
		returnType	= "ExposeComponentMetaData"
		access		= "private"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfif !structKeyExists(_private, "ExposeComponentMetaData") >
			<cfset _private.ExposeComponentMetaData = createObject("component", "ExposeComponentMetaData").setCfcMetaData(getVar()) />
		</cfif>
		<cfReturn _private.ExposeComponentMetaData />
	</cfFunction>

</cfComponent>