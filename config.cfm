<cfscript>
	settings = StructNew();
	// Access settings
	settings.password = 'password';
	// Display settings	
	settings.display.dateFormat = 'yyyy-mm-dd';
	settings.display.timeFormat = 'HH:mm:ss';
	// Dashboard settings
	settings.dashboard.updateInterval = 5000;
</cfscript>