<cfComponent
	Hint		= ""
	output		= "no"
	extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="datasourceName" type="string" />
	<cfProperty name="catalogName" type="string" />
	<cfProperty name="schemaName" type="string" />

	<cfFunction
		name		= "setName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Name" required="yes" type="string" hint="" />
		<cfScript>
			return setDatasourceName(arguments.name);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return getDatasourceName();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setDatasourceName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="DatasourceName" required="yes" type="string" hint="" />
		<cfset variables.DatasourceName = arguments.DatasourceName />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getDatasourceName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "may return void"
	>
		<cfif NOT structKeyExists(variables, "DatasourceName")>
			<cfReturn />
		</cfif>
		<cfReturn variables.DatasourceName />
	</cfFunction>

	<cfFunction
		name		= "setSchemaName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="SchemaName" required="yes" type="string" hint="" />
		<cfset variables.SchemaName = arguments.SchemaName />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getSchemaName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "SchemaName")>
			<cfReturn 'dbo' />
		</cfif>
		<cfReturn variables.SchemaName />
	</cfFunction>

	<cfFunction
		name		= "setCatalogName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="CatalogName" required="yes" type="string" hint="" />
		<cfset variables.CatalogName = arguments.CatalogName />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getCatalogName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "CatalogName") )
				return '';

			return variables.CatalogName;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getTargetHash"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn hash(getDataSource().getTargetHash()) />
	</cfFunction>

</cfComponent>