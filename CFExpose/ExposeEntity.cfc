<cfComponent
	Hint		= "ColdFusion 9+ ONLY!"
	output		= "no"
	extends		= "ExposeComponent"
	accessors	= "yes"
>

	<cfProperty name="Var" type="any" />

	<cfFunction
		name		= "init"
		returnType	= "ExposeEntity"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="entity" required="no" type="any" hint="array, string or entityObject" />
		<cfScript>
			if(structKeyExists(arguments, "entity"))
				setVar(arguments.entity);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setVar"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Var" required="yes" type="any" hint="" />
		<cfScript>
			if(isSimpleValue(arguments.Var))
				arguments.Var = EntityNew(arguments.var);

			setEntity(arguments.Var);
			variables.setup.variable = getMetaData(arguments.Var);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getVar"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "Var") )
				return variables.Var;

			return super.getVar();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "ExposeColumnByName"
		returnType	= "ExposeEntityColumn"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			return new ExposeEntityColumn(ExposeEntity=this, name=arguments.name);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "ExposeFirstEntityAsComponent"
		returnType	= "ExposeComponent"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn createObject("component", "ExposeComponent").init(getFirstEntity()) />
	</cfFunction>

	<cfFunction
		name		= "setEntity"
		returnType	= "ExposeEntity"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "array, string or entityObject"
	>
		<cfArgument name="entity" required="no" type="any" hint="array, string or entityObject" />
		<cfset variables.Entity = arguments.entity />
		<cfReturn this />
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
			return variables.Entity;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "toQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= "takes columnNameList that can contain relationship references, and returns each matching column name. For relationship references, returns only the value of the first matching relationship column"
		hint		= ""
	>
		<cfArgument name="columnNameList"	required="no"	type="string"	hint="" />
		<cfScript>
			if(!structKeyExists(arguments, "columnNameList"))
				arguments.columnNameList = getColumnNameList();

			return EntityParser(arguments.columnNameList).getQuery();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "EntityParser"
		returnType	= "EntityParser"
		access		= "public"
		output		= "no"
		description	= "takes columnNameList that can contain relationship references, and returns each matching column name. For relationship references, returns only the value of the first matching relationship column"
		hint		= "a much more highly advanced way to cast an entity or entity array to query than the ColdFusion built-in EntityToQuery"
	>
		<cfArgument name="columnNameList"	required="no"	type="string"	hint="" />
		<cfset arguments.Entity = getEntity() />
		<cfReturn new EntityParser(argumentCollection=arguments) />
	</cfFunction>

	<cfFunction
		name		= "ExposeJoin"
		returnType	= "ExposeEntity"
		access		= "public"
		output		= "no"
		description	= "returns same type of object as THIS for a given entity join"
		hint		= ""
	>
		<cfArgument name="joinName" required="yes" type="variableName" hint="" />
		<cfScript>
			var local = structNew();

			local.property = ExposeFirstEntityAsComponent().getPropertyByName(arguments.joinName);
			local.Entity = new ExposeComponent(getFirstEntity()).getRelativeComponent(local.property.cfc);

			return new ExposeEntity(local.Entity);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getJoinEntityName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="joinName" required="yes" type="variableName" hint="" />
		<cfReturn ExposeJoin(arguments.joinName).getEntityName() />
	</cfFunction>

	<cfFunction
		name		= "getJoinTableName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="joinName" required="yes" type="variableName" hint="" />
		<cfReturn ExposeJoin(arguments.joinName).getTableName() />
	</cfFunction>

	<cfFunction
		name		= "getJoinColumnNameList"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="joinName" required="yes" type="variableName" hint="" />
		<cfScript>
			var local = structNew();
			local.property = getPropertyByName(arguments.joinName);
			local.Orm = getRelativeComponent(local.property.cfc);

			return new ExposeEntity(local.Orm).getColumnNameList();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getFirstEntity"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			var local = structNew();

			local.entity = getEntity();

			if(isArray(local.entity))
			{
				if(arrayLen(local.entity))
					return local.entity[1];
				else
					throw 'Entity Received is an empty array and requested data cannot be read';
			}else if(isSimpleValue(local.entity) AND len(local.entity))
				return EntityNew(local.entity);

			return local.entity;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getColumnPropertyArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.ptArray = getPropertyTagArray();
			local.returnArray = arrayNew(1);

			for(local.x=arrayLen(local.ptArray); local.x GT 0; --local.x)
			{
				local.property = local.ptArray[local.x];

				/* check for columns we don't want like join columns */
					if(structKeyExists(local.property, "cfc"))
						continue;
				/* end */

				arrayPrepend(local.returnArray, local.property);
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getJoinPropertyArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.ptArray = getPropertyTagArray();
			local.returnArray = arrayNew(1);

			for(local.x=arrayLen(local.ptArray); local.x GT 0; --local.x)
			{
				local.property = local.ptArray[local.x];

				if(structKeyExists(local.property, "cfc"))
					arrayPrepend(local.returnArray, local.property);
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getColumnNameList"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="isEditableOnlyMode" required="no" type="boolean" default="no" hint="returns only columns who can be inserted or updated" />
		<cfScript>
			if(!structKeyExists(variables, "columnNameList"))
			{
				local.columnNameList	= '';
				local.editableNameList	= '';

				local.propertyArray	= getColumnPropertyArray();
				local.propertyLen	= arrayLen(local.propertyArray);

				for(local.arrayLoop=1; local.arrayLoop LTE local.propertyLen; ++local.arrayLoop)
				{
					local.property = local.propertyArray[local.arrayLoop];

					local.columnNameList = listAppend(local.columnNameList, local.property.name);

					/* check if editable */
						if(!isColumnPropertyAllowUpdate(local.property))
							continue;

						local.editableNameList = listAppend(local.editableNameList, local.property.name);
					/* end */
				}

				variables.columnNameList = local.columnNameList;
				variables.editableNameList = local.editableNameList;
			}

			if(arguments.isEditableOnlyMode)
				return variables.editableNameList;
			else
				return variables.columnNameList;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getIdentityColumnName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			if(!structKeyExists(variables, "identityColumnName"))
			{
				local.propertyArray = getVar().properties;
				for(local.arrayLoop=arrayLen(local.propertyArray); local.arrayLoop GT 0; --local.arrayLoop)
				{
					local.property = local.propertyArray[local.arrayLoop];
					if
					(
						(
							structKeyExists(local.property, "generator")
						AND
							local.property.generator EQ 'identity'
						)
					OR
						(
							structKeyExists(local.property, "fieldType")
						AND
							local.property.fieldType EQ 'id'
						)
					)
					{
						variables.identityColumnName = local.property.name;
						break;
					}
				}
			}

			return variables.identityColumnName;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSchemaName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			local.metaData = getVar();

			if(structKeyExists(local.metaData, "schema"))
				return local.metaData.schema;

			return 'dbo';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getCatalogName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			local.metaData = getVar();

			if(structKeyExists(local.metaData, "catalog"))
				return local.metaData.catalog;

			return '';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getTableName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			local.metaData = getVar();

			if(structKeyExists(local.metaData, "table"))
				return local.metaData.table;

			return listLast(local.metaData.name, '.');
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setIdentityRowId"
		returnType	= "ExposeEntity"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="rowId" required="yes" type="numeric" hint="" />
		<cfScript>
			evaluate('getComponent().set#getIdentityColumnName()#(arguments.rowId)');
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getEntityName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			local.metaData = getVar();

			if(structKeyExists(local.metaData, "entity"))
				return local.metaData.entity;

			return listLast(local.metaData.name, '.');
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isAllowColumnUpdate"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="columnName" required="yes" type="string" hint="" />
		<cfScript>
			local.propertyArray		= getVar().properties;
			local.propertyLen	= arrayLen(local.propertyArray);

			for(local.arrayLoop=1; local.arrayLoop LTE local.propertyLen; ++local.arrayLoop)
			{
				local.property = local.propertyArray[local.arrayLoop];

				if(local.property.name EQ arguments.columnName)
					return isColumnPropertyAllowUpdate(local.property);
			}

			throw 'Column Name "#arguments.columnName#" not found';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isAllowColumnInsert"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="columnName" required="yes" type="string" hint="" />
		<cfScript>
			local.propertyArray		= getVar().properties;
			local.propertyLen	= arrayLen(local.propertyArray);

			for(local.arrayLoop=1; local.arrayLoop LTE local.propertyLen; ++local.arrayLoop)
			{
				local.property = local.propertyArray[local.arrayLoop];

				if(local.property.name EQ arguments.columnName)
					return isColumnPropertyAllowInsert(local.property);
			}

			throw 'Column Name "#arguments.columnName#" not found';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isColumnPropertyAllowUpdate"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="property" required="yes" type="struct" hint="" />
		<cfScript>
			return	(
						(
							!structKeyExists(arguments.property, "update")
						OR
							(
								isBoolean(arguments.property.update)
							AND
								arguments.property.update
							)
						)
					AND
						(
							!structKeyExists(arguments.property, "generator")
						OR
							arguments.property.generator NEQ "identity"
						)
					);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isColumnPropertyAllowInsert"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="property" required="yes" type="struct" hint="" />
		<cfScript>
			return	(
						(
							!structKeyExists(arguments.property, "insert")
						OR
							(
								isBoolean(arguments.property.insert)
							AND
								arguments.property.insert
							)
						)
					AND
						(
							!structKeyExists(arguments.property, "generator")
						OR
							arguments.property.generator NEQ "identity"
						)
					);
		</cfScript>
	</cfFunction>

</cfComponent>
