/*
	System of asynchronously loading client scripts, particularly javascripts & stylesheets.
	!Warning, do not use ClientFileLoader with stylesheets from CDN's.
	!Currently it is very difficult across all browsers to know when a stylesheet has loaded/failed and ClientFileLoader cannot be trusted to failover for stylesheets
*/
if(typeof(ClientFileLoader) == 'undefined')
{
	if(typeof(CflArrays) != typeof({}))CflArrays={before:[], after:[]};

	ClientFileLoader = function()//Object. Used to load scripts mid HTML page request. Great for load balancing/lazy loading javascripts not until they are required
	{
		this.lastLoad					= null;
		this.scriptsToLoad				= [];
		this.stylesToLoad				= [];
		this.onLoadCalls				= [];
		this.isPreventDuplicateLoadMode	= true;
		this.timeout					= 8000;
		this.pauseLoadCompleteCount		= 0;

		this._private=
		{
			isDebugMode	: 0
		}

		/* load all scripts put into que */
			var loadMethod = function()
			{
				ClientFileLoader.windowLoadComplete()
			}

			if(window.readyState==="complete" || document.readyState==="complete")
				setTimeout(loadMethod,1);
			else if(window.addEventListener)
				window.addEventListener("load",loadMethod,false);
			else
			{
				if(window.attachEvent)
					window.attachEvent("onload",loadMethod);
				else if(document.getElementById)
					window.onload = loadMethod;
			}
		/* end */

		return this;
	};

	ClientFileLoader.prototype.addLoadCompletePause = function(amount)
	{
		if(!isNaN(amount) && amount != 0)
			amount = 1;

		this.pauseLoadCompleteCount = this.pauseLoadCompleteCount + amount;

		return this;
	}

	ClientFileLoader.prototype.warn = function(msg)
	{
		if(typeof(console) != 'undefined' && typeof(console.log) != 'undefined')
		{
			msg = 'CFL: '+msg;
			console.warn(msg);
		}else
			this.log(msg);
	}

	ClientFileLoader.prototype.log = function(msg,dump)
	{
		if(!this.isDebugMode())return this;

		msg = 'CFL: '+msg;

		if(typeof(console) != 'undefined' && typeof(console.log) != 'undefined')
		{
			if(!dump)dump='';
			console.log(msg,dump);
		}

		if(typeof(ColdFusion) != 'undefined')
			ColdFusion.Log.info(msg , 'ClientFileLoader');

		return this;
	}

	ClientFileLoader.prototype.getTimeout=function()
	{return this.timeout}

	ClientFileLoader.prototype.setTimeout=function(n)
	{this.timeout=n}

	ClientFileLoader.prototype.isDebugMode = function(yesNo)
	{
		if(yesNo != null)
			this._private.isDebugMode = yesNo;

		return this._private.isDebugMode;
	}

	/* LOADING METHODS */
		ClientFileLoader.prototype.loadJavaScript = function(path , callback, failOverScriptArray)//adds script to batch and starts loading all scripts in que
		{
			this.addJavaScript({path:path, callback:callback, failOverScriptArray:failOverScriptArray});
			this.loadScripts();
		}

		ClientFileLoader.prototype.addJavaScript = function(path, callback, failOverScriptArray, testMethod)//adds script to batch for loading
		{
			this.scriptsToLoad.push({path:path, callback:callback, failOverScriptArray:failOverScriptArray, testMethod:testMethod});
			//this.log('Script Load Request Added: ' + path.substr(path.search(/[^\/\\]+\..+$/,'') , path.length) );
		}

		ClientFileLoader.prototype.loadScripts = function()//main function to start fetching all scripts set for batch loading
		{
			var local = {};

			/* first, discover any methods waiting for my implied technique of calling them before I loadScripts */
				this.log(CflArrays.before.length+' Implied Onloads Detected');

				while(CflArrays.before.length)
					CflArrays.before.shift().call(this,this);
			/* end */

			this.log('Going to load ' + this.scriptsToLoad.length + ' scripts');

			if(this.isAllScriptsLoaded())
				return this.setScriptsLoadingCompleted();//incase no scripts defined but a callback is

			if( this.lastLoad==null )//lock to not reset loading
				return this.loadNextJavaScript();
		}
		//!!SINGLE CALLS WHEN LOAD ORDER IS NOT IMPORTANT
		ClientFileLoader.prototype.callJavaScript = function(path, callback, failOverScriptArray, testMethod)//Fetches script from server
		{
			var local = { newScript:document.createElement('script') };

			/* cross browser friendly callback for when scripts completed loading (onload) */
				local.onloadMethod = function()
				{
					arguments.callee.Owner.setJavaScriptLoaded(arguments.callee.src);

					if(arguments.callee.timeOutNum)
						clearTimeout(arguments.callee.timeOutNum);

					if(arguments.callee.callback)
						arguments.callee.callback();
				}
				local.onloadMethod.Owner = this;
				local.onloadMethod.callback = callback;
				local.onloadMethod.src = path;
			/* end */

			//Does the test method return false indicating we should not load yet
			if(typeof(testMethod)==typeof(function(){}) && testMethod() == false)
				return local.onloadMethod();

			local.newScript.type = 'text/javascript';
			local.newScript.src = path;

			if(typeof(failOverScriptArray)==typeof([]) && failOverScriptArray.length)
				local.onloadMethod.timeOutNum = this.attachFailOverCallbackMethodToScriptElement(local.newScript, failOverScriptArray, path);

			this.attachOnloadMethodToScriptElement(local.onloadMethod, local.newScript);

			if( !document.getElementsByTagName("head").length )
			{
				local.head = document.createElement('HEAD');
				document.firstChild.appendChild( local.head );
			}

			this.log('Loading ' + path);

			document.getElementsByTagName("head")[0].appendChild(local.newScript);
		}
	/* END */

	ClientFileLoader.prototype.attachOnloadMethodToScriptElement = function(method, ScriptElement)
	{
		if(!ScriptElement)
		{
			this.warn('bug',arguments.callee.caller);
			console.info(arguments.callee.caller);
		}

		if( typeof(ScriptElement.onreadystatechange) == 'undefined' )
			ScriptElement.onload = method;
		else
		{
			ScriptElement.onreadystatechange = function()
			{
				if (this.readyState == 'complete' || this.readyState == 'loaded')
					arguments.callee.onloadMethod();
			}
			ScriptElement.onreadystatechange.onloadMethod = method;
		}
	}

	ClientFileLoader.prototype.setPreventDuplicateLoadMode=function(yesNo)
	{this.isPreventDuplicateLoadMode=(yesNo||yesNo==null)?true:false;}

	ClientFileLoader.prototype.setOnLoadComplete = function(method)
	{CflArrays.after[CflArrays.after.length] = method}

	ClientFileLoader.prototype.windowLoadComplete = function()//indicates DOM window loading completed
	{this.loadScripts()}

	ClientFileLoader.prototype.removeLoadCompletePause = function()
	{
		--this.pauseLoadCompleteCount;

		if(this.isLoadingScriptsComplete())
			this.setScriptsLoadingCompleted();

		return this;
	}

	ClientFileLoader.prototype.isLoadingScriptsComplete = function()
	{return this.isAllScriptsLoaded() && !this.isLoadCompletePaused()}

	ClientFileLoader.prototype.isLoadCompletePaused = function()
	{return this.pauseLoadCompleteCount > 0}

	ClientFileLoader.prototype.setScriptsLoadingCompleted=function()//private method used to indicate that all scripts told to load have been loaded
	{
		if(this.isLoadingScriptsComplete())
			this.fireLoadCompleteCallbacks()

		return this;
	}

	ClientFileLoader.prototype.fireLoadCompleteCallbacks = function()
	{
		var local = {cCount:0};

		for(local.cCount=CflArrays.after.length-1; local.cCount >= 0; --local.cCount)
		{
			this.log('Firing Callback '+(local.cCount+1)+' of '+ CflArrays.after.length, CflArrays.after[local.cCount])
			CflArrays.after[local.cCount]();
		}

		this.lastLoad = null;
		CflArrays.after=[];//clear callback as they should NEVER be called twice

		return this;
	}

	ClientFileLoader.prototype.setJavaScriptLoaded = function(src , isCacheLoaded)//private methods used to indicate when a javascript finished loading
	{
		var local = {};

		this.scriptsToLoad.shift();//remove to show as added

		if(isCacheLoaded==null || isCacheLoaded)
			this.setScriptLoaded(src);

		this.loadNextJavaScript();
	}

	ClientFileLoader.prototype.setScriptLoaded = function(path)//private methods used to indicate when a script finished loading
	{
		if(!path)
		{
			var message = 'Incorrect ClientFileLoader Setup. A script attempted to indicate it had finished loading but did not properly define what script had finished loading';

			if(console != null && console.log != null)
				console.log(message,'Path Argument:',path,'Caller Function:',arguments.callee.caller)

			throw message;
		}

		this.log('Loaded ' + path.substr(path.search(/[^\/\\]+\..+$/, ''), path.length)+'. '+this.scriptsToLoad.length + ' script loads left');
	}

	ClientFileLoader.prototype.loadNextJavaScript = function()//private method used to ensure scripts load in order
	{
		var local = {};

		if( !this.isAllScriptsLoaded() )
		{
			local.script = this.scriptsToLoad[0];

			this.log('loading next script in que:'+local.script.path);

			if( this.isJavaScriptLoaded(local.script.path) )
				this.setJavaScriptLoaded(local.script.path, false);
			else
			{
				this.lastLoad = local.script;
				this.callJavaScript(local.script.path , local.script.callback, local.script.failOverScriptArray, local.script.testMethod);
			}
		}else
			this.setScriptsLoadingCompleted();

		return true;
	}

	ClientFileLoader.prototype.isAllScriptsLoaded = function()
	{return (this.scriptsToLoad.length < 1)}

	ClientFileLoader.prototype.isJavaScriptLoaded = function( path )
	{
		if(!this.isPreventDuplicateLoadMode)return false;

		var local = { scripts:document.getElementsByTagName('SCRIPT') };

		for(local.x=0; local.x < local.scripts.length; ++local.x)
		{
			local.src = local.scripts[local.x].src;
			local.src = local.src.substr( local.src.length-path.length , local.src.length );
			if( local.src == path )return true;
		}
		return false;
	}

	ClientFileLoader.prototype.destroyJavaScriptFiles = function()
	{
		var local = {};

		local.scripts = document.getElementsByTagName('SCRIPT');

		for(local.x=local.scripts.length-1; local.x >= 0; --local.x){
			if( local.scripts[local.x].src.length ){
				local.scripts[local.x].parentNode.removeChild( local.scripts[local.x] );
			}
		}
	}

	ClientFileLoader.prototype.unloadCssScript = function( path )//Removes style sheet reference. Elements with a class set in the style sheet will no longer be visible
	{
		var local = {};

		local.links	= document.getElementsByTagName('LINK');

		for(local.x=local.links.length-1; local.x >= 0; --local.x)
		{
			local.src = local.links[local.x].href;
			local.src = local.src.substr( local.src.length-path.length , local.src.length );
			if( local.src == path )
			{
				local.links[local.x].parentNode.removeChild( local.links[local.x] );
				break;
			}
		}
	}

	ClientFileLoader.prototype.getFailOverCallback = function(failOverScriptArray, path)
	{
		var local = {};

		local.failOverMethod = function()
		{
			var local = {}
			local.Owner = arguments.callee.Owner;
			local.failOverScriptArray = arguments.callee.failOverScriptArray;

			if(local.failOverScriptArray.length)
			{
				local.nextScript = local.failOverScriptArray.shift();
				local.message = 'Script Load Fail. Now Loading Failover. Failed Script:'+arguments.callee.src+'. Failover script:'+local.nextScript+'. Failover Scripts Left to Try:'+local.failOverScriptArray.length;
				local.Owner.warn(local.message);

				if(this.timeOutNum != null)
					clearTimeout(this.timeOutNum);

				local.Owner.callJavaScript(local.nextScript, this.callback, local.failOverScriptArray);
			}
		}
		local.failOverMethod.Owner = this;
		local.failOverMethod.failOverScriptArray = failOverScriptArray;
		local.failOverMethod.src = path;

		return local.failOverMethod;
	}

	ClientFileLoader.prototype.attachFailOverCallbackMethodToScriptElement = function(ScriptElement, failOverScriptArray, path)//returns timeout number
	{
		var local = {};

		/* create failover callback method */
			local.failOverMethod = this.getFailOverCallback(failOverScriptArray, path);
			ScriptElement.onerror = local.failOverMethod;
		/* end */

		/* timeout until we try fail over script */
			local.timeoutMethod = function()
			{
				arguments.callee.Owner.warn('load timeout for script '+arguments.callee.src);

				arguments.callee.failOverMethod.call(arguments.callee.ScriptElm);
			}
			local.timeoutMethod.Owner = this;
			local.timeoutMethod.failOverMethod = local.failOverMethod;
			local.timeoutMethod.ScriptElm = ScriptElement;
			local.timeoutMethod.src = path;
			local.timeOutNum = setTimeout(local.timeoutMethod, this.getTimeout());

			ScriptElement.timeOutNum = local.timeOutNum;
			ScriptElement.setAttribute("timeOutNum",local.timeOutNum);
		/* end */
		return local.timeOutNum;
	}

	ClientFileLoader.prototype.loadCssScript = function(path, callback, failOverScriptArray)
	{
		var local = {};

		if( !this.isCssScriptLoaded(path) )
		{
			local.cssNode = document.createElement('link');
			local.cssNode.type	= 'text/css';
			local.cssNode.rel	= 'stylesheet';
			local.cssNode.href	= path;
			local.cssNode.media	= 'screen';

			/* cross browser friendly callback for when scripts completed loading (onload) */
				//You cannot detect except in IE when a css script has loaded. Do not use a CDN to deliver CSS scripts for now
				local.onloadMethod = function()
				{
					arguments.callee.Owner.setScriptLoaded(arguments.callee.pathLoaded);

					if(arguments.callee.timeOutNum)
						clearTimeout(arguments.callee.timeOutNum);

					if(arguments.callee.callback)
						arguments.callee.callback();
				}
				local.onloadMethod.Owner = this;
				local.onloadMethod.callback=callback;
				local.onloadMethod.pathLoaded = path;
/*

				if(typeof(failOverScriptArray)==typeof([]) && failOverScriptArray.length)
				{
					if( typeof(local.cssNode.onreadystatechange) == 'undefined' )//Browser is not IE
					{
						local.ImgElement = document.createElement('object');
						local.ImgElement.src = path;
						local.ImgElement.data = path;
						local.ImgElement.style.display='none';

						arguments.callee.timeOutNum = this.attachFailOverCallbackMethodToScriptElement(local.ImgElement, failOverScriptArray, path);
						this.attachOnloadMethodToScriptElement(local.onloadMethod, local.ImgElement);
						document.getElementsByTagName("head")[0].appendChild(local.ImgElement);
					}else

					arguments.callee.timeOutNum = this.attachFailOverCallbackMethodToScriptElement(local.cssNode, failOverScriptArray, path);
				}
*/
			/* end */
			this.attachOnloadMethodToScriptElement(local.onloadMethod, local.cssNode);

			this.log('Loading CSS Script:' + path);
			document.getElementsByTagName("head")[0].appendChild(local.cssNode);
			//this.setScriptLoaded(path);
		}
	}

	ClientFileLoader.prototype.isCssScriptLoaded=function( path )
	{
		var local = {};

		local.links			= document.getElementsByTagName('LINK');
		local.isLinkLoaded	= false;

		for(local.x=0; local.x < local.links.length; ++local.x)
		{
			local.src = local.links[local.x].href;
			local.src = local.src.substr( local.src.length-path.length , local.src.length );
			if( local.src == path )return true;
		}

		return false;
	}

	ClientFileLoader = new ClientFileLoader();
}