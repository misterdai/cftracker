<cfsilent>
	<cfset request.layout = false />
	<cfsetting showdebugoutput="false" />
</cfsilent><cfinclude template="../../../blocks/header.cfm" />
	<style type="text/css">
		html, body {
			margin:0; padding:0; height:100%;
			background-color:#2E2E2E;
		}
		#floater {
			position:relative; float:left;
			height:50%;	margin-bottom:-150px;
			width:1px;
		}
 
		#centered {
			position:relative; clear:left;
			height:300px; width:400px;
			margin:0 auto;
		}
		#logo {
			 color:white; font-weight:bold;
			 font-size:16px;
		}
		#content {padding:10px;
			background:#fff;
			-moz-border-radius: 10px;
			-webkit-border-radius: 10px;
			border-radius: 10px; 
}
	</style>
</head>
<body>
	<div id="floater"></div>
	<div id="centered">
		<div id="logo">
			<img src="assets/images/loginlogo.png" width="400" height="98" />
		</div>
		<div id="content">
			<cfoutput>#body#</cfoutput>
		</div>
	</div>
</body>
</html>