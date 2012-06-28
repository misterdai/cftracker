<cfdump var="#SESSION#">
<cfoutput>	
StructCount : #StructCount( SESSION )#<br>
IsNull : #IsNull( SESSION )#<br>
IsDefined : #IsDefined( "SESSION" )#<br>
</cfoutput>

<cfabort>


<cfscript>
NeoPageContext = CreateObject( "java", "coldfusion.runtime.NeoPageContext" );
writeDump( NeoPageContext );
writeDump( NeoPageContext.getVariableScope() );

CfJspPage = CreateObject( "java", "coldfusion.runtime.CfJspPage" );
writeDump( CfJspPage );

/*MemoryTrackable = CreateObject( "java", "coldfusion.monitor.MemoryTrackable" );
writeDump( MemoryTrackable );*/

QueryStat = CreateObject( "java", "coldfusion.monitor.sql.QueryStat" );
writeDump( QueryStat );

MemoryTrackerProxy = CreateObject( "java", "coldfusion.monitor.memory.MemoryTrackerProxy" );
writeDump( MemoryTrackerProxy );

ServletContext = CreateObject( "java", "javax.servlet.ServletContext" );
writeDump( ServletContext );
</cfscript>
