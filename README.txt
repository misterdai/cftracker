                                                                               
                                -=[ README ]=-

================================================================================
Information
--------------------------------------------------------------------------------
Version: 2.0 Beta 2
Website: http://cftracker.riaforge.org

Author:  David "Mister Dai" Boyer
Blog:    http://misterdai.wordpress.com

================================================================================
Introduction
--------------------------------------------------------------------------------
CFTracker consists of three aspects:
	* A CFIDE admin extension.
	* A standalone version of the extension.
	* A set of Coldfusion components.

These give you access to view and take action on any active applications,
sessions or items in the query cache.  You can also see memory information
and other statistics.

For further information, see the "Features" section below.

================================================================================
Features
--------------------------------------------------------------------------------
Dashboard
	Graphs / Tables
		Sessions per application
		Memory usage
		Query / Template Cache hit ratios
		Number of threads per group.
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
Threads
	View all threads for the Coldfusion server.
	Paged table of threads with filtering.
	Currently running template for request threads.
================================================================================