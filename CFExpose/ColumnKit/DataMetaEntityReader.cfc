<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "DataMetaReader"
	accessors	= "yes"
	Column		= "ColumnEntity"
>

	<cfProperty name="Entity"		type="any" />
	<!--- parent properties --->
		<cfProperty name="Row"			type="Row" />
		<cfProperty name="TableName"	type="string" />
		<cfProperty name="SchemaName"	type="string" />
		<cfProperty name="CatalogName"	type="string" />
		<cfProperty name="Datasource"	type="Datasource" />
		<cfProperty name="Alias"		type="string" />
		<cfProperty name="TableRef"		type="string" />
	<!--- end --->

	<!--- Represented Objects Naming Conventions --->
		<cfFunction
			name		= "getTableName"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfScript>
				if(!structKeyExists(variables, "tableName"))
				{
					if(isEntityMode())
						variables.tableName = getExposedEntity().getTableName();
					else
						return '';
				}

				return variables.tableName;
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
			<cfif NOT structKeyExists(variables, "SchemaName")>
				<cfReturn getExposedEntity().getSchemaName() />
			</cfif>
			<cfReturn variables.SchemaName />
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
					variables.CatalogName = getExposedEntity().getCatalogName();

				return variables.CatalogName;
			</cfScript>
		</cfFunction>
	<!--- end : Represented Objects Naming Conventions --->

	<!--- Entity Methods --->
		<cfFunction
			name		= "setEntityName"
			returnType	= "any"
			output		= "no"
			access		= "public"
			hint		= ""
			description	= ""
		>
			<cfArgument name="EntityName"	required="Yes"	type="string"		hint="" />
			<cfset variables.EntityName = arguments.EntityName />
			<cfReturn this />
		</cfFunction>

		<cfFunction
			name		= "getEntityName"
			returnType	= "string"
			output		= "no"
			access		= "public"
			hint		= ""
			description	= ""
		>
			<cfif not structKeyExists(variables, "EntityName") >
				<cfset variables.EntityName = "" />
			</cfif>
			<cfReturn variables.EntityName />
		</cfFunction>

		<cfFunction
			name		= "getNewEntity"
			returnType	= "WEB-INF.cfTags.component"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfReturn EntityNew( listLast(getEntityName(),'.') ) />
		</cfFunction>

		<cfFunction
			name		= "getEntity"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				if(!structKeyExists(variables, 'Entity'))
				{
					variables.Entity = getNewEntity();

					if(structKeyExists(variables, "Entity"))
						return variables.Entity;
				}

				return;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getExposedEntity"
			returnType	= "CFExpose.ExposeEntity"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfScript>
				if(!structKeyExists(variables, "ExposedOrm"))
					variables.ExposedOrm = Expose(getNewEntity(),'entity');

				return variables.ExposedOrm;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getEntityByRowId"
			returnType	= "WEB-INF.cfTags.component"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="rowId" required="yes" type="numeric" hint="" />
			<cfScript>
				local.returnEntity = EntityLoadByPk(getEntityName(), arguments.rowId);

				if(structKeyExists(local, "returnEntity"))
					return local.returnEntity;

				return getNewEntity();
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getEntityArray"
			returnType	= "array"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="filterCriteria"	required="no"	type="struct"	default="#structNew()#" hint="name/value pairs" />
			<cfArgument name="sortOrder"		required="no"	type="string"	default=""				hint="" />
			<cfArgument name="options"			required="no"	type="struct"	default="#structNew()#"	hint="ignorecase,offset,maxResults,cacheable,cachename,timeout" />
			<cfReturn EntityLoad(getEntityName(), arguments.filterCriteria, arguments.sortOrder, arguments.options) />
		</cfFunction>

		<cfFunction
			name		= "deleteRow"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="rowId" required="yes" type="string" hint="" />
			<cfScript>
				EntityDelete(getEntityByRowId(arguments.rowId));
				return arguments.rowId;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "deleteRows"
			returnType	= "numeric"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "-returns number of rows deleted"
		>
			<cfArgument name="rowIdList" required="yes" type="string" hint="" />
			<cfScript>
				local.array = listToArray(arguments.rowIdList);

				for(local.rowId in local.array)
					deleteRow(local.rowId);

				return arrayLen(local.array);
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
			<cfArgument name="columnNameList"	required="no"	type="string"							hint="only have certain columns returned" />
			<cfArgument name="options"			required="no"	type="struct"	default="#structNew()#"	hint="ignorecase,offset,maxResults,cacheable,cachename,timeout" />
			<cfArgument name="filterCriteria"	required="no"	type="struct"	default="#structNew()#" hint="name/value pairs" />
			<cfArgument name="sortOrder"		required="no"	type="string"	default=""				hint="" />
			<cfScript>
				local.entityArray = EntityLoad(getEntityName(), arguments.filterCriteria, arguments.sortOrder, arguments.options);

				if(!structKeyExists(arguments, 'columnNameList'))
					arguments.columnNameList = getExposedEntity().getColumnNameList();

				if(!arrayLen(local.entityArray))
					return queryNew(getExposedEntity().toQuery().columnList);

				local.ExposedEntity = Expose(local.entityArray,'entity');
				local.EntityParser = local.ExposedEntity.EntityParser();

				if(structKeyExists(arguments, "columnNameList"))
				{
					local.identityColumnName = local.ExposedEntity.getIdentityColumnName();

					if(!listFindNoCase(arguments.columnNameList, local.identityColumnName))
						arguments.columnNameList = listAppend(arguments.columnNameList, local.identityColumnName);

					local.EntityParser.setColumnNameList(arguments.columnNameList);
				}

				return local.EntityParser.getQuery();
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isEntityMode"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfReturn len(getEntityName()) />
		</cfFunction>
	<!--- end : Entity Methods --->

	<cfFunction
		name		= "getColumnArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "columnArray"))
				return variables.columnArray;

			getColumnMap();

			return variables.columnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getColumnMap"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "columnMap"))
				return variables.columnMap;

			local.propertyArray = getExposedEntity().getColumnPropertyArray();
			variables.columnArray = arrayNew(1);
			variables.columnMap = structNew();

			for(local.pIndex=arrayLen(local.propertyArray); local.pIndex GT 0; --local.pIndex)
			{
				local.propertyStruct = local.propertyArray[local.pIndex];
				local.columnStruct = structNew();

				local.columnStruct.name = local.propertyStruct.name;

				if(structKeyExists(local.propertyStruct, "column"))
					local.columnStruct.COLUMN_NAME = local.propertyStruct.column;
				else
					local.columnStruct.COLUMN_NAME = local.propertyStruct.name;

				local.columnStruct.ORDINAL_POSITION = (arrayLen(local.propertyArray) - local.pIndex) + 1;
				local.columnStruct.CHARACTER_MAXIMUM_LENGTH='';

				local.columnStruct.IsEditable = 1;

				if(structKeyExists(local.propertyStruct, "update") AND !local.propertyStruct.update)
					local.columnStruct.IsEditable = 0;

				if(structKeyExists(local.propertyStruct, "TYPE"))
					local.columnStruct.TYPE_NAME = local.propertyStruct.type;

				if(structKeyExists(local.propertyStruct, "length"))
					local.columnStruct.CHARACTER_MAXIMUM_LENGTH = local.propertyStruct.length;

				local.columnStruct.IS_IDENTITY = structKeyExists(local.propertyStruct, "FIELDTYPE") && local.propertyStruct.FIELDTYPE == 'id';

				local.columnStruct.IS_NULLABLE = true;
				if(structKeyExists(local.propertyStruct, "notnull"))
					local.columnStruct.IS_NULLABLE = !local.propertyStruct.notnull;

				//save
				arrayPrepend(variables.columnArray, local.columnStruct);
				variables.columnMap[local.columnStruct.column_name] = local.columnStruct;
			}

			return variables.columnMap;
		</cfScript>
	</cfFunction>

</cfComponent>
<!---
?may still need this method. Hate it?
		<cfFunction
			name		= "OrmTransaction"
			returnType	= "ExposeDatabase.OrmTransaction"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="options"			required="no"	type="struct"	hint="ignorecase,offset,maxResults,cacheable,cachename,timeout" />
			<cfScript>
				local.OrmTransaction = new ExposeDatabase.OrmTransaction();

				local.OrmTransaction.Setup().setBaseEntity(getEntityName());

				if(structKeyExists(arguments, "options"))
					local.OrmTransaction.Setup().setOptionsCollection(argumentCollection=arguments.options);

				return local.OrmTransaction;
			</cfScript>
		</cfFunction>
--->