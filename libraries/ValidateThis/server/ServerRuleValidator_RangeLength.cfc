<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ServerRuleValidator_RangeLength" extends="AbstractServerRuleValidator" hint="I am responsible for performing the RangeLength validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="valObject" type="any" required="yes" hint="The validation object created by the business object being validated." />
	
		<cfset var Parameters = arguments.valObject.getParameters() />
		<cfset var theLength =  Len(arguments.valObject.getObjectValue()) />
		<cfif shouldTest(arguments.valObject) AND theLength LT Parameters.MinLength OR theLength GT Parameters.MaxLength>
			<cfset fail(arguments.valObject,createDefaultFailureMessage("#arguments.valObject.getPropertyDesc()# must be between #Parameters.MinLength# and #Parameters.MaxLength# characters long.")) />
		</cfif>
	</cffunction>
	
</cfcomponent>
	

