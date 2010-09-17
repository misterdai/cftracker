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
<cfcomponent output="false" name="ClientRuleScripter_EqualTo" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the EqualTo validation.">

	<cffunction name="generateSpecificValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		
		<!--- Not working yet
		<cfreturn "objForm#arguments.formName#.#arguments.validation.clientFieldName#.validateSame(objForm#arguments.formName#.#arguments.validation.Parameters.ComparePropertyName#.obj);" />
		 --->
		 <cfreturn "" />

	</cffunction>

</cfcomponent>

