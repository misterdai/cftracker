<style>
	#StageArea .x-border-layout-ct {border-width:0px}
</style>
<div class="ucFormWrap" id="<cfOutput>#getJsClassName()#Wrap</cfOutput>">
	<form class="ucForm" method="post" target="_blank" style="width:100%;height:100%;display:block">
		<input type="hidden" name="isCFUnitConsoleRequest" value="true" />
		<cfOutput>
			<!--- carry over any form input variables --->
				<cfLoop collection="#form#" item="inputname">
					<cfif inputname NEQ 'FIELDNAMES' >
						<input type="hidden" name="#inputname#" value="#form[inputname]#" class="passthru" />
					</cfif>
				</cfLoop>
			<!--- end --->
		</cfOutput>
		<cfLayout
			type		= "border"
			name		= "ucLayout"
			style		= "width:640px;"
			align		= "left"
		>
			<cfLayoutArea
				position		= "left"
				title			= "Control Panel"
				name			= "ControlPanel"
				style			= "width:210px;overflow:hidden"
				splitter		= "no"
				align			= "left"
				overflow		= "auto"
				collapsible		= "yes"
				initcollapsed	= "no"
				closable		= "no"
				inithide		= "no"
			>
				<div class="ControlPanel"><cfInclude template="SkinControlPanel.cfm" /></div>
			</cfLayoutArea>

			<cfLayoutArea
				position		= "center"
				name			= "StageArea"
				align			= "left"
			>
				<cfLayout
					type	= "border"
					name	= "Stage"
					align	= "left"
				>
					<cfLayoutArea
						position		= "top"
						title			= "Function Based Code Evaluation"
						style			= "height:100%"
						splitter		= "yes"
						align			= "left"
						overflow		= "auto"
						collapsible		= "yes"
						initcollapsed	= "yes"
						closable		= "no"
						inithide		= "no"
					>
						<cfInclude template="CodingWrap.cfm" />
					</cfLayoutArea>
					<cfLayoutArea
						position		= "center"
						name			= "BottomResultContainer"
						align			= "left"
						overflow		= "auto"
					>
						<cfInclude template="CenterStage.cfm" />
					</cfLayoutArea>
				</cfLayout>
			</cfLayoutArea>
		</cfLayout>
	</form>
</div>