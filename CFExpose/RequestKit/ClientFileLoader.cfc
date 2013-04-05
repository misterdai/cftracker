<cfComponent
	Hint		= "Supplies output of script loading mechanics in a cross browser compatible manner with asynchronous calls that allow for success/fail callbacks"
	Description	= "This Component enables the setting of client side based scripts` for loading and more importantly, the callbacks that are associated with success/fail loading of the defined scripts"
	Output		= "no"
	Extends		= "CFExpose.RequestKit.CFExposeClientSideClass"
	accessors	= "yes"
>

	<cfProperty name="jsUrl"									type="string" />
	<cfProperty name="cssUrl"									type="string" />
	<cfProperty name="ClientFileLoaderJavascriptCoreFileUrl"	type="string" />
	<cfProperty name="UrlAddress"								type="UrlAddress" />
	<cfProperty name="RequestStruct"							type="struct" />

	<cfScript>
		/*
			Shared scope assurance that two scripts are not loaded twice.
			Also assure ClientFileLoader js object is not loaded twice.
		*/
			if( !structKeyExists(request, "ClientFileLoader") )
			{
				request.ClientFileLoader=
				{
					 isLoaded					= 0
					,uniqueOncompleteNameList	= ""
					,toOutputArray				= arrayNew(1)
					,styleOutputArray			= arrayNew(1)
					,loadedArray				= arrayNew(1)
					,onLoadMethods				= arrayNew(1)
					,isDebug					= 0
					,isAjaxRequestMode			= 0
					,JavascriptCoreFileUrl		= ''
					,pauseLoadCompleteCount		= 0
					,isAnythingOutput			= 0
				};

			}
		/* end */

		variables.jsURL	= "";
		variables.cssURL= "";
	</cfScript>

	<cfFunction
		name		= "isOutputNeeded"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.requestStruct = getRequestStruct();
			return arrayLen(local.requestStruct.toOutputArray) OR arrayLen(local.requestStruct.onLoadMethods);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "resetLoading"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			request.ClientFileLoader.toOutputArray			= [];
			request.ClientFileLoader.styleOutputArray		= [];
			request.ClientFileLoader.pauseLoadCompleteCount	= 0;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPauseLoadCompleteMethodName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			request.ClientFileLoader.pauseLoadCompleteCount = request.ClientFileLoader.pauseLoadCompleteCount + 1;
			return 'ClientFileLoader.removeLoadCompletePause';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRequestStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return request.ClientFileLoader;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isAjaxRequestMode"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				request.ClientFileLoader.isAjaxRequestMode = arguments.yesNo;

			/* attempt to auto detect if we are in ajax mode based on known ColdFusion ajax techniques. Otherwise developer should use the method : isAjaxRequestMode(true/false) */
				if(!structKeyExists(request.ClientFileLoader, "isAjaxRequestMode"))
					request.ClientFileLoader.isAjaxRequestMode=
					(
						structKeyExists(url , "_cf_clientId")
					OR	structKeyExists(url , "_cf_containerId")
					OR	structKeyExists(form , "_cf_clientId")
					OR	structKeyExists(form , "_cf_containerId")
					OR	(
							(
								structKeyExists(url , "method")
							OR	structKeyExists(form , "method")
							)
						AND	listLast(cgi.script_name,'.') EQ 'cfc'	/* <----- detect cfc direct invoke */
						)
					);
			/* end */

			return request.ClientFileLoader.isAjaxRequestMode;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isDebug"
		returnType	= "boolean"
		output		= "no"
		access		= "public"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo"	required="No"	type="boolean"		hint="" />
		<cfif structKeyExists(arguments, "yesNo") >
			<cfset request.ClientFileLoader.isDebug = arguments.yesNo />
		</cfif>
		<cfReturn request.ClientFileLoader.isDebug />
	</cfFunction>

	<cfFunction
		Name		= "getCoreLoadingScriptTag"
		returnType	= "string"
		Access		= "public"
		Output		= "no"
		Hint		= ""
		Description	= "responsible for rendering the html script tag call for the core ClientFileLoader.js file"
	>
		<cfArgument name="jsCoreFileURL"				required="no"	type="string"	default="getClientFileLoaderJavascriptCoreFileUrl()"	hint="Javascript API file relied on for loading scripts after a page is loaded.Path and name required" />
		<cfScript>
			if(isAjaxRequestMode() OR request.ClientFileLoader.isLoaded)
				return '';

			if(arguments.jsCoreFileURL EQ "getClientFileLoaderJavascriptCoreFileUrl()")
				arguments.jsCoreFileURL = getClientFileLoaderJavascriptCoreFileUrl().getString();
		</cfScript>
		<cfSaveContent Variable="local.scriptContent">
			<cfOutput>
				<script type="text/javascript" language="Javascript" src="#arguments.jsCoreFileUrl#"></script>
			</cfOutput>
		</cfSaveContent>
		<cfset request.ClientFileLoader.isLoaded = 1 />
		<cfReturn local.scriptContent />
	</cfFunction>

	<cfFunction
		name		= "isPreventDuplicateLoadMode"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= "When true, will prevent duplicate script calls. When ColdFusion is in debug mode, all scripts will always be fetched when called for"
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.PreventDuplicateLoadMode = arguments.yesNo;

			if(!structKeyExists(variables, "PreventDuplicateLoadMode"))
				variables.PreventDuplicateLoadMode = 1;

			return variables.PreventDuplicateLoadMode;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setAjaxRequestMode"
		returnType	= "ClientFileLoader"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="isAjaxRequestMode" required="yes" type="boolean" hint="" />
		<cfset isAjaxRequestMode(arguments.isAjaxRequestMode) />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		Name		= "setOnLoadCompleteCallback"
		returnType	= "ClientFileLoader"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="method"	required="yes"	type="variableName"	hint="" />
		<cfif listFindNoCase(request.ClientFileLoader.uniqueOncompleteNameList , arguments.method) >
			<cfThrow
				message = "The same jsMethod '#arguments.method#' has been requested to be called onLoadCompete and is invalid"
				detail	= "The component '#getMetaData(this).name#' calls jsMethods after completely loading all requested script files. It would be illegal to call the same method twice. Methods requested: #request.ClientFileLoader.uniqueOncompleteNameList#"
			/>
		</cfif>
		<cfScript>
			arrayAppend(request.ClientFileLoader.onLoadMethods, arguments.method);
			request.ClientFileLoader.uniqueOncompleteNameList = listAppend(request.ClientFileLoader.uniqueOncompleteNameList , arguments.method);

			Return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "FolderDepth"
		returnType	= "ClientFileLoader"
		Access		= "public"
		Output		= "no"
		Hint		= "Returns a new ClientFileLoader that has all media reference at a one depper child depth. IE : Image/depth Scripts/depth Styles/depth"
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfReturn
			createObject("component" , "ClientFileLoader" ).
				setJavascriptURL(getJsUrl() & arguments.name & "/").
					setCssURL(getCssUrl() & arguments.name & "/").
						setAjaxRequestMode(isAjaxRequestMode())
		/>
	</cfFunction>

	<cfFunction
		Name		= "isScriptLoaded"
		returnType	= "boolean"
		Access		= "private"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="script" required="yes" type="string" hint="" />
		<cfScript>
			for(local.loadIndex=1; local.loadIndex LTE arrayLen(request.ClientFileLoader.loadedArray); ++local.loadIndex)
				if( request.ClientFileLoader.loadedArray[local.loadIndex] EQ arguments.script )
					return true;

			return false;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getFileNameExtension"
		returnType	= "string"
		access		= "private"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="fileName" required="yes" type="string" hint="" />
		<cfReturn listLast(fileName , '.') />
	</cfFunction>

	<cfFunction
		Name		= "addScript"
		returnType	= "ClientFileLoader"
		Access		= "public"
		Output		= "no"
		description	= "Base method for loading of ALL scripts ... argument type will apply the correct syntax upon calling for output of script(s)"
		Hint		= ""
	>
		<cfArgument name="script"			required="yes"	type="string"		hint="" />
		<cfArgument name="type"				required="no"	type="variableName"	hint="css,stylesheet, js OR javascript" />
		<cfArgument name="urlType"	 		required="no"	type="variableName" hint="Default is based on file extension. Used to indicate that a css file should be loaded from a javascript area or visa versa. Value must be either 'css' or 'js'" />
		<cfArgument name="failOverList"		required="no"	type="string"		hint="comma seperated. allows list of fail overs, if one script fails to load, the next in the list is loaded" />
		<cfArgument name="jsTestCondition"	required="no"	type="string"		hint="script will only load when js test condition returns true. string should be set as if typing with-in an if() condition" />
		<cfScript>
			var local = {};

			if( !isScriptLoaded(script) )
			{
				arrayAppend(request.ClientFileLoader.loadedArray, arguments.script);

				if( not structKeyExists( arguments , "type" ) )
					arguments.type = getFileNameExtension(arguments.script);

				Switch(arguments.type)
				{
					Case "css":
					Case "stylesheet":
					{
						arguments.type = 'css';
						local.content = getCssCall(argumentCollection=arguments);
						break;
					}
					default:
					{
						arguments.type = 'js';
						local.content = getScriptCall(argumentCollection=arguments);
						break;
					}
				}

				local.struct = {content=local.content, type=arguments.type};
				arrayAppend(request.ClientFileLoader.toOutputArray, local.struct);
			}

			Return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "getOutput"
		returnType	= "string"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfReturn getScriptContentForOutput() />
	</cfFunction>

	<cfFunction
		name		= "outputToHtmlHead"
		returnType	= "void"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfset output(isHtmlHeadMode=1) />
	</cfFunction>

	<cfFunction
		Name		= "output"
		returnType	= "string"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="isHtmlHeadMode"		required="no"	type="boolean"	default="no"	hint="" />
		<cfArgument name="isInlineOutputMode"	required="no"	type="boolean"	default="no"	hint="" />
		<cfArgument name="isReturnMode"			required="no"	type="boolean"	default="no"	hint="" />
		<cfScript>
			if
			(
				!arrayLen(request.ClientFileLoader.toOutputArray)
			AND
				!arrayLen(request.ClientFileLoader.onLoadMethods)
			)
				Return '';

			if( arguments.isInlineOutputMode )
			{
				writeOutput( getScriptContentForOutput() );
				Return '';
			}else if( arguments.isReturnMode )
				Return getScriptContentForOutput();
		</cfScript>
		<cfHtmlHead text="#getScriptContentForOutput()#" />
		<cfReturn "" />
	</cfFunction>

	<cfFunction
		name		= "getOnloadEventScriptTag"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT arrayLen(request.ClientFileLoader.onLoadMethods) )
				return '';

			local.onCompleteMethodName = "ClientFileLoaderOnComplete_" & arrayLen(request.ClientFileLoader.loadedArray) & "_" & getTickCount();
		</cfScript>
		<cfSaveContent Variable="local.onloadOutput">
			<cfOutput>
				<script type="text/javascript" language="Javascript">
					CflArrays.after.push
					(
						function()
						{
							<cfLoop from="1" to="#arrayLen(request.ClientFileLoader.onLoadMethods)#" index="local.loadIndex" >
								<cfset local.arrayLoop = request.ClientFileLoader.onLoadMethods[local.loadIndex] />
								if( typeof( #local.arrayLoop# ) != typeof(new Function()) )
									setTimeout( function(){#local.arrayLoop#()} , 500 );<!--- Ajax inner html delay for undefined AND to-be overwritten --->
								else
									setTimeout( function(){#local.arrayLoop#()} , 30 );<!--- cross-browser friendly way to allow "innerHTML" to finish processing first --->
							</cfLoop>
						}
					)
				</script>
			</cfOutput>
		</cfSaveContent>
		<cfset request.ClientFileLoader.onLoadMethods = arrayNew(1) />
		<cfReturn local.onloadOutput />
	</cfFunction>

	<cfFunction
		Name		= "getScriptContentForOutput"
		returnType	= "string"
		Access		= "private"
		Output		= "no"
		Hint		= "Returns string of all scripts not output a.k.a. loaded to screen"
	>
		<cfScript>
			local.return_string = "";

			if( request.ClientFileLoader.isAnythingOutput EQ 0 )
			{
				//CFMethods().htmlHead('<script type="text/javascript" language="Javascript">' & getJsParamLoadArrayString() & '</script>');
				local.return_string &= '<script type="text/javascript" language="Javascript">' & getJsParamLoadArrayString() & '</script>';
				request.ClientFileLoader.isAnythingOutput = 1;
			}

			local.isOutputNeeded = isOutputNeeded();

			/* style output */
				if( arrayLen(request.ClientFileLoader.styleOutputArray) )
				{
					local.styleOutput='';

					for(local.arrayLoop=1; local.arrayLoop LTE arrayLen(request.ClientFileLoader.styleOutputArray); local.arrayLoop=local.arrayLoop+1)
						local.styleOutput = local.styleOutput & request.ClientFileLoader.styleOutputArray[local.arrayLoop];

					local.return_string &= local.styleOutput;
				}
			/* end */

			local.return_string &= getOnloadEventScriptTag();
		</cfScript>
		<cfif local.isOutputNeeded >
			<!--- FIRE THE LOADING OF THE SCRIPTS --->
				<cfSaveContent Variable="local.scriptOutput">
					<cfOutput>
						<script type="text/javascript" language="Javascript">
							CflArrays.before.push
							(
								function(CFL)
								{
									CFL.addLoadCompletePause(#request.ClientFileLoader.pauseLoadCompleteCount#);

									<cfif isPreventDuplicateLoadMode() >
										CFL.setPreventDuplicateLoadMode(false);
									</cfif>
									<cfif isDebug() >
										CFL.isDebugMode(1);
									</cfif>
									<cfLoop from="1" to="#arrayLen(request.ClientFileLoader.toOutputArray)#" index="local.arrayLoop">
										#request.ClientFileLoader.toOutputArray[local.arrayLoop].content#
									</cfLoop>
								}
							);

							<cfif isDebug() >
								<cfif isAjaxRequestMode() >
									<cfset local.message = 'requesting script load' />
								<cfElse>
									<cfset local.message = 'requesting script load after window load' />
								</cfif>
								console.log('#local.message#');
							</cfif>
							<cfif isAjaxRequestMode() >
								var method=function()
								{
									if(typeof(ClientFileLoader) != 'undefined')
									{
										ClientFileLoader.loadScripts();
										clearInterval(arguments.callee.iID)
									}
								}
								method.iID = setInterval(method,100);
							</cfif>
						</script>
					</cfOutput>
				</cfSaveContent>
				<cfset local.return_string &= local.scriptOutput />
			<!--- END : FIRE THE LOADING OF THE SCRIPTS --->
		</cfif>
		<cfScript>
			/* has the core javascript file been output */
				if(NOT isAjaxRequestMode() AND NOT request.ClientFileLoader.isLoaded)
					local.return_string = local.return_string & getCoreLoadingScriptTag();
			/* end */

			resetLoading();

			Return trim(local.return_string);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getJsParamLoadArrayString"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn 'if(typeof(CflArrays) != typeof({}))CflArrays={before:[], after:[]};' />
	</cfFunction>

	<cfFunction
		Name		= "getScriptLoadArray"
		returnType	= "array"
		Access		= "public"
		Output		= "no"
		Hint		= "Returns struct of all scripts loaded. Just a handy method to see whats going on"
	>
		<cfReturn request.ClientFileLoader.loadedArray />
	</cfFunction>

	<cfFunction
		Name		= "getScriptCall"
		returnType	= "string"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="script"		required="yes"	type="string"				hint="" />
		<cfArgument name="failOverList"	required="no"	type="string"	default=""	hint="comma seperated. allows list of fail overs, if one script fails to load, the next in the list is loaded" />
		<cfArgument name="jsTestCondition"	required="no"	type="string"		hint="script will only load when js test condition returns true. string should be set as if typing with-in an if() condition" />
		<cfScript>
			local.isDomainBound = isUrlDomainBound(arguments.script);
			if(NOT local.isDomainBound)
				arguments.script = typeToUrl('js') & trim(arguments.script);

			local.failOverArray = listToArray(arguments.failOverList);
			for(local.failIndex=1; local.failIndex LTE arrayLen(local.failOverArray); local.failIndex=local.failIndex+1)
			{
				local.scriptAddress = local.failOverArray[local.failIndex];

				if(NOT isUrlDomainBound(local.scriptAddress))
					local.scriptAddress = typeToUrl('js') & trim(local.scriptAddress);

				local.failOverArray[local.failIndex] = local.scriptAddress;
			}

			arguments.failOverList = serializeJSON(local.failOverArray);
			arguments.script = serializeJSON(arguments.script);

			if(structKeyExists(arguments, "jsTestCondition"))
				arguments.jsTestCondition = "function(){return #arguments.jsTestCondition#}";
			else
				arguments.jsTestCondition = 'null';

			local.returnString = "ClientFileLoader.addJavaScript(#arguments.script#, null, #arguments.failOverList#, #arguments.jsTestCondition#);";

			return local.returnString;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "getCSSCall"
		returnType	= "string"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="script"		required="yes"	type="string"	hint="" />
		<cfArgument name="failOverList"	required="no"	type="string"	hint="" />
		<cfScript>
			if(NOT isUrlDomainBound(arguments.script))
				arguments.script = typeToUrl('css') & trim(arguments.script);

			Return "ClientFileLoader.loadCssScript( #serializeJSON(arguments.script)# );";
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "typeToUrl"
		returnType	= "string"
		Access		= "private"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="type" required="yes" type="string" hint="" />
		<cfSwitch expression="#arguments.type#">
			<cfCase value="css,stylesheet,stylesheets" delimiters=",">
				<cfReturn getCssUrl() />
			</cfCase>
			<cfDefaultCase>
				<cfReturn getJsUrl() />
			</cfDefaultCase>
		</cfSwitch>
	</cfFunction>

	<cfFunction
		name		= "getStyleSheetOutput"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "get ONLY style sheets awaiting output"
	>
		<cfScript>
			local.output		= "";
			local.callCount		= arrayLen(request.ClientFileLoader.toOutputArray);
			local.removeCount	= 0;

			for(local.currentScript=1; local.currentScript LTE local.callCount; ++local.currentScript)
			{
				local.adjScript = local.currentScript - local.removeCount;

				if( request.ClientFileLoader.toOutputArray[local.adjScript].type NEQ 'css')
					continue;

				local.output &= request.ClientFileLoader.toOutputArray[local.adjScript].content & chr(10);

				arrayDeleteAt(request.ClientFileLoader.toOutputArray, local.adjScript);

				++local.removeCount;
			}
		</cfScript>
		<!--- ajax mode return --->
			<cfSaveContent Variable="local.output">
				<cfOutput>
					<script type="text/javascript" language="Javascript">
						#getJsParamLoadArrayString()#
						CflArrays.before.push(function(CFL){#chr(10) & local.output#});
					</script>
				</cfOutput>
			</cfSaveContent>
		<!--- end --->
		<cfReturn local.output />
	</cfFunction>

	<cfFunction
		name		= "setScriptContent"
		returnType	= "ClientFileLoader"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="content" required="yes" type="string" hint="" />
		<cfScript>
			var struct = {content=arguments.content, type='js'};

			arrayAppend(request.ClientFileLoader.toOutputArray, struct);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setStyleContent"
		returnType	= "ClientFileLoader"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="content" required="yes" type="string" hint="" />
		<cfScript>
			arguments.content = '<style>#arguments.content#</style>';
			arrayAppend(request.ClientFileLoader.styleOutputArray, arguments.content);
			return this;
		</cfScript>
	</cfFunction>

	<!--- URL BASED METHODS --->
		<cfFunction
			name		= "isUrlDomainBound"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="url" required="yes" type="string" hint="" />
			<cfReturn reFindNoCase("^[^:]+://.+", arguments.url, 1, false) />
		</cfFunction>

		<cfFunction
			name		= "setClientFileLoaderJavascriptCoreFileUrl"
			returnType	= "ClientFileLoader"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="url" required="yes" type="any" hint="" />
			<cfScript>
				if(isSimpleValue(arguments.url))
					request.ClientFileLoader.JavascriptCoreFileUrl = getNewMediaAddress(arguments.url);
				else
					request.ClientFileLoader.JavascriptCoreFileUrl = arguments.url;

				//? was a file name included in the set url ?
				if(!len(request.ClientFileLoader.JavascriptCoreFileUrl.getFileName()))
					request.ClientFileLoader.JavascriptCoreFileUrl.setFileName('ClientFileLoader.js');

				variables.ClientFileLoaderJavascriptCoreFileUrl = request.ClientFileLoader.JavascriptCoreFileUrl;

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isCflCoreFileUrlSet"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				return NOT isSimpleValue(request.ClientFileLoader.JavascriptCoreFileUrl);
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getClientFileLoaderJavascriptCoreFileUrl"
			returnType	= "CFExpose.RequestKit.MediaAddress"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfScript>
				if( isCflCoreFileUrlSet() )
					return request.ClientFileLoader.JavascriptCoreFileUrl;

				request.ClientFileLoader.JavascriptCoreFileUrl = getNewMediaAddress().appendRelativeFolderPath('ClientFileLoader/ClientFileLoader.js');
				variables.ClientFileLoaderJavascriptCoreFileUrl = request.ClientFileLoader.JavascriptCoreFileUrl;

				return request.ClientFileLoader.JavascriptCoreFileUrl;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setUrlAddress"
			returnType	= "ClientFileLoader"
			access		= "public"
			output		= "no"
			description	= "define where to load javascript files from in a url string address or UrlAddress object"
			hint		= ""
		>
			<cfArgument name="UrlAddress" required="yes" type="any" hint="string or UrlAddress object" />
			<cfScript>
				if( isSimpleValue(arguments.UrlAddress) )
				{
					variables.UrlAddress = getNewMediaAddress(arguments.UrlAddress);
					return this;
				}

				variables.UrlAddress = arguments.UrlAddress;

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getUrlAddress"
			returnType	= "UrlAddress"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "returns a blank UrlAddress object"
		>
			<cfScript>
				if( NOT structKeyExists(variables, "UrlAddress") )
					variables.UrlAddress = createObject('component', 'UrlAddress');

				return variables.UrlAddress;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getJsURL"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfReturn getUrlAddress().getFolderUrlPath() & variables.jsURL />
		</cfFunction>

		<cfFunction
			name		= "getCssURL"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfReturn getUrlAddress().getFolderUrlPath() & variables.cssURL />
		</cfFunction>

		<cfFunction
			Name		= "setJavascriptURL"
			returnType	= "ClientFileLoader"
			Access		= "public"
			Output		= "no"
			Hint		= ""
		>
			<cfArgument name="url" required="yes" type="string" hint="" />
			<cfset variables.jsURL = arguments.url />
			<cfReturn this />
		</cfFunction>

		<cfFunction
			Name		= "setStyleSheetURL"
			returnType	= "ClientFileLoader"
			Access		= "public"
			Output		= "no"
			Hint		= ""
		>
			<cfArgument name="url" required="yes" type="string" hint="" />
			<cfset variables.cssURL = arguments.url />
			<cfReturn this />
		</cfFunction>
	<!--- end : URL BASED METHODS --->

</cfComponent>