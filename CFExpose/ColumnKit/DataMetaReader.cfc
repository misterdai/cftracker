<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
	Column		= "Column"
>

	<cfProperty name="Row"			type="Row" />
	<cfProperty name="TableName"	type="string" />
	<cfProperty name="SchemaName"	type="string" />
	<cfProperty name="CatalogName"	type="string" />
	<cfProperty name="Datasource"	type="Datasource" />
	<cfProperty name="Alias"		type="string" />
	<cfProperty name="TableRef"		type="string" />
	<cfScript>
		variables.columnStruct = structNew();
	</cfScript>

	<cfFunction
		name		= "setRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Row" required="yes" type="Row" hint="" />
		<cfScript>
			variables.Row = arguments.Row;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "Row") )
				return variables.Row;
		</cfScript>
		<cfThrow message="Row Not Yet Set" detail="Use the method 'setRow' in component '#getMetaData(this).name#'" />
	</cfFunction>

	<cfFunction
		name		= "getColumnByName"
		returnType	= "Column"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			if(structKeyExists(variables.columnStruct, arguments.name))
				return variables.columnStruct[arguments.name];

			arguments.Row = getRow();

			local.Column = arguments.Row.getByName(arguments.name);

			if(!structKeyExists(local, 'Column'))
				local.Column = new( iExpose().getAttribute('Column'), arguments);

			local.Column.setDataMetaReader(this);

			variables.columnStruct[arguments.name] = local.Column;

			return local.Column;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setDatasource"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Datasource" required="yes" type="Datasource" hint="" />
		<cfScript>
			variables.Datasource = arguments.Datasource;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDatasource"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "Datasource") )
				return variables.Datasource;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setTableName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="TableName" required="yes" type="string" hint="" />
		<cfset variables.TableName = arguments.TableName />
		<cfReturn this />
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
		name		= "getAlias"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "helper method that makes a unique alias name of the entity object this instance represents"
		description	= ""
	>
		<cfScript>
			local.cName = getCatalogName() & '_';
			local.sName = getSchemaName() & '_';

			return left(local.cName,1) & left(local.sName,1) & getTableName();
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
		<cfReturn hash(getTableName() & getSchemaName() & getCatalogName()) />
	</cfFunction>

	<cfFunction
		name		= "getTableRef"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="isWithAlias"	required="yes"	type="boolean"	default="yes"	hint="" />
		<cfScript>
			local.tableName = getTableName();
			local.returnString = '[#local.tableName#]';

			local.schemaName = getSchemaName();
			local.isSchemaDefined = structKeyExists(local, "schemaName") AND len(local.schemaName);
			if(local.isSchemaDefined)
				local.returnString = '[#local.schemaName#].' & local.returnString;

			local.catalogName = getCatalogName();
			if(structKeyExists(local, "catalogName") AND len(local.catalogName))
			{
				if(NOT local.isSchemaDefined)
					local.returnString = '[dbo].' & local.returnString;

				local.returnString = '[#local.catalogName#].' & local.returnString;
			}

			if(arguments.isWithAlias)
				local.returnString &= ' AS ' & getAlias();

			return local.returnString;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSchemaName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, 'schemaName'))
				return variables.schemaName;

			return getRow().getSchemaName();
		</cfScript>
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
			if(structKeyExists(variables, 'catalogName'))
				return variables.catalogName;

			return getRow().getCatalogName();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getTableName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, 'tableName'))
				return variables.tableName;

			return getRow().getTableName();
		</cfScript>
	</cfFunction>

</cfComponent>