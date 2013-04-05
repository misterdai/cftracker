<cfComponent
	Hint		= ""
	Output		= "no"
	Extends		= "CFMethods"
>

	<cfFunction
		name		= "Conversions"
		returnType	= "CFConversionMethods"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			if(NOT structKeyExists(variables, "CFConversionMethods"))
				variables.CFConversionMethods = createObject("component", "CFConversionMethods");

			return variables.CFConversionMethods;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "Strings"
		returnType	= "CFStringMethods"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			if(NOT structKeyExists(variables, "CFStringMethods"))
				variables.CFStringMethods = createObject("component", "CFStringMethods");

			return variables.CFStringMethods;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "CF"
		returnType	= "ExposeColdFusion"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return createObject("component", "ExposeColdFusion");
		</cfScript>
	</cfFunction>

</cfComponent>