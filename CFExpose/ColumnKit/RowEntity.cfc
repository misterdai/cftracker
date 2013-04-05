<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "Row"
	accessors	= "yes"
	Column		= "ColumnEntity"
>

	<cfProperty name="Entity"				type="Entity" />
	<cfProperty name="EntityName"			type="string" />
	<!--- parents --->
<!---
		<cfProperty name="NameArray"			type="array" />
		<cfProperty name="ElementArray"			type="array" />
		<cfProperty name="IdentityColumnName"	type="string" />
		<cfProperty name="IdentityColumnValue"	type="string" />
		<cfProperty name="DataMetaReader"		type="DataMetaReader" />
		<cfProperty name="JoinArray"			type="array" />
--->
	<!--- end: parents --->

	<cfScript>
		variables.rowMemory = structNew();
	</cfScript>

	<cfFunction
		name		= "setColumnByEntityProperty"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="tagName"			required="yes"	type="string"	hint="" />
		<cfArgument name="name"				required="no"	type="string"	hint="" />
		<cfArgument name="ColumnClassName"	required="no"	type="string"	hint="" />
		<cfArgument name="Row"				required="no"	type="Row"		hint="" />
		<cfArgument name="decoratorName"	required="no"	type="string"	hint="" />
		<cfArgument name="decoratorType"	required="no"	type="string"	hint="" />
		<cfScript>
			local.nameArray = listToArray(arguments.tagName, '.');
			local.lastName = local.nameArray[arrayLen(local.nameArray)];
			local.sendName = local.lastName;

			if(!structKeyExists(arguments, 'name'))
				arguments.name = local.nameArray[arrayLen(local.nameArray)];

			/* joins */
				if(arrayLen(local.nameArray) GT 1)
				{
					local.Entity = getEntity();
					local.LastExpEntity = getDataMetaReader().getExposedEntity();
					local.TopRow = this;
					local.LastRow = this;

					for(local.index=1; local.index LT arrayLen(local.nameArray); ++local.index)
					{
						local.name = local.nameArray[local.index];
						local.propStruct = local.LastExpEntity.getPropertyByName(local.name);

						local.Entity = local.LastExpEntity.getRelativeComponent(local.propStruct.cfc);
						local.ExpEntity = Expose(local.Entity,'entity');

						/* row config */
							if(!structKeyExists(variables.rowMemory, local.name))
							{
								variables.rowMemory[local.name] = getNewRow(Entity=local.Entity);
								arguments.Row = variables.rowMemory[local.name];
								local.JoinConditionModel = new CFExpose.TransKit.ConditionModel();

								if(structKeyExists(local.propStruct, "fkcolumn"))
									local.JoinColumn = arguments.Row.getByName(local.propStruct.fkcolumn);
								else if(structKeyExists(local.propStruct, "mappedby"))
								{
									local.jPropStruct = local.ExpEntity.getPropertyByName(local.propStruct.mappedby);

									if(structKeyExists(local.jPropStruct, "fkcolumn"))
										local.JoinColumn = arguments.Row.paramByName(name=local.jPropStruct.fkcolumn, datatype='string', isSummaryColumn=0);
								}

								/* join maybe by identity */
									if(!structKeyExists(local, 'JoinColumn'))
									{
										local.propName = local.ExpEntity.getIdentityColumnName();
										local.JoinColumn = arguments.Row.getByName(local.propName);
										local.colProp = local.ExpEntity.getPropertyByName(local.propName);
										arguments.Row.setColumnByPropertyAttributes(propStruct=local.colProp, isSummaryColumn=0);

										local.JoinColumn = arguments.Row.getByName(local.propName);
									}
								/* end: join by identity */

								if(structKeyExists(local.propStruct, "fkcolumn"))
								{
									if(structKeyExists(local.colProp, "type"))
										local.dataType = local.colProp.type;
									else if(structKeyExists(local.colProp, "ormtype"))
										local.dataType = local.colProp.ormtype;

									local.InnerColumn = local.LastRow.paramByName(name=local.propStruct.fkcolumn, datatype=local.dataType, isSummaryColumn=0, IsReadOnly=1);
								}else
									local.InnerColumn = local.LastRow.getIdentityColumn();

								local.JoinConditionModel.setColumnCondition(local.InnerColumn, local.JoinColumn);
								local.TopRow.setJoin(arguments.Row, local.JoinConditionModel, 'LEFT');
							}else
								arguments.Row = variables.rowMemory[local.name];

							local.LastRow = arguments.Row;
							local.LastExpEntity = local.ExpEntity;
						/* end */

						//the column being set is the join column
						if(structKeyExists(local, "JoinColumn") AND local.JoinColumn.getName() EQ local.lastName)
							return setColumn(local.JoinColumn);

						structDelete(local, "JoinColumn");
					}
				}else
					local.ExpEntity = getDataMetaReader().getExposedEntity();
			/* end : joins */

			arguments.propStruct = local.ExpEntity.getPropertyByName(local.lastName);

			setColumnByPropertyAttributes(argumentCollection=arguments);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setEntity"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Entity" required="yes" type="any" hint="" />
		<cfScript>
			variables.Entity = arguments.Entity;
			return this;
		</cfScript>
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
			if(structKeyExists(variables, "Entity"))
				return variables.Entity;

			local.entityName = listLast(getEntityName(),'.');

			if(len(local.entityName))
			{
				variables.Entity = entityNew(local.entityName);
				return variables.Entity;
			}
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setEntityName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="EntityName" required="yes" type="string" hint="" />
		<cfScript>
			variables.EntityName = arguments.EntityName;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getEntityName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "entityName"))
				return variables.entityName;

			if(structKeyExists(variables, "Entity"))
				return getMetaData(variables.Entity).name;

			local.entityAttr = Expose(this).getAttribute("Entity");
			if( len(local.entityAttr) )
				return local.entityAttr;

			return '';
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
			if(structKeyExists(variables, 'IdentityColumnName'))
				return variables.IdentityColumnName;

			/* see if the super can dig it up */
				variables.IdentityColumnName = super.getIdentityColumnName();

				if(len(variables.IdentityColumnName))
					return variables.IdentityColumnName;
			/* end */

			/* lookup by entity */
				local.DataMetaReader = getDataMetaReader();
				local.ExEntity = local.DataMetaReader.getExposedEntity();
				variables.IdentityColumnName = local.ExEntity.getIdentityColumnName();

				local.Column = getByName(variables.IdentityColumnName);
				if(structKeyExists(local, "Column"))
				{
					setIdentityColumnName(variables.IdentityColumnName);
					return variables.IdentityColumnName;
				}

				setColumnByEntityProperty(variables.IdentityColumnName);
				//setColumnByAttributes(name=variables.IdentityColumnName, isIdentity=1);

				return variables.IdentityColumnName;
			/* end */

			return '';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDataMetaReader"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "DataMetaReader") )
				return variables.DataMetaReader;

			/* get by entity attribute */
				local.entityName = getEntityName();

				if(len(local.entityName))
				{
					variables.DataMetaReader = new('DataMetaEntityReader').setEntityName(local.entityName).setRow(this);

					return variables.DataMetaReader;
				}else
					throw 'hit';
			/* end */
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getNewRow"
		returnType	= "RowEntity"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return new('RowEntity',arguments);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "paramByName"
		returnType	= "Column"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			local.Column = super.getByName(arguments.name);

			if(!structKeyExists(local, 'Column'))
			{
				setColumnByAttributes(argumentCollection=arguments);
				local.Column = getByName(arguments.name);
				local.Column.setRow(this);
			}

			return local.Column;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnByPropertyAttributes"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="propStruct"		required="yes"	type="struct" hint="" />
		<cfArgument name="ColumnClassName"	required="no"	type="string" hint="" />
		<cfArgument name="name"				required="no"	type="string" hint="" />
		<cfArgument name="Row"				required="no"	type="Row" hint="" />
		<cfArgument name="isSummaryColumn"	required="no"	type="boolean" hint="" />
		<cfArgument name="decoratorName"	required="no"	type="string"	hint="" />
		<cfArgument name="decoratorType"	required="no"	type="string"	hint="" />
		<cfScript>
			local.isIdentity=
			(
				(structKeyExists(arguments.propStruct, "fieldType") AND arguments.propStruct.fieldType EQ 'id')
			OR	(structKeyExists(arguments.propStruct, "generator") AND arguments.propStruct.generator EQ 'identity')
			);

			if(!structKeyExists(arguments.propStruct, "NOTNULL"))
				local.isAllowNullValue = 1;
			else
				local.isAllowNullValue = !yesNoFormat(arguments.propStruct.NOTNULL);

			local.propStruct = duplicate(arguments.propStruct);
			structDelete(arguments, "propStruct");
			CFMethods().structDeleteNulls(arguments);
			structAppend(local.propStruct, arguments);

			local.propStruct.isIdentity = local.isIdentity;
			local.propStruct.isAllowNullValue = local.isAllowNullValue;

			if(structKeyExists(local.propStruct, "column"))
				local.propStruct.columnName = local.propStruct.column;

			if(structKeyExists(local.propStruct, "length"))
				local.propStruct.maxlength = local.propStruct.length;

			setColumnByAttributes(argumentCollection=local.propStruct);

			return this;
		</cfScript>
	</cfFunction>

</cfComponent>
<!---
	<cfFunction
		name		= "getArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(arrayLen(variables.elementArray))
				return variables.elementArray;

			/* auto load */
				local.Er = getDataMetaReader();
				local.colPropArray = local.Er.getExposedEntity().getColumnPropertyArray();

				for(local.colIndex=arrayLen(local.colPropArray); local.colIndex GT 0; --local.colIndex)
				{
					local.colProp = local.colPropArray[local.colIndex];

					setColumnByPropertyAttributes(local.colProp);
				}

				return variables.elementArray;
			/* end: auto load */
		</cfScript>
	</cfFunction>
--->
