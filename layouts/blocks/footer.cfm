<hr />
<div class="span-24 last backcolour"><cfoutput>
	<div class="version whiteBk ui-corner-bottom">Version: #application.cftracker.release.version# (#DateFormat(application.cftracker.release.date, application.settings.display.dateformat)#)</div>
	<div class="resources">
		<img src="#this.assetBegin#assets/images/icons/home.png#this.assetEnd#" width="16" height "16" alt="Website" /> <a href="http://www.cftracker.net/">Website</a>
		<img src="#this.assetBegin#assets/images/icons/twitter.png#this.assetEnd#" width="16" height "16" alt="Twitter" /> <a href="http://twitter.com/cftracker">Twitter</a>
		<img src="#this.assetBegin#assets/images/icons/docs.png#this.assetEnd#" width="16" height "16" alt="Documentation" /> <a href="http://www.cftracker.net/page.cfm/docs">Documentation</a>
		<img src="#this.assetBegin#assets/images/icons/donations.png#this.assetEnd#" width="16" height "16" alt="Donations" /> <a href="http://www.cftracker.net/page.cfm/contribute">Donations</a>
		<img src="#this.assetBegin#assets/images/icons/support.png#this.assetEnd#" width="16" height "16" alt="Support" /> <a href="http://www.cftracker.net/support">Support</a>
		<img src="#this.assetBegin#assets/images/icons/discussion.png#this.assetEnd#" width="16" height="16" alt="Discussion" /> <a href="http://groups.google.com/group/cftracker">Discussion Group</a>
	</div>
</cfoutput></div>