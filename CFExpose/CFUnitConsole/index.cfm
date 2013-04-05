<cfScript>
	currentUrlFolder = getDirectoryFromPath(cgi.script_name);
	mediaUrlAddress = listDeleteAt(currentUrlFolder,listLen(currentUrlFolder,'/\'),'/\') & '/Media/';
</cfScript>
<!DOCTYPE html>
<html style="width:100%;height:100%;margin:0px;padding:0px">
	<head></head>
	<body style="width:100%;height:100%;margin:0px;padding:0px">
		<cfModule
			template					= "../CustomTags/UnitConsole.cfm"
			isWindowMode				= "#isDefined('isWindowMode')#"
			mediaUrlAddress				= "#mediaUrlAddress#"
			remoteProcessorUrlAddress	= "#currentUrlFolder#"
			isDebug						= "#isDefined('isDebug') AND ((isBoolean(isDebug) AND isDebug) OR (isSimpleValue(isDebug) AND not len(isDebug)))#"
		/>
	</body>
</html>