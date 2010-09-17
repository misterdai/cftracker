<!--- 
   Copyright 2007 Paul Marcotte, Bob Silverberg

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   TransientFactory.cfc (.1)
   [2009-09-25]	Initial Release.				
 --->
<cfcomponent output="false" hint="I create Transient objects.">

	<!--- public --->

	<cffunction name="init" access="public" output="false" returntype="any" hint="returns a configured transient factory">
		<cfargument name="lightWire" type="any" required="yes" />
		<cfset variables.lightWire = arguments.lightWire />
		<!---<cfargument name="pathToResultObject" type="string" required="yes" />
		<cfset variables.classes = {Result=arguments.pathToResultObject,Validation="ValidateThis.server.Validation",BusinessObjectWrapper="ValidateThis.core.BusinessObjectWrapper",ResourceBundle="ValidateThis.util.ResourceBundle"} />--->
		<cfset variables.afterCreateMethod = "setup" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="any" hint="returns a configured, autowired transient">
		<cfargument name="transientName" type="string" required="true">
		<cfargument name="afterCreateArgs" type="struct" required="false" default="#structNew()#">
		
		
		<cfset var obj = variables.lightWire.getTransient(arguments.transientName) />
		<!--- Need to do manual injections of singletons as we're not coupled to CS anymore, ugly but it works for now 
		<cfif arguments.transientName EQ "Result">
			<cfset initArgs.Translator = variables.Translator />
		</cfif>
		<cfset local.obj = createObject("component",variables.classes[arguments.transientName])>
		<cfif StructKeyExists(local.obj,"init")>
			<cfinvoke component="#local.obj#" method="init" argumentcollection="#arguments.initArgs#" />
		</cfif>--->
		<cfif StructKeyExists(obj,variables.afterCreateMethod)>
			<cfinvoke component="#obj#" method="#variables.afterCreateMethod#" argumentcollection="#arguments.afterCreateArgs#" />
		</cfif>
		<cfreturn obj>
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="any" hint="provides virtual api [new{transientName}] for any registered transient.">
		<cfargument name="MissingMethodName" type="string" required="true" />
		<cfargument name="MissingMethodArguments" type="struct" required="true" />
		<cfif (Left(arguments.MissingMethodName,3) eq "new")>
			<cfreturn create(Right(arguments.MissingMethodName,Len(arguments.MissingMethodName)-3),arguments.MissingMethodArguments)>
		</cfif>
	</cffunction>

</cfcomponent>
