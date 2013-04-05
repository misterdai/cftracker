<cfComponent
	Hint		= "per url functionality"
	output		= "no"
	extends		= "ExposeVariable"
	accessors	= "yes"
>

	<cfScript>
		setVarValidateByTypeName('CFExpose.RequestKit.UrlRequest');

		variables.hostRegX			= '^((http(s)?://)?)+[^/?]+\.[^/?]+';
		variables.favRegX			= '([^''"\t\s\r\n]+)?favicon\.[^''"\t\s\r\n]+';
		variables.protocolCheckRegX	= '^[^:]+://';
	</cfScript>

	<cfFunction
		name		= "setVar"
		returnType	= "ExposeUrl"
		access		= "public"
		output		= "no"
		description	= "set the variable that all functions revolve around"
		hint		= "adds http:// if no protocol detected"
	>
		<cfArgument name="url" required="yes" type="any" hint="" />
		<cfScript>
			if(isSimpleValue(arguments.url))
			{
				if( NOT reFindNoCase(variables.protocolCheckRegX, arguments.url, 1, false) )
					arguments.url = 'http://' & arguments.url;

				arguments.url = createObject("component", "CFExpose.RequestKit.UrlRequest").init(arguments.url);
			}

			return super.setVar(arguments.url);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isRedirectMode"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.RedirectMode = arguments.yesNo;

			if(!structKeyExists(variables, "RedirectMode"))
				variables.RedirectMode = 1;

			return variables.RedirectMode;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isResolveUrlMode"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.ResolveUrlMode = arguments.yesNo;

			if(!structKeyExists(variables, "ResolveUrlMode"))
				variables.ResolveUrlMode = 0;

			return variables.ResolveUrlMode;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getLastHttpRequestStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn variables.httpResult />
	</cfFunction>

	<cfFunction
		name		= "getHttpRequestStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= "cfHttp request is made and the result is logged and returned"
		hint		= ""
	>
		<cfArgument name="redirect" 		required="no"	type="boolean"						hint="if the http call had relocation header information, that path can be followed" />
		<cfArgument name="resolveUrl"		required="no"	type="boolean"						hint="" />
		<cfArgument name="throwOnError"		required="no"	type="boolean"		default="yes"	hint="" />
		<cfArgument name="isHardRedirect"	required="no"	type="boolean"		default="no"	hint="when redirect=true, this method will return a key in the struct return of relocationUrl. It does this by examining cfHttp requests for responseHeader localtion indicators that a redirect has occured. This may not always work right in all cases so this override has been provided to have cfHttp do it's normal redirect job" />
		<cfArgument name="UrlRequest"		required="no" type="CFExpose.RequestSwitch.UrlRequest" hint="getVar()" />
		<cfScript>
			var local = structNew();

			if(NOT structKeyExists(arguments, "UrlRequest"))
				arguments.UrlRequest = getVar();

			if(NOT structKeyExists(arguments, "redirect"))
				arguments.redirect = isRedirectMode();

			if(NOT structKeyExists(arguments, "resolveUrl"))
				arguments.resolveUrl = isResolveUrlMode();
		</cfScript>
		<cfHttp
			url			= "#arguments.UrlRequest.getString()#"
			method		= "#arguments.UrlRequest.getMethod()#"
			resolveURL	= "#arguments.resolveUrl#"
			redirect	= "#arguments.isHardRedirect#"
			userAgent	= "#arguments.UrlRequest.getBrowserName()#"
			result		= "local.httpResult"
		>
		<!---
			port				= "port_number"
			throwOnError		= "yes"
			timeout				= "seconds"
			getasbinary			= "no"
			multipart			= "no"
			file				= "filename"
			path				= "path"
		--->
			<!--- cookies --->
				<cfset local.struct = arguments.UrlRequest.getCookieStruct() />
				<cfif structCount(local.struct) >
					<cfLoop collection="#local.struct#" item="local.key">
						<cfhttpparam type="cookie" name="#local.key#" value="#local.struct[local.key]#" />
					</cfLoop>
				</cfif>
			<!--- end : cookies --->
			<!--- form vars --->
				<cfset local.struct = arguments.UrlRequest.getFormStruct() />
				<cfif structCount(local.struct) >
					<cfLoop collection="#local.struct#" item="local.key">
						<cfhttpparam type="formField" name="#local.key#" value="#local.struct[local.key]#" />
					</cfLoop>
				</cfif>
			<!--- end : form vars --->
		</cfHttp>
		<cfScript>
			if( arguments.redirect AND structKeyExists(local.httpResult.responseHeader, "location") )
			{
				local.relocationUrl = local.httpResult.responseHeader.location;
				arguments.url = local.relocationUrl;

				local.httpResult = getHttpRequestStruct(argumentCollection=arguments);

				if( NOT structKeyExists(local.httpResult, "relocationUrl") )
				{
					local.httpResult = duplicate(local.httpResult);//this breaks the CF restriction that won't let you modify the cfHttp struct
					local.httpResult.relocationUrl = local.relocationUrl;
				}
			}

			variables.httpResult = local.httpResult;

			return local.httpResult;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRequestString"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="redirect" 		required="no"	type="boolean"		hint="" />
		<cfArgument name="resolveUrl"		required="no"	type="boolean"		hint="" />
		<cfArgument name="throwOnError"		required="no"	type="boolean"		hint="" />
		<cfArgument name="isHardRedirect"	required="no"	type="boolean"		hint="when redirect=true, this method will return a key in the struct return of relocationUrl. It does this by examining cfHttp requests for responseHeader localtion indicators that a redirect has occured. This may not always work right in all cases so this override has been provided to have cfHttp do it's normal redirect job" />
		<cfArgument name="UrlRequest"		required="no"	type="CFExpose.RequestSwitch.UrlRequest" hint="default=getVar()" />
		<cfReturn getHttpRequestStruct(argumentCollection=arguments).fileContent />
	</cfFunction>

	<cfFunction
		name		= "getHostFromString"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "returns empty string when no host found"
	>
		<cfArgument name="url" required="yes" type="string" hint="" />
		<cfScript>
			var local = structNew();

			local.find = reFindNoCase(variables.hostRegX, arguments.url, 1, true);

			if(arrayLen(local.find.len))
				return left(arguments.url, local.find.len[1]) & '/';

			return '';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getHost"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "returns empty string when no host found"
	>
		<cfReturn getHostFromString(getVar().getString()) />
	</cfFunction>

	<cfFunction
		name		= "getFavIconUrl"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= "depending on internet connectivity this method may take time to complete"
		hint		= "when no length returned, favicon could not be found"
	>
		<cfScript>
			var local = structNew();

			local.host = getHost();
			local.directIcoUrl	= '#local.host#favicon.ico';
			local.directPngUrl	= '#local.host#favicon.png';

			/* parse from http request */
				/* try parsing from html */
					local.htmlStruct = getHttpRequestStruct(redirect="yes", resolveUrl="yes");

					if(structKeyExists(local.htmlStruct, "relocationUrl"))
						local.host = getHostFromString(local.htmlStruct.relocationUrl);
					else
						local.host = getHost();

					local.favIconUrl = extractFavIconUrlFromString(htmlString=local.htmlStruct.fileContent, host=local.host);

					if(len(local.favIconUrl))
						return local.favIconUrl;
				/* end */

				/* try parsing from host index */
					local.htmlStruct = getHttpRequestStruct(url=local.host, redirect="yes", resolveUrl="no");

					if(structKeyExists(local.htmlStruct, "relocationUrl"))
						local.host = getHostFromString(local.htmlStruct.relocationUrl);
					else
						local.host = getHost();

					local.favIconUrl = extractFavIconUrlFromString(htmlString=local.htmlStruct.fileContent, host=local.host);

					if(len(local.favIconUrl))
						return local.favIconUrl;
				/* end */
			/* end */

			/* direct invoke tests */
				/* try ico */
					try{
						if(NOT isSimpleValue(getRequestString(url=local.directIcoUrl, method='get', redirect="yes")))
							return local.directIcoUrl;
					}catch(any e){}
				/* end */

				/* try png */
					try{
						if(NOT isSimpleValue(getRequestString(url=local.directPngUrl, method='get', redirect="yes")))
							return local.directPngUrl;
					}catch(any e){}
				/* end */
			/* end */

			return '';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "extractFavIconUrlFromString"
		returnType	= "string"
		access		= "private"
		output		= "no"
		description	= "when return is no length, url not found"
		hint		= ""
	>
		<cfArgument name="htmlString"	required="yes"	type="string"	hint="" />
		<cfArgument name="host"			required="no"	type="string"	hint="ONLY needed if a relative url is inside htmlString. default is component instance set url, otherwise if favicon url to pluck with host reference is different, then provide here" />
		<cfScript>
			var local = structNew();

			local.findStruct = reFindNoCase(variables.favRegX, arguments.htmlString, 1, true);

			if(arrayLen(local.findStruct.pos) AND local.findStruct.pos[1])
			{
				local.hrefString = mid(arguments.htmlString, local.findStruct.pos[1], local.findStruct.len[1]);

				/* ? add host prefix ? In the case of relative pointing */
					if(NOT local.hrefString CONTAINS '/' OR NOT reFindNoCase(variables.hostRegX, local.hrefString, 1, false))
					{
						if(left(local.hrefString,1) EQ '/' OR left(local.hrefString,1) EQ '\')
							local.hrefString = right(local.hrefString,len(local.hrefString)-1);

						if(structKeyExists(arguments, "host"))
							local.host = arguments.host;
						else
							local.host = getHost();

						local.hrefString = local.host & local.hrefString;
					}
				/* end */

				return local.hrefString;
			}

			return '';
		</cfScript>
	</cfFunction>

</cfComponent>
