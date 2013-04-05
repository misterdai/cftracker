<cfComponent
	Hint		= "Just a helpful component extension. Useless by itself but powerful to components doing javascript client output"
	Output		= "no"
	Extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="baseHref"				type="string" />
	<cfProperty name="queryString"			type="string" />
	<cfProperty name="relativeScriptUrl"	type="string" />
	<cfProperty name="fileName"				type="string" />
	<cfProperty name="varStruct"			type="struct" />
	<cfScript>
		variables.varStruct = structNew();
	</cfScript>

	<cfFunction
		name		= "init"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="url" required="no" type="string" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "url"))
				setRelativePath(arguments.url);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getVarStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return variables.varStruct;
		</cfScript>
	</cfFunction>

	<!--- methods with no sets --->
		<cfFunction
			name		= "injectCurrentRequestVariables"
			returnType	= "UrlAddress"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				var local = {};

				for(local.key in url)set(local.key, url[local.key]);

				for(local.key in form)
					if(local.key NEQ 'FIELDNAMES')
						set(local.key, form[local.key]);

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getString"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfScript>
				return getFolderUrlPath() & getFileName() & getQueryString();
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getFolderUrlPath"
			returnType	= "string"
			output		= "no"
			access		= "public"
			hint		= "simply combines the results of all the set url variables without filename and variables"
			description	= ""
		>
			<cfReturn getBaseHref() & getRelativePath() />
		</cfFunction>
	<!--- end : methods with no sets --->

	<cfFunction
		name		= "pullFileNameFromString"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="url" required="yes" type="string" hint="" />
		<cfScript>
			arguments.url = pullQueryStringFromString(arguments.url);

			local.pathLen = listLen(arguments.url,'/\');
			local.isEndTargetPathFile = 0;

			if(local.pathLen)
			{
				/* detect if file name defined */
					local.endTargetPath = listGetAt(arguments.url, local.pathLen, '/\');
					local.isEndTargetPathFile = reFindNoCase("^[^.]+\..+", local.endTargetPath, 1, false);
				/* end */
			}

			//react to file name defined
			if(local.isEndTargetPathFile)
			{
				setFileName(local.endTargetPath);
				/* remove file name from return string */
					local.trimLen = len(arguments.url)-len(local.endTargetPath);

					if(local.trimLen)
						arguments.url = left(arguments.url, local.trimLen);
					else
						arguments.url = '';
				/* end */
			}

			return arguments.url;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "setBaseHref"
		returnType	= "UrlAddress"
		Access		= "public"
		Output		= "no"
		Hint		= "anything related to this components url will be prefixed with a base href string"
	>
		<cfArgument name="url" required="yes" type="string" hint="" />
		<cfScript>
			if(len(arguments.url))
			{
				arguments.url = pullFileNameFromString(arguments.url);

				if(right(arguments.url,1) NEQ '/')
					arguments.url &= '/';
			}

			variables.baseHref = arguments.url;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "getBaseHref"
		returnType	= "string"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfif not structKeyExists(variables, "baseHref") >
			<cfset variables.baseHref = "" />
		</cfif>
		<cfReturn variables.baseHref />
	</cfFunction>

	<cfFunction
		name		= "getRelativePath"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			if( !structKeyExists(variables , "relativeScriptUrl") )
				variables.relativeScriptUrl = "";

			return variables.relativeScriptUrl;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setRelativePath"
		returnType	= "UrlAddress"
		output		= "no"
		access		= "public"
		description	= "all scripts required, will be loaded with the base url set here"
		hint		= "also does a string comparison to set basehref to avoid double setting"
	>
		<cfArgument name="relativeScriptUrl"	required="true"	type="string"		hint="" />
		<cfScript>
			arguments.relativeScriptUrl = pullFileNameFromString(arguments.relativeScriptUrl);

			/* basehref comparisons */
				if(len(arguments.relativeScriptUrl))
				{
					local.baseHref = getBaseHref();
					local.baseHrefLen = len(local.baseHref);

					//? is the left side of the argument relativeScriptUrl the same as basehref ?
					//? if so, remove it from the relative url
					if(local.baseHrefLen AND local.baseHref EQ left(arguments.relativeScriptUrl,len(local.baseHrefLen)))
						arguments.relativeScriptUrl = right(arguments.relativeScriptUrl, len(arguments.relativeScriptUrl)-len(local.baseHrefLen));

					//? ensure address ends with a forward slash
					if(right(arguments.relativeScriptUrl,1) NEQ '/')
						arguments.relativeScriptUrl = arguments.relativeScriptUrl & '/';

					//?if we already know we have basehref, ensure the relative path is not root bound to prevent double slashes
					if(local.baseHrefLen AND left(arguments.relativeScriptUrl,1) EQ '/' )
						arguments.relativeScriptUrl = right(arguments.relativeScriptUrl,len(arguments.relativeScriptUrl)-1);
				}
			/* end */

			variables.relativeScriptUrl = arguments.relativeScriptUrl;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "appendRelativeFolderPath"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		description	= "expects a folderPath argument with no file name or url vars and adds that onto the url address of this instance"
		hint		= ""
	>
		<cfArgument name="folderPath" required="yes" type="string" hint="" />
		<cfScript>
			local.relativePath = getRelativePath();

			if(len(local.relativePath) and len(arguments.folderPath) and right(local.relativePath,1) neq '/')
				local.relativePath &= '/';

			local.relativePath = getRelativePath() & arguments.folderPath;

			return setRelativePath(local.relativePath);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setFileName"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="FileName" required="yes" type="string" hint="" />
		<cfScript>
			variables.FileName = arguments.FileName;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getFileName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfif NOT structKeyExists(variables, "FileName")>
			<cfset variables.FileName = '' />
		</cfif>
		<cfReturn variables.FileName />
	</cfFunction>

	<cfFunction
		name		= "getQueryString"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			local.returnString = '';
			local.varStruct = getVarStruct();
			for(local.keyName in local.varStruct)
			{
				local.value = local.varStruct[local.keyName];
				local.value = urlEncodedFormat(local.value);

				local.returnString &= '&' & local.keyName & '=' & local.value;
			}

			if( len(local.returnString) )
			{
				local.returnString = right(local.returnString,len(local.returnString)-1);//remove starting &
				local.returnString = '?' & local.returnString;
			}

			return local.returnString;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "appendQueryString"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="queryString" required="yes" type="string" hint="" />
		<cfScript>
			local.rowArray = listToArray(arguments.queryString, '&');

			for(local.rowIndex=arrayLen(local.rowArray); local.rowIndex > 0; --local.rowIndex)
			{
				local.row = local.rowArray[local.rowIndex];
				local.name = listFirst(local.row,'=');
				if(listLen(local.row,'=') GT 1)
					local.value = listLast(local.row,'=');
				else
					local.value = 1;

				set(local.name, urlDecode(local.value));
			}

			return this;
		</cfScript>
	</cfFunction>

	<!--- Query String Methods --->
		<cfFunction
			name		= "delete"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="name" required="yes" type="string" hint="" />
			<cfScript>
				structDelete(getVarStruct(), arguments.name);
				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "set"
			returnType	= "UrlAddress"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "ensures the variable being set does not exist"
		>
			<cfArgument name="name"		required="yes"	type="string"				hint="" />
			<cfArgument name="value"	required="no"	type="string"	default="1"	hint="" />
			<cfScript>
				local.varStruct = getVarStruct();
				local.varStruct[arguments.name] = arguments.value;
				return this;
			</cfScript>
		</cfFunction>
		<cfset this.setVar = set />

		<cfFunction
			name		= "pullQueryStringFromString"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="string" required="yes" type="string" hint="" />
			<cfScript>
				//?url variables
				if(find('?',arguments.string))
				{
					local.queryString = reReplaceNoCase(arguments.string, '^[^?]+\?', '');
					appendQueryString(local.queryString);
					arguments.string = listFirst(arguments.string,'?');
				}

				return arguments.string;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setVarStruct"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= "a structs simple value nodes will be made into url arguments"
			description	= "turns collection into url vars"
		>
			<cfArgument name="struct" required="yes" type="struct" hint="" />
			<cfScript>
				for(local.x in arguments.struct)
					if(isSimpleValue(arguments.struct[local.x]))
						set(local.x, arguments.struct[local.x]);

				return this;
			</cfScript>
		</cfFunction>
	<!--- end : query string methods --->

	<cfFunction
		name		= "get"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			if(structKeyExists(variables.varStruct, arguments.name))
				return variables.varStruct[arguments.name];
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isVarDefined"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			return structKeyExists(variables.varStruct, arguments.name);
		</cfScript>
	</cfFunction>

</cfComponent>