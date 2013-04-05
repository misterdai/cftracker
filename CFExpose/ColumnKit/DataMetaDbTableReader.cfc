<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	accessors	= "yes"
	extends		= "DataMetaReader"
	Column		= "ColumnDbTable"
>

	<cfProperty name="Row"			type="Row" />
	<cfProperty name="TableName"	type="string" />
	<cfProperty name="EntityName"	type="string" />
	<cfProperty name="SchemaName"	type="string" />
	<cfProperty name="CatalogName"	type="string" />
	<cfProperty name="Datasource"	type="Datasource" />
	<cfProperty name="Alias"		type="string" />

	<cfFunction
		name		= "throwMissingColumn"
		returnType	= "void"
		access		= "public"
		output		= "no"
		description	= "simple throw message of missing column in defined table"
		hint		= ""
	>
		<cfArgument name="column_name"	required="yes"	type="string" hint="" />
		<cfThrow
			message	= "The column '#arguments.column_name#' does not exist in table '#getTableRef(0)#'"
			detail	= "An operation on the column was specified but unable to be fullfilled as the column does not appear to exist"
		/>
	</cfFunction>

	<cfFunction
		name		= "getColumnArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="column_name"	required="no"	type="string" hint="" />
		<cfScript>
			getColumnMap();
			return variables.columnMap.array;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getIdentityColumnName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.columnMap = getColumnMap();

			for(local.keyName in local.columnMap)
			{
				local.columnStruct = local.columnMap[local.keyName];

				if(local.columnStruct.Is_Identity)
					return local.keyName;
			}

			return '';
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "getColumnMap"
		returnType	= "struct"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="column_name"	required="no"	type="string" hint="" />
		<cfScript>
			if(structKeyExists(variables, "columnMap"))
			{
				if(structKeyExists( arguments , "column_name" ))
					if(structKeyExists(variables.columnMap.struct , arguments.column_name))
						return variables.columnMap.struct[arguments.column_name];
					else
						throwMissingColumn(arguments.column_name);

				return variables.columnMap.struct;
			}

			if(structKeyExists(variables , "columnMap" ))
				return variables.columnMap.struct;

			variables.columnMap = {struct = structNew()};

			local.catalogName = getCatalogName();
			if(structKeyExists(local, "catalogName") AND len(local.catalogName))
				local.attributeStruct.dbname = local.catalogName;

			local.Datasource = getDatasource();

			if(structKeyExists(local, "Datasource"))
				local.attributeStruct.datasource = getDatasource().getDatasourceName();

			local.query = getTableColumnSchemaQuery();

			queryAddColumn(local.query , "Is_Identity" , arrayNew(1));

			/* convert to struct. Also add IS_IDENTITY and correct type_name */
				local.struct	= structNew();
				local.array		= arrayNew(1);

				for(local.loop=1; local.loop LTE local.query.recordCount; ++local.loop)
				{
					local.columnName	= local.query.column_name[ local.loop ];
					local.type_name		= local.query.type_name[ local.loop ];

					/* cast to struct */
						local.columnArray = listToArray(local.query.columnList);
						for(local.colArrayLoop=arrayLen(local.columnArray); local.colArrayLoop GT 0; --local.colArrayLoop)
						{
							local.columnloop = local.columnArray[local.colArrayLoop];
							local.struct[local.columnName][local.columnloop] = local.query[local.columnloop][local.loop];
						}
					/* end */

					local.struct[local.columnName].name = local.columnName;

					local.struct[local.columnName].IsEditable = !local.query.IsComputed[local.loop];

					if( right(local.type_name,9) EQ " identity" )//depending on SQL or cfDbInfo, identity specifier might be in the type_name
					{
						local.struct[local.columnName].type_name = left(local.type_name , len(local.type_name)-9);
						local.struct[local.columnName].Is_Identity = "YES";
					}else if(local.query.IsIdentityIdentified[ local.loop ])
						local.struct[local.columnName].Is_Identity = "YES";
					else
						local.struct[local.columnName].Is_Identity = "NO";

					arrayAppend(local.array, local.struct[local.columnName]);
				}

				variables.columnMap.array	= local.array;
				variables.columnMap.query	= local.query;
				variables.columnMap.struct	= local.struct;
			/* end */

			if( structKeyExists(arguments , "column_name") )
			{
				if( structKeyExists(local.struct , arguments.column_name) )
					Return local.struct[ arguments.column_name ];

				throwMissingColumn(arguments.column_name);
			}

			Return local.struct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getTableColumnSchemaQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.catalogName = getCatalogName();
			local.schemaName = getSchemaName();

			local.tableRef = getTableName();

			if(len(local.schemaName))
				local.tableRef = local.schemaName & '.' & local.tableRef;
		</cfScript>
		<cfQuery name="local.query" timeout="120">
				DECLARE @tableRef varchar(120)

				SELECT	@tableRef = <cfQueryParam value="#local.tableRef#" cfsqltype="cf_sql_VARCHAR" />

				SELECT	type_name=data_type
						,IsIdentityIdentified=ISNULL(columnproperty( object_id(table_schema+'.'+table_name) , column_name , 'IsIdentity' ),0)
						,IS_NULLABLE=IS_NULLABLE
						,COLUMN_NAME=COLUMN_NAME
						,CHARACTER_MAXIMUM_LENGTH=CHARACTER_MAXIMUM_LENGTH
						,ORDINAL_POSITION=ORDINAL_POSITION
						,IsComputed=ISNULL((SELECT top 1 1 FROM sys.computed_columns WHERE name=c.Column_Name AND object_id=object_id(@tableRef)),0)
				FROM	<cfif structKeyExists(local, "catalogName") AND len(local.catalogName) >[#getCatalogName()#].</cfif>Information_Schema.Columns c
				WHERE	table_name = <cfQueryParam value="#getTableName()#" cfsqltype="cf_sql_VARCHAR" />
			<cfif len(local.schemaName) >
				AND		table_schema = <cfQueryParam value="#getSchemaName()#" cfsqltype="cf_sql_VARCHAR" />
			</cfif>
		</cfQuery>
		<cfif NOT local.query.recordCount >
			<cfQuery name="local.tableQuery" timeout="120">
					SELECT	TOP 1 IsFound=1
					FROM	<cfif structKeyExists(local, "catalogName") AND len(local.catalogName) >[#getCatalogName()#].</cfif>Information_Schema.Tables
					WHERE	table_name = <cfQueryParam value="#getTableName()#" cfsqltype="cf_sql_VARCHAR" />
				<cfif len(local.schemaName) >
					AND		table_schema = <cfQueryParam value="#getSchemaName()#" cfsqltype="cf_sql_VARCHAR" />
				</cfif>
			</cfQuery>
			<cfScript>
				if(NOT val(local.tableQuery.IsFound))
				{
					if(!structKeyExists(local, 'catalogName'))
						local.catalogName = '';

					throw(message='No columns were found in the defined table: #getTableName()#', detail='Please ensure you have the correct table-name, schema-name(#local.schemaName#) and catalog-name(#local.catalogName#)');
				}
			</cfScript>
		</cfif>
		<cfReturn local.query />
	</cfFunction>

</cfComponent>