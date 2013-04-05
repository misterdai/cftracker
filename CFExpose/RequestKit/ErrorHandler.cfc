<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="DumpLimit"		type="numeric" />
	<cfProperty name="EmailSubject"		type="string" />
	<cfProperty name="ErrorId"			type="string" />
	<cfProperty name="UserRequest"		type="UserRequest" />
	<cfProperty name="LinkedServers"	type="array" />
	<cfProperty name="Message"			type="string" />
	<cfScript>
		variables.dumpScopes = structNew();
		variables.consoleVars = structNew();
		variables.linkedServers = arrayNew(1);
		variables.dumpLimit = 5;

		setConsoleVarByName(cgi.remote_addr,'From IP');
		setConsoleVarByName(cgi.http_user_agent,'Browser Type');
		setDumpScopeByName(form, 'form');
		setDumpScopeByName(url, 'url');
		setDumpScopeByName(cgi, 'cgi');
		setDumpScopeByName(cookie, 'cookie');
	</cfScript>

	<cfFunction
		name		= "getErrorId"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, 'errorid'))
				variables.errorId = dateFormat(now(), "yyyymmdd") & timeFormat(now(), 'hhmmssms') & '_' & getTickCount();

			return variables.errorId;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setUserRequest"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="UserRequest" required="yes" type="UserRequest" hint="" />
		<cfScript>
			variables.UserRequest = arguments.UserRequest;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getUserRequest"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "UserRequest") )
				variables.UserRequest = createObject("component", "UserRequest");

			return variables.UserRequest;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setLinkedServerName"
		returnType	= "ErrorHandler"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="LinkedServer"	required="yes"	type="string" hint="" />
		<cfArgument name="label"		required="yes"	type="string" hint="" />
		<cfset arrayAppend(variables.linkedServers, arguments) />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "setPriority"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Priority" required="yes" type="numeric" hint="" />
		<cfset variables.Priority = arguments.Priority />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getPriority"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "Priority")>
			<cfif getUserRequest().isBot() >
				<cfset variables.Priority = 2 />
				<cfReturn 2 />
			</cfif>
			<cfReturn 3 />
		</cfif>
		<cfReturn variables.Priority />
	</cfFunction>

	<cfFunction
		name		= "setConsoleVarByName"
		returnType	= "ErrorHandler"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="variable"		required="yes"	type="any"						hint="" />
		<cfArgument name="name"			required="yes"	type="string"					hint="" />
		<cfArgument name="isCodeFormat"	required="no"	type="boolean"	default="no"	hint="" />
		<cfset variables.consoleVars[arguments.name] = arguments />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "setDumpScopeByName"
		returnType	= "ErrorHandler"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="variable" required="yes" type="any" hint="" />
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfset variables.dumpScopes[arguments.name] = arguments.variable />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "setMessage"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Message" required="yes" type="string" hint="" />
		<cfScript>
			if(!structKeyExists(variables, 'EmailSubject'))
				setEmailSubject(CFMethods().Strings().midSlim(arguments.message,85)&' (#cgi.remote_addr#)');

			variables.Message = arguments.Message;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getMessage"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "Message")>
			<cfThrow message="Message Not Yet Set" detail="Use the method 'setMessage' in component '#getMetaData(this).name#'" />
		</cfif>
		<cfReturn variables.Message />
	</cfFunction>

	<cfFunction
		name		= "setDetail"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Detail" required="yes" type="string" hint="" />
		<cfset variables.Detail = arguments.Detail />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getDetail"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "Detail")>
			<cfThrow message="Detail Not Yet Set" detail="Use the method 'setDetail' in component '#getMetaData(this).name#'" />
		</cfif>
		<cfReturn variables.Detail />
	</cfFunction>

	<cfFunction
		name		= "getErrorStruct"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn variables.Exception />
	</cfFunction>

	<cfFunction
		name		= "setException"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Exception" required="yes" type="any" hint="" />
		<cfScript>
			variables.Exception = arguments.Exception;

			if( structKeyExists(arguments.exception, "cause") )
				local.examine = arguments.exception.cause;
			else
				local.examine = arguments.Exception;

			if( structKeyExists(local.examine, "message") )
				setMessage(local.examine.message);

			if( structKeyExists(local.examine, "detail") )
				setDetail(local.examine.detail);

			if( structKeyExists(variables.Exception, "sql") )
				setConsoleVarByName(variable=variables.Exception.sql, name='Sql String', isCodeFormat=1);

			if(structKeyExists(local.examine, "TagContext") AND arrayLen(local.examine.TagContext))
			{
				local.templateStruct = local.examine.TagContext[1];
				setConsoleVarByName(local.templateStruct.template&':'&local.templateStruct.line,'Offending Template');

				/* get file line sampling */
					local.examineString = getFileLines(local.templateStruct.template,local.templateStruct.line,4,4);

					if(len(local.examineString))
						setConsoleVarByName(variable=local.examineString, name='Offending Code', isCodeFormat=1);
				/* end */
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getFileLines"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="filePath"		required="yes"	type="string"		hint="" />
		<cfArgument name="startLine"	required="yes"	type="numeric"		hint="" />
		<cfArgument name="linesBefore"	required="no"	type="numeric"	default="4"	hint="" />
		<cfArgument name="linesAfter"	required="no"	type="numeric"	default="4"	hint="" />
		<cfScript>
			var local = {};

			local.lines = '';
			local.counter = arguments.startline;

			if(!fileExists(arguments.filePath))
				return '';

			local.FileString	= FileRead(arguments.filePath);
			local.fileLength	= len(reReplaceNoCase(local.FileString, '[^\n]+', '', 'all'));

			local.startLine = arguments.startLine - arguments.linesBefore;

			if(local.startLine LT 1)
				local.startLine=1;

			local.endLine = arguments.startLine + arguments.linesAfter;

			if(local.endLine GT local.fileLength)
				local.endLine = local.fileLength;

			if(local.endLine LT 1)
				local.endLine = 1;

			if(local.startline GT local.endLine)
			{
				local.temp = local.startline;
				local.startline = local.endLine;
				local.endLine = local.temp;
			}
		</cfScript>
		<cfLoop File="#arguments.filePath#" index="local.fileLine" from="#local.startline#" to="#local.endLine#">
			<cfScript>
				local.lines &= local.counter & ': ' & local.fileLine;

				if( local.counter NEQ local.endLine )
					local.lines &= chr(13) & chr(10);

				local.counter = local.counter + 1;
			</cfScript>
		</cfLoop>
		<cfReturn local.lines />
	</cfFunction>

	<cfFunction
		name		= "setEmailSubject"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="EmailSubject" required="yes" type="string" hint="" />
		<cfset variables.EmailSubject = arguments.EmailSubject />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getEmailSubject"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "EmailSubject")>
			<cfReturn 'An unexpected error has occurred' />
		</cfif>
		<cfReturn variables.EmailSubject />
	</cfFunction>

	<cfFunction
		name		= "send"
		returnType	= "ErrorHandler"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			var local = {};

			local.errorLabel = '';
			local.EmailSubject = getEmailSubject();
			local.priority = getPriority();

			if( getUserRequest().isInternalAddress() )
				local.errorLabel = 'In-house ';
			else if( getUserRequest().isBot() )
				local.errorLabel = 'Bot ';

			if(local.priority GTE 4)
				local.errorLabel &= 'Severe Error';
			else if(local.priority EQ 3)
				local.errorLabel &= 'Error';
			else if(local.priority EQ 2)
				local.errorLabel &= 'Warning';
			else
				local.errorLabel &= 'Important Info';

			local.errorLabel &= ': ';

			setEmailSubject(local.errorLabel & local.EmailSubject);

			local.tempDirPath = getTempDirectory();
			local.tempFileName = 'ErrorReport#dateFormat(now(), "yyyy-mm-dd")#-#timeFormat(now(), 'hh-mm-ss')#.html';
		</cfScript>
		<cfMail attributeCollection="#getMailAttributes()#">
			#getOverviewDebugOutput()#
			<cfTry>
				<cfMailParam file="#local.tempFileName#" content="#getExtendedDebugOutput()#" />
				<cfCatch></cfCatch>
			</cfTry>
		</cfMail>
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getMailAttributes"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			var attr=
			{
				 to			= getEmailToAddress()
				,from		= getEmailFromAddress()
				,subject	= getEmailSubject()
				,type		= "html"
			};

			if(structKeyExists(variables, "EmailBcc"))
				attr.bcc = getEmailBcc();

			attr.priority = 6 - getPriority();

			return attr;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setEmailBcc"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="EmailBcc" required="yes" type="string" hint="" />
		<cfset variables.EmailBcc = arguments.EmailBcc />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getEmailBcc"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "EmailBcc")>
			<cfThrow message="EmailBcc Not Yet Set" detail="Use the method 'setEmailBcc' in component '#getMetaData(this).name#'" />
		</cfif>
		<cfReturn variables.EmailBcc />
	</cfFunction>

	<cfFunction
		name		= "setEmailFromAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="EmailFromAddress" required="yes" type="string" hint="" />
		<cfset variables.EmailFromAddress = arguments.EmailFromAddress />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getEmailFromAddress"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "EmailFromAddress")>
			<cfReturn 'Error@#cgi.host#' />
		</cfif>
		<cfReturn variables.EmailFromAddress />
	</cfFunction>

	<cfFunction
		name		= "setEmailToAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="EmailToAddress" required="yes" type="string" hint="" />
		<cfset variables.EmailToAddress = arguments.EmailToAddress />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getEmailToAddress"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "EmailToAddress")>
			<cfThrow message="EmailToAddress Not Yet Set" detail="Use the method 'setEmailToAddress' in component '#getMetaData(this).name#'" />
		</cfif>
		<cfReturn variables.EmailToAddress />
	</cfFunction>

	<cfFunction
		name		= "getErrorRelativeUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(NOT structKeyExists(variables, "ErrorUrl"))
			{
				variables.errorUrl = cgi.script_name;

				if(len(cgi.path_info) AND cgi.path_info NEQ cgi.script_name)
					variables.errorUrl &= cgi.path_info;

				variables.errorUrl &= '?' & cgi.query_string;

				for(local.key in form)
					variables.errorUrl &= '&#local.key#=' & urlEncodedFormat(form[local.key]);

				if(listLen(variables.errorUrl,'?') eq 1)
					variables.errorUrl = listFirst(variables.errorUrl,'?');
			}

			return variables.ErrorUrl;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDebugOutput"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn getOverviewDebugOutput() & getExtendedDebugOutput() />
	</cfFunction>

	<cfFunction
		name		= "getOverviewDebugOutput"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.priority = getPriority();
			local.fullPathUrl = 'http://' & cgi.server_name & getErrorRelativeUrl();
		</cfScript>
		<cfSetting enableCFoutputOnly="no" />
		<cfSaveContent Variable="local.output">
			<style>
				.ErrorWrap {font-size:0.9em;font-family:Arial;}

				.ErrorTable {font-size:0.8em;font-family:Arial;}

				.Priority4 .ErrorTable th
				{background-color:#CCFFCC}
				.Priority5 .ErrorTable th
				{background-color:#FF99CC}
				.Priority3 .ErrorTable th
				{background-color:#EEEEEE}
				.Priority2 .ErrorTable th
				{background-color:#CCFFCC}
				.Priority1 .ErrorTable th
				{background-color:#CCFFCC}

				.ErrorTable th
				{text-align:right;background-color:#EEEEEE;font-size:0.9em}

				.ErrorTable td
				{text-align:left;padding-left:5px}

				.ErrorWrap #Top {color:black;text-decoration:none;}

				.ErrorWrap .TopWrap {text-align:right}

				pre, .Small {font-size:0.7em}
			</style>
			<cfOutput>
				<div class="ErrorWrap">
					<div class="Priority#getPriority()#">
						<cfif getUserRequest().isInternalAddress() >
							<h3>This Error Occurred by a Request From With-in One of Our Own Offices</h3>
						<cfElseif getUserRequest().isBot() >
							<h3>This Error Occurred by a Request From a Web Spider</h3>
						</cfif>
						<table cellPadding="3" cellSpacing="3" border="0" class="ErrorTable">
							<tr>
								<th valign="top">Priority</th>
								<td title="priority:#local.priority#">
									<cfif local.priority GTE 5 >
										Very Severe
									<cfelseif local.priority EQ 4 >
										Severe
									<cfelseif local.priority EQ 3 >
										Mild Severity
									<cfelseif local.priority EQ 2 >
										Warning Only
									<cfelseif local.priority EQ 1 >
										No Action Required
									</cfif>
								</td>
							</tr>
							<cfif structKeyExists(variables, "Message") >
								<tr>
									<th valign="top">Message</th>
									<td>#variables.message#</td>
								</tr>
							</cfif>
							<cfif structKeyExists(variables, "detail") >
								<tr>
									<th valign="top">Detail</th>
									<td>#variables.detail#</td>
								</tr>
							</cfif>
							<tr>
								<th valign="top">Offending URL</th>
								<td class="Small">
									<a href="#local.fullPathUrl#">#local.fullPathUrl#</a>
								</td>
							</tr>
							<cfif len(cgi.http_referer) >
								<tr>
									<th valign="top">Referring Url</th>
									<td>#cgi.http_referer#</td>
								</tr>
							</cfif>
							<tr>
								<th valign="top">Time</th>
								<td>#dateFormat(now(), "short")# #timeFormat(now(), "short")#</td>
							</tr>
							<tr>
								<th>Error Id</th>
								<td>#getErrorId()#</td>
							</tr>
							<cfLoop collection="#variables.consoleVars#" item="local.key">
								<tr>
									<th valign="top">#local.key#</th>
									<td>
										<cfif variables.consoleVars[local.key].isCodeFormat AND isSimpleValue(variables.consoleVars[local.key].variable) >
											#htmlCodeFormat(variables.consoleVars[local.key].variable)#
											<!---#htmlCodeFormat(reReplaceNoCase(variables.consoleVars[local.key].variable, '(\r|\n)', '<br />', 'all'))#--->
										<cfElseif isSimpleValue(variables.consoleVars[local.key].variable) >
											#htmlEditFormat(variables.consoleVars[local.key].variable)#
										<cfElse>
											<cfDump var="#variables.consoleVars[local.key].variable# (top #variables.dumpLimit#)" expand="yes" top="#variables.dumpLimit#" showUDFs="no" />
										</cfif>
									</td>
								</tr>
							</cfLoop>
						</table>
					</div>
				</div>
			</cfOutput>
		</cfSaveContent>
		<cfReturn local.output />
	</cfFunction>

	<cfFunction
		name		= "getExtendedDebugOutput"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.errorRelUrl = getErrorRelativeUrl();
			local.fullPathUrl = 'http://' & cgi.server_name & local.errorRelUrl;
		</cfScript>
		<cfSetting enableCFoutputOnly="no" />
		<cfSaveContent Variable="local.output">
			<h4><a name="Top" id="Top">Quick Links</a></h4>
			<cfOutput>
				<div>
					<cfLoop collection="#variables.dumpScopes#" item="local.keyName">
						<a href="###local.keyName#dump">#local.keyName#</a>&nbsp;&bull;&nbsp;
					</cfLoop>
					<cfLoop array="#variables.linkedServers#" index="local.ls">
						<a href="http://#local.ls.linkedServer & local.errorRelUrl#">GOTO on #local.ls.label#</a>&nbsp;&bull;&nbsp;
					</cfLoop>
					<a href="#local.fullPathUrl#" target="_blank">GOTO!</a>
				</div>
				<br />
				<cfif structKeyExists(variables, "exception") >
					<hr />
					<cfdump var="#variables.exception#" label="Error" top="#variables.dumpLimit#" showUDFs="no" />
				</cfif>
				<cfLoop collection="#variables.dumpScopes#" item="local.keyName">
					<hr />
					<div class="TopWrap">
						<a href="##top" id="#local.keyName#dump" name="#local.keyName#dump" class="Small">Top</a>
					</div>
					<cfTry>
						<cfDump var="#variables.dumpScopes[local.keyName]#" label="#local.keyName# (top #variables.dumpLimit#)" top="#variables.dumpLimit#" showUDFs="no" />
						<cfCatch>
							Cannot Dump the Scope: #local.keyName#
							<h3>Message</h3>
							<p>#cfcatch.message#</p>
							<h4>Detail</h4>
							<p>#cfcatch.detail#</p>
						</cfCatch>
					</cfTry>
				</cfLoop>
			</cfOutput>
		</cfSaveContent>
		<cfReturn local.output />
	</cfFunction>

	<cfFunction
		name		= "writeToFile"
		returnType	= "ErrorHandler"
		access		= "public"
		output		= "no"
		hint		= "output html debug output to a file "
		description	= ""
	>
		<cfArgument name="filePath" required="yes" type="string" hint="" />
		<cfScript>
			FileWrite(arguments.filePath, getDebugOutput());
			return this;
		</cfScript>
	</cfFunction>

</cfComponent>