<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" hint="I wrap a struct to allow it to be validated like an object.">

	<cffunction name="Init" access="Public" returntype="any" output="false" hint="I am the constructor">
		<cfreturn this />
	</cffunction>

	<cffunction name="setup" access="Public" returntype="any" output="false" hint="I am called after the constructor to load data into an instance">
		<cfargument name="theStruct" type="struct" required="yes" hint="The struct to be wrapped" />
		<cfset variables.theStruct = arguments.theStruct />
	</cffunction>

	<cffunction name="getValue" access="public" output="false" returntype="Any" hint="An abstract getter">
		<cfargument name="propertyName" type="any" required="true" />
		
		<cfif structKeyExists(variables.theStruct,arguments.propertyName)>
			<cfreturn variables.theStruct[arguments.propertyName] />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>

</cfcomponent>
	

