<cfscript>
SessionTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');

writeDump(SessionTracker);

NeoPageContext = CreateObject( "java", "coldfusion.runtime.NeoPageContext" );
writeDump( NeoPageContext );

CfJspPage = CreateObject( "java", "coldfusion.runtime.CfJspPage" );
writeDump( CfJspPage );


QueryStat = CreateObject( "java", "coldfusion.monitor.sql.QueryStat" );
writeDump( QueryStat );

MemoryTrackerProxy = CreateObject( "java", "coldfusion.monitor.memory.MemoryTrackerProxy" );
writeDump( MemoryTrackerProxy );

ServletContext = CreateObject( "java", "javax.servlet.ServletContext" );
writeDump( ServletContext );

writeDump(server);
//MemoryTrackable = CreateObject( "java", "coldfusion.monitor.MemoryTrackable" );
//writeDump( MemoryTrackable );
</cfscript>
