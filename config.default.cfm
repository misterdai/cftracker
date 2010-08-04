<cfscript>
	settings = StructNew();
	// Demo mode
	settings.demo = false;
	// Access settings
	settings.security.password = '';
	settings.security.maxattempts = 5;
	settings.security.lockseconds = 3600;
	// Display settings	
	settings.display.dateFormat = 'yyyy-mm-dd';
	settings.display.timeFormat = 'HH:mm:ss';
</cfscript>