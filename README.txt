===========================================
Information
-------------------------------------------
Version: 2.0 Beta
Website: http://cftracker.riaforge.org

Author:  David "Mister Dai" Boyer
Blog:    http://misterdai.wordpress.com

===========================================
Introduction
-------------------------------------------
CFTracker consists of three aspects:
	* A CFIDE admin extension.
	* A standalone version of the extension.
	* A set of Coldfusion components.

These give you access to view and take action on any active applications,
sessions or items in the query cache.  You can also see memory information
and other statistics.

For further information, see the "Features" section below.

===========================================
Installation
-------------------------------------------
There are two options available for installation:
1. Install into the CFIDE/administrator directory.
	a. Copy the "cftracker" folder into your "cfide/administrator" folder.
	b. Make sure the "extends" attribute of the application.cfc is correct.
	c. Edit the "custommenu.xml" file in your "cfide/administrator" folder.
	d. Add the following:
		<submenu label="CFTracker">
			<menuitem href="cftracker/" target="content">Dashboard</menuitem>
			<menuitem href="cftracker/?action=applications" target="content">Applications</menuitem>
			<menuitem href="cftracker/?action=sessions" target="content">Sessions</menuitem>
			<menuitem href="cftracker/?action=queries" target="content">Query Cache</menuitem>
			<menuitem href="cftracker/?action=stats" target="content">Statistics</menuitem>
		</submenu>
	e. Log into CFIDE/administrator and use the links you've just added.
2. Install standalone:
	a. Make sure you understand that there is no authentication in CFTracker.
	b. Select a suitable location and copy the cftracker folder there.
	c. Make sure the "extends" attribute of the application.cfc is correct.
	d. Open a web browser and surf to the folder.
	
===========================================
Features
-------------------------------------------
Dashboard
	Graphs / Tables
		Sessions per application
		Memory usage
		Query / Template Cache hit ratios
Applications
	Paged list of current Coldfusion applications.
	Actions
		Stop - Cease the application completely (sessions unaffected).
		Restart - Flag application to run onApplicationStart again on next request.
		Refresh - Update the last accessed time.
	Information
		View settings dump.
		View scope variables dump.
		Last accessed date and time.
		Expected expiry date and time if no further activity.
		Application creation date and time.
		Initialised flag.

Sessions
	Filter by application or view all.
	Paged list of sessions.
		Filter sessions by session key value(s).
	Actions
		Stop - Cease the session completely.
		Refresh - Update the last accessed time of the session.
	Information
		View scope variables dump.
		Expiry state.
		Last accessed date and time.
		Expected expiry date and time if no further activity.
		Session creation date and time.
		Type (CF / J2eeSession).
		Client IP at session creation.
		ID from URL flag.
	Action all sessions by
		Information value (Regex).
		Session scope value (Regex).
		Stop / Refresh actions.

Query Cache
	Paged list of cached queries.
		Search by queryName or SQL.
	Actions
		Purge individual item(s).
		Purge all.
	Information
		View Result set.
		Query name.
		Parameters (type and value).
		Creation date.
		SQL.
		View Monitoring stats (if enabled).
	Action all queries by.
		Regular expression against SQL.
===========================================