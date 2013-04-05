<div class="ReturnSettingsWrap">
	<div>
		<label for="expand">&nbsp;Expand Dumps</label>
		<select name="expand" class="IsDumpExpanded">
			<option value="1">Yes</option>
			<option value="0">No</option>
		</select>
	</div>
	<div>
		<label for="showUDFs">&nbsp;showUDFs</label>
		<select name="showUDFs" class="showUDFs">
			<option value="0">No</option>
			<option value="1">Yes</option>
		</select>
	</div>
	<div>
		<label for="asMetaData">&nbsp;MetaData Dumps</label>
		<select name="asMetaData" class="IsDumpMetaData">
			<option value="0">No</option>
			<option value="1">Yes</option>
		</select>
	</div>
	<div>
		<label for="isReturnUnformattedQuerySql">&nbsp;Return Raw Query String</label>
		<select name="isReturnUnformattedQuerySql" class="isReturnUnformattedQuerySql">
			<option value="1">Yes</option>
			<option value="0">No</option>
		</select>
	</div>
	<div>
		<label for="requestTimeOut">&nbsp;Request Time Out</label>
		<input class="RequestTimeOut" name="requestTimeOut" value="0" />
	</div>
	<div>
		<label for="IsAutoInvoke">&nbsp;Invoke Methods</label>
		<select class="IsAutoInvoke" name="IsAutoInvoke" title="Controls how the variable selection panel reacts to user selections that are of type 'function'">
			<option value="1" title="Methods will be invoke if no arguments are required">Yes</option>
			<option value="0">No</option>
			<option value="2" title="Methods will only be invoked if their are no arguments">Auto</option>
		</select>
	</div>
	<div>
		<label for="dumpformat">&nbsp;Dump Format</label>
		<select name="dumpformat" class="IsDumpFormat">
			<option value="html">html</option>
			<option value="text">text</option>
		</select>
	</div>
	<div>
		<label for="dumptop">&nbsp;Dump Top</label>
		<select name="dumptop">
			<option value="300">300</option>
			<cfOutput>
				<cfLoop from="1" to="5" index="local.top">
					<option value="#local.top#">#local.top#</option>
				</cfLoop>
				<cfLoop from="10" to="100" index="local.top" step="20">
					<option value="#local.top#">#local.top#</option>
				</cfLoop>
				<cfLoop from="300" to="1000" index="local.top" step="100">
					<option value="#local.top#">#local.top#</option>
				</cfLoop>
				<cfLoop from="2000" to="10000" index="local.top" step="1000">
					<option value="#local.top#">#local.top#</option>
				</cfLoop>
				<option value="">no limit</option>
			</cfOutput>
		</select>
	</div>
	<br style="clear:both" />
	<br style="clear:both" />
</div>