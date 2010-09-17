<!---
	
	Copyright 2009, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" hint="I am used to deal with different types of objects: standard CFCs, Wheels objects and Groovy objects.">

	<cffunction name="Init" access="Public" returntype="any" output="false">
		<cfargument name="abstractGetterMethod" type="string" required="true" />
		
		<cfset variables.abstractGetterMethod = arguments.abstractGetterMethod />
		<cfreturn this />

	</cffunction>
	
	<cffunction name="isCFC" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a cfc.">
		<cfargument name="theObject" type="any" required="true" />
		
		<cfreturn isInstanceOf(arguments.theObject,"WEB-INF.cftags.component") />
	
	</cffunction>

	<cffunction name="isWheels" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a Wheels object.">
		<cfargument name="theObject" type="any" required="true" />
		
		<cfreturn isInstanceOf(arguments.theObject,"models.Wheels") />
	
	</cffunction>

	<cffunction name="isGroovy" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a Groovy object.">
		<cfargument name="theObject" type="any" required="true" />
		
		<cfreturn structKeyExists(arguments.theObject,"metaclass") AND isInstanceOf(arguments.theObject.metaclass,"groovy.lang.MetaClassImpl") />
	
	</cffunction>

	<cffunction name="findGetter" access="public" output="false" returntype="any" hint="I try to locate a property in an object, returning the name of the getter">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="propertyName" type="any" required="true" />
		
		<cfset var theProp = "" />
		<cfset var theGetter = "" />
		
		<cfif isWheels(arguments.theObject)>
			<cfif structKeyExists(arguments.theObject.properties(),arguments.propertyName)>
				<cfset theGetter = "$propertyvalue('#arguments.propertyName#')" />
			</cfif>
		<cfelseif isCFC(arguments.theObject)>
			<cfif structKeyExists(arguments.theObject,"get" & arguments.propertyName)>
				<cfset theGetter = "get#arguments.propertyName#()" />
			<cfelseif structKeyExists(arguments.theObject,variables.abstractGetterMethod)>
				<cfset theGetter = "#variables.abstractGetterMethod#('#arguments.propertyName#')" />
			</cfif>
		<cfelseif isGroovy(arguments.theObject)>
			<cfset theProp = arguments.theObject.metaclass.hasProperty(arguments.theObject,arguments.propertyName) />
			<cfif isDefined("theProp")>
				<cfset theGetter = theProp.getGetter().getName() & "()" />
			</cfif>
		</cfif>
		
		<cfreturn theGetter />

	</cffunction>

</cfcomponent>
	

