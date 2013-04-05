<cfComponent
	Hint		= "Just a helpful component extension. Useless by itself but powerful to components doing javascript client output"
	Output		= "no"
	Extends		= "UrlAddress"
	accessors	= "yes"
>

	<cfProperty name="baseHref"				type="string" />
	<cfProperty name="queryString"			type="string" />
	<cfProperty name="relativeScriptUrl"	type="string" />
	<cfProperty name="fileName"				type="string" />

	<cfProperty name="BrowserName"			type="string" />
	<cfProperty name="method"				type="variableName" />
	<cfProperty name="cookieStruct"			type="struct" />
	<cfProperty name="formStruct"			type="struct" />

	<cfFunction
		name		= "setMethod"
		returnType	= "ExposeUrl"
		access		= "public"
		output		= "no"
		description	= "url method protocol. GET or POST"
		hint		= ""
	>
		<cfArgument name="Method" required="yes" type="variableName" hint="" />
		<cfset variables.Method = arguments.Method />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getMethod"
		returnType	= "variableName"
		access		= "public"
		output		= "no"
		description	= "url method protocol. GET or POST"
		hint		= ""
	>
		<cfif NOT structKeyExists(variables, "Method")>
			<cfReturn 'GET' />
		</cfif>
		<cfReturn variables.Method />
	</cfFunction>

	<cfFunction
		name		= "setFormStruct"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="FormStruct" required="yes" type="struct" hint="" />
		<cfScript>
			variables.FormStruct = arguments.FormStruct;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getFormStruct"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "FormStruct") )
				variables.FormStruct = structNew();

			return variables.FormStruct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setCookieStruct"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="CookieStruct" required="yes" type="struct" hint="" />
		<cfScript>
			variables.CookieStruct = arguments.CookieStruct;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getCookieStruct"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "CookieStruct") )
				variables.CookieStruct = structNew();

			return variables.CookieStruct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setBrowserName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="BrowserName" required="yes" type="string" hint="" />
		<cfScript>
			variables.BrowserName = arguments.BrowserName;
			return this;
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
				variables.BrowserName = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E)';

			return variables.BrowserName;
		</cfScript>
	</cfFunction>

</cfComponent>