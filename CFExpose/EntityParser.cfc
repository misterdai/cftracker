<cfComponent
	Description	= "special way of defining entities & relations to execute as one query"
	Hint		= "ColdFusion 9+ ONLY! takes columnNameList that can contain relationship references, and returns each matching column name. For relationship references, returns only the value of the first matching relationship column"
	output		= "no"
	extends		= "ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="Entity" type="any" />
	<cfProperty name="columnArray" type="array" />
	<cfset variables.columnArray = arrayNew(1) />

	<cfFunction
		name		= "getEntity"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfif structKeyExists(variables, "Entity") >
			<cfReturn variables.Entity />
		</cfif>
		<cfThrow
			message	= "Entity not yet set"
			detail	= "Use method 'setEntity' in component '#getMetaData(this).name#'"
		/>
	</cfFunction>

	<cfFunction
		name		= "setEntity"
		returnType	= "EntityParser"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="Entity" required="yes" type="any" hint="" />
		<cfset variables.Entity = arguments.Entity />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			local.Entity = getEntity();

			/* just make an array if not so we don't have to write two different code methods */
				if(!isArray(local.Entity))
					local.Entity = [local.Entity];
			/* end */

			/* build column name list */
				local.columnNameList = "";

				if(!arrayLen(variables.columnArray) AND arrayLen(local.Entity))
				{
					local.columnNameList	= new ExposeEntity(local.Entity[1]).getColumnNameList();
					local.columnNameArray	= listToArray(local.columnNameList);
					local.columnCount		= arrayLen(local.columnNameArray);

					for(local.columnNameIndex=1; local.columnNameIndex LTE local.columnCount; ++local.columnNameIndex)
						variables.columnArray[local.columnNameIndex] = {columnName=local.columnNameArray[local.columnNameIndex], selectAs=local.columnNameArray[local.columnNameIndex]};
				}else
					for(local.columnIndex=arrayLen(variables.columnArray); local.columnIndex GT 0; --local.columnIndex)
						local.columnNameList = listAppend(local.columnNameList, variables.columnArray[local.columnIndex].selectAs);

			/* end */

			local.query = queryNew(local.columnNameList);

			/* loop rows */
				local.entityCount = arrayLen(local.Entity);
				for(local.currentRow=1; local.currentRow LTE local.entityCount; ++local.currentRow)
				{
					queryAddRow(local.query);
					local.CurrentEntity = local.Entity[local.currentRow];

					/* loop column name list */
						for(local.columnIndex=arrayLen(variables.columnArray); local.columnIndex GT 0; --local.columnIndex)
						{
							local.column = variables.columnArray[local.columnIndex];

							if(structKeyExists(local.column, "joinName"))
							{
								local.joinSyntax = '';
								local.joinArray = listToArray(local.column.joinName, '.');
								local.PreEntityJoin = local.CurrentEntity;

								for(local.jIndex=1; local.jIndex LTE arrayLen(local.joinArray); ++local.jIndex)
								{
									local.PreEntityJoin = evaluate('local.PreEntityJoin.get#local.joinArray[local.jIndex]#()');

									if(isNull(local.PreEntityJoin))
										continue;

									if(isArray(local.PreEntityJoin))
									{
										local.targetRow = 1;

										//TODO: this needs better defining, perhaps along with rowNumber[1] we could do [,] to specify a list delimiter
										if(structKeyExists(local.column, "rowNumber") AND local.column.rowNumber LTE arrayLen(local.PreEntityJoin))
											local.targetRow = local.column.rowNumber;

										local.PreEntityJoin = local.PreEntityJoin[local.targetRow];
									}
								}

								if(isNull(local.PreEntityJoin))
									continue;

								local.EntityJoin = local.PreEntityJoin;

								local.value = evaluate('local.EntityJoin.get#local.column.columnName#()');
							}else
								local.value = evaluate('local.CurrentEntity.get#local.column.columnName#()');

							if(!isNull(local.value))
								querySetCell(local.query, local.column.selectAs, local.value, local.currentRow);
						}
					/* end */
				}
			/* end */

			return local.query;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumn"
		returnType	= "EntityParser"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="columnName"	required="yes"	type="string"	hint="" />
		<cfArgument name="selectAs"		required="no"	type="string"	hint="" />
		<cfArgument name="joinName"		required="no"	type="string"	hint="" />
		<cfArgument name="rowNumber"	required="no"	type="numeric"	hint="" />
		<cfScript>
			if(!structKeyExists(arguments, "selectAs"))
				arguments.selectAs = arguments.columnName;

			arrayAppend(variables.columnArray, arguments);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnNameList"
		returnType	= "EntityParser"
		access		= "public"
		output		= "no"
		description	= "takes column list argument and parses into columnName,selectAs and joinName"
		hint		= ""
	>
		<cfArgument name="list" required="yes" type="string" hint="" />
		<cfScript>
			local.columnNameArray = listToArray(arguments.list);
			for(local.invokeIndex=arrayLen(local.columnNameArray); local.invokeIndex GT 0; --local.invokeIndex)
			{
				local.invokeCollection = structNew();
				local.columnString = local.columnNameArray[local.invokeIndex];

				if(local.columnString CONTAINS '=')
				{
					local.invokeCollection.selectAs = listFirst(local.columnString,'= ');
					local.columnDef = listLast(local.columnString,'= ');
				}else
				{
					local.invokeCollection.selectAs = listLast(local.columnString,' ');
					local.columnDef = listFirst(local.columnString,' ');
				}

				local.invokeCollection.columnName = listLast(local.columnDef,'.');

				/* row number */
					if(local.invokeCollection.columnName contains '[')
					{
						local.rowNumber = val(listLast(local.invokeCollection.columnName,'['));

						if(local.rowNumber)
							local.invokeCollection.rowNumber = local.rowNumber;

						local.invokeCollection.columnName = listFirst(local.invokeCollection.columnName,'[');
					}
				/* end: row number */

				if(listLen(local.columnDef,'.') GT 1)
					local.invokeCollection.joinName = trim(listDeleteAt(local.columnDef,listLen(local.columnDef,'.'),'.'));

				local.invokeCollection.columnName = trim(local.invokeCollection.columnName);
				local.invokeCollection.selectAs = trim(local.invokeCollection.selectAs);

				setColumn(argumentCollection=local.invokeCollection);
			}

			return this;
		</cfScript>

	</cfFunction>

</cfComponent>