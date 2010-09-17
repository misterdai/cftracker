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
<cfcomponent output="false" hint="I am _the_ factory object for ValidateThis, I also create BO Validators for the framework.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ValidationFactory">
		<cfargument name="ValidateThisConfig" type="struct" required="true" />

		<cfset var lwConfig = createObject("component","ValidateThis.util.BeanConfig").init(arguments.ValidateThisConfig) />
		<cfset variables.lwFactory = createObject("component","ValidateThis.util.LightWire").init(lwConfig) />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<cfset variables.Validators = StructNew() />

		<cfreturn this />
	</cffunction>

	<cffunction name="createBOVsFromCFCs" access="public" output="false" returntype="void" hint="I create BOVs from annotated CFCs">
		
		<cfset var fileSystem = getBean("fileSystem") />
		<cfset var BOComponentPath = ""/>
		<cfset var actualPath = ""/>
		<cfset var cfcNames = "" />
		<cfset var cfc = "" />
		<cfset var componentPath = ""/>
		<cfset var objectType = "" />
		<cfset var md = "" />
		
		<cfloop list="#variables.ValidateThisConfig.BOComponentPaths#" index="BOComponentPath">
			<cfset actualPath = fileSystem.getMappingPath(BOComponentPath) />
			<cfset cfcNames = fileSystem.listRelativeFilePaths(actualPath,"*.cfc",true)/>
			<cfloop list="#cfcNames#" index="cfc">
				<cfset componentPath = BOComponentPath & replace(replaceNoCase(cfc,".cfc","","last"),"/",".","all") />
				<cfset objectType = listLast(componentPath,".") />
				<cfset md = getComponentMetadata(componentPath) />
				
				<!--- TODO: Now we need to call getValidator --->
				<cfset getValidator(objectType=listLast(componentPath,"."),componentPath=componentPath,definitionPath=getDirectoryFromPath(fileSystem.getMappingPath(componentPath))) />
				<!---
				<cfif ListLast(obj,".") EQ "cfc" AND obj CONTAINS arguments.fileNamePrefix>
					<cfset arguments.childCollection[replaceNoCase(ListLast(obj,"_"),".cfc","")] = CreateObject("component",componentPath & ReplaceNoCase(obj,".cfc","")).init(argumentCollection=arguments.initArguments) />
				</cfif>
				--->
			</cfloop>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getBean" access="public" output="false" returntype="any" hint="I return a singleton">
		<cfargument name="BeanName" type="Any" required="false" />
		
		<cfreturn variables.lwFactory.getSingleton(arguments.BeanName) />
	
	</cffunction>
	
	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="false" default="" />
		<cfargument name="theObject" type="any" required="false" default="" hint="The object from which to read annotations" />
		<cfargument name="componentPath" type="any" required="false" default="" hint="The component path to the object - used to read annotations using getComponentMetadata" />

		<cfif NOT StructKeyExists(variables.Validators,arguments.objectType)>
			<cfset variables.Validators[arguments.objectType] = createValidator(argumentCollection=arguments) />
		</cfif>
		<cfreturn variables.Validators[arguments.objectType] />
		
	</cffunction>
	
	<cffunction name="createValidator" returntype="any" access="private" output="false">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" hint="The object from which to read annotations, a blank means no object was passed" />
		<cfargument name="componentPath" type="any" required="true" hint="The component path to the object - used to read annotations using getComponentMetadata" />
		
		<cfreturn CreateObject("component",variables.ValidateThisConfig.BOValidatorPath).init(arguments.objectType,getBean("FileSystem"),
			getBean("externalFileReader"),getBean("annotationReader"),getBean("ServerValidator"),getBean("ClientValidator"),getBean("TransientFactory"),
			getBean("CommonScriptGenerator"),getBean("Version"),
			variables.ValidateThisConfig.defaultFormName,variables.ValidateThisConfig.defaultJSLib,variables.ValidateThisConfig.JSIncludes,variables.ValidateThisConfig.definitionPath,
			arguments.definitionPath,arguments.theObject,arguments.componentPath) />

	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn getBean("TransientFactory").newResult() />
		
	</cffunction>

</cfcomponent>
	

