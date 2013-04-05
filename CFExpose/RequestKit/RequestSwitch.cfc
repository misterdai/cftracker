<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "ClientSideClass"
	accessors	= "yes"
>

	<cfProperty name="CurrentProcessNumber" type="numeric" />
	<cfProperty name="processStruct"		type="struct" />
	<cfProperty name="processNameArray"		type="array" />
	<cfProperty name="processName"			type="string" />
	<cfProperty name="Debug"				type="boolean" />
	<cfProperty name="RemoteRequest"		type="boolean" />
	<cfProperty name="SubmitMode"			type="boolean" />
	<cfProperty name="clientInputStruct"	type="struct" />
	<cfProperty name="MaintainClientInput"	type="boolean" />
	<cfProperty name="UrlAddress"			type="CFExpose.RequestKit.UrlAddress" />
	<cfProperty name="SubmitUrlAddress"		type="CFExpose.RequestKit.UrlAddress" />
	<cfProperty name="UrlAddressStamp"		type="CFExpose.RequestKit.UrlAddress" />
	<cfProperty name="ProcessPropertyArray"	type="struct" setter="no" />
	<cfScript>
		variables.ProcessPropertyArray	= arrayNew(1);
		variables.processStruct			= structNew();
		variables.processNameArray		= arrayNew(1);
	</cfScript>

	<cfFunction
		name		= "setProcessProperty"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			arrayAppend(variables.processPropertyArray, arguments.name);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isProcessNameDefined"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= "checks set processes or if a method name exists"
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfReturn structKeyExists(variables.processStruct, arguments.name) OR structKeyExists(variables, arguments.name) />
	</cfFunction>

	<cfFunction
		name		= "setProcess"
		returnType	= "RequestSwitch"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="processName"				required="yes"	type="variableName"	hint="" />
		<cfArgument name="submitProcessName"		required="no"	type="variableName"	hint="" />
		<cfArgument name="submitFailProcessName"	required="no"	type="variableName" hint="" />
		<cfArgument name="initArguments"			required="no"	type="struct"		hint="" />
		<cfArgument name="appendAfterProcessByName"	required="no"	type="string"		hint="if this argument is defined and a matching name found it will be put in the process que just after the named process" />
		<cfArgument name="viewName"					required="no"	type="string"		hint="" />
		<cfScript>
			if(structKeyExists(arguments, "appendAfterProcessByName"))
			{
				for(local.pNum=1; local.pNum LT arrayLen(variables.processNameArray); ++local.pNum)
				{
					if(variables.processNameArray[local.pNum] EQ arguments.appendAfterProcessByName)
					{
						arguments.processNumber = local.pNum+1;
						arrayInsertAt(variables.processNameArray, arguments.processNumber, arguments.processName);
						break;
					}
				}
			}
			if(!structKeyExists(arguments, "processNumber"))
			{
				arrayAppend(variables.processNameArray, arguments.processName);
				arguments.processNumber = arrayLen(variables.processNameArray);
			}

			arguments.clientInput = structNew();

			variables.processStruct[arguments.processName] = arguments;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isDebug"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.Debug = arguments.yesNo;

			if(!structKeyExists(variables, "Debug"))
				variables.Debug = 0;

			return variables.Debug;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getCurrentProcessNumber"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn getCurrentProcessMetaData().processNumber />
	</cfFunction>

	<cfFunction
		name		= "getProcessNameArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "named order of processes"
	>
		<cfReturn variables.processNameArray />
	</cfFunction>

	<cfFunction
		name		= "isRemoteRequest"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= "signify the type of request currently is remote"
		description	= "remote just means the variable 'isRemoteRequest' is present in client input or simply set by server side code"
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.RemoteRequest = arguments.yesNo;

			if(!structKeyExists(variables, "RemoteRequest"))
				variables.RemoteRequest = structKeyExists(getClientInput(), 'isRemoteRequest');

			return variables.RemoteRequest;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isSubmitMode"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.SubmitMode = arguments.yesNo;

			if(!structKeyExists(variables, "SubmitMode"))
				return structKeyExists(getClientInput(), "submitProcessName");

			return variables.SubmitMode;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getOutput"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			local.cpName = getProcessName();

			if(!len(local.cpName))
				throw
				(
					message='Process Name Not Defined For Output'
					,detail='Component #getMetaData(this).name#'
				);

			//? is a current submit process defined ?
			if(isSubmitMode())
				return submitProcess(local.cpName);

			local.processOutput = getProcessOutputByName(local.cpName);

			return local.processOutput;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRemoteOutput"
		returnType	= "string"
		returnFormat= "plain"
		access		= "remote"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			init(argumentCollection=arguments);

			//any subsequent requests should be forced to include the method parameter
			getUrlAddressStamp().set('method','getRemoteOutput');

			local.isSubmit = isSubmitMode();
			isSubmitMode(local.isSubmit);
			local.cpName = getProcessName();

			/* ensure remote access */
				performRemoteMethodCheck(local.cpName);

				if(isSubmitMode())
				{
					local.submitMethodName = getSubmitProcessName(local.cpName);

					if(len(local.submitMethodName))
						performRemoteMethodCheck(local.submitMethodName);
				}
			/* end */
			local.output = getOutput();

			return local.output;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "performRemoteMethodCheck"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="methodName" required="yes" type="string" hint="" />
		<cfScript>
			local.metaData = getMetaData(variables[arguments.methodName]);

			if(!structKeyExists(local.metaData, 'access') OR local.metaData.access NEQ 'remote')
				CFMethods().throw('RequestSwitch Error, the method "#arguments.methodName#" in component "#getMetaData(this).name#" does not allow remote access');

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSubmitProcessName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processName" required="yes" type="string" hint="" />
		<cfScript>
			local.currentProcessStruct = getProcessMetaData(arguments.processName);

			if(structKeyExists(local.currentProcessStruct, "submitProcessName"))
				return local.currentProcessStruct.submitProcessName;

			local.nextProcessName = getNextProcessName(arguments.processName);

			if( len(local.nextProcessName) )
				return local.nextProcessName;


			return getProcessName();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "submitProcess"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processName" required="yes" type="string" hint="" />
		<cfScript>
			local.isGotoNextProcess = 1;
			local.processStruct = getClientInput();
			local.currentProcessStruct = getProcessMetaData(arguments.processName);
			local.currentProcessName = getProcessName();
			local.isSubmitProcessorDefined = structKeyExists(local.processStruct, "submitProcessName") AND local.processStruct.submitProcessName NEQ arguments.processName;

			if(local.isSubmitProcessorDefined)
				local.submitProcessName = local.processStruct.submitProcessName;
			else
				local.submitProcessName = getSubmitProcessName(arguments.processName);

			//reset client input for the submitting process (incase a checkbox was checked and now is unchecked)
			local.currentProcessStruct.clientInput = local.processStruct;

			/* submit processing detection */
				setProcessName(local.submitProcessName);
				isSubmitMode(1);

				local.submitResult = getProcessOutputByName(local.submitProcessName);

				local.currentProcessStruct.submitResult = local.submitResult;

				local.isReturnString=
				(
					NOT isBoolean(local.submitResult)
				AND	isSimpleValue(local.submitResult)
				);

				//?fail and return
				if(local.isReturnString)
					return local.submitResult;

				local.isSubmitFail = isBoolean(local.submitResult) AND !local.submitResult;
				if(local.isSubmitFail)
				{
					gotoPriorProcess();
					return getProcessOutputByName(getProcessName());
				}

				/* submit fail processor defined? */
					local.isNextProcessHandlerDefined=
					(
						NOT local.submitResult
					AND	structKeyExists(local.currentProcessStruct, "submitFailProcessName")
					);

					if(local.isNextProcessHandlerDefined)
					{
						local.isGotoNextProcess = 0;
						setProcessName(local.currentProcessStruct.submitFailProcessName);
					}
				/* end */
			/* end */

			setProcessName(arguments.processName);//before going to next process, must redefine submit calling process

			if(local.isGotoNextProcess)
				gotoNextProcess();

			//the method used to submit is the same method we are about to run
			if(local.submitProcessName EQ getProcessName())
				return local.submitResult;

			//If execution comes this far, typically it means all processes have been completed and the last step will be returned again
			return getProcessOutputByName(getProcessName());
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getNextProcessName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processName" required="no" type="string" hint="" />
		<cfScript>
			if(!structKeyExists(arguments, 'processName'))
				arguments.processName = getProcessName();

			if(!isProcessDefinedAfterProcessName(arguments.processName))
				return '';

			local.pNum = processNameToNumber(arguments.processName) + 1;

			return processNumberToName(local.pNum);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "processNumberToName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="number" required="yes" type="numeric" hint="" />
		<cfScript>
			return variables.processNameArray[arguments.number];
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "processNameToNumber"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			return variables.processStruct[arguments.name].processNumber;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isProcessDefinedAfterProcessName"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processName" required="yes" type="string" hint="" />
		<cfScript>
			local.processNumber = getProcessMetaData(arguments.processName).processNumber;

			return arrayLen(variables.processNameArray) GT local.processNumber;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getProcessSubmitResult"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processName" required="no" type="string" hint="" />
		<cfScript>
			if(!structKeyExists(arguments, 'processName'))
				arguments.processName = getProcessName();

			return submitProcess(arguments.processName);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "gotoPriorProcess"
		returnType	= "RequestSwitch"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.cpNum = getCurrentProcessNumber();
			local.processNameArray = getProcessNameArray();
			local.isPriorProcessDefined = local.cpNum GT 1;

			if(local.isPriorProcessDefined)
			{
				local.priorProcessName = local.processNameArray[local.cpNum - 1];
				setProcessName(local.priorProcessName);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "gotoNextProcess"
		returnType	= "RequestSwitch"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.cpNum = getCurrentProcessNumber();
			local.processNameArray = getProcessNameArray();
			local.isAdditionalProcessDefined = (arrayLen(local.processNameArray) GT local.cpNum);

			if(local.isAdditionalProcessDefined)
			{
				local.nextProcessName = local.processNameArray[local.cpNum + 1];
				setProcessName(local.nextProcessName);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getProcessTotalCount"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn arrayLen(getProcessNameArray()) />
	</cfFunction>

	<!--- Client Input Methods --->
		<cfFunction
			name		= "readClientInputStruct"
			returnType	= "RequestSwitch"
			access		= "public"
			output		= "no"
			hint		= "reading client input helps determine where and what happens next in the process"
			description	= ""
		>
			<cfScript>
				if(!getProcessTotalCount())
					return this;

				local.ciStruct = getClientInput();
				local.processMenu = getProcessMenuStruct();

				local.processName = getProcessName();

				if(isMaintainClientInput())
				{
					local.isPerProcessStringDefined=structKeyExists(local.ciStruct, "clientInputPerProcessJson");

					if(local.isPerProcessStringDefined)
						local.ciStruct.clientInputPerProcessJson = urlDecode(local.ciStruct.clientInputPerProcessJson);

					local.isPerProcessJsonDefined=
					(
						local.isPerProcessStringDefined
					AND
						isJson(local.ciStruct.clientInputPerProcessJson)
					);

					if(local.isPerProcessJsonDefined)
						local.clientInputPerView = deserializeJson(local.ciStruct.clientInputPerProcessJson);
					else
						local.clientInputPerView = structNew();

					//set client input per process
					for(local.name in local.clientInputPerView)
						if(structKeyExists(local.processMenu,local.name))
						{
							structAppend(local.processMenu[local.name].clientInput, local.clientInputPerView[local.name]);
							setProcessPropertiesByScope(local.clientInputPerView[local.name]);
						}

					structDelete(local.ciStruct, "clientInputPerProcessJson");
				}

				if(isProcessNameDefined(local.processName))
				{
					if(!structKeyExists(local.processMenu, local.processName) )
					{
						local.processMenu[local.processName] = structNew();
						local.processMenu[local.processName].processNumber = 0;
						local.processMenu[local.processName].clientInput = structNew();
					}

					structAppend(local.processMenu[local.processName].clientInput, local.ciStruct);
				}

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getClientInputPerProcessJson"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				local.returnStruct = structNew();
				local.processMenuStruct = getProcessMenuStruct();

				for(local.processName in local.processMenuStruct)
				{
					if(structCount(local.processMenuStruct[local.processName].clientInput))
						local.returnStruct[local.processName] = local.processMenuStruct[local.processName].clientInput;
				}

				if(structCount(local.returnStruct))
					return serializeJson(local.returnStruct);

				return '';
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setClientInputStruct"
			returnType	= "RequestSwitch"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="struct" required="yes" type="struct" hint="" />
			<cfScript>
				variables.clientInputStruct = arguments.struct;
				readClientInputStruct();
				setProcessPropertiesByScope(variables.clientInputStruct);

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setProcessPropertiesByScope"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="struct" required="yes" type="struct" hint="" />
			<cfScript>
				if(!arrayLen(variables.processPropertyArray))
					return this;

				for(local.keyName in arguments.struct)
				{
					local.nameFind = arrayFindNoCase(variables.processPropertyArray, local.keyName);
					if(local.nameFind)
						evaluate('set#local.keyName#(urlDecode(arguments.struct[local.keyName]))');
				}

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getClientInput"
			returnType	= "struct"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "url and form struct act as client input when not defined"
		>
			<cfArgument name="processName" required="no" type="string" hint="" />
			<cfScript>
				local.isProcessDefined = structKeyExists(arguments, "processName") and isProcessNameDefined(arguments.processName);

				if(local.isProcessDefined)
					return getProcessMetaData(arguments.processName).clientinput;

				if( NOT structKeyExists(variables, "clientInputStruct") )
				{

					variables.clientInputStruct = structNew();
					structAppend(variables.clientInputStruct, url);
					structAppend(variables.clientInputStruct, form);
					setClientInputStruct(variables.clientInputStruct);
				}

				return variables.ClientInputStruct;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isMaintainClientInput"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			hint		= "all data will be placed into a struct by process name & cut into url addresses a json variable that represents that input"
			description	= ""
		>
			<cfArgument name="yesNo" required="no" type="boolean" hint="" />
			<cfScript>
				if(structKeyExists(arguments, "yesNo"))
					variables.MaintainClientInput = arguments.yesNo;

				if(!structKeyExists(variables, "MaintainClientInput"))
					variables.MaintainClientInput = 1;

				return variables.MaintainClientInput;
			</cfScript>
		</cfFunction>
	<!--- end : Client Input Methods --->

	<cfFunction
		name		= "getDebugScopes"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			var debugging=
			{
				 isMaintainClientInput	= isMaintainClientInput()
				,getClientInput			= getClientInput()
				,getProcessName			= getProcessName()
				,getProcessMenuStruct	= getProcessMenuStruct()
			};

			return debugging;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getViewByName"
		returnType	= "CFExpose.RequestKit.View"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfArgument name="initArguments" required="no" type="struct" default="#structNew()#" hint="" />
		<cfScript>
			local.View = new(arguments.name, arguments.initArguments);

			local.SubmitUrl = getSubmitUrlAddress();
			local.View.setSubmitUrlAddress(local.SubmitUrl);

			return local.View;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getProcessOutputByName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="name"	required="yes"	type="variableName"	hint="" />
		<cfScript>
			local.processMetaData = getProcessMetaData(arguments.name);

			local.priorProcessName = getPriorProcessName();
			local.clientInputStruct = getClientInput(local.priorProcessName);
			structAppend(local.clientInputStruct, getClientInput());

			/* build init arguments */
				local.initArguments = structNew();

				if(structKeyExists(local.processMetaData, "initArguments"))
					structAppend(local.initArguments, local.processMetaData.initArguments);

				structAppend(local.initArguments, local.clientInputStruct);
			/* end: build init arguments */

			/* get output by view */
				if(structKeyExists(local.processMetaData, "viewName"))
					return getViewByName(local.processMetaData.viewName, local.initArguments).getOutput();
			/* end: output by view */

			/* get output by method invokation */
				local.isMethodDefined=
				(
					structKeyExists(this, arguments.name)
				OR	structKeyExists(variables, arguments.name)
				);

				if(local.isMethodDefined)
				{
					local.cpName = getProcessName();
					local.methodMetaData = getMetaData(variables[arguments.name]);

					local.result = evaluate("#arguments.name#(argumentCollection=local.clientInputStruct)");

					if(structKeyExists(local, 'result') AND isSimpleValue(local.result))
					{
						if(local.cpName neq getProcessName())
							return local.result;

						local.processLayout = getProcessLayout(local.result, arguments.name);
						return local.processLayout;
					}

					if(structKeyExists(local, "result"))
					{
						if(!structKeyExists(url, 'returnFormat'))
							url.returnformat = 'json';
						return serializeJson(local.result);
					}

					CFMethods().throw(message='The method "#local.methodMetaData.name#" returned void', detail='All process methods, must return a value');
				}
			/* end: output by method invokation */

			/* the process could not be found, output the prior process */
				local.priorProcessName = getPriorProcessName();

				if(len(local.priorProcessName))
					return getProcessOutputByName(getPriorProcessName());
			/* end */
		</cfScript>
		<cfThrow
			message	= "The process '#arguments.name#', cannot be found"
			detail	= "No view defined and the component '#getMetaData(this).name#', is missing a method named '#arguments.name#'"
		/>
	</cfFunction>

	<cfFunction
		name		= "setUrlAddress"
		returnType	= "RequestSwitch"
		access		= "public"
		output		= "no"
		description	= "accepts string"
		hint		= ""
	>
		<cfArgument name="UrlAddress" required="yes" type="any" hint="accepts string" />
		<cfScript>
			if(isSimpleValue(arguments.UrlAddress))
				arguments.UrlAddress = new('UrlAddress').init(arguments.UrlAddress);

			variables.UrlAddress = arguments.UrlAddress.setVar('ProcessName', getProcessName());

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getUrlAddress"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "UrlAddress") )
				variables.UrlAddress = getProcessUrlAddress();

			return variables.UrlAddress;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setSubmitUrlAddress"
		returnType	= "RequestSwitch"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="SubmitUrlAddress" required="yes" type="string" hint="" />
		<cfScript>
			if(isSimpleValue(arguments.SubmitUrlAddress))
				arguments.SubmitUrlAddress = getUrlAddress().init(arguments.SubmitUrlAddress);

			variables.SubmitUrlAddress = arguments.SubmitUrlAddress;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSubmitUrlAddress"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="processName"			required="no"	type="string"	hint="" />
		<cfArgument name="submitProcessName"	required="no"	type="string"	hint="" />
		<cfScript>
			arguments.UrlAddress = getProcessUrlAddress(argumentCollection=arguments);

			addSubmitTokenToUrlAddress(argumentCollection=arguments);
			return arguments.UrlAddress;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getReboundSubmitUrlAddress"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processName" required="no" type="string" hint="" />
		<cfScript>
			if(!structKeyExists(arguments, 'processName'))
				arguments.processName = getProcessName();

			local.UrlAddress = getReboundUrlAddress();
			addSubmitTokenToUrlAddress(UrlAddress=local.UrlAddress, processName=arguments.processName);

			return local.UrlAddress;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "addSubmitTokenToUrlAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="UrlAddress"			required="yes"	type="CFExpose.RequestKit.UrlAddress" hint="" />
		<cfArgument name="processName"			required="no"	type="string"	hint="" />
		<cfArgument name="submitProcessName"	required="no"	type="string"	hint="" />
		<cfScript>
			if(!structKeyExists(arguments, "processName"))
				arguments.processName = getProcessName();

			if(!structKeyExists(arguments, 'submitProcessName'))
			{
				local.metaData = getProcessMetaData(arguments.processName);

				if(structKeyExists(local, "metaData") AND structKeyExists(local.metaData, "submitProcessName"))
					arguments.submitProcessName = local.metaData.submitProcessName;
				else
					arguments.submitProcessName = arguments.processName;
			}

			arguments.UrlAddress.setVar('submitProcessName', arguments.submitProcessName);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSubmitUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn getSubmitUrlAddress().getString() />
	</cfFunction>

	<cfFunction
		name		= "setUrlAddressStamp"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "url that will be cloned for every url address usage by all other methods"
		description	= ""
	>
		<cfArgument name="UrlAddressStamp" required="yes" type="any" hint="" />
		<cfScript>
			if(isSimpleValue(arguments.UrlAddressStamp))
				arguments.UrlAddressStamp = new('UrlAddress').init(arguments.UrlAddressStamp);

			variables.UrlAddressStamp = arguments.UrlAddressStamp;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getUrlAddressStamp"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		hint		= "url that will be cloned for every url address usage by all other methods"
		description	= ""
	>
		<cfScript>
			if( !structKeyExists(variables, "UrlAddressStamp") )
			{
				local.urlString = cgi.script_name;

				variables.UrlAddressStamp = new('UrlAddress').init(local.urlString);

				/*
				//not safe to assume (example: after a delete, that id would get passed around )
				if(len(cgi.query_string))
					local.urlString = local.urlString & '?' & urlDecode(cgi.query_string);
				*/

				variables.UrlAddressStamp.delete('submitProcessName');
			}

			return variables.UrlAddressStamp;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getReboundUrlAddress"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		hint		= "best for remote processes to pick-up their remote address based on the current request"
		description	= ""
	>
		<cfScript>
			local.urlString = cgi.script_name;

			//not safe to assume (example: after a delete, that id would get passed around )
			if(len(cgi.query_string))
				local.urlString = local.urlString & '?' & cgi.query_string;

			local.UrlAddress = new UrlAddress(local.urlString);

			return local.UrlAddress;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getProcessUrlAddress"
		returnType	= "UrlAddress"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="processName" required="no" type="string" hint="" />
		<cfScript>
			if(!structKeyExists(arguments, "processName"))
				arguments.processName = getProcessName();

			local.UrlAddress = duplicate(getUrlAddressStamp());
			setUrlAddressVariables(local.UrlAddress, arguments.processName);

			return local.UrlAddress;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getProcessUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="processName" required="no" type="string" hint="" />
		<cfReturn getProcessUrlAddress(argumentCollection=arguments).getString() />
	</cfFunction>

	<cfFunction
		name		= "setUrlAddressVariables"
		returnType	= "RequestSwitch"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="UrlAddress"	required="yes"	type="UrlAddress" hint="" />
		<cfArgument name="processName"	required="no"	type="string" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "processName"))
				arguments.UrlAddress.setVar('processName', arguments.processName);


			/* set process properties */
				local.ppArray = getProcessPropertyArray();
				for(local.ppIndex=arrayLen(local.ppArray); local.ppIndex GT 0; --local.ppIndex)
				{
					local.value = evaluate('get'&local.ppArray[local.ppIndex]&'()');

					if(structKeyExists(local, "value"))
						arguments.UrlAddress.set(local.ppArray[local.ppIndex],local.value);
				}
			/* end */


			if(isMaintainClientInput())
			{
				local.cIPVJ = getClientInputPerProcessJson();

				if(len(local.cIPVJ))
					arguments.UrlAddress.setVar('clientInputPerProcessJson', local.cIPVJ);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setProcessName"
		returnType	= "RequestSwitch"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="processName" required="yes" type="variableName" hint="" />
		<cfScript>
			if(structKeyExists(variables,'submitMode'))
				isSubmitMode(0);//take us out of submit mode, the current process has changed

			variables.ProcessName = arguments.processName;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPriorProcessName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "may return first processName if currently on first process. May return empty-string when no processes defined"
	>
		<cfScript>
			local.cpNum = getCurrentProcessNumber();
			local.processNameArray = getProcessNameArray();

			if(!arrayLen(local.processNameArray) OR local.cpNum EQ 1)
				return '';

			if(local.cpNum GT 1)
				local.cpNum = local.cpNum - 1;

			if(local.cpNum LT 1)
				local.cpNum = 1;

			return local.processNameArray[local.cpNum];
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isFirstProcess"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return getCurrentProcessNumber() eq 1;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isLastProcess"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return getCurrentProcessNumber() eq getProcessTotalCount();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getProcessName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			local.result=structKeyExists(variables, "ProcessName");

			/* detect current process name within client scope */
				if(NOT structKeyExists(variables, "ProcessName"))
				{
					local.clientInputStruct = getClientInput();

					if
					(
						structKeyExists(local.clientInputStruct, "processName")
					AND
						isProcessNameDefined(local.clientInputStruct.processName)
					)
					{
						//local.isSubmit = isSubmitMode();//record submit mode
						variables.ProcessName = local.clientInputStruct.processName;
						//isSubmitMode(local.isSubmit);//re-establish submit mode
						structDelete(local.clientInputStruct, "processName");
					}
				}
			/* end */

			//? no current process defined
			if(NOT structKeyExists(variables, "ProcessName") AND arrayLen(variables.processNameArray))
				variables.ProcessName = variables.processNameArray[1];

			if(NOT structKeyExists(variables, "ProcessName"))
				return '';
				//CFMethods().throw('No Processes Defined in Component "#getMetaData(this).name#"');

			return variables.ProcessName;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getCurrentProcessMetaData"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn getProcessMetaData(getProcessName()) />
	</cfFunction>

	<cfFunction
		name		= "getProcessDefinitions"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= "contains all set process metadata"
		description	= ""
	>
		<cfReturn variables.processStruct />
	</cfFunction>
	<cfset getProcessMenuStruct = getProcessDefinitions  />
	<cfset getProcessStruct = getProcessMenuStruct />

	<cfFunction
		name		= "getProcessMetaData"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "if process meta data not defined, returns bare struct with basic attributes such as processNumber=0"
	>
		<cfArgument name="processName" required="no" type="string" hint="" />
		<cfScript>
			if(getProcessTotalCount())
			{
				local.processStruct = getProcessMenuStruct();

				if(NOT structKeyExists(arguments, "processName"))
					arguments.processName = getProcessName();

				if(structKeyExists(local.processStruct, arguments.processName))
				{
					local.Process = local.processStruct[arguments.processName];
					return local.Process;
				}
			}

			local.return.processNumber = 0;
			local.return.clientInput = structNew();

			return local.return;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getProcessMetaDataByNumber"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processNumber" required="yes" type="numeric" hint="" />
		<cfScript>
			local.menuStruct = getProcessMenuStruct();
			local.processName = variables.processNameArray[arguments.processNumber];

			return local.menuStruct[local.processName];
		</cfScript>
		<cfReturn  />
	</cfFunction>

	<cfFunction
		name		= "getProcessLayout"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="body"		 	required="yes"	type="string"		hint="" />
		<cfArgument name="processName"	required="yes"	type="variableName"	hint="" />
		<cfset local.output = arguments.body />
		<cfif isDebug() >
			<cfSaveContent Variable="local.debugOutput">
				<cfDump var="#getDebugScopes()#" label="Debug Dump" expand="no" />
			</cfSaveContent>
			<cfset local.output &= local.debugOutput />
		</cfif>
		<cfReturn local.output />
	</cfFunction>

	<cfFunction
		name		= "paramClientInput"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="keyName"		required="yes"	type="string"	hint="" />
		<cfArgument name="defaultValue"	required="yes"	type="any"		hint="if undefined, set and returned" />
		<cfArgument name="processName"	required="no"	type="string"	hint="default is current process" />
		<cfScript>
			if(structKeyExists(arguments, "processName"))
				local.clientInput = getClientInput(arguments.processName);
			else
				local.clientInput = getClientInput();

				if(structKeyExists(local.clientInput, arguments.keyName))
					return local.clientInput[arguments.keyName];
				local.clientInput[arguments.keyName] = arguments.defaultValue;

				return arguments.defaultValue;
		</cfScript>
	</cfFunction>

</cfComponent>