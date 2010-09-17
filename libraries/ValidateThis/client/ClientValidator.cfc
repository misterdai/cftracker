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
<cfcomponent displayname="ClientValidator" output="false" hint="I generate client side validations from Business Object validations.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ClientValidator">
		<cfargument name="childObjectFactory" type="any" required="true" />
		<cfargument name="translator" type="any" required="true" />
		<cfargument name="fileSystem" type="any" required="true" />
		<cfargument name="JSRoot" type="string" required="true" />
		<cfargument name="extraClientScriptWriterComponentPaths" type="string" required="true" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="true" />

		<cfset variables.childObjectFactory = arguments.childObjectFactory />
		<cfset variables.translator = arguments.translator />
		<cfset variables.fileSystem = arguments.fileSystem />
		<cfset variables.JSRoot = arguments.JSRoot />
		<cfset variables.extraClientScriptWriterComponentPaths = arguments.extraClientScriptWriterComponentPaths />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />

		<cfset setScriptWriters() />
		<cfreturn this />
	</cffunction>

	<cffunction name="getValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script.">
		<cfargument name="Validations" type="any" required="true" />
		<cfargument name="formName" type="any" required="true" />
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var validation = "" />
		<cfset var theScript = "" />
		<cfset var theScriptWriter = variables.ScriptWriters[arguments.JSLib] />

		<cfsetting enableCFoutputOnly = "true">
		
		<cfif IsArray(arguments.Validations) and ArrayLen(arguments.Validations)>
			<!--- Loop through the validations array, generating the JS validation statements --->
			<cfsavecontent variable="theScript">
				<cfoutput>#Trim(theScriptWriter.generateScriptHeader(arguments.formName))#</cfoutput>
				<cfloop Array="#arguments.Validations#" index="validation">
					<!--- Generate the JS validation statements  --->
					<cfoutput>#Trim(theScriptWriter.generateValidationScript(validation,arguments.formName,arguments.locale))#</cfoutput>
				</cfloop>
				<cfoutput>#Trim(theScriptWriter.generateScriptFooter())#</cfoutput>
			</cfsavecontent>
		</cfif>
		<cfsetting enableCFoutputOnly = "false">
		<cfreturn theScript />

	</cffunction>

	<cffunction name="getGeneratedJavaScript" returntype="any" access="public" output="false" hint="I ask the appropriate client script writer to generate some JS for me.">
		<cfargument name="scriptType" type="any" required="true" hint="Current valid values are JSInclude, Locale and VTSetup." />
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="formName" type="any" required="false" default="" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />
		<cfinvoke component="#variables.ScriptWriters[arguments.JSLib]#" method="generate#arguments.scriptType#Script" locale="#arguments.locale#" formName="#arguments.formName#" returnvariable="theScript" />
		<cfreturn theScript />

	</cffunction>
	
	<cffunction name="getScriptWriters" access="public" output="false" returntype="any">
		<cfreturn variables.ScriptWriters />
	</cffunction>
	
	<cffunction name="setScriptWriters" returntype="void" access="private" output="false" hint="I create script writer objects from a list of component paths">
		
		<cfset var initArgs = {childObjectFactory=variables.childObjectFactory,translator=variables.translator,JSRoot=variables.JSRoot,extraClientScriptWriterComponentPaths=variables.extraClientScriptWriterComponentPaths,defaultFailureMessagePrefix=variables.defaultFailureMessagePrefix} />
		<cfset var swDirs = variables.fileSystem.listDirs(GetDirectoryFromPath(getCurrentTemplatePath())) />
		<cfset var swDir = 0 />
		<cfset var swPaths = "" />
		<cfloop list="#swDirs#" index="swDir">
			<cfset swPaths = listAppend(swPaths,"ValidateThis.client." & swDir) />
		</cfloop>
		<cfset variables.ScriptWriters = variables.childObjectFactory.loadChildObjects(swPaths & "," & variables.extraClientScriptWriterComponentPaths,"ClientScriptWriter_",structNew(),initArgs) />

	</cffunction>
	
	<cffunction name="getScriptWriter" access="public" output="false" returntype="any">
		<cfargument name="JSLib" type="any" required="true" />
		<cfreturn variables.ScriptWriters[arguments.JSLib] />
	</cffunction>

</cfcomponent>

