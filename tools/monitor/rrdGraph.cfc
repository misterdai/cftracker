<cfcomponent output="false">
	<cfscript>
		variables.colours = ['336699','99CCFF','999933','666699','CC9933','006666','3399FF','993300','CCCC99','666666','FFCC66','6699CC','663366','9999CC','CCCCCC','669999','CCCC66','CC6600','9999FF','0066CC','99CCCC','999999','FFCC00','009999','99CC33','FF9900','999966','66CCCC','339966','CCCC33'];
	</cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="filename" type="string" required="true" />
		<cfscript>
			var local = {};
			
			variables.filename = arguments.filename;
			variables.colourIndex = 1;

			variables.jConsole = CreateObject('java', 'org.rrd4j.ConsolFun');
			variables.jUtil = CreateObject('java', 'org.rrd4j.core.Util').init();
			variables.jBuffImg = CreateObject('java', 'java.awt.image.BufferedImage');

			variables.jGraphDef = CreateObject('java', 'org.rrd4j.graph.RrdGraphDef');
			variables.jGraphDef.setFilename(variables.filename);
			variables.jGraphDef.setAntiAliasing(true);
			variables.jGraphDef.setTitle('test');
			variables.jGraphDef.setShowSignature(false);
		
			variables.methods = {};
			local.methods = variables.jGraphDef.getClass().getMethods();
			local.len = ArrayLen(local.methods);
			for (local.i = 1; local.i Lte local.len; local.i++) {
				local.name = local.methods[local.i].getName();
				if (Left(local.name, 3) Eq 'set') {
					variables.methods[local.name] = local.methods[local.i];
				}
			}
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="setTimeSpan" access="public" output="false">
		<cfargument name="start" type="date" required="true" />
		<cfargument name="end" type="date" required="false" default="#Now()#" />
		<cfscript>
			var local = {};
			local.tzInfo = GetTimeZoneInfo();
			arguments.start = DateAdd('n', local.tzInfo.utcHourOffset * 60 + local.tzInfo.utcMinuteOffset, arguments.start);
			arguments.end = DateAdd('n', local.tzInfo.utcHourOffset * 60 + local.tzInfo.utcMinuteOffset, arguments.end);
			variables.start = DateDiff('s', CreateDate(1970, 1, 1), arguments.start);
			variables.end = DateDiff('s', CreateDate(1970, 1, 1), arguments.end);
			variables.jGraphDef.setStartTime(JavaCast('long', variables.start));
			variables.jGraphDef.setEndTime(JavaCast('long', variables.end));
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="addDatasource" access="public" output="false">
		<cfargument name="itemName" type="string" required="true" />
		<cfargument name="rrdPath" type="string" required="true" />
		<cfargument name="dsName" type="string" required="true" />
		<cfargument name="archive" type="string" required="false" default="AVERAGE" />
		<cfscript>
			var local = {};
			variables.jGraphDef.datasource(arguments.itemName, arguments.rrdPath, arguments.dsName, variables.jConsole[UCase(arguments.archive)]);
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="addCDef" access="public" output="false">
		<cfargument name="itemName" type="string" required="true" />
		<cfargument name="cdef" type="string" required="true" />
		<cfset variables.jGraphDef.datasource(arguments.itemName, arguments.cdef) />
		<cfreturn true />
	</cffunction>
	
	<cffunction name="comment" access="public" output="false">
		<cfargument name="text" type="string" required="true" />
		<cfargument name="endLine" type="boolean" required="false" default="false" />
		<cfscript>
			var local = {};
			if (arguments.endLine) {
				local.el = '\l';
			} else {
				local.el = '';
			}
			variables.jGraphDef.comment(arguments.text & local.el);
		</cfscript>
	</cffunction>
	
	<cffunction name="gprint" access="public" output="false">
		<cfargument name="itemName" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfargument name="format" type="string" required="true" />
		<cfargument name="endLine" type="boolean" required="false" default="false" />
		<cfscript>
			var local = {};
			if (arguments.endLine) {
				local.el = '\l';
			} else {
				local.el = '';
			}
			variables.jGraphDef.gprint(arguments.itemName, variables.jConsole[UCase(arguments.value)], arguments.format & local.el);
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="line" access="public" output="false">
		<cfargument name="itemName" type="string" required="true" />
		<cfargument name="colour" type="string" required="false" />
		<cfargument name="legend" type="string" required="false" default="" />
		<cfargument name="width" type="numeric" required="false" default="1" />
		<cfscript>
			var local = {};
			if (StructKeyExists(arguments, 'colour')) {
				local.colour = arguments.colour;
			} else {
				local.colour = variables.colours[variables.colourIndex];
				variables.colourIndex++;
				if (variables.colourIndex Gt ArrayLen(variables.colours)) {
					variables.colourIndex = 1;
				}
			}

			variables.jGraphDef.line(arguments.itemName, variables.jUtil.parseColor(local.colour), arguments.legend, JavaCast('long', arguments.width));
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="render" access="public" output="false">
		<cfscript>
			var local = {};
			variables.jGraph = CreateObject('java', 'org.rrd4j.graph.RrdGraph').init(variables.jGraphDef);
			local.jImage = CreateObject('java', 'java.awt.image.BufferedImage').init(100, 100, variables.jBuffImg.TYPE_INT_RGB);
			variables.jGraph.render(local.jImage.getGraphics());
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="image" access="public" output="false">
		<cfscript>
			return variables.jGraph.getRrdGraphInfo().getBytes();
		</cfscript>
	</cffunction>
	
	<cffunction name="imageTag" access="public" output="false">
		<cfset var output = '' />
		<cfsavecontent variable="output"><cfimage action="writeToBrowser" source="#variables.jGraph.getRrdGraphInfo().getBytes()#" format="png" /></cfsavecontent>
		<cfreturn output />
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false">
		<cfargument name="missingMethodName" type="string" required="true" />
		<cfargument name="missingMethodArguments" type="struct" required="true" />
		<cfscript>
			var local = {};
			if (Left(arguments.missingMethodName, 3) Eq 'set' And StructKeyExists(variables.methods, arguments.missingMethodName)) {
				local.params = ArrayNew(1);
				local.jParams = variables.methods[arguments.missingMethodName].getParameterTypes();
				local.jPCount = ArrayLen(local.jParams);
				if (local.jPCount Eq ArrayLen(arguments.missingMethodArguments)) {
					for (local.i = 1; local.i Lte local.jPCount; local.i++) {
						local.params[local.i] = JavaCast(ListLast(local.jParams[local.i].getName(), '.'), arguments.missingMethodArguments[local.i]);
					}
					variables.methods[arguments.missingMethodName].invoke(variables.jGraphDef, local.params);
				} else {
					//throw('Parameter mismatch');
				}
				
			}
		</cfscript>
	</cffunction>
	
	<!---
		variables.jGraphDef has a load of set methods
		what's the best way to expose them
		
		Examples:
			variables.jGraphDef.setVerticalLabel(string);
			variables.jGraphDef.setUnit(string);
			variables.jGraphDef.setWidth(int);
			variables.jGraphDef.setTitle(string);
			variables.jGraphDef.setLazy(boolean);
		Goal:
			cfcRrdGraph.setWidth(123);
			cfcRrdGraph.setTitle('bob');
		Want to avoid:
			onMissingMethod + Evaluate
				result = Evaluate('variables.jGraphDef.#arguments[1]#('#arguments[2]#')
			Creating all those set methods by hand when they just mirror the others
	--->
</cfcomponent>
