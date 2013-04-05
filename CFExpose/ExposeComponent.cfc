<cfComponent
	Hint		= ""
	output		= "no"
	extends		= "ExposeComponentMetaData"
	accessors	= "yes"
>

	<cfProperty name="Var" type="any" />
	<cfProperty name="Url" type="string" />

	<cfFunction
		name		= "init"
		returnType	= "ExposeComponent"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="Component" required="no" type="WEB-INF.cfTags.Component" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "Component"))
				setComponent(arguments.Component);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setComponent"
		returnType	= "ExposeComponent"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="Component" required="yes" type="WEB-INF.cfTags.Component" hint="" />
		<cfset variables.Component = arguments.Component />
		<cfset setVar(getMetaData(arguments.Component)) />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getComponent"
		returnType	= "WEB-INF.cfTags.Component"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn variables.Component />
	</cfFunction>

	<cfFunction
		name		= "getMethodMetaData"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "inspects component metadata and extendtions containing a given method name regardless of access"
	>
		<cfArgument name="methodName"			required="yes"	type="string"	hint="" />
		<cfArgument name="componentMetaData"	required="no"	type="struct"	hint="when this argument is supplied, the analyzations are done against this argument and not the component set with this ExposeComponent instance" />
		<cfScript>
			var local = structNew();

			if(structKeyExists(arguments , "componentMetaData"))
				return super.getMethodMetaData(argumentCollection=arguments);
			else
			{
				local.component = getVar();

				//?can we extract just by seeing if a public variable exists?
				if(structKeyExists(local.component , arguments.methodName))
					return getMetaData(local.component[arguments.methodName]);

				return super.getMethodMetaData(argumentCollection=arguments);
			}
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "returnTestVariable"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="name"				required="yes"	type="variableName" hint="" />
		<cfArgument name="scope"			required="yes"	type="struct" hint="" />
		<cfArgument name="setMethodName"	required="no"	type="variableName" hint="" />
		<cfScript>
			var local = structNew();

			if(structKeyExists(arguments.scope, arguments.name))
				return arguments.scope[arguments.name];

			local.var = getComponent();

			if
			(
				!structKeyExists(arguments, "setMethodName")
			AND
				structKeyExists(local.var, "set" & arguments.name)
			)
				arguments.setMethodName = "set" & ucase(left(arguments.name,1)) & removeChars(arguments.name,1,1);

			local.message="#CFMethods().Strings().variableNameToTitle(arguments.name)#, has not yet been set";

			if(structKeyExists(arguments, "setMethodName"))
				local.detail = "Use method '#arguments.setMethodName#'";
			else
				local.detail = "Error";

			local.detail &= " in component '#getMetaData(local.var).name#'";

			throw(message=local.message, detail=local.detail);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isMethodNameDefined"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="name"			required="no"	type="variableName"			hint="" />
		<cfArgument name="isPublicOnly" required="no"	type="boolean" default="0" hint="" />
		<cfScript>
			if(structKeyExists(getComponent() , arguments.name))
				return true;

			if(!arguments.isPublicOnly)
				return super.isMethodNameDefined(arguments.name);

			return false;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getConnectiveArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= "returns all component names that the component may depend on"
		hint		= ""
	>
		<cfArgument name="isRecursiveMode" required="no" type="boolean" default="10" hint="yes/no. is number is received then that is how many times it will recurse" />
		<cfScript>
			var local = structNew();

			local.returnArray	= arrayNew(1);
			local.keyList		= listSort(getNonExtendedMethodNameList() , "textnocase" , "asc");
			local.Component		= getComponent();
			local.nameChainList	= "";

			local.metaData		= getMetaData(local.Component);
			local.keyListCount	= listLen(local.keyList);
			local.namedPath		= listDeleteAt(local.metaData.name,listLen(local.metaData.name,'.'),'.');
			local.lastName		= listLast(local.metaData.name,'.');

			/* aid in preventing endless recursion */
				if(arguments.isRecursiveMode AND structKeyExists(arguments , "nameChainList"))
					local.nameChainList = arguments.nameChainList;
			/* end */

			for(local.x=1; local.x LTE local.keyListCount; ++local.x)
			{
				local.method = local.Component[listGetAt(local.keyList,local.x)];

				if(NOT isCustomFunction(local.method))continue;
				local.methodMetaData = getMetaData(local.method);

				if
				(
					isMethodReturnComponent(local.methodMetaData.name)
				AND
					local.methodMetaData.returnType NEQ local.lastName//avoid methods that just return themselves
				)
				{
					local.definition=
					{
						methodName	= local.methodMetaData.name,
						returnType	= local.methodMetaData.returnType
					};

					if(listLen(local.definition.returnType,'.') LT 2)
						local.definition.returnType = local.namedPath & '.' & local.definition.returnType;

					arrayAppend(local.returnArray , local.definition);

					if(arguments.isRecursiveMode)
					{
						local.nameChainList = listAppend(local.nameChainList , local.definition.returnType);//aid in preventing loop recursion

						if(isNumeric(arguments.isRecursiveMode))
							--arguments.isRecursiveMode;

						if
						(
							structKeyExists(arguments , "nameChainList")
						AND
							listFindNoCase(arguments.nameChainList , local.definition.returnType)
						)
						{
							local.returnArray[arrayLen(local.returnArray)].isEndlessRecursiveMaker=1;
							structDelete(local , "isEndlessRecursiveMaker" , true);
							continue;
						}

						try{
							local.subArray=
								createObject("component" , "ExposeComponent")
									.setVar(local.definition.returnType)
										.getConnectiveArray(isRecursiveMode=arguments.isRecursiveMode , nameChainList=local.nameChainList);

							if(arrayLen(local.subArray))
								local.returnArray[arrayLen(local.returnArray)].connectiveArray = local.subArray;
						}catch(any e)
						{
							local.returnArray[arrayLen(local.returnArray)].connectiveArray = arrayNew(1);
						}
					}
				}
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isMethodReturnComponent"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="method" required="yes" type="string" hint="" />
		<cfset var Component = getComponent() />
		<cfReturn CFMethods().isMethodReturnComponent(Component[arguments.method]) />
	</cfFunction>

	<cfFunction
		name		= "getSameTypeRelativeComponentMetadataArray"
		returnType	= "any"<!---array--->
		access		= "public"
		output		= "no"
		hint		= "returns array of component's metadata that are stored on the file system relative to the currently set component instance"
		description	= ""
	>
		<cfArgument name="isRecursiveMode"	required="yes"	type="boolean" default="yes" hint="" />
		<cfArgument name="namePrefix"		required="no"	type="string"		hint="only used by this method to create recursion when needed" />
		<cfArgument name="path"				required="no"	type="string"		hint="only used by this method to create recursion when needed" />
		<cfScript>
			var local = structNew();

			local.returnArray = arrayNew(1);
			local.metadata = getVar();

			if(structKeyExists(arguments, 'path'))
				local.path = arguments.path;
			else
				local.path = getDirectoryFromPath(local.metaData.path);

			local.ExposeDir = createObject("component", "ExposeDirectory").init(local.path);
			local.query = local.ExposeDir.getChildQuery(filter="*.cfc", recursive='no');

			if(structKeyExists(arguments, "namePrefix"))
				local.shortName = arguments.namePrefix;
			else
				local.shortName = listDeleteAt(local.metadata.name,listLen(local.metadata.name,'.'),'.');

			for(local.currentRow=1; local.currentRow LTE local.query.recordCount; local.currentRow=local.currentRow+1)
			{
				local.name = local.shortName & '.' & listDeleteAt(local.query.name[local.currentRow], listLen(local.query.name[local.currentRow],'.'), '.');
				local.Component = createObject("component", local.name);

				if(isInstanceOf(local.Component, local.metadata.name))
					arrayAppend(local.returnArray, getMetaData(local.Component));
			}

			/* sub folders */
				if(arguments.isRecursiveMode)
				{
					local.query = local.ExposeDir.getChildQuery(type='dir', recursive='no');
					for(local.currentRow=1; local.currentRow LTE local.query.recordCount; local.currentRow=local.currentRow+1)
					{
						if(NOT isValid("variableName" , local.query.name[local.currentRow]))
							continue;

						local.subPath = local.query.directory[local.currentRow] & '/' & local.query.name[local.currentRow];
						local.namePrefix = local.shortName & '.' & local.query.name[local.currentRow];

						local.childArray = getSameTypeRelativeComponentMetadataArray(isRecursiveMode=1, path=local.subPath, namePrefix=local.namePrefix);

						local.returnArray.addAll(local.childArray);
					}
				}
			/* end */

			return local.returnArray;
		</cfScript>
	</cfFunction>

</cfComponent>