Introduction
------------
The custom extension to the ColdFusion admin gives you access to some of CFTrackers useful features.
* List of currently active applications.
	* View application sessions.
	* View application scope contents (can be slow for large scopes!).
	* Attempt expiration of application.
	* Reinitialise (Runs onApplicationStart on next new request).
	* Refresh application last access time.
	* Information
		* Number of sessions.
		* Expiry state.
		* Last accessed.
		* Expected timeout date if there is no further activity.
		* Date the application started.
		* Initialised? (Has run onApplicationStart)
* List of sessions for a selected application.
	* Filter list of sessions using a very basic key / value pairs.
	* Can attempt a force expiration of selected sessions.
	* View session contents (without changing the sessions last accessed time).
	* Information:
		* Expiry state.
		* Last accessed.
		* Expected timeout date if there is no further activity.
		* Date the session started.
		* ID from URL (If cfid and cftoken originally taken from the URL).
		* Client IP (Client IP address).

Installation
------------
 1. Locate the file custommenu.xml (usually in [CF Installation Path]/cfide/administrator/.
 2. Add the following:
	<submenu label="CFTracker">
		<menuitem href="cftracker/index.cfm" target="content">Applications &amp; Sessions</menuitem>
		<menuitem href="cftracker/status.cfm" target="content">Server Status</menuitem>
	</submenu>

