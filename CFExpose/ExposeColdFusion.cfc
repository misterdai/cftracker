<cfComponent
	Hint		= "Most but not all code in here requires ColdFusion 9+. Some code in here is undocumented ColdFusion functionality and may not work on shared hosting enviroments where this exposed functionality is locked out from accessing"
	output		= "no"
	extends		= "ExposeVariable"
>

	<cfFunction
		name		= "getMemoryData"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			var local = structNew();

			/* get memory in bytes */
				local.OsBean = createObject('java','java.lang.management.ManagementFactory').getOperatingSystemMXBean();
				local.Converts = CFMethods().Conversions();
				local.rStruct.freeBytes = local.OsBean.getFreePhysicalMemorySize();
				local.rStruct.totalBytes = local.OsBean.getTotalPhysicalMemorySize();
				/*
					!!!Another way to do the above if needed
					local.Runtime = CreateObject("java","java.lang.Runtime").getRuntime();
					local.rStruct.freeBytes = local.Runtime.freeMemory();
					local.rStruct.totalBytes = local.Runtime.totalMemory();
				*/
			/* end */

			local.rStruct.percentUsed = 100 - round((local.rStruct.freeBytes / local.rStruct.totalBytes) * 100);
			local.rStruct.freeSpace = local.Converts.convertBytes(local.rStruct.freeBytes);
			local.rStruct.totalSpace = local.Converts.convertBytes(local.rStruct.totalBytes);

			return local.rStruct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDriveStatusArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "requires use of java object: java.io.File"
	>
		<cfScript>
			var local = structNew();
			local.File = createObject("java","java.io.File");
			local.rootArray = local.File.listRoots();
			local.returnArray = arrayNew(1);

			for(local.dIndex=arrayLen(local.rootArray); local.dIndex GT 0; --local.dIndex)
			{
				local.Drive = local.rootArray[local.dIndex];
				local.driveStruct = structNew();
				local.driveStruct.path = local.Drive.getPath();
				local.driveStruct.freeBytes = local.Drive.getUsableSpace();
				local.driveStruct.totalBytes = local.Drive.getTotalSpace();
				local.driveStruct.freeSpace = CFMethods().Conversions().convertBytes(local.driveStruct.freeBytes);
				local.driveStruct.totalSpace = CFMethods().Conversions().convertBytes(local.driveStruct.totalBytes);
				local.driveStruct.isReadable = local.Drive.canWrite();
				local.driveStruct.isWritable = local.Drive.canRead();

				//percent used
				local.driveStruct.percentUsed = 0;
				if(local.driveStruct.totalBytes AND local.driveStruct.freeBytes)
					local.driveStruct.percentUsed = 100 - round((local.driveStruct.freeBytes / local.driveStruct.totalBytes) * 100);


				arrayPrepend(local.returnArray, local.driveStruct);
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDiskFreeSpace"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "requires use of java object: java.io.File"
	>
		<cfArgument name="path"		required="no"	type="string"		default="/"		hint="" />
		<cfArgument name="format"	required="no"	type="variableName"	default="any"	hint="byte OR any" />
		<cfScript>
			var local = structNew();

			local.fileOb = createObject("java", "java.io.File").init(arguments.path);

			local.space = local.fileOb.getTotalSpace() - local.fileOb.getUsableSpace();

			if(arguments.format EQ 'byte' OR arguments.format EQ 'bytes')
				return local.space;

			return CFMethods().Conversions().convertBytes( local.space );
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDiskUsedSpace"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "requires use of java object: java.io.File"
	>
		<cfArgument name="path"		required="no"	type="string"		default="/"		hint="" />
		<cfArgument name="format"	required="no"	type="variableName"	default="any"	hint="byte OR any" />
		<cfScript>
			var local = structNew();

			local.fileOb = createObject("java", "java.io.File").init(arguments.path);

			local.space = local.fileOb.getTotalSpace() - local.fileOb.getUsableSpace();

			if(arguments.format EQ 'byte' OR arguments.format EQ 'bytes')
				return local.space;

			return CFMethods().Conversions().convertBytes( local.space );
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDiskTotalSpace"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "requires use of java object: java.io.File"
	>
		<cfArgument name="format"	required="no"	type="variableName"	default="any"	hint="byte OR any" />
		<cfArgument name="path"		required="no"	type="string"		default="/"		hint="" />
		<cfScript>
			var local = structNew();

			local.fileOb = createObject("java", "java.io.File").init(arguments.path);

			local.space = local.fileOb.getTotalSpace();

			if(arguments.format EQ 'byte' OR arguments.format EQ 'bytes')
				return local.space;

			return CFMethods().Conversions().convertBytes( local.space );
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSystemSlash"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "on a mac, returns a forward slash and for windows a backslash. CF does not always resolve incorrect slashes between OS's"
		description	= ""
	>
		<cfReturn getDirectoryFromPath('test.cfm') />
	</cfFunction>

	<cfFunction
		name		= "getCFIDEAjaxResourcePath"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= "great place to install scripts requiring url invokation. Lessons the need to set script locations by piggie backing on the CFIDE url targeting (that is that it is assumed CFIDE is correctly setup and accessible)"
		hint		= "always returns with a forward slash"
	>
		<cfReturn expandPath('/CFIDE/scripts/ajax/resources/') />
	</cfFunction>

	<cfFunction
		name		= "isCfideUrlReachableFromCurrentRequest"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= "attempts auto detect"
		hint		= "makes cfhttp request to current domain for request based on the cgi scope"
	>
		<cfArgument name="isThrowErrors" required="no" type="boolean" default="no" hint="" />
		<cfHttp
			url					= "/CFIDE/Administrator/index.cfm"
			timeout				= "7"
			resolveURL			= "yes"
			throwOnError		= "#arguments.isThrowErrors#"
		></cfHttp>
		<cfif cfhttp.Statuscode EQ '200 OK' >
			<cfReturn 1 />
		</cfif>
		<cfReturn 0 />
	</cfFunction>

	<cfFunction
		name		= "getCustomTagPath"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfset var systemslash = getDirectoryFromPath('test.cfm') />
		<cfReturn '#server.coldfusion.rootDir & systemslash#CustomTags#systemslash#' />
	</cfFunction>

	<!--- cfAdmin based functionality --->
		<cfFunction
			name		= "getMappings"
			access		= "public"
			returntype	= "struct"
			output		= "false"
			hint		= "Get the mappings from coldfusion admin"
		>
			<cfReturn createObject("java","coldfusion.server.ServiceFactory").runtimeService.getMappings() />
		</cffunction>

		<cfFunction
			name		= "addMapping"
			returnType	= "ExposeColdFusion"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="reference"	required="yes"	type="string" hint="" />
			<cfArgument name="path"			required="yes"	type="string" hint="" />
			<cfScript>
				var local = structNew();
				local.mappings = getMappings();
				local.mappings[arguments.reference] = arguments.path;
				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "deleteMapping"
			returnType	= "ExposeColdFusion"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="reference"	required="yes"	type="string" hint="" />
			<cfScript>
				var local = structNew();
				local.mappings = getMappings();
				structDelete(local.mappings, arguments.reference);
				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isValidLoginAccount"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			description	= "returns if arguments specified match ColdFusion login account"
			hint		= ""
		>
			<cfArgument name="cfAdminPassword"	required="yes"	type="string"					hint="" />
			<cfArgument name="cfAdminUserName"	required="no"	type="string"	default="Admin"	hint="" />
			<cfReturn
				createObject("component" , "cfide.adminapi.administrator" ).login
				(
					adminPassword	= arguments.cfAdminPassword,
					adminUserId		= arguments.cfAdminUserName
				)
			/>
		</cfFunction>

		<cfFunction
			Name		= "cfAdminLogin"
			returnType	= "ExposeColdFusion"
			Access		= "public"
			Output		= "no"
			Hint		= "logs you into component 'cfide.adminapi.administrator' which is used by most advanced functionality in this component"
		>
			<cfArgument name="cfAdminPassword"	required="yes"	type="string"	hint="" />
			<cfArgument name="cfAdminUserName"	required="no"	type="string"	default="admin" hint="" />
			<cfset createObject("component", "cfide.adminapi.administrator").login(adminPassword=arguments.cfAdminPassword , adminUserId=arguments.cfAdminUserName ) />
			<cfReturn this />
		</cfFunction>

		<cfFunction
			name		= "clearComponentCache"
			returnType	= "ExposeColdFusion"
			access		= "public"
			output		= "no"
			description	= "same thing as going to cfAdmin interface and clearing component cache. Warning, may not work on tight security or shared CF instances if CFIDE.adminapi.runtime is locked down"
			hint		= "Clears the Component cache. requires cfAdminLogin (Use method cfAdminLogin)"
		>
			<cfArgument name="cfAdminPassword"	required="no"	type="string"	hint="" />
			<cfArgument name="cfAdminUserName"	required="no"	type="string"	 hint="" />
			<cfScript>
				if(structKeyExists(arguments, "cfAdminPassword") OR structKeyExists(arguments, "cfAdminUserName"))
					cfAdminLogin(argumentCollection=arguments);

				new('CFIDE.adminapi.runtime').clearComponentCache();

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "clearTrustedCache"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= "Clears template cache or only specific template cache. requires cfAdminLogin (Use method cfAdminLogin). Accepts folders as cache clearing list"
			description	= "Returns list of cleared templates. Same thing as going to cfAdmin interface and clearing template cache. Warning, may not work on tight security or shared CF instances if CFIDE.adminapi.runtime is locked down"
		>
			<cfArgument name="templateList"		required="no"	type="string"	hint="a comma separated list of templates to delete from cache. Otherwise all templates are cleared. Accepts folders in list" />
			<cfArgument name="cfAdminPassword"	required="no"	type="string"	hint="" />
			<cfArgument name="cfAdminUserName"	required="no"	type="string"	default="admin"	hint="" />
			<cfScript>
				if(structKeyExists(arguments, "cfAdminPassword") OR structKeyExists(arguments, "cfAdminUserName"))
					cfAdminLogin(argumentCollection=arguments);

				/* directory logic */
					local.templateArray = listToArray(arguments.templateList);
					local.slash = getSystemSlash();

					for(local.index=arrayLen(local.templateArray); local.index GT 0; --local.index)
					{
						local.path = local.templateArray[local.index];

						if(!directoryExists(local.path))
							continue;

							local.fileQuery = Expose(local.path,'directory').readFilesOrderedByHierachy(sort='name asc' , filter='*.cfc|*.cfm', maxDepth=40, listInfo='name', slash=local.slash);

							for(local.currentRow=0; local.currentRow < local.fileQuery.recordCount; local.currentRow=local.currentRow+1)
						{
							local.filePath = local.path & local.slash & local.fileQuery.name[local.currentRow];
							arrayAppend(local.templateArray,local.filePath);
						}

						arrayDeleteAt(local.templateArray,local.index);
					}
				/* end */

				arguments.templateList = listAppend(arguments.templateList, arrayToList(local.templateArray));
				new('CFIDE.adminapi.runtime').clearTrustedCache(argumentCollection=arguments);

				return arguments.templateList;
			</cfScript>
		</cfFunction>

		<cfFunction
			name			= "restart"
			returnType		= "string"
			access			= "public"
			output			= "no"
			description		= "restarts coldfusion services"
			hint			= ""
		>
			<cfScript>
				var local = structNew();
				local.oJRun	= CreateObject("java", "jrunx.kernel.JRun");
				local.oJRun.restart(local.oJRun.getServerName());
			</cfScript>
			<cfReturn 'Restarting #local.oJRun.getServerName()# JRun server' />
		</cfFunction>
	<!--- end : cfAdmin based functionality --->

	<cfFunction
		name		= "getJRUN"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn CreateObject("java", "jrunx.kernel.JRun") />
	</cfFunction>

	<cfFunction
		Name		= "getSessions"
		returnType	= "struct"
		Access		= "public"
		Output		= "no"
		Hint		= "Get all the session memory variable storages for active sessions"
	>
		<cfArgument name="applicationName" required="no" type="string"	default="#application.applicationName#" hint="" />
		<cfReturn createObject("java","coldfusion.runtime.SessionTracker").getSessionCollection(arguments.applicationName) />
	</cfFunction>

	<cfFunction
		Name		= "getApplications"
		returnType	= "struct"
		Access		= "public"
		Output		= "no"
		Hint		= "Uses undocumented code and often will not work on shared hosting enviorments where this functionality is locked out from access"
	>
		<cfScript>
			var local = structNew();
			local.returnObj	= structNew();
			local.appObject	= createObject("java","coldfusion.runtime.ApplicationScopeTracker");
			local.sessionObj	= createObject("java","coldfusion.runtime.SessionTracker");

			local.apps = local.appObject.getApplicationKeys();

			while(local.apps.hasMoreElements())
			{
				local.appName = local.apps.nextElement();
				if( len(local.appName) )
					local.returnObj[local.appName] = local.appObject.getApplicationScope(local.appName);
			}

			return local.returnObj;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getStackTrace"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="isThrowErrorMode" required="no" type="boolean" default="yes" hint="" />
		<cfscript>
			var local = structNew();

			try
			{
				local.j = CreateObject("java","java.lang.Throwable").getStackTrace();

				local.StackTrace = QueryNew("ClassName,MethodName,NativeMethod,LineNumber,hashCode,string,fileName");
				QueryAddRow(local.StackTrace , ArrayLen(local.j));

				for (local.i=1; local.i LE ArrayLen(local.j); local.i = local.i+1)
				{

					local.StackTrace.ClassName[local.i] = local.j[local.i].getClassName();

					local.StackTrace.MethodName[local.i] = local.j[local.i].getMethodName();

					local.StackTrace.fileName[local.i]	= local.j[local.i].getFileName();

					local.StackTrace.NativeMethod[local.i]	= local.j[local.i].isNativeMethod();
					local.StackTrace.LineNumber[local.i]	= local.j[local.i].getLineNumber();
					local.StackTrace.hashCode[local.i]		= local.j[local.i].hashCode();

					local.StackTrace.string[local.i]		= local.j[local.i].toString();
				}
			}
			catch(Any e)
			{
				if(arguments.isThrowErrorMode)throw(e);//rethrow
			}

			return local.StackTrace;
		</cfscript>
	</cfFunction>

	<cfFunction
		name		= "getCurrentTagContextArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= "returns super useful array that reveals what is being executed in the current tree of tags/invokes being read by ColdFusion"
		hint		= "typically just used for debugging"
	>
		<cfScript>
			var local = structNew();

			try{throw();}
			catch(Any e)
			{
				local.tagContext = e.TagContext;
				/* delete from the array the parts used in throwning an error to generate the tagContext */
					arrayDeleteAt(local.tagContext , 1);
					arrayDeleteAt(local.tagContext , 1);
				/* end */
				return local.tagContext;
			}
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "getDataSources"
		returnType	= "struct"
		Access		= "public"
		Output		= "no"
		Hint		= "Return datasources setup in cfAdministrator"
	>
		<cfArgument name="cfAdminPassword"	required="yes"	type="string"	hint="" />
		<cfArgument name="cfAdminUserName"	required="no"	type="string"	default="admin" hint="" />
		<cfScript>
			var dsObj = createObject("component","cfide.adminapi.datasource");

			createObject("component", "cfide.adminapi.administrator").login(adminPassword=arguments.cfAdminPassword , adminUserId=arguments.cfAdminUserName );

			Return dsObj.GETDATASOURCES();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDatasourceNameArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn CreateObject("java", "coldfusion.server.ServiceFactory").DataSourceService.getNames() />
	</cfFunction>

	<cfFunction
		name		= "getDatasourceDriverName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= "returns RDBMS manufacturer (Relational Database Management System)"
		hint		= "uses ColdFusion's undocumented ServiceFactory. This is not always a sure bet since ColdFusion does not release this as a standard available function"
	>
		<cfArgument name="datasource"			required="yes"	type="variableName"					hint="" />
		<cfset var local = structNew() />
		<cfDbInfo
			datasource	= "#arguments.datasource#"
			name		= "local.dbinfo"
			type		= "version"
		/>
		<cfReturn local.dbinfo.Driver_Name />
	</cfFunction>

	<cfFunction
		name		= "isDatasourceNameDefined"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "Uses undocumented code and often will not work on shared hosting enviorments where this functionality is locked out from access"
	>
		<cfArgument name="name" required="yes" type="variableName" hint="" />
		<cfReturn structKeyExists(CreateObject("java", "coldfusion.server.ServiceFactory").DataSourceService.getDatasources() , arguments.name) />
	</cfFunction>

	<cfFunction
		name		= "clearAllOutput"
		returnType	= "ExposeColdFusion"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "clears all output generated by cfoutput, cfajaximport, and cfhtmlhead"
	>
		<cfContent reset="true" />
		<cfset clearHeaderBuffer() />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "clearHeaderBuffer"
		output		= "no"
		returntype	= "ExposeColdFusion"
		hint		= "clears all content generated by the cfHtmlHead & CFAjaxProxy tag"
	>
		<cfScript>
			var local = structNew();

			local.out = getHeaderBuffer();

			local.method = local.out.getClass().getDeclaredMethod('initHeaderBuffer', ArrayNew(1));
			local.method.setAccessible(true);
			local.method.invoke(local.out, arrayNew(1));

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getHeaderBuffer"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			var local = structNew();

			local.out = getPageContext().getOut();

			while(getMetaData(local.out).getName() is 'coldfusion.runtime.NeoBodyContent')
				local.out = local.out.getEnclosingWriter();

			return local.out;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getHeaderBufferString"
		output		= "false"
		returntype	= "string"
	>
		<cfScript>
			var local = StructNew();

			local.out = getHeaderBuffer();

			if(listFirst(server.coldfusion.productVersion) LTE 7)
			{
				local.field = local.out.getClass().getDeclaredField("headerBuffer");
				local.field.setAccessible(true);
				local.buffer = local.field.get(local.out);
				return iif(StructKeyExists(local,'buffer'),"local.buffer.toString()",de(""));
			}
			else // CF8 intruduced new header Buffer
			{
				local.field = local.out.getClass().getDeclaredField("prependHeaderBuffer");
				local.field.setAccessible(true);
				local.buffer = local.field.get(local.out);
				local.output = iif(StructKeyExists(local,'buffer'),"local.buffer.toString()",de(""));

				local.field = local.out.getClass().getDeclaredField("appendHeaderBuffer");
				local.field.setAccessible(true);
				local.buffer = local.field.get(local.out);

				return local.output & iif(StructKeyExists(local,'buffer'),"local.buffer.toString()",de(""));
			}

			return '';
		</cfScript>
	</cfFunction>

</cfComponent>