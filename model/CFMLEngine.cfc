<cfcomponent output="false" hint="I represent the CFML server">
	<cfscript>

	CFMLEngine function init(){
		variables.JAVAVersion = CreateObject( "java", "java.lang.System" ).getProperty( "java.version" );
		variables.productVersion = listFirst( server.coldfusion.productversion );
		variables.productName = UCase( server.coldfusion.productname );
	}
	
	string function getJAVAVersion(){
		return variables.JAVAVersion;
	}
	
	string function getVersion(){
		return variables.productVersion;
	}
	
	string function getName(){
		return variables.productName;
	}
	
	</cfscript>
</cfcomponent>