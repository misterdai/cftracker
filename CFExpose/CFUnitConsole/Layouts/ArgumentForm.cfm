<style>
	.ArgumentFormTable {border:2px black groove;width:100%}
	.ArgumentFormWrap {/*display:table;*/}
	.ArgumentFormWrap .Title {padding:3px;background-color:#888888;color:white}
	.ArgumentFormWrap form {margin-bottom:3px;padding-bottom:3px}
	.ArgumentFormWrap .ColumnHeadWrap {font-size:0.7em;}
	.ArgumentFormWrap .ColumnHeadWrap td {background:#333333;color:white}
	.ArgumentFormWrap .ColumnHead {white-space:nowrap;padding:3px;}
	.ArgumentFormWrap .Send.ColumnHead {text-align:center}
	.ArgumentFormWrap .Name.ColumnHead {text-align:left}
	.ArgumentFormWrap .Value.ColumnHead {min-width:150px;text-align:left}
	.ArgumentFormWrap .Type.ColumnHead {width:75px}
	.ArgumentFormWrap .Hint.ColumnHead {}
	.ArgumentFormWrap .MetaDataTitle {padding-left:5px}
	.ArgumentFormWrap .Odd {background-color:#EEEEEE}
	.ArgumentFormWrap .Even {background-color:#FFFFFF}
	.ArgumentFormWrap .Entry {padding:2px;padding-bottom:4px}
	.ArgumentFormWrap .Send.Entry {text-align:center}
	.ArgumentFormWrap .Type.Entry {font-size:0.7em;text-align:center}
	.ArgumentFormWrap .Hint.Entry {font-size:0.7em;text-align:left}
	.ArgumentFormWrap .Value.Entry input.Value {width:100%}
	.ArgumentFormWrap .SubmitWrap {text-align:center;padding:4px;background-color:#CCCCCC;border-top:1px solid black}
</style>
<div class="ArgumentFormWrap">
	<cfoutput>
		<form action="javascript:return false" onsubmit="#arguments.onSubmit#(this);return false;">
			<input type="hidden" name="targetMethod" value="#arguments.targetMethod#" />
			<Table cellPadding="5" cellSpacing="0" border="0" class="ArgumentFormTable">
				<cfset local.counter = 1 />
				<tHead>
					<tr>
						<td colspan="5" class="Title">Invoke Method: #local.metadata.name#</td>
					</tr>
					<tr class="ColumnHeadWrap">
						<td class="Send ColumnHead">Send</td>
						<td class="Name ColumnHead">Argument Name</td>
						<td class="Value ColumnHead">Argument Value</td>
						<td class="Type ColumnHead">Type Name</td>
						<td class="Hint ColumnHead">Hint</td>
					</tr>
				</tHead>
				<cfLoop from="1" to="#arrayLen(local.parameters)#" index="local.paramIndex">
					<cfScript>
						local.array_loop = local.parameters[local.paramIndex];
						if( (local.counter mod 2) )
							local.background = "Odd";
						else
							local.background = "Even";

						if( not structKeyExists( local.array_loop , "default" ) )
							local.array_loop.default = "";
					</cfScript>
					<input type="hidden" name="argumentNames" value="#local.array_loop.name#" />
					<tr class="#local.background#">
						<td class="Send Entry">
							<input
								type		= "checkbox"
								name		= "#local.array_loop.name#_isValue"
								id			= "null_#local.array_loop.name#_1"
								value		= "true"
								title		= "Force argument value to be sent or not sent at all"
								<cfif local.array_loop.required AND not len(local.array_loop.default) >checked </cfif>
							/>
						</td>
						<td class="Name Entry" style="<cfif local.array_loop.required >color:red</cfif>">
							#local.array_loop.name#
						</td>
						<td nowrap class="Value Entry">
							<cfif not structKeyExists( local.array_loop , "type" ) >
								<cfset local.array_loop.type = "any" />
							</cfif>
							<cfSwitch expression="#local.array_loop.type#">
								<cfCase value="boolean">
									<label for="arg_#local.counter#_1" style="cursor:pointer">
										<input
											type		= "radio"
											name		= "#local.array_loop.name#_value"
											id			= "arg_#local.counter#_1"
											value		= "true"
											onchange	= "this.form.#local.array_loop.name#_isValue.checked=1;"
											<cfif isBoolean(local.array_loop.default) AND local.array_loop.default > checked</cfif>
										/>&nbsp;Yes
									</label>&nbsp;
									<label for="arg_#local.counter#_0" style="cursor:pointer">
										<input
											type		= "radio"
											name		= "#local.array_loop.name#_value"
											id			= "arg_#local.counter#_0"
											value		= "false"
											onchange	= "this.form.#local.array_loop.name#_isValue.checked=1;"
											<cfif isBoolean(local.array_loop.default) AND not numberFormat(local.array_loop.default)> checked</cfif>
										/>&nbsp;No
									</label>
								</cfCase>
								<cfDefaultCase>
									<cfset local.default = local.array_loop.default />
									<cfif local.default EQ "[runtime expression]" >
										<cfset local.default = "" />
									</cfif>
									<input
										type	= "<cfif local.array_loop.name contains 'password' >password<cfelse>text</cfif>"
										name	= "#local.array_loop.name#_value"
										value	= "#local.default#"
										class	= "Value"
										onkeyup	= "var tar=this.form.#local.array_loop.name#_isValue;if(this.value.length){tar.checked=1;}else{tar.checked=0};<cfif local.array_loop.type eq 'numeric' >this.value=this.value.replace(/[^0-9-.,]/,'')</cfif>"
									/>
								</cfDefaultCase>
							</cfSwitch>
						</td>
						<td class="Type Entry">#local.array_loop.type#</td>
						<td class="Hint Entry">
							<cfif structKeyExists( local.array_loop , "hint" ) >
								#local.array_loop.hint#
							</cfif>
						</td>
					</tr>
					<cfset local.counter = local.counter + 1 />
				</cfLoop>
				<tFoot>
					<tr>
						<td colspan="5" class="SubmitWrap">
							<input type="submit" value="SEND ARGUMENTS" />
							<cfif structKeyExists( url , "_cf_containerID" ) >
								&nbsp;
								<input type="button" value="REFRESH ARGUMENTS" onclick="javascript:ColdFusion.navigate('http://#cgi.script_name#&functionCode=#htmlEditFormat(arguments.functionCode)#&onSubmit=#htmlEditFormat(arguments.onSubmit)#','#htmlEditFormat(url._cf_containerID)#')" />
							</cfif>
						</td>
					</tr>
				</tFoot>
			</Table>
		</form>
	</cfoutput>
	<h3 class="MetaDataTitle">Method MetaData</h3>
	<cfDump var="#local.obj#" label="Function Dump" expand="yes" />
</div>