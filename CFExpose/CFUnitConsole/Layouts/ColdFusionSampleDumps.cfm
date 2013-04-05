<cfset methodList = structKeyList(GetFunctionList()) />
<div class="SampleDumpOptionsWrap">
	<a href="#" class="selectable" name="directoryRead">cfDirectory List</a>
	<a href="#" class="selectable" name="cfObjectCache" title="Clears Query Cache">cfObjectCache</a>
	<a href="#" class="selectable" name="GetHttpRequestData" title="returns data relavent to a running request">GetHttpRequestData()</a>
	<cfif listFindNoCase(methodList, "directoryList") >
		<a href="#" class="selectable" name="directoryList" title="">directoryList()</a>
	</cfif>
	<a href="#" class="selectable" name="ComponentGetMetaData" title="Example return of using the method getMetaData() with a component as your argument">Component getMetaData()</a>
	<cfif listFindNoCase(methodList, "FileOpen") >
		<a href="#" class="selectable" name="FileOpen" title="Demonstrates use of the function FileOpen(). Tech Note:For this example, FileClose() is automatically used as always should you always FileClose() after you open a file with FileOpen()">FileOpen()</a>
	</cfif>
	<a href="#" class="selectable" name="getFileInfo" title="Example use of the function getFileInfo()">getFileInfo()</a>
	<a href="#" class="selectable" name="getTempDirectory" title="Example use of the function getTempDirectory()">getTempDirectory()</a>

	<cfif listFindNoCase(methodList, "OrmFlush") >
		<!---
		<a href="#" class="selectable" name="EntityReload" title="Clears all entity cache">EntityReload()</a>
		--->
		<a href="#" class="selectable" name="OrmFlush" title="Clears all data cache and sends all awaited data transaction to the database for execution">OrmFlush()</a>
		<a href="#" class="selectable" name="OrmReload" title="Clears and reloads all ORM object metadata">OrmReload()</a>
		<a href="#" class="selectable" name="ormSessionDump">Orm Session Dump</a>
	</cfif>
</div>