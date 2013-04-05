<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "UrlRequest"
	accessors	= "yes"
>

	<cfProperty name="baseHref"				type="string" />
	<cfProperty name="queryString"			type="string" />
	<cfProperty name="relativeScriptUrl"	type="string" />
	<cfProperty name="fileName"				type="string" />

	<cfProperty name="method"				type="variableName" />
	<cfProperty name="cookieStruct"			type="struct" />
	<cfProperty name="formStruct"			type="struct" />

	<cfProperty name="address"				type="string" />
	<cfProperty name="LocalHostAddress"		type="boolean" />
	<cfProperty name="localNetwork"			type="boolean" />
	<cfProperty name="internalAddress"		type="boolean" />
	<cfProperty name="Bot"					type="boolean" />
	<cfProperty name="BrowserName"			type="string" />
	<cfProperty name="RelativeRequestUrl"	type="string" />
	<cfProperty name="RequestDomain"		type="string" />

	<cfScript>
		variables.localHostIpList = 'localhost,127.0.0.1,::1';

		variables.botNameContainsArray = ["bot","spider","crawler","scoutjet","ec2linkfinder"];

		/* set the current request as the url */
			variables.relativeRequestUrl = 'http://' & cgi.http_host & cgi.script_name;

			if(len(cgi.path_info) AND cgi.path_info NEQ cgi.script_name)
				variables.relativeRequestUrl = variables.relativeRequestUrl & cgi.path_info;

			if(len(cgi.query_string))
				variables.relativeRequestUrl = variables.relativeRequestUrl & '?' & urlDecode(cgi.query_string);

			setRelativePath(variables.relativeRequestUrl);
		/* end : set as current request */
	</cfScript>

	<cfFunction
		name		= "setAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "cgi.REMOTE_addr"
		description	= ""
	>
		<cfArgument name="Address" required="yes" type="string" hint="" />
		<cfScript>
			variables.Address = arguments.Address;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "cgi.REMOTE_addr"
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "Address") AND isDefined('cgi') AND structKeyExists(cgi, "REMOTE_addr") )
				return cgi.REMOTE_addr;

			return variables.Address;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setLocalHostAddress"
		returnType	= "ErrorHandler"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Address" required="yes" type="string" hint="" />
		<cfset variables.localHostIpList = listAppend(variables.localHostIpList, arguments.Address) />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "isLocalHostAddress"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.LocalHostAddress = arguments.yesNo;

			if(!structKeyExists(variables, "LocalHostAddress"))
				return listFindNoCase(variables.localHostIpList, getAddress());

			return variables.LocalHostAddress;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getLocalNetwork"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, "LocalNetwork"))
				return isLocalNetwork();

			return variables.LocalNetwork;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isLocalNetwork"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.LocalNetwork = arguments.yesNo;

			if(!structKeyExists(variables, "LocalNetwork"))
				variables.LocalNetwork = isLocalHostAddress() OR (left(getAddress(),8) EQ '192.168.');

			return variables.LocalNetwork;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getInternalAddress"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, "InternalAddress"))
				return isInternalAddress();

			return variables.InternalAddress;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isInternalAddress"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.InternalAddress = arguments.yesNo;

			if(!structKeyExists(variables, "InternalAddress"))
				variables.InternalAddress = false;

			return variables.InternalAddress OR isLocalNetwork();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isAddressInList"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= "send in list of addresses and if user request address matches, returns true"
		description	= ""
	>
		<cfArgument name="addressList"	required="yes"	type="string"				hint="" />
		<cfArgument name="delimiters"	required="no"	type="string"	default="," hint="" />
		<cfReturn listFindNoCase(arguments.addressList, getAddress(), arguments.delimiters) />
	</cfFunction>

	<cfFunction
		name		= "isBot"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.Bot = arguments.yesNo;

			if(!structKeyExists(variables, "Bot"))
			{
				variables.Bot = 0;
				local.browserName = getBrowserName();
				local.containsArray = getBotContainsNameArray();

				for(local.containIndex=arrayLen(local.containsArray); local.containIndex > 0; --local.containIndex)
				{
					if(local.browserName CONTAINS local.containsArray[local.containIndex])
					{
						variables.Bot = 1;
						break;
					}
				}
			}

			return variables.Bot;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getBotContainsNameArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return variables.botNameContainsArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getBrowserName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "BrowserName") )
				variables.BrowserName = cgi.http_user_agent;

			return variables.BrowserName;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getJsonCgi"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, "jsonCgi"))
				variables.jsonCgi = serializeJson(cgi);

			return variables.jsonCgi;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isInternetExplorer"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.InternetExplorer = arguments.yesNo;

			if(!structKeyExists(variables, "InternetExplorer"))
				variables.InternetExplorer = cgi.HTTP_USER_AGENT CONTAINS 'MSIE' OR cgi.HTTP_USER_AGENT CONTAINS 'EXPLORER';

			return variables.InternetExplorer;
		</cfScript>
	</cfFunction>

</cfComponent>