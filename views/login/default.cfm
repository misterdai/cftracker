<cfoutput>
<div>
	<div>
		<cfif rc.ValidationResult.hasErrors()>
			<div class="alert alert-error">
			<cfloop array="#rc.ValidationResult.getErrors()#" index="local.alert">
				#local.alert#<br>
			</cfloop>
			</div>
		</cfif>
		
		<form class="well" action="#buildUrl( "login.dologin" )#" method="post">
			<label>Password</label>
			<input type="text" name="password" class="span3" placeholder="cfTracker password">
			<input type="submit" class="btn" vaue="Submit">
		</form>
		
	</div>
</div>

</cfoutput>