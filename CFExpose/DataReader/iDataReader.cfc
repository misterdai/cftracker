<cfInterface hint="">

	<cfFunction
		name		= "next"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
	</cfFunction>

	<cfFunction
		name		= "setCurrentRowNumber"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="CurrentRowNumber" required="yes" type="numeric" hint="" />
	</cfFunction>

	<cfFunction
		name		= "getCurrentRowNumber"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
	</cfFunction>

	<cfFunction
		name		= "toStructOfArrays"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="columnList" required="no" type="string" hint="" />
	</cfFunction>

	<cfFunction
		name		= "toQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="columnList" required="no" type="string" hint="" />
	</cfFunction>

	<cfFunction
		name		= "each"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="method"		required="yes" type="any" hint="" />
		<cfArgument name="columnList"	required="no" type="string" hint="" />
	</cfFunction>

	<cfFunction
		name		= "getStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="columnList" required="no" type="string" hint="" />
	</cfFunction>

	<cfFunction
		name		= "getByName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
	</cfFunction>

	<cfFunction
		name		= "getRowCount"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
	</cfFunction>

	<cfFunction
		name		= "getColumnList"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
	</cfFunction>

</cfInterface>