<cfComponent
	Description	= "a great component for all components to extend for the purpose of exposing ColdFuion based functionality"
	Hint		= "all methods in here should be private and only used by the components that extend this component"
	Output		= "no"
>

	<cfFunction
		name		= "CFMethods"
		returnType	= "CFMethodsController"
		access		= "private"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			if(NOT structKeyExists(variables, "CFMethodsController"))
				variables.CFMethodsController = createObject("component", "CFMethodsController");

			return variables.CFMethodsController;
		</cfScript>

	</cfFunction>

</cfComponent>