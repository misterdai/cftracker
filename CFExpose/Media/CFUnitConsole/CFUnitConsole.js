CFUnitConsole_array = [];

CFUnitConsole = function()
{
	this.id 							= CFUnitConsole_array.length;
	this.is_auto_invoke					= false;
	//this.objectInputContainerId		= null;
	this.returnStringFormatMode			= 'textarea';
	this.formElementId					= null;
	this.isReturnQuerySqlString			= false;
	this.defaultOptionArray				= [];//{value:value,title:title,typeName:typeName}
	//this.selectNextVariableElementId	= null;
	this.inputMode						= 'input';
	this.animationSpeed					= 500;
	this.ucWrapId						= null;

	//memory needed for form of arguments call back onsubmit
	CFUnitConsole_array[CFUnitConsole_array.length] = this;

	return this;
};

/* debug methods */
	CFUnitConsole.prototype.isDebug = function(yesNo)
	{
		if(yesNo!=null)
			this.isDebugMode = yesNo;
		else if(this.isDebugMode==null)
			this.isDebugMode=0;

		return this.isDebugMode
	}

	CFUnitConsole.prototype.log = function(msg)
	{
		if(!this.isDebug())return;

		msg = 'CFUC: '+msg;

		if(typeof(console) != 'undefined' && typeof(console.log) != 'undefined')
			console.log(msg)

		if(typeof(ColdFusion) != 'undefined')
			ColdFusion.Log.info(msg , 'CFUnitConsole');
	}
/* end : debug methods */

/* SETS */

	CFUnitConsole.prototype.submitFormToNewWindow = function()
	{
		var form = this.getFormElement();
		form.target = '_blank';
		this.applyFormAction();
		form.submit();
	}

	CFUnitConsole.prototype.setDefaultOption = function(value, title, typeName, className,parameters)
	{
		this.defaultOptionArray.push({value:value,title:title,typeName:typeName, className:className, parameters:parameters})
	}

	CFUnitConsole.prototype.setFormElementId = function(id)
	{this.formElementId = id}

	CFUnitConsole.prototype.applyFormAction = function()
	{this.getFormElement().action = this.getDumpStringURL()}

	/*
	CFUnitConsole.prototype.setSelectNextVariableElementId = function(id)
	{this.selectNextVariableElementId = id}
	*/

	CFUnitConsole.prototype.setNextNodePickerContainerElementId = function(id)
	{this.nextNodePickerContainerElementId = id}

	CFUnitConsole.prototype.set_auto_invoke_mode = function(mode)
	{this.is_auto_invoke = mode}

	CFUnitConsole.prototype.setFormatStringReturnsMode = function(mode)
	{this.returnStringFormatMode=mode}

	CFUnitConsole.prototype.setSubFunctionCode = function(s)
	{this.getSubFunctionEvaluateCodeInputElement().value=s}
/* end */

/* GETS */
	CFUnitConsole.prototype.getFormElement = function()
	{return document.getElementById(this.getFormElementId())}

	CFUnitConsole.prototype.getTextAreaSyntaxElement = function()
	{return jQuery('.FunctionCode',this.getFormElement())[0]}

	CFUnitConsole.prototype.getSubFunctionEvaluateCodeInputElement = function()
	{return jQuery('.SubFunctionEvaluateCode',this.getFormElement())[0]}

	CFUnitConsole.prototype.getDumpContainerId = function()
	{return this.dumpContainerId}

	CFUnitConsole.prototype.getFormElementId = function()
	{return this.formElementId}

	CFUnitConsole.prototype.getSubFunctionEvaluateCode = function()
	{return this.getSubFunctionEvaluateCodeInputElement().value}

	CFUnitConsole.prototype.getFunctionCode = function()
	{return this.getTextAreaSyntaxElement().value}

	CFUnitConsole.prototype.getStringCallbackReference=function()
	{return 'CFUnitConsole_array['+this.id+']'}

	CFUnitConsole.prototype.getSyntaxNotation = function()
	{
		var local = {notation:this.getTextAreaSyntaxElement().value}

		local.notation = local.notation.replace(/\/\*.*?\*\//mg,'');//remove comments
		local.notation = local.notation.replace(/\/\/[^\r\n]+/mg,'');//remove line comments
		local.notation = local.notation.replace(/<!--.*?-->/mg,'');//remove comments
		local.notation = local.notation.replace(/(\r|\n)+(\t|\s)*\./mg,'.');
		local.notation = local.notation.replace(/(^[\s\t\r\n]+)|([\s\t\r\n]+$)/,'');

		/*
		if( local.notation.charAt(local.notation.length-1) == ';' )
			local.notation = local.notation.substring(0, local.notation.length-1);
		*/

		return local.notation;
	}

	CFUnitConsole.prototype.getMethodCallback = function(method)
	{
		var returnMethod = function(a,b,c,d,e){return arguments.callee.eventProcessor.call(arguments.callee.owner,a,b,c,d,e)}
		returnMethod.eventProcessor = method
		returnMethod.owner = this
		return returnMethod
	}
/* END */

CFUnitConsole.prototype.back = function()
{
	var local={};

	local.SubElement = this.getSubFunctionEvaluateCodeInputElement();
	local.newString	= local.SubElement.value;
	local.newString = this.backDotNotationString(local.newString);
	local.SubElement.value = local.newString;

	this.testNode();
}

CFUnitConsole.prototype.backDotNotationString = function(string)
{
	string = string.replace(/\([^\(]+\)$/,'');//remove ending parenthesis

	if(string.search(/\]$/) > -1)
		return string.replace(/\[[^\]]+\]$/,'');//remove ending bracets

	return string.replace(/\.?[^.]*$/,'');//remove ending notation
}

CFUnitConsole.prototype.animatePopulateDefaultOptions = function()
{
	var local = {};
	local.NodePickerWrap = document.getElementById(this.nextNodePickerContainerElementId);
	jQuery(local.NodePickerWrap).slideUp(this.animationSpeed, this.getMethodCallback(this.populateDefaultOptions))
}

CFUnitConsole.prototype.populateDefaultOptions = function()
{
	if(this.getSyntaxNotation().length)
		return;

	if(this.nextNodePickerContainerElementId != null)
	{
		var local = {};

		document.getElementById(this.nextNodePickerContainerElementId).innerHTML = '';

		for(local.x=0; local.x < this.defaultOptionArray.length; ++local.x)
			this.appendNodeOption(this.defaultOptionArray[local.x].title, this.defaultOptionArray[local.x].value, this.defaultOptionArray[local.x].typeName, this.defaultOptionArray[local.x].parameters);
	}

	this.showVariablePanel()
}

CFUnitConsole.prototype.prependNodeOption = function(title, value, typeName)//!return Html DOM Element
{
	var NewOption = this.createNodeOption(title, value, typeName);
	jQuery(document.getElementById(this.nextNodePickerContainerElementId)).prepend(NewOption);
	return NewOption;
}

CFUnitConsole.prototype.appendNodeOption = function(title, value, typeName, parameters)//!return Html DOM Element
{
	var NewOption = this.createNodeOption(title, value, typeName);

	if(parameters)
		NewOption.parameters = parameters;

	jQuery(document.getElementById(this.nextNodePickerContainerElementId)).append(NewOption);
	return NewOption;
}

CFUnitConsole.prototype.createNodeOption = function(title, value, typeName)
{
	var local={div:document.createElement('a')};

	local.jDiv = jQuery(local.div).addClass('selectable');

	local.div.innerHTML = title;
	local.jDiv.attr("nodeSyntax", value).attr('type',typeName);

	/* click event */
		local.action = function(){arguments.callee.owner.testSelectedNode(this)};
		local.action.owner = this;

		local.jDiv.click(local.action);
	/* end */

	if(typeName)
		local.jDiv.addClass(typeName);

	return local.div;
}

CFUnitConsole.prototype.testNode = function(name)
{
	var local = {};

	local.Elm = this.getSubFunctionEvaluateCodeInputElement();
	local.Elm.value = local.Elm.value.replace(/\.(\t|\s)+$/,'');//accidental dots,tabs, or spaces

	if(name != null)
		this.appendNotation(name)

	if(!local.Elm.value.length && !this.getSyntaxNotation().length)
		return this.animatePopulateDefaultOptions();

	this.dump();
}

/*
CFUnitConsole.prototype.getSelectablesElement = function()
{return document.getElementById('selectVariable')}
*/

CFUnitConsole.prototype.testSelectedNode = function(node)
{
	var local={};

	local.node			= jQuery(node);
	local.type			= local.node.attr('type');//unused
	local.parameters	= local.node[0].parameters;
	local.nodeSyntax	= local.node.attr("nodeSyntax");

	if(local.type && local.type == 'BackButton')
		return this.back();

	this.lastSelectedValue = local.nodeSyntax;

	if(local.parameters == null)
		return this.testNode(local.nodeSyntax);

	if(local.parameters.length==0)
		return this.testNode(local.nodeSyntax+'()');

	/* check existence of defined parameters *///options[local.x].type == 'function'

		local.requiredFound = false;
		// see if we can autoinvoke
			if(this.is_auto_invoke)
			{
				for(local.x=0; local.x < local.parameters.length; ++local.x)
				{
					if(local.parameters[local.x].required)
					{
						local.requiredFound = true;
						break;
					}
				}
			}
		// end

		//decide to auto invoke method call or not
			if
			(
				local.parameters.length
			&&
				(
					!this.is_auto_invoke
				||
					local.requiredFound
				)
			)
			{
				this.awaiting_parameters	= local.parameters;

				local.location				= this.getArgumentParameterFormUrl();
				local.vars					= 'onSubmit='+this.getStringCallbackReference()+'.submitArguments&targetMethod='+local.nodeSyntax;
				local.location				= this.addUrlVarOntoUrl(local.vars, local.location);

				ColdFusion.Window.create
				(
					'ArgumentSpecificationWindow',
					'Specify Argument Collection',
					null,
					{modal:false,closable:true,draggable:true,resizable:true,initshow:true,center:true,width:750,height:450}
				);

				ColdFusion.navigate(local.location , 'ArgumentSpecificationWindow', null, null, 'post', this.getFormElementId());

				return true;
			}
		//end
	/* end */
}

CFUnitConsole.prototype.limitSelectablesToFind = function(value)
{
	var local = {Select:document.getElementById(this.nextNodePickerContainerElementId)}

	if(typeof(this.SelectablesRemovedElement)=='undefined')
		this.SelectablesRemovedElement = document.createElement('div');

	value			= value.toLowerCase();
	local.reggy		= new RegExp(value, 'i');

	/* put back on */
		for(local.x=0; local.x < this.SelectablesRemovedElement.childNodes.length; ++local.x)
		{
			local.option	= this.SelectablesRemovedElement.childNodes[local.x];
			local.text		= local.option.innerHTML.toLowerCase();

			if(jQuery(local.option).attr('type') == 'BackButton')
				continue;

			if(local.text.search(local.reggy) > -1)
			{
				local.option.style.display='none';
				local.Select.appendChild(local.option);
				jQuery(local.option).slideDown();
				--local.x;
			}
		}
	/* end */

	/* take off */
		local.selectableArray = jQuery('.selectable',local.Select);
		for(local.x=local.selectableArray.length-1; local.x > -1; --local.x)
		{
			local.option	= local.selectableArray[local.x];

			local.text		= local.option.innerHTML.toLowerCase();

			if(local.text.search(local.reggy) < 0)
			{
				local.method = function(){arguments.callee.Owner.SelectablesRemovedElement.appendChild(this)}
				local.method.Owner = this;
				jQuery(local.option).slideUp(null, local.method)
			}
		}
	/* end */
}

CFUnitConsole.prototype.getLastSelectedValue = function()
{return this.lastSelectedValue}

CFUnitConsole.prototype.displayError = function(error , b , c)
{
	this.createErrorWindow();
	ColdFusion.Window.getWindowObject('error_window').body.dom.innerHTML = error;
	ColdFusion.Window.show('error_window');
}

CFUnitConsole.prototype.createErrorWindow=function()
{
	if( !this.isErrorWindowCreated )
	{
		ColdFusion.Window.create(
			'error_window',
			'ColdFusion Error Occured!',
			null,
			{
				width		: 700,
				height		: 480,
				modal		: false,
				closable	: true,
				draggable	: true,
				resizable	: true
			}
		);

		ColdFusion.Window.getWindowObject('error_window').center();
		ColdFusion.Window.getWindowObject('error_window').body.dom.style.padding	= 10;
		this.isErrorWindowCreated=1
	}
}

CFUnitConsole.prototype.submitArguments = function( target_form )
{

	var local = {target_form:target_form};

	local.target_form.name	= 'submitArgumentForm';
	local.target_form.id	= 'submitArgumentForm';

	local.args			= [];
	local.argumentNames = [];
	local.argumentNameInputs = local.target_form.argumentNames;

	if( typeof(local.argumentNameInputs.type) == 'undefined' )
		for( local.x=0; local.x < local.argumentNameInputs.length; ++local.x)
			local.argumentNames[local.argumentNames.length] = local.argumentNameInputs[local.x].value;
	else
		local.argumentNames[0] = local.argumentNameInputs.value;

	/* discover value */
		for( local.x=0; local.x < local.argumentNames.length; ++local.x )
		{
			local.name		= local.argumentNames[local.x];
			local.input		= local.target_form[ local.name+'_value' ];
			local.isValue	= local.target_form[ local.name+'_isValue' ];
			local.value		= null;

			if( local.isValue.checked )
			{
				if(
					typeof(local.input.type) == 'undefined'
				&&
					local.input.length > 1
				&&
					(local.input[0].type.toLowerCase() == 'checkbox' || local.input[0].type.toLowerCase() == 'radio' )
				)
				{
					for(local.y=0; local.y < local.input.length; ++local.y)
					{
						if( local.input[local.y].checked )
						{
							local.value = local.input[local.y].value;
							break;
						}
					}
				}else if(local.input.type=='text' || local.input.type=='password' || local.input.type=='textarea')
					local.value = local.input.value;

				local.args[local.args.length] = { name:local.name , value:local.value };
			}else
				local.args[local.args.length] = { name:local.name , value:null };
		}
	/* end */

	/* send values for invokation */
		for(local.x=0; local.x < this.awaiting_parameters.length; ++local.x)
		{
			for(local.y=0; local.y < local.args.length; ++local.y)
			{
				/* json name? */
					if(this.awaiting_parameters[local.x].name)
						local.name = this.awaiting_parameters[local.x].name;
					else
						local.name = this.awaiting_parameters[local.x].NAME;

					this.awaiting_parameters[local.x].name = local.name;
				/* end */

				if( local.args[local.y].name.toLowerCase() == local.name.toLowerCase() )
				{
					if( local.args[local.y].value == null )
						this.awaiting_parameters[local.x].value = null;
					else
						this.awaiting_parameters[local.x].value = local.args[local.y].value;
					break;
				}
			}
		}
	/* end */

	ColdFusion.Window.hide('ArgumentSpecificationWindow');

	local.subCode = this.getSubFunctionEvaluateCode();
	if(local.subCode.length)
		local.subCode += '.';

	local.notation = local.subCode + local.target_form.targetMethod.value + '(' + this.getInvokeArgumentsString(this.awaiting_parameters) + ')';
	this.getSubFunctionEvaluateCodeInputElement().value = local.notation;
	this.dump();
	//this.getNextChild();
}

CFUnitConsole.prototype.appendNotation = function(notation)
{
	var local = {};

	local.SubElement = this.getSubFunctionEvaluateCodeInputElement();

	if(local.SubElement.value.length)
	{
		if(notation.search(/\./) > -1)
			notation = '["'+notation+'"]';
		else
			local.SubElement.value += '.';
	}

	local.SubElement.value += notation;
}

CFUnitConsole.prototype.getInvokeArgumentsString = function(parameters)
{
	var local = {};

	local.return_string = "";
	local.each_array	= new Array();

	for(local.x=0; local.x < parameters.length; ++local.x)
	{
		if(parameters[local.x].value != null)
		{
			if(isNaN(parameters[local.x].value))
				local.setTo = '"' + parameters[local.x].value.replace(/"/g,'""') + '"';
			else
				local.setTo = parameters[local.x].value;

			local.each_array[local.each_array.length] = parameters[local.x].name + '=' + local.setTo;
		}
	}

	local.return_string = local.each_array.join(" , ");

	return local.return_string;
}

CFUnitConsole.prototype.animateAppendNewChild = function(options)
{
	this.newOptions = options;
	this.hideVariablePanel(this.getMethodCallback(this.appendNewChild));
}

CFUnitConsole.prototype.hideVariablePanel = function(callback)
{
	var local = {}
	local.NodePickerWrap = document.getElementById(this.nextNodePickerContainerElementId);
	jQuery(local.NodePickerWrap).slideUp(this.animationSpeed, callback);
}

CFUnitConsole.prototype.checkAdjustDisplayForPreviousVariable = function()
{
	if(this.getSubFunctionEvaluateCode().length || this.getFunctionCode().length)
	{
		this.prependNodeOption('&lt;&nbsp;Previous Variable','','BackButton');

		this.showVariablePanel();
	}
}

CFUnitConsole.prototype.showVariablePanel = function()
{jQuery(document.getElementById(this.nextNodePickerContainerElementId)).slideDown(this.animationSpeed)}

CFUnitConsole.prototype.appendNewChild = function(options)
{
	var local = {};

	if(options==null)
		options = this.newOptions;

	this.log('Appending '+options.length+' Options');

	/*
	local.select = this.getSelectablesElement();
	local.select.options.length = 0;
	local.select.options[0] = new Option("","");//for single select:show first option shows as blank. for multi:allows on change to occur
	*/

	document.getElementById(this.nextNodePickerContainerElementId).innerHTML = '';

	for(local.x=0; local.x < options.length; ++local.x)
	{
		local.type = options[local.x].type.toLowerCase();

		if(local.type == 'function')
			local.returnType = options[local.x].returntype.toLowerCase();
		else
			local.returnType = options[local.x].type.toLowerCase();

		local.hasValidOptions = true;

		if(options[local.x].isreturncomponent)
			local.returnTypeCode = 'component';
		else
			local.returnTypeCode = local.returnType;

		local.text	= options[local.x].name;
		local.div	= this.appendNodeOption(local.text, options[local.x].name, local.returnTypeCode);

		local.isReturnComponent = options[local.x].isreturncomponent ? true : false;

		local.div = jQuery(local.div).attr('isreturncomponent',local.isReturnComponent).attr('type', local.type);

		if(local.type == 'function')
		{
			local.div[0].parameters = options[local.x].parameters;
			local.div[0].innerHTML +=  '()';

			/* build title hint */
				local.hint = '';
				if(typeof(options[local.x].access)=='undefined')
					options[local.x].access = 'public';

				local.hint += ' -Access: '+options[local.x].access;

				local.hint += ' -Return-Type: '+local.returnType;

				if(options[local.x].isextendedmethod)
					local.hint += '\r\t -Extended From:' + options[local.x].extendedbyname;

				if(typeof(options[local.x].hint)==typeof('') && options[local.x].hint.length)
					local.hint += '\r\t-'+options[local.x].hint;

				local.div.attr('title',local.hint);
			/* end */

			if(options[local.x].isextendedmethod)
				local.div[0].style.color = '#555555';
		}

		local.div.attr("backgroundColorMemory", local.div[0].style.backgroundColor);
	}

	this.checkAdjustDisplayForPreviousVariable();

	return true;
}

/* url gets and sets */
	CFUnitConsole.prototype.setDumpUrl = function(url)
	{this.dumpUrl=url}

	CFUnitConsole.prototype.setSampleDumpUrl = function(url)
	{this.sampleDumpUrl=url}

	CFUnitConsole.prototype.setKeysUrl = function(url)
	{this.keysUrl=url}

	CFUnitConsole.prototype.setArgumentParameterFormUrl = function(url)
	{this.argumentParameterFormUrl = url}

	CFUnitConsole.prototype.getDumpUrl = function()
	{return this.dumpUrl}

	CFUnitConsole.prototype.getKeysUrl = function()
	{return this.keysUrl}

	CFUnitConsole.prototype.getSampleDumpUrl = function()
	{return this.sampleDumpUrl}

	CFUnitConsole.prototype.getArgumentParameterFormUrl = function()
	{return this.argumentParameterFormUrl}
/* end */

CFUnitConsole.prototype.getDumpStringURL = function()
{
	var local = {returnString:'' , dumpSetupCollection:this.getDumpSetupCollection()}
	for(local.x in local.dumpSetupCollection)
		local.returnString += (local.returnString.length ? '&' : '') + local.x +'='+ local.dumpSetupCollection[local.x].toString();

	return this.addUrlVarOntoUrl(local.returnString, this.getDumpUrl());
}


CFUnitConsole.prototype.addUrlVarOntoUrl = function(urlvar, url)
{return url + (url.search(/\?/) > -1 ? '' : '?') + (url.search(/\?.+/) > -1 ? '&' : '') + urlvar}

CFUnitConsole.prototype.getDumpSetupCollection=function()
{
	var local=
	{
		 SubFunctionEvaluateCode		: this.getSyntaxNotation()
		,returnStringFormatMode			: this.returnStringFormatMode
		,isReturnUnformattedQuerySql	: this.isReturnQuerySqlString
	}

	return local;
}

CFUnitConsole.prototype.hideAllRefreshIcons = function()
{
	var each = function(){jQuery(this).fadeOut()}
	jQuery('.DumpOuterWrap .RefreshIcon',document.getElementById(this.getFormElementId)).each(each);
}

CFUnitConsole.prototype.showAllRefreshIcons = function()
{
	var each = function(){jQuery(this).fadeIn()}
	jQuery('.DumpOuterWrap .RefreshIcon',document.getElementById(this.getFormElementId)).each(each);
}

CFUnitConsole.prototype.setDumpContent = function(string)
{
	document.getElementById(this.getDumpContainerId()).innerHTML = string;

	jQuery(document.getElementById(this.getDumpContainerId())).slideDown(this.animationSpeed);
}

CFUnitConsole.prototype.setDumpContainerId = function(dumpContainerId)
{this.dumpContainerId=dumpContainerId}

//Ajax request to dump a built-in ColdFusion example action. Not actual method used to dump test
CFUnitConsole.prototype.displaySampleDump = function(sampleDumpTypeName)
{
	var callbackMethod = function(){arguments.callee.Owner.fetchSampleDump(arguments.callee.sampleDumpTypeName)}
	callbackMethod.Owner = this;
	callbackMethod.sampleDumpTypeName = sampleDumpTypeName;

	this.hideDumpWrap(callbackMethod);
	this.hideAllRefreshIcons();
}

CFUnitConsole.prototype.fetchSampleDump = function(sampleDumpTypeName)
{
	var local = {};

	/* ajax error handling */
		local.errorMethod = function(a,b,c,d,e)
		{
			//console.log('error',a,b,c,d,e);
			arguments.callee.Owner.setDumpContent(a.responseText)
			document.getElementById(arguments.callee.Owner.nextNodePickerContainerElementId).innerHTML = '';
			arguments.callee.Owner.checkAdjustDisplayForPreviousVariable();
			throw 'Console Log Error Occured';
		};
		local.errorMethod.Owner=this;
	/* end */

	local.dumpSetupCollection = {};
	local.dumpSetupCollection.sampleDumpTypeName=sampleDumpTypeName;

	jQuery.get(this.getSampleDumpUrl(), local.dumpSetupCollection, this.getMethodCallback(this.setDumpContent)).error(local.errorMethod);
}

CFUnitConsole.prototype.dump = function()//Ajax request to dump targeted node
{
	this.hideDumpWrap(this.getMethodCallback(this.sendDumpRequest));
	this.showAllRefreshIcons();
}

CFUnitConsole.prototype.hideDumpWrap = function(callback)
{jQuery('#'+this.getDumpContainerId()).slideUp(this.animationSpeed, callback)}

CFUnitConsole.prototype.sendDumpRequest = function()
{
	var local = {dumpSetupCollection:this.getDumpSetupCollection()}

	/* ajax error handling */
		local.errorMethod = function(a,b,c,d,e)
		{
			//console.log('error',a,b,c,d,e);
			arguments.callee.Owner.setDumpContent(a.responseText)
			document.getElementById(arguments.callee.Owner.nextNodePickerContainerElementId).innerHTML = '';
			arguments.callee.Owner.checkAdjustDisplayForPreviousVariable();
			throw 'Console Log Error Occured';
		};
		local.errorMethod.Owner=this;
	/* end */

	this.hideVariablePanel();

	local.callbackMethod = function(r)
	{
		arguments.callee.Owner.setDumpContent(r.outputString);
		arguments.callee.Owner.animateAppendNewChild(r.nodeKeyList);
	}
	local.callbackMethod.Owner = this;

	//local.data = jQuery(this.getFormElement()).serialize();

	/* cast console special inputs into JSON */
		local.nameValueArray = jQuery(this.getFormElement()).serializeArray();
		local.nameValueStruct = {};
		for(local.index=local.nameValueArray.length-1; local.index > -1; --local.index)
			local.nameValueStruct[local.nameValueArray[local.index].name] = local.nameValueArray[local.index].value;

		local.passthruData = {};
		local.passthruElms = jQuery('.passthru', this.getFormElement());
		for(local.ptIndex=local.passthruElms.length-1; local.ptIndex > -1; --local.ptIndex)
		{
			local.iName = local.passthruElms.eq(local.ptIndex).attr('name');
			local.passthruData[local.iName] = local.nameValueStruct[local.iName];
			local.nameValueStruct[local.iName].isPassthru = 1;
			//delete local.nameValueStruct[local.iName];
		}

		local.CFUnitConsoleJSON = ColdFusion.JSON.encode(local.nameValueStruct);

		local.passthruData.CFUnitConsoleJSON = local.CFUnitConsoleJSON;
	/* end */

	this.setDumpContent('<img src="/CFIDE/scripts/ajax/resources/cf/images/loading.gif" />');

	jQuery.post(this.getDumpUrl(), local.passthruData, local.callbackMethod, 'json').error(local.errorMethod);
}

CFUnitConsole.prototype.variablePanelSelectableElementToDefaultOption = function(Element)
{
	var local = {};

	local.jElement = jQuery(Element);

	local.action = function(){arguments.callee.owner.testSelectedNode(this);return false;};
	local.action.owner = this;

	local.jElement.click(local.action);

	local.type = local.jElement.attr('type');
	local.parameters = local.jElement.attr('parameters');

	if(local.parameters)
	{
		local.parameters = jQuery.parseJSON(local.parameters);
		local.jElement.removeAttr('parameters');
		Element.parameters = local.parameters;
	}

	local.className = local.jElement.attr('class');

	this.setDefaultOption(local.jElement.attr('nodesyntax'), local.jElement.html(), local.type, local.className, local.parameters);
}
/*
CFUnitConsole.prototype.toggleFunction = function()
{
	jQuery('.MultiLineCodeInputWrap',this.getFormElement()).slideToggle();
}
*/
CFUnitConsole.prototype.setFunctionToggleEventToElement = function(Elm)
{
	var method = function(){arguments.callee.Owner.toggleFunction()}
	method.Owner = this;
	jQuery(Elm).click(method);
}

CFUnitConsole.prototype.setCfWindowName = function(name)
{
	var local = {};

	this.windowName = name;
	var resizeCallback = this.getMethodCallback(this.delayFullsizeLayouts);

	var myWindow = ColdFusion.Window.getWindowObject(name);
	myWindow.on('resize',resizeCallback);

	ColdFusion.Window.onShow(name,this.getMethodCallback(this.delayFullsizeLayouts));

	if(myWindow.isVisible())
		this.delayFullsizeLayouts(myWindow);

	//if the window is not shown or init, this will take care of the whole thing
	myWindow.collapsible = true;

	if(myWindow.toolbox)//?ColdFusion 8
	{
		local.collapseClassName = "x-dlg-collapse";
		local.collapseMouseOverClassName = "x-dlg-collapse-over";
		myWindow.collapseBtn = myWindow.toolbox.createChild({cls:local.collapseClassName});
	}else if(myWindow.header)//?ColdFusion 9
	{
		local.collapseClassName = "x-tool x-tool-toggle";
		local.collapseMouseOverClassName = "x-tool-toggle-over";
		myWindow.collapseBtn = myWindow.header.createChild({cls:local.collapseClassName});
	}

	local.collapseClickMethod=function()
	{arguments.callee.method.call(arguments.callee.Owner)}
	local.collapseClickMethod.Owner = myWindow;

	if(myWindow.collapseClick)
		local.collapseClickMethod.method = myWindow.collapseClick;
	else
		local.collapseClickMethod.method = myWindow.toggleCollapse;

	if(myWindow.collapseBtn)
	{
		myWindow.collapseBtn.on("click", local.collapseClickMethod, myWindow);
		myWindow.header.on("dblclick" , local.collapseClickMethod , local.window);
		myWindow.collapseBtn.addClassOnOver(local.collapseMouseOverClassName);
	}


	document.getElementById(myWindow._cf_body).appendChild(document.getElementById('CFWindowTempContainer'));
}

CFUnitConsole.prototype.getWindowName = function()
{return this.windowName}

CFUnitConsole.prototype.setBorderLayoutName = function(name)
{
	this.borderLayoutName=name;

	jQuery(window).resize(this.getMethodCallback(this.delayFullsizeLayouts));

	this.delayFullsizeLayouts();
}

CFUnitConsole.prototype.setStageBorderLayoutName = function(name)
{this.subBorderLayoutName=name}

CFUnitConsole.prototype.delayFullsizeLayouts = function()
{
	setTimeout(this.getMethodCallback(this.fullsizeLayouts),300);
	setTimeout(this.getMethodCallback(this.fullsizeLayouts),600);//ensure overflow bars the might disappear reflect the updated size
}

CFUnitConsole.prototype.fullsizeLayouts = function()
{
	var local = {}

	local.BorderLayout = ColdFusion.Layout.getBorderLayout(this.borderLayoutName);

	if(local.BorderLayout.container)//?CF9
		local.jParent = jQuery(local.BorderLayout.container.dom.parentNode);
	else
		local.jParent = jQuery(local.BorderLayout.el.dom.parentNode);

	local.height = local.jParent.innerHeight();
	local.width = local.jParent.innerWidth();

	/* resize main outer layout */
		if(local.BorderLayout.setSize)
			local.BorderLayout.setSize(local.width, local.height);//CF9
		else
			local.BorderLayout.el.setSize(local.width, local.height);//CF8
	/* end */

	/* resize inner stage */
		local.StageLayout = ColdFusion.Layout.getBorderLayout('Stage');
		if(local.StageLayout.setHeight)
			local.StageLayout.setHeight(local.height-4);
		else
			local.StageLayout.el.setHeight(local.height-4);
	/* end */

	//CF8 redraw
	if(typeof(local.BorderLayout.layout) == typeof(function(){}))
	{
		local.BorderLayout.layout();
		local.StageLayout.layout();
	}
}

/* auto config */
	CFUnitConsole.prototype.autoConfigContainerElementById = function(id)
	{
		var local = {};

		this.ucWrapId = id;
		local.ContainerElement = document.getElementById(id);

		/* pre build callback methods */
			local.submitMethod=function(){arguments.callee.Owner.dump();return false};
			local.submitMethod.Owner=this;

			local.onSearchKeyUpMethod=function(){arguments.callee.Owner.limitSelectablesToFind(this.value)}
			local.onSearchKeyUpMethod.Owner=this;

			local.toggleReturnSampleDumpsDisplayButtonMethod=function(e)
			{
				var target = document.getElementById(arguments.callee.Owner.ucWrapId);
				jQuery('.SampleDumpOptionsWrap',target).slideToggle();
				(e ? e : event).preventDefault();return false;
			}
			local.toggleReturnSampleDumpsDisplayButtonMethod.Owner=this;

			/* hide show return settings panel */
				local.toggleReturnSettingsDisplayButtonMethod=function(e)
				{
					var target = document.getElementById(arguments.callee.Owner.ucWrapId);
					jQuery('.ReturnSettingsWrap',target).slideToggle();
					(e ? e : event).preventDefault();return false;
				}
				local.toggleReturnSettingsDisplayButtonMethod.Owner=this;
			/* end */

			local.backEventMethod = function(){arguments.callee.Owner.back()}
			local.backEventMethod.Owner=this;

			local.singleLinkInputKeyWatchMethod = function(e)
			{
				var event = e ? e : event;
				var keyboardCode = event.charCode ? event.charCode : event.keyCode;
				if(keyboardCode==13 && event.shiftKey)
					arguments.callee.Owner.submitFormToNewWindow();
			}
			local.singleLinkInputKeyWatchMethod.Owner = this;

			local.multiLinkInputKeyWatchMethod = function(e)
			{
				var event = e ? e : event;
				var keyboardCode = event.charCode ? event.charCode : event.keyCode;
				if(keyboardCode==13 && event.shiftKey)
				{
					arguments.callee.Owner.dump();
					return false;
				}

				if(!arguments.callee.Owner.getFunctionCode().length)
				{
					arguments.callee.Owner.animatePopulateDefaultOptions();
					arguments.callee.Owner.setSubFunctionCode('');
				}
			}
			local.multiLinkInputKeyWatchMethod.Owner = this;

			local.submitButtonClickMethod = function(e)
			{
				var event = e ? e : event;
				if(event.shiftKey)
				{
					arguments.callee.Owner.submitFormToNewWindow();
					return false;
				}
			}
			local.submitButtonClickMethod.Owner = this;

			local.changeReturnStringFormatMode = function()
			{
				arguments.callee.Owner.setFormatStringReturnsMode(this.value);
				var Container = document.getElementById(arguments.callee.Owner.ucWrapId);
				jQuery('.ReturnSettingsWrap',Container).hide();
			}
			local.changeReturnStringFormatMode.Owner = this;

			local.sampleDumpLinkMethod = function()
			{
				var Owner = arguments.callee.Owner;
				var Container = document.getElementById(Owner.ucWrapId);
				var name = jQuery(this,Container).attr('name');
				Owner.displaySampleDump(name);
				//jQuery('.SampleDumpOptionsWrap',Container).hide();
			}
			local.sampleDumpLinkMethod.Owner = this;

			local.requestTimeoutKeyupMethod = function()
			{if(this.value.search(/[^0-9]/) > -1)this.value=this.value.replace(/[^0-9]/,'')}

			local.changeAutoInvoke = function()
			{arguments.callee.Owner.set_auto_invoke_mode(parseInt(this.value))}
			local.changeAutoInvoke.Owner = this;
			/*
			local.setFunctionToggleEventToElement = function()
			{arguments.callee.Owner.setFunctionToggleEventToElement(this)}
			local.setFunctionToggleEventToElement.Owner=this;
			*/
		/* end */

		/* jQuery setup */
			jQuery('form.ucForm', local.ContainerElement)
				.attr('id',id+'_form')
				.attr('name',id+'_form')
				.submit(local.submitMethod);

			jQuery('.DumpWrap', local.ContainerElement)
				.attr('id',id+'_dumpContainer');

			jQuery('.NextNodePickerWrap',local.ContainerElement)
				.attr('id',id+'_nextNodePickerContainer');

			jQuery('.SearchVariablePanel',local.ContainerElement)
				.keyup(local.onSearchKeyUpMethod);

			jQuery('.ToggleReturnSampleDumpsDisplayButton',local.ContainerElement)
				.click(local.toggleReturnSampleDumpsDisplayButtonMethod);

			jQuery('.ToggleReturnSettingsDisplayButton',local.ContainerElement)
				.click(local.toggleReturnSettingsDisplayButtonMethod);
/*
			jQuery('.BackButton',local.ContainerElement)
				.click(local.backEventMethod);
*/
			jQuery(this.getSubFunctionEvaluateCodeInputElement())
				.keyup(local.singleLinkInputKeyWatchMethod);

			jQuery('.FunctionCode',local.ContainerElement)
				.keyup(local.multiLinkInputKeyWatchMethod);

			jQuery('.SubmitButton',local.ContainerElement)
				.click(local.submitButtonClickMethod);

			jQuery('.RefreshIcon',local.ContainerElement)
				.click(this.getMethodCallback(this.dump));

			jQuery('.ReturnStringFormatMode',local.ContainerElement)
				.change(local.changeReturnStringFormatMode);

			jQuery('.SampleDumpOptionsWrap a',local.ContainerElement)
				.each(function(){jQuery(this).click(local.sampleDumpLinkMethod)});

			jQuery('.ReturnSettingsWrap .RequestTimeOutInput',local.ContainerElement)
				.keyup(local.requestTimeoutKeyupMethod);

			jQuery('.IsAutoInvoke',local.Container)
				.change(local.changeAutoInvoke);

			jQuery('.ReturnSettingsWrap .CloseButton',local.ContainerElement)
				.click(local.toggleReturnSettingsDisplayButtonMethod);
/*
			jQuery('.FunctionToggle',local.ContainerElement)
				.each(local.setFunctionToggleEventToElement);
*/

			/* all existing selectables are considered defaults */
				local.variablePanelSelectableElementToDefaultOption=function()
				{arguments.callee.Owner.variablePanelSelectableElementToDefaultOption(this);}
				local.variablePanelSelectableElementToDefaultOption.Owner = this;

				jQuery('.VariablePanel .selectable',local.ContainerElement)
					.each(local.variablePanelSelectableElementToDefaultOption);
			/* end */
		/* end */

		/* report important elements to control class */
			this.setFormElementId(id+'_form');
			this.setDumpContainerId(id+'_dumpContainer');
			this.setNextNodePickerContainerElementId(id+'_nextNodePickerContainer');
		/* end */

		/* pick-up settings */
			local.jElement = jQuery('.ReturnStringFormatMode',local.ContainerElement);
			local.returnStringFormatMode = parseInt(local.jElement.val());
			this.setFormatStringReturnsMode(local.returnStringFormatMode);
		/* end */

		jQuery('.ControlPanels',local.ContainerElement).accordion({collapsible:1})
	}
/* end : auto config */