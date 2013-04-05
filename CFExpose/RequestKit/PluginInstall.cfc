<cfComponent
	Hint		= ""
	Output		= "no"
	extends		= "RequestSwitch"
>

	<cfScript>
		setProcess(processName='getLogin', submitProcessName='processLogin', submitFailProcessName='getLogin');
		setProcess(processName='getOverView');
		setProcess(processName='getInstallItemPreview');
		setProcess(processName='getInstallSummaryConfirmation');
		setProcess(processName='getInstallCompleteConfirmation');
	</cfScript>

	<cfFunction
		name		= "setInstallObject"
		returnType	= "PluginInstall"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="path"			required="yes"	type="string"		hint="" />
		<cfArgument name="type"			required="no"	type="variableName"	hint="" />
		<cfArgument name="name"			required="no"	type="string"		hint="" />
		<cfArgument name="description"	required="no"	type="string"	default=""	hint="" />
		<cfArgument name="mediaName"	required="no"	type="string"		hint="" />
		<cfScript>
			if(not structKeyExists(arguments, "type"))
			{
				if(listLast(arguments.path,'.') EQ 'cfm')
					arguments.type = 'CustomTag';
				else if(directoryExists(arguments.path))
					arguments.type = 'media';
			}

			if(arguments.type eq 'media' AND !structKeyExists(arguments, "mediaName"))
				arguments.mediaName = listLast(arguments.path,'/\');

			if(arguments.type eq 'media' AND !structKeyExists(arguments, "name"))
				arguments.name = arguments.mediaName;

			if(!structKeyExists(arguments, "name"))
				arguments.name = listFirst(listLast(arguments.path,'/\'), ".");

			if(!structKeyExists(arguments, "medianame"))
				arguments.medianame = arguments.name;

			arrayAppend(getInstallObjectArray(), arguments);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getInstallObjectArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(NOT structKeyExists(variables, "installObjectArray"))
				variables.installObjectArray = arrayNew(1);

			return variables.installObjectArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getNewMediaAddress"
		returnType	= "CFExpose.RequestKit.MediaAddress"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn createObject("component", "CFExpose.Media").init(argumentCollection=arguments) />
	</cfFunction>

	<cfFunction
		name		= "onProcessStart"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processName"		required="yes"	type="string" hint="" />
		<cfArgument name="processNumber"	required="yes"	type="string" hint="" />
		<cfReturn '' />
	</cfFunction>

	<cfFunction
		name		= "isValidAdminSession"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			var local = structNew();

			local.clientInputStruct = getClientInputStruct('getLogin');

			if(!structKeyExists(local.clientInputStruct, "cfAdminUserName") OR !structKeyExists(local.clientInputStruct, "cfAdminPassword"))
				return false;

			return processLogin(argumentCollection=local.clientInputStruct);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getProcessOutputByName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="processName"	required="yes"	type="string" hint="" />
		<cfif arguments.processName NEQ 'getLogin' AND !isValidAdminSession() >
			<cfReturn getProcessOutputByName('getLogin') />
		</cfif>
		<cfReturn super.getProcessOutputByName(arguments.processName) />
	</cfFunction>

	<cfFunction
		name		= "setLibraryRequirementByPath"
		returnType	= "PluginInstall"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="path"						required="yes"	type="string"	hint="" />
		<cfArgument name="mappingName"				required="no"	type="string"	hint="will use folder name of path" />
		<cfArgument name="mappingDependencyName"	required="no"	type="string" hint="" />
		<cfScript>
			if(!structKeyExists(arguments, "mappingName"))
				arguments.mappingName = listLast(arguments.path,'/\');

			arrayAppend(getLibraryRequirementArray(), arguments);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getLibraryRequirementArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "libraryRequirementArray") >
			<cfset variables.libraryRequirementArray = arrayNew(1) />
		</cfif>
		<cfReturn variables.libraryRequirementArray />
	</cfFunction>

	<cfFunction
		name		= "getDetectPreviousInstall"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn 'getDetectPreviousInstall' />
	</cfFunction>

	<cfFunction
		name		= "getProcessLayout"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="body"			required="yes"	type="string"		hint="" />
		<cfArgument name="ProcessName"	required="yes"	type="variableName"	hint="" />
		<cfset var local = structNew() />
		<cfif arguments.ProcessName EQ 'getInstallItemAdditionalInformation' >
			<cfReturn arguments.body />
		</cfif>
		<cfSaveContent Variable="local.output">
			<cfOutput>#getClientFileLoader().addScript('PluginInstall/Stage.css').getOutput()#</cfOutput>
			<cfOutput>
				<div class="PluginInstallWrap">
					<table cellPadding="0" cellSpacing="0" border="0" class="stageWrap">
						<tr>
							<td valign="center" align="center">
								<div class="stage<cfif arguments.ProcessName eq 'getLogin' > CFLogo</cfif>">
									<div class="innerStage">
										<form method="post" class="loginform" action="#getSubmitUrl()#">
											<div class="logospacer"></div>
											#arguments.body#
											<div style="clear:both"></div>
											<cfif getCurrentProcessNumber() NEQ getTotalProcessCount() >
												<cfif getCurrentProcessNumber() GT 1 >
													<br />
													<input type="button" value="&lt;&nbsp;Back" class="button" onclick="history.back(-1)" />
													<input type="submit" value="Continue" class="button" />
												<cfElse>
													<input type="submit" value="Login" class="button" />
												</cfif>
											</cfif>
										</form>
										<!---<cf_UnitConsole var="#getClientInputStruct()#" />--->
										<cfif arguments.ProcessName eq 'getLogin' >
											<table border="0" cellpadding="0" cellspacing="0">
												<tbody>
													<tr>
														<td style="vertical-align:middle;"><img src="/CFIDE/administrator/images/spacer.gif" alt="" width="10" height="1"><img src="/CFIDE/administrator/images/adobelogo.gif" alt="" width="29" height="32">
														</td><td style="width:500px;"><p style="margin:20px 20px 20px 20px;" class="LoginCopyrightText"> Adobe, the Adobe logo, ColdFusion, and Adobe ColdFusion are trademarks or registered trademarks of Adobe Systems Incorporated in the United States and/or other countries.  All other trademarks are the property of their respective owners.</p>
														</td>
													</tr>
												</tbody>
											</table>
										</cfif>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</cfOutput>
		</cfSaveContent>
		<cfReturn local.output />
	</cfFunction>

	<cfFunction
		name		= "isItemIdInstalled"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="itemId" required="yes" type="numeric" hint="" />
		<cfset var path = getTargetInstallPathByItemId(arguments.itemId) />
		<cfReturn directoryExists(path) OR fileExists(path) />
	</cfFunction>

	<cfFunction
		name		= "getTargetInstallPathByItemId"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="itemId" required="yes" type="numeric" hint="" />
		<cfScript>
			var local = {};

			local.item = getInstallObjectArray();
			local.item = local.item[arguments.itemId];

			switch(local.item.type)
			{
				case 'media':return expandPath('/CFIDE/')&local.item.mediaName;
				case 'customtag':return Expose('ColdFusion').getCustomTagPath()&local.item.mediaName&'.cfm';
			}

			return '';
		</cfScript>
	</cfFunction>

	<!--- Remote Methods --->
		<cfFunction
			name		= "getLogin"
			returnType	= "string"
			access		= "remote"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="cfAdminPassword" required="no" type="string" hint="" />
			<cfSaveContent Variable="local.output">
				<cfOutput>
					<div class="input">
						<label for="cfAdminUserName">User Name</label>
						<input name="cfAdminUserName" id="cfAdminUserName" autocomplete="off" value="admin" />
					</div>
					<div class="input password">
						<label>Password</label>
						<input name="cfadminPassword" id="cfadminPassword" type="password" />
					</div>
					<cfif structKeyExists(arguments, "cfAdminPassword") >
						<p class="logininvalidtext">
							Invalid Password. Please try again.
						</p>
					</cfif>
				</cfOutput>
			</cfSaveContent>
			<cfReturn local.output />
		</cfFunction>

		<cfFunction
			name		= "getOverView"
			returnType	= "string"
			access		= "remote"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfScript>
				var local = structNew();

				local.libraryRequirementArray = getLibraryRequirementArray();

				local.mappingStruct = Expose('ColdFusion').getMappings();
			</cfScript>
			<cfSaveContent Variable="local.output">
				<h3>Plug-in Decription and Brief Overview</h3>
				<p>In this process you will install ColdFusion based add-on functionality to enhance your development range of motion on this server.</p>
				<br />
				<h3>Requirements</h3>
				<i>Below are prerequists and actions required before installation.</i>
				<cfOutput>
					<div class="LibraryRequirementWrap">
						<cfLoop array="#local.libraryRequirementArray#" index="local.item">
							<cfset local.webrootPath = expandPath('/') & local.item.mappingName />
							<br />
							For the #local.item.mappingName# library to function correctly, a mapping must be added to the processing ColdFusion installation <b>OR</b> the library can be copied into the web root folder
							<div style="height:5px"></div>
							<p>
								<label for="#local.item.mappingName#_LibraryType_mapping">
									<input type="radio" name="#local.item.mappingName#_LibraryType" id="#local.item.mappingName#_LibraryType_mapping" value="mapping"<cfif !directoryExists(local.webrootPath) > checked</cfif> />&nbsp;&nbsp;Add a #local.item.mappingName# ColdFusion Mapping
								</label>
							</p>
							<ul>
								<li>Mapping Path: #local.item.path#</li>
								<li>This configuration allows the #local.item.mappingName# folder to stay where it is in the current running installation folder.</li>
							</ul>
							<p>
								<label for="#local.item.mappingName#_LibraryType_webroot">
									<input type="radio" name="#local.item.mappingName#_LibraryType" id="#local.item.mappingName#_LibraryType_webroot" value="webroot"<cfif directoryExists(local.webrootPath) > checked</cfif> />&nbsp;&nbsp;Copy #local.item.mappingName# library into the web root folder
								</label>
							</p>
							<ul>
								<li>Web Root Path: #local.webrootPath#</li>
							</ul>
							<cfif structKeyExists(local.mappingStruct, "/#local.item.mappingName#") >
								<p>
									<label for="#local.item.mappingName#_LibraryType_deletemapping">
										<input type="radio" name="#local.item.mappingName#_LibraryType" id="#local.item.mappingName#_LibraryType_deletemapping" value="delete-mapping" />&nbsp;&nbsp;<b>Uninstall</b> and Delete Existing CF Mapping
									</label>
								</p>
								<ul>
									<li>Mapping Path: #local.mappingStruct['/#local.item.mappingName#']#</li>
								</ul>
							</cfif>
							<cfif directoryExists(local.webrootPath) >
								<p>
									<label for="#local.item.mappingName#_LibraryType_deletewebroot">
										<input type="radio" name="#local.item.mappingName#_LibraryType" id="#local.item.mappingName#_LibraryType_deletewebroot" value="delete-webroot" />&nbsp;&nbsp;<b>Uninstall</b> and Delete Existing Web Root Library
									</label>
								</p>
								<ul>
									<li>Web Root Path: #local.webrootPath#</li>
								</ul>
							</cfif>
						</cfLoop>
					</div>
				</cfOutput>
			</cfSaveContent>
			<cfReturn local.output />
		</cfFunction>

		<cfFunction
			name		= "getInstallItemPreview"
			returnType	= "string"
			access		= "remote"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				var local = {};

				local.installObjectArray = getInstallObjectArray();
			</cfScript>
			<cfSaveContent Variable="local.output">
				<h3>Install Items</h3>
				<p>Below are items associated with this plug-in. Choose which items to add/remove from the current running ColdFusion instance.</p>
				<br />
				<cfWindow
					name		= "IntallItemInfoWindow"
					title		= "Install Item Additional Information"
					modal		= "yes"
					center		= "yes"
					closable	= "true"
					draggable	= "true"
					initShow	= "no"
					resizable	= "true"
					bodyStyle	= "overflow:auto"
					width		= "400"
					height		= "400"
				></cfWindow>
				<div class="InstallItemsWrap">
					<div class="Status Title">Plugin Selection</div>
					<div class="Type Title">Install Type</div>
					<div class="Info Title">Plugin Selection</div>
					<cfOutput>
						<cfset local.itemCount=1 />
						<cfLoop array="#local.installObjectArray#" index="local.item">
							<cfset local.url = getProcessUrlAddress('getInstallItemAdditionalInformation').setVar('InstallItemId',local.itemCount).getString() />
							<div class="row">
								<cfset isItemIdInstalled(local.itemCount) />
								<div class="Status Value">
									<cfset local.isInstalled = isItemIdInstalled(local.itemCount) />
									<cfset local.inputType = 'checkbox' />
									<cfif local.isInstalled >
										<cfset local.inputType = 'radio' />
									</cfif>
									<label for="InstallItem_#local.item.name#_1">
										<input type="#local.inputType#" name="InstallItem_#local.item.name#" id="InstallItem_#local.item.name#_1" value="1" checked />&nbsp;&nbsp;#local.item.name#
									</label>
									<cfif local.isInstalled >
										<div>
											<label for="InstallItem_#local.item.name#_0">
												<input type="#local.inputType#" name="InstallItem_#local.item.name#" id="InstallItem_#local.item.name#_0" value="0" />&nbsp;&nbsp;Uninstall
											</label>
										</div>
									</cfif>
								</div>
								<div class="Type Value">
									<cfSwitch expression="#local.item.type#">
										<cfCase value="media">CFIDE Folder</cfCase>
										<cfDefaultCase>#local.item.type#</cfDefaultCase>
									</cfSwitch>
								</div>
								<div class="Info Value">
									<button type="button" value="Get Info" onclick="ColdFusion.navigate('#local.url#', 'IntallItemInfoWindow');ColdFusion.Window.show('IntallItemInfoWindow')">Get Info</button>
								</div>
							</div>
							<cfset local.itemCount = local.itemCount + 1 />
						</cfLoop>
					</cfOutput>
				</div>
			</cfSaveContent>
			<cfReturn local.output />
		</cfFunction>

		<cfFunction
			name		= "getInstallSummaryConfirmation"
			returnType	= "string"
			access		= "remote"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="isPastTense" required="no" type="boolean" default="no" hint="is this the confirmation process?" />
			<cfScript>
				var local = {};

				local.libraryRequirementArray = getLibraryRequirementArray();
				local.objectArray = getInstallObjectArray();

				local.mappingStruct = Expose('ColdFusion').getMappings();

				local.overviewClientInput = getClientInputStruct('getOverView');
				local.objectClientInput = getClientInputStruct('getInstallItemPreview');
			</cfScript>
			<cfSaveContent Variable="local.output">
				<div class="InstallSummaryWrap">
					<h3>Install Summary Confirmation</h3>
					<p>Below are items associated with this plug-in and the actions that<cfif arguments.isPastTense > have been<cfElse> will be</cfif> applied to them</p>
					<br />
					<cfOutput>
						<table cellPadding="0" cellSpacing="0" border="0">
							<tr>
								<th>Action</th><th>Item Name</th><th>Install Type</th><th>Install Path</th>
							</tr>
								<cfLoop array="#local.libraryRequirementArray#" index="local.item">
									<cfset local.value = local.overviewClientInput['#local.item.mappingName#_librarytype'] />
									<tr>
										<td>
											<cfif listFirst(local.value,'-') eq 'delete' >
												Remove<cfif arguments.isPastTense >d</cfif>
											<cfelse>
												Add<cfif arguments.isPastTense >ed</cfif>
											</cfif>
										</td>
										<td>#local.item.mappingName#</td>
										<td>
											<cfif listFirst(local.value,'-') eq 'webroot'>
												Web Root install
											<cfElse>
												Mapping Install
											</cfif>
										</td>
										<td>
											<cfif listFirst(local.value,'-') eq 'webroot'>
												#expandPath('/') & local.item.mappingName#
											<cfElse>
												#local.item.path#
											</cfif>
										</td>
									</tr>
								</cfLoop>
								<cfset local.counter = 1 />
								<cfLoop array="#local.objectArray#" index="local.item">
									<cfif structKeyExists(local.objectClientInput, "installitem_#local.item.name#") >
										<tr>
											<td>
												<cfif structKeyExists(local.objectClientInput, "installitem_#local.item.name#") AND local.objectClientInput["installitem_#local.item.name#"] >
													Add<cfif arguments.isPastTense >ed</cfif>
												<cfelseif structKeyExists(local.objectClientInput, "installitem_#local.item.name#") AND !local.objectClientInput["installitem_#local.item.name#"] >
													Remove<cfif arguments.isPastTense >d</cfif>
												</cfif>
											</td>
											<td>#local.item.name#</td>
											<td>
												<cfSwitch expression="#local.item.type#">
													<cfCase value="media">CFIDE Folder</cfCase>
													<cfDefaultCase>#local.item.type#</cfDefaultCase>
												</cfSwitch>
											</td>
											<td>#getTargetInstallPathByItemId(local.counter)#</td>
										</tr>
									</cfif>
									<cfset local.counter = local.counter + 1 />
								</cfLoop>
							</tr>
						</table>
					</div>
				</cfOutput>
				<!---
				<cfDump var="#local.overviewClientInput#" label="" expand="yes" />
				<cfDump var="#local.libraryRequirementArray#" label="" expand="no" />
				<hr />
				<cfDump var="#local.objectClientInput#" label="" expand="yes" />
				<cfDump var="#local.objectArray#" label="" expand="no" />
				--->
			</cfSaveContent>
			<cfReturn local.output />
		</cfFunction>

		<cfFunction
			name		= "getInstallCompleteConfirmation"
			returnType	= "string"
			access		= "remote"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				var local = {};

				/* install / uninstall */
					local.libraryRequirementArray = getLibraryRequirementArray();
					local.objectArray = getInstallObjectArray();

					local.mappingStruct = Expose('ColdFusion').getMappings();

					local.overviewClientInput = getClientInputStruct('getOverView');
					local.objectClientInput = getClientInputStruct('getInstallItemPreview');

					/* mappings */
						for(local.itemIndex=1; local.itemIndex LTE arrayLen(local.libraryRequirementArray); ++local.itemIndex)
						{
							local.item = local.libraryRequirementArray[local.itemIndex];
							local.value = local.overviewClientInput['#local.item.mappingName#_librarytype'];
							local.isDelete = listFirst(local.value,'-') eq 'delete';
							local.isMapping = listLast(local.value,'-') eq 'mapping';

							if(local.isMapping)
							{
								if(local.isDelete)
									Expose('ColdFusion').deleteMapping('/#local.item.mappingName#');
								else
									Expose('ColdFusion').addMapping('/#local.item.mappingName#',local.item.path);
							}else
							{
								local.installTo = expandPath('/')&local.item.mappingName;

								if(local.isDelete)
									Expose(local.installTo,'directory').delete();
								else
									Expose(local.item.path,'directory').copyTo(destination=local.installTo, nameconflict='overwrite');
							}
						}

						for(local.itemIndex=1; local.itemIndex LTE arrayLen(local.objectArray); ++local.itemIndex)
						{
							local.item = local.objectArray[local.itemIndex];
							local.isDelete = structKeyExists(local.objectClientInput, "installitem_#local.item.name#") AND !local.objectClientInput["installitem_#local.item.name#"];
							local.isInstall = structKeyExists(local.objectClientInput, "installitem_#local.item.name#") AND local.objectClientInput["installitem_#local.item.name#"];
							local.installPath = getTargetInstallPathByItemId(local.itemIndex);
							local.isFolder = !listLast(local.item.path,'/\') contains '.';

							if(local.isInstall)
							{
								if(local.isFolder)
									Expose(local.item.path,'directory').copyTo(destination=local.installPath, nameconflict='overwrite');
								else
								{
									if(fileExists(local.installPath))
										FileDelete(local.installPath);

									FileCopy(local.item.path, local.installPath);
								}
							}

							if(local.isDelete)
							{
								if(local.isFolder)
									Expose(local.installPath,'directory').delete();
								else
									FileDelete(local.installPath);
							}
						}
				/* end */
			</cfScript>
			<cfSaveContent Variable="local.output">
				<cfOutput>
					#getInstallSummaryConfirmation(1)#
					<br />
					<h3>Install Process Completed!</h3>
					<a href="#getProcessUrl('getOverView')#">Restart Install Process</a>
				</cfOutput>
			</cfSaveContent>
			<cfReturn local.output />
		</cfFunction>

		<cfFunction
			name		= "processLogin"
			returnType	= "boolean"
			access		= "remote"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="cfAdminUserName" required="no" type="string" default="" hint="" />
			<cfArgument name="cfAdminPassword" required="no" type="string" default="" hint="" />
			<cfReturn Expose(var='',type='ColdFusion').isValidLoginAccount(cfAdminUserName=arguments.cfAdminUserName, cfAdminPassword=arguments.cfAdminPassword) />
		</cfFunction>

		<cfFunction
			name			= "getInstallItemAdditionalInformation"
			returnType		= "string"
			access			= "remote"
			output			= "no"
			hint			= ""
			description		= ""
		>
			<cfArgument name="installItemId" required="yes" type="numeric" hint="" />
			<cfScript>
				var local = {};

				local.item = getInstallObjectArray();
				local.item = local.item[arguments.installItemId];

				if(len(local.item.description))
					local.item.description = local.item.description & '<br />';

				if(local.item.type eq 'media')
					local.item.description = local.item.description & 'This item will be made available by exposing the built-in CFIDE directory for it''s url availability to make this item as easily available via url invokation.';
				else if(local.item.type eq 'customtag')
					local.item.description = local.item.description & 'This item will be made available as a custom tag for use by any ColdFusion process.';
			</cfScript>
			<cfSaveContent Variable="local.output">
				<cfOutput>
					<div class="InstallItemInfoWrap">
						<h3>#local.item.name# Item Description</h3>
						<p>#local.item.description#</p>
						<br />
						<h4>Item Details:</h4>
						<table cellPadding="3" cellSpacing="3" border="0">
							<tr>
								<th>Target Install Path</th><td>#getTargetInstallPathByItemId(arguments.installitemId)#</td>
							</tr>
							<tr>
								<th>Repository Path</th><td>#local.item.path#</td>
							</tr>
							<tr>
								<th>Currently Installed</th><td>#yesNoFormat(isItemIdInstalled(arguments.installitemId))#</td>
							</tr>
							<tr>
								<th>Size</th>
								<td>
									<cfset local.path = local.item.path />
									<cfset local.filter = '' />
									<cfset local.isFile = listLast(local.item.path,'/\') contains '.' />
									<cfif local.isFile >
										<cfset local.filter = '#local.item.name#.cfm' />
										<cfset local.path = getDirectoryFromPath(local.item.path) />
									</cfif>
									<cfDirectory directory="#local.path#" name="local.dirList" action="list" recurse="no" type="all" sort="asc" filter="#local.filter#" />
									#local.dirList.size[1]#k
								</td>
							</tr>
						</table>
					</div>
				</cfOutput>
			</cfSaveContent>
			<cfReturn local.output />
		</cfFunction>
	<!--- END : Remote Methods --->
</cfComponent>