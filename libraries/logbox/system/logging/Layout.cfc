<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	3/13/2009
Description :
	This is a base layout object that will help you create custom 
	layout's for messages in appenders
----------------------------------------------------------------------->
<cfcomponent output="false" hint="This is a base custom layout for a message in an appender.">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cfscript>
		// The log levels enum as a public property
		this.logLevels = createObject("component","logbox.system.logging.LogLevels");
		// A line Sep Constant, man, wish we had final in CF.
		this.LINE_SEP  = chr(13) & chr(10);
	</cfscript>
	
	<!--- Init --->
	<cffunction name="init" access="public" returntype="Layout" hint="Constructor" output="false">
		<cfargument name="appender" type="logbox.system.logging.AbstractAppender" required="true" default="" hint="The appender linked to."/>
		<cfscript>
			
			// The appender we are linked to.
			instance.appender = arguments.appender;
			
			// Return 
			return this;
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PUBLIC ------------------------------------------>

	<!--- format --->
	<cffunction name="format" output="false" access="public" returntype="string" hint="Format a logging event message into your own format">
		<cfargument name="logEvent" type="logbox.system.logging.LogEvent"   required="true"   hint="The logging event to use to create a message.">
		<cfthrow message="You must implement this layout's format() method."
				 type="Layout.FormatNotImplementedException">
	</cffunction>
	
</cfcomponent>