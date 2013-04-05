<cfComponent
	Description	= "This component makes setup of a ColdFusion driven HttpProxy much more objective to work with"
	Hint		= ""
	output		= "no"
	extends		= "Proxy"
>
	<cfScript>
		variables.http=
		{
			port			= 80,
			method			= 'GET',
			throwOnError	= true,
			resolveURL		= true
		};
	</cfScript>

	<cfFunction
		Name		= "setHttpParameters"
		returnType	= "httpProxy"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="url"			required="no"	type="string"						hint="" />
		<cfArgument name="port"			required="no"	type="numeric"						hint="" />
		<cfArgument name="method"		required="no"	type="variableName"					hint="defines if variables passed will be in form 'post' mode or url encoded 'get' variables" />
		<cfArgument name="timeout"		required="no"	type="numeric"						hint="seconds" />
		<cfArgument name="throwOnError"	required="no"	type="boolean"		default="yes"	hint="should an error be generated and reported onError" />
		<cfArgument name="resolveURL"	required="no"	type="boolean"		default="yes"	hint="" />
		<cfScript>
			if(structKeyExists(arguments , "url"))
				setUrl(arguments.url);

			CFMethods().structDeleteNulls(arguments);
			structAppend(variables.http , arguments);

			Return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "invokeHttp"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfset local.httpCollection = variables.http />
		<cfset local.passthruCollection = super.Passthru().getPassthruCollection() />
		<cfset local.httpCollection.url = getUrl() />
		<cfHttp attributeCollection="#local.httpCollection#" >
			<cfLoop collection="#local.passthruCollection#" item="local.passthruKey">
				<cfScript>
					local.param=
					{
						name	= local.passthruKey,
						value	= local.passthruCollection[local.passthruKey]
					};

					switch(variables.http.method)
					{
						case 'GET':{local.param.type="URL";break;}
						case 'POST':{local.param.type="formField";break;}
					}
				</cfScript>
				<cfhttpparam attributeCollection="#local.param#" />
			</cfLoop>
		</cfHttp>
		<cfReturn cfhttp.fileContent />
	</cfFunction>
</cfComponent>