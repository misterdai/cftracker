<cfComponent
	Description	= ""
	Hint		= ""
	Output		= "no"
	accessors	= "yes"
	Implements	= "iDataReader"
	Extends		= "DataReader"
>

	<cfProperty name="Query" type="query" />

	<cfProperty name="CurrentRowNumber"	type="numeric" />
	<cfProperty name="ColumnList"		type="string" />

	<cfFunction
		name		= "getColumnList"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn getQuery().columnList />
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
		<cfScript>
			local.query = getQuery();
			return local.query[arguments.name][getCurrentRowNumber()];
		</cfScript>
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
		<cfScript>
			return getQuery();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRowCount"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return getQuery().recordCount;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setQuery"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Query" required="yes" type="query" hint="" />
		<cfScript>
			variables.Query = arguments.Query;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getQuery"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "Query") )
				return variables.Query;
		</cfScript>
		<cfThrow message="Query Not Yet Set" detail="Use the method 'setQuery' in component '#getMetaData(this).name#'" />
	</cfFunction>

</cfComponent>