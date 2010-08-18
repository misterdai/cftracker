<cfcomponent output="false">
	<cffunction name="init" access="public" output="false">
		<cfargument name="filename" type="string" required="true" />
		<cfscript>
			variables.jConsole = CreateObject('java', 'org.rrd4j.ConsolFun');
			variables.jDsType = CreateObject('java', 'org.rrd4j.DsType');
			variables.jDouble = CreateObject('java', 'java.lang.Double');
			variables.jPool = CreateObject('java', 'org.rrd4j.core.RrdDbPool').getInstance();
			variables.filename = arguments.filename;
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="boolean">
		<cfargument name="filename" type="string" required="true" />
		<cfargument name="starttime" type="numeric" required="false" default="#Now()#" />
		<cfargument name="datasources" type="array" required="true" hint="['DS:name:GAUGE:600:0:U']" />
		<cfargument name="archives" type="array" required="true" hint="['RRA:AVERAGE:0.5:10:1000']" />
		<cfscript>
			var local = {};
			local.jRrdDef = CreateObject('java', 'org.rrd4j.core.RrdDef').init(variables.filename);
			local.startTime = DateDiff('s', CreateDate(1970, 1, 1), arguments.starttime);
			local.jRrdDef.setStartTime(JavaCast('long', 0));
			local.dsCount = ArrayLen(arguments.datasources);
			for (local.i = 1; local.i Lte local.dsCount; local.i++) {
				local.jRrdDef.addDatasource(arguments.datasources[local.i]);
			}
			local.archCount = ArrayLen(arguments.archives);
			for (local.i = 1; local.i Lte local.archCount; local.i++) {
				local.jRrdDef.addArchive(arguments.archives[local.i]);
			}
			local.jRrdDb = CreateObject('java', 'org.rrd4j.core.RrdDb').init(local.jRrdDef);
			local.jRrdDb.close();
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="addData" access="public" output="false" returntype="boolean">
		<cfargument name="data" type="array" required="true" />
		<cfscript>
			var local = {};
			local.len = ArrayLen(arguments.data);
			variables.jRrdDb = variables.jPool.requestRrdDb(variables.filename);
		</cfscript>
		<cftry>
			<cfscript>
				local.jSample = variables.jRrdDb.createSample();
				for (local.i = 1; local.i Lte local.len; local.i++) {
					local.jSample.setAndUpdate(arguments.data[local.i]);
				}
			</cfscript>
			<cfcatch type="any">
				<cfset variables.jPool.release(variables.jRrdDb) />
				<cfrethrow />
			</cfcatch>
		</cftry>
		<cfset variables.jPool.release(variables.jRrdDb) />
		<cfreturn true />
	</cffunction>
</cfcomponent>