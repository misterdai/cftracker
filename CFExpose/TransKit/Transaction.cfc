<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="Row"				type="Row" />
	<cfProperty name="ResultQuery"		type="query" />
	<cfProperty name="ConditionModel"	type="ConditionModel" />
	<cfProperty name="Datasource"		type="Datasource" />

	<cfFunction
		name		= "setDatasource"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Datasource" required="yes" type="CFExpose.ColumnKit.Datasource" hint="" />
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

			local.DataMetaReader = getRow().getDataMetaReader();

			local.Datasource = local.DataMetaReader.getDatasource();

			if(structKeyExists(local, "Datasource"))
			{
				variables.Datasource = local.Datasource;
				return variables.Datasource;
			}

			return;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Row" required="yes" type="CFExpose.ColumnKit.Row" hint="" />
		<cfset variables.Row = arguments.Row />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getRow"
		returnType	= "CFExpose.ColumnKit.Row"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "Row")>
			<cfThrow message="Row Not Yet Set" detail="Use the method 'setRow' in component '#getMetaData(this).name#'" />
		</cfif>
		<cfReturn variables.Row />
	</cfFunction>

	<cfFunction
		name		= "setResultQuery"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="ResultQuery" required="yes" type="query" hint="" />
		<cfset variables.ResultQuery = arguments.ResultQuery />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getResultQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "ResultQuery")>
			<cfset execute() />
			<!---
			<cfThrow message="ResultQuery Not Yet Set" detail="Use the method 'setResultQuery' in component '#getMetaData(this).name#'" />
			--->
		</cfif>
		<cfReturn variables.ResultQuery />
	</cfFunction>

	<cfFunction
		name		= "getRawQueryString"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn getResultQuery().getMetaData().getExtendedMetaData().sql />
	</cfFunction>

	<cfFunction
		name		= "setConditionModel"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="ConditionModel" required="yes" type="ConditionModel" hint="" />
		<cfset variables.ConditionModel = arguments.ConditionModel />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getConditionModel"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "ConditionModel")>
			<cfset variables.ConditionModel = createObject("component", "ConditionModel") />
		</cfif>
		<cfReturn variables.ConditionModel />
	</cfFunction>

</cfComponent>
<!---
	<cfFunction
		name		= "getEntityArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.returnArray = arrayNew(1);
			local.Row = getRow();
			local.cArray = local.Row.getArray();

			/* Primary From Entity */
				local.pEntityStruct = structNew();
				local.pEntityStruct.Entity = local.Row.getEntity();
				arrayAppend(local.returnArray,local.pEntityStruct);
			/* end */

			/* grap the join columns */
				for(local.x=2; local.x LTE arrayLen(local.cArray); ++local.x)
				{
					local.appendStruct = structNew();
					local.Col = local.cArray[local.x];
					local.Entity = local.Col.getEntity();
					local.targetHash = local.Entity.getTargetHash();

					/* prevent adding an already defined Row */
						if(local.returnArray[1].Entity.getTargetHash() EQ local.targetHash)
							continue;

						/* loop return array to see if we already have this reference */
							local.isEntityDefined = 0;
							for(local.rIndex=arrayLen(local.returnArray); local.rIndex GT 0; local.rIndex=local.rIndex)
							{
								if(local.targetHash EQ local.returnArray[local.rIndex].Entity.getTargetHash())
								{
									local.isEntityDefined = 1;
									break;
								}
							}

							if(local.isEntityDefined)
								continue;
						/* end */
					/* end */

					local.appendStruct.Entity = local.Entity;
					structAppend(local.appendStruct, local.Col.getJoinConditionStruct());

					arrayAppend(local.returnArray, local.appendStruct);
				}
			/* end */

			return local.returnArray;
		</cfScript>
	</cfFunction>
--->
