<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="SeriesArray" type="array" />
	<cfScript>
		variables.seriesArray = arrayNew(1);
	</cfScript>

	<cfFunction
		name		= "getArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn variables.seriesArray />
	</cfFunction>

	<cfFunction
		name		= "setSeries"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="ConditionModel"	required="yes"	type="ConditionModel" hint="" />
		<cfArgument name="compoundType"		required="no"	type="variableName" default="and" hint="and, or" />
		<cfScript>
			arrayAppend(variables.seriesArray, arguments);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getNewSetSeries"
		returnType	= "ConditionModel"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="compoundType" required="no" type="variableName" default="and" hint="and, or" />
		<cfScript>
			arguments.ConditionModel = new ConditionModel();
			setSeries(arguments.ConditionModel, arguments.compoundType);
			return arguments.ConditionModel;
		</cfScript>
	</cfFunction>

</cfComponent>