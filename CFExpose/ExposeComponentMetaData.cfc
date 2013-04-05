<cfComponent
	Hint		= ""
	output		= "no"
	extends		= "ExposeVariable"
	accessors	= "yes"
>

	<cfProperty name="Url" type="string" />
	<cfset setVarValidateByTypeName('struct') />

	<cfFunction
		name		= "setCfcMetaData"
		returnType	= "ExposeComponentMetaData"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="metaData" required="yes" type="struct" hint="" />
		<cfReturn setVar(arguments.metaData) />
	</cfFunction>

	<cfFunction
		name		= "getCfcMetaData"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn getVar() />
	</cfFunction>

	<cfFunction
		name		= "getAttribute"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name"				required="yes"	type="string"					hint="" />
		<cfArgument name="default"			required="no"	type="string"	default=""		hint="" />
		<cfArgument name="isCheckParents"	required="no"	type="boolean"	default="yes"	hint="" />
		<cfScript>
			local.metaData = getCfcMetaData();

			if(structKeyExists(local.metaData, arguments.name))
				return local.metaData[arguments.name];

			if(arguments.isCheckParents AND structKeyExists(local.metaData, "extends"))
				return createObject("component", "ExposeComponentMetaData").setVar(local.metaData.extends).getAttribute(argumentCollection=arguments);

			return arguments.default;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "getUniqueVariableName"
		returnType	= "variableName"
		Access		= "public"
		Output		= "no"
		Hint		= "pretty damn unique variableName generator but not as long a string as UUID gaurenteed unique"
	>
		<cfArgument name="type" required="no" type="variableName" hint="" />
		<cfScript>
			if(not structKeyExists(arguments, "type"))
				arguments.type = listLast(getVar().name, './\');

			Return "_" & arguments.type & "_" & getTickCount() & timeFormat(now(),'ssL');
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPropertyTagArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="isIncludeParents" required="no" type="boolean" default="1" hint="" />
		<cfArgument name="metaData" required="no" type="struct" hint="typicall only passed during recursion" />
		<cfScript>
			if(!structKeyExists(arguments, 'metaData'))
				arguments.metaData = getVar();

			local.returnArray = arrayNew(1);

			if(structKeyExists(arguments.metaData, "properties"))
			{
				for(local.x=arrayLen(arguments.metaData.properties); local.x GT 0; --local.x)
				{
					local.struct = duplicate(arguments.metaData.properties[local.x]);
					local.struct.CfcOwnerName = arguments.metaData.name;
					arrayPrepend(local.returnArray, local.struct);
				}

				if(structKeyExists(arguments.metaData, "extends") AND arguments.isIncludeParents)
					local.returnArray = CFMethods().arrayAppendArray(local.returnArray, getPropertyTagArray(1,arguments.metaData.extends));
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isPropertyDefined"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			var local = structNew();

			local.metaData = getVar();

			if( structKeyExists(local.metaData , "properties") )
				for(local.arrayIndex=arrayLen(local.metaData.properties); local.arrayIndex GT 0; --local.arrayIndex)
					if( local.metaData.properties[local.arrayIndex].name eq arguments.name )
						return true;

			return false;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPropertyByName"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			var local = structNew();
			local.metaData = getCfcMetaData();

			if( structKeyExists(local.metaData , "properties") )
				for(local.arrayIndex=arrayLen(local.metaData.properties); local.arrayIndex GT 0; --local.arrayIndex)
					if( local.metaData.properties[local.arrayIndex].name eq arguments.name )
						return local.metaData.properties[local.arrayIndex];
		</cfScript>
		<cfThrow
			message	= "property '#arguments.name#' is not defined in component '#local.metaData.name#'"
			detail	= ""
		/>
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
		<cfScript>
			var local = structNew();
			local.metaData	= getVar();

			if(!structKeyExists(local.metaData , "functions"))
				return false;//no function defined

			local.functions	= local.metaData.functions;

			for(local.functionCounter=arrayLen(local.functions); local.functionCounter GT 0; --local.functionCounter)
			{
				if(local.functions[local.functionCounter].name eq arguments.name)
					return true;

				/* cause recursion */
					while(local.functionCounter EQ 1 AND structKeyExists(local.metaData , "extends"))
					{
						local.metadata = local.metaData.extends;

						if(!structKeyExists(local.metadata , "functions"))//?are their even functions in this method?
						{
							if(structKeyExists(local.metaData , "extends"))
								continue;
							else
								break;
						}

						local.functions			= local.metadata.functions;
						local.functionCounter	= arrayLen(local.functions);
					}
			}

			return false;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getExtendDependentsArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= "all components, this component depends on"
		hint		= ""
	>
		<cfScript>
			var local = structNew();

			local.returnArray = arrayNew(1);
			local.metaData	= getVar();

			while( structKeyExists(local.metaData , "extends") )
			{
				local.metaData = local.metaData.extends;
				local.metaStruct = {name=local.metaData.name , path=local.metaData.path};
				arrayAppend(local.returnArray , local.metaStruct);
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getLastName"
		returnType	= "variableName"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "returns the last variableName in a components name string"
	>
		<cfReturn listLast(getVar().name,'.') />
	</cfFunction>

	<cfFunction
		name		= "getPath"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn getVar().path />
	</cfFunction>

	<cfFunction
		name		= "getContainerFolderName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn listLast(getDirectoryFromPath(getPath()) , '/\') />
	</cfFunction>

	<cfFunction
		name		= "getMethodUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "not gaurenteed accurate BUT in a lot of cases, a url's name can be converted into it's url"
		description = "returns an educated guess at the url path to component. Method argument adds a url parameter of method=metod-name"
	>
		<cfArgument name="method"		required="yes"	type="variableName"	hint="" />
		<cfReturn getUrl(method) />
	</cfFunction>

	<cfFunction
		name		= "getUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "not gaurenteed accurate BUT in a lot of cases, a url's name can be converted into it's url"
		description = "returns an educated guess at the url path to component. Method argument adds a url parameter of method=metod-name"
	>
		<cfArgument name="method"		required="no"	type="variableName"	hint="" />
		<cfScript>
			var local = structNew();

			local.name = getVar().name;
			local.path = replace(local.name,".","/","all") & ".cfc";

			if(structKeyExists(arguments , "method"))
				local.path = local.path & "?method=#arguments.method#";

			Return local.path;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getFileContents"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= "returns cfc file contents"
		hint		= ""
	>
		<cfReturn fileRead(getPath()) />
	</cfFunction>

	<cfFunction
		name		= "getComponentExtensionMetaDataByLastName"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="lastName" required="yes" type="variableName" hint="" />
		<cfScript>
			var local = structNew();

			local.obj = getVar();
			local.lastNameLen=len(arguments.lastName);

			while(structKeyExists(local.obj , "extends") OR listLast(local.obj.name,'.') EQ arguments.lastName)
				if(listLast(local.obj.name,'.') EQ arguments.lastName)
					Return local.obj;
				else
					local.obj = local.obj.extends;
		</cfScript>
		<cfThrow
			message	= "Could not find component extension by last name"
			detail	= "Last name: #arguments.lastName#"
		/>
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
				local.metaData = arguments.componentMetaData;
			else
				local.metaData = getVar();

			local.debugMetaData = duplicate(local.metaData);//before we go recursive, let's remember the top

			/* loop through extensions */
				while(1 == 1)
				{
					if(structKeyExists(local.metaData , "functions"))
					{
						local.functionArray = local.metaData.functions;
						local.fCount = arrayLen(local.functionArray);

						for(local.methodLoop=1; local.methodLoop LTE local.fCount; ++local.methodLoop)
						{
							if(local.functionArray[local.methodLoop].name EQ arguments.methodName)
								return local.functionArray[local.methodLoop];
						}
					}

					if(structKeyExists(local.metaData , "extends"))
						local.metadata = local.metadata.extends;
					else
						break;
				}
			/* end */
		</cfScript>
		<cfThrow
			message	= "The method '#arguments.methodName#' could not be found in the component '#local.debugMetaData.name#'"
			detail	= "This operation was at the request of the component '#getMetaData(getVar()).name#'"
		/>
	</cfFunction>

	<cfFunction
		name		= "getSuperMethodMetaData"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "inspects component metadata for extendtions containing a given method name"
	>
		<cfArgument name="methodName" required="yes" type="variableName" hint="" />
		<cfReturn getMethodMetaData(methodName=arguments.methodName , componentMetaData=getVar().extends) />
	</cfFunction>

	<cfFunction
		name		= "getRelativeComponentByMetaData"
		returnType	= "Component"
		access		= "private"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="name"					required="yes"	type="variableName"					hint="" />
		<cfArgument name="metaData"				required="yes"	type="struct"						hint="" />
		<cfArgument name="isSearchExtensions"	required="no"	type="boolean"		default="yes"	hint="" />
		<cfScript>
			var local = structNew();

			local.metaData = arguments.metaData;
			local.failMessage = "";
			local.pathName = replace(arguments.name,'.','/','all');

			while( structKeyExists(local.metaData,"extends") )
			{
				local.name			= local.metaData.name;
				local.directory		= getDirectoryFromPath(local.metaData.path);
				local.filePath		= local.directory & local.pathName &'.cfc';
				local.componentCall	= local.name & '.' & arguments.name;

				if( fileExists(local.filePath) )
				{
					local.prefix = listDeleteAt(local.name , listLen(local.name,'./\') , './\' );

					local.componentCall = arguments.name;
					if(len(local.prefix))
    					local.componentCall	= local.prefix & '.' & arguments.name;

					return createObject("component" , local.componentCall);
				}

				if(arguments.isSearchExtensions AND structKeyExists(arguments.metaData,"extends"))
					local.metaData = local.metaData.extends;

				local.failMessage = local.failMessage & "<li>&raquo;&nbsp;<b>#local.name#</b> - #local.filePath# -- #local.directory# :: #local.pathName#</li>";
			}

			return createObject("component" , arguments.name);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRelativeComponentByName"
		returnType	= "Component"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="name"					required="yes"	type="variableName"					hint="" />
		<cfArgument name="isSearchExtensions"	required="no"	type="boolean"		default="yes"	hint="" />
		<cfReturn getRelativeComponentByMetaData(arguments.name, getVar(), arguments.isSearchExtensions) />
	</cfFunction>

	<cfFunction
		name		= "isRemoteMethod"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="method"		required="yes"	type="variableName"	hint="" />
		<cfScript>
			var local = structNew();

			local.metaData = getMethodMetaData(arguments.method);

			return structKeyExists(local.metaData,"access") AND local.metaData.access EQ "remote";
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getNonExtendedMethodNameList"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "Function name list of methods only found with-in set component"
	>
		<cfArgument name="delimiters"	required="no"	type="string" default="," hint="" />
		<cfScript>
			var local = structNew();

			local.metaData = getVar();

			if(structKeyExists(local.metaData , "functions" ))
			{
			    local.arrayOfMethodNames = CFMethods().Conversions().arrayStructKeyValuesToArray(local.metaData.functions, "name");
				return arrayToList(local.arrayOfMethodNames, arguments.delimiters);
			}

			return "";
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "alignComponentCallToComponent"
		returnType	= "variableName"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "helps make ease the calling of components one or more directories deep from the invoking component with fullname dot notation"
	>
		<cfArgument name="name"	required="yes"	type="variableName"	hint="" />
		<cfset local.name = getVar().name />
		<cfReturn CFMethods().listDeleteLast(local.name, '.') & "." & arguments.name />
	</cfFunction>

	<cfFunction
		name		= "isComponentNameRelativeToComponent"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "indicates is a component call is relative to the component set in this instance"
	>
		<cfArgument name="name"					required="yes"	type="variableName"					hint="" />
		<cfArgument name="isSearchExtensions"	required="no"	type="boolean"		default="yes"	hint="if it's relative to an extended component, then we can return true" />
		<cfScript>
			var local = structNew();

			local.metadata = getVar();

			arguments.name = replace(arguments.name , '.' , '/' ,'all') & '.cfc';

			while(0==0)
			{
				local.path = getDirectoryFromPath(local.Metadata.path);

				if( fileExists(local.path & arguments.name) )
					return true;

				if(!arguments.isSearchExtensions OR !structKeyExists(local.metaData , "extends"))
					break;

				local.metaData = local.metaData.extends;
			}

			return false;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRelativeComponentFullName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "if relative component found, then returns full name ELSE just returns the argument 'name'"
	>
		<cfArgument name="name"					required="yes"	type="variableName"					hint="" />
		<cfArgument name="isSearchExtensions"	required="no"	type="boolean"		default="yes"	hint="if it's relative to an extended component, then we can return true" />
		<cfScript>
			var local = structNew();

			local.metadata	= getVar();
			local.name		= replace(arguments.name , '.' , '/' ,'all') & '.cfc';

			while(0==0)
			{

				local.path = getDirectoryFromPath(local.Metadata.path);

				if( fileExists(local.path & local.name) )
				{
					local.callPath = listDeleteAt(local.Metadata.name, listLen(local.Metadata.name,'.'),'.');

					if(len(local.callPath))
						local.callPath &= '.';

					return local.callPath & listLast(arguments.name);
				}

				if(!arguments.isSearchExtensions OR !structKeyExists(local.metaData , "extends"))
					break;

				local.metaData = local.metaData.extends;
			}

			return arguments.name;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRelativeComponent"
		returnType	= "WEB-INF.cfTags.Component"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "retreives component either by full name or by name relative to set component"
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfReturn createObject("component" , getRelativeComponentFullName(arguments.name)) />
	</cfFunction>

</cfComponent>
