Installation notes
------------------
1. Copy the rrd4j-2.0.5.jar to your CFML engine lib directory.
2. Restart your CFML engine.
3. Set up a scheduled task to run task.cfm every 5 minutes.
4. Execute the scheduled task.
5. View the index.cfm.
-------------------
Information
-------------------
RRD are a special type of database in which you can define datasources
and then different archives for them.  Each arhive is divided over a
period of time (heartbeats).  This means that you can have older data
recorded at lower resolutions, so the databases will never grow any
larger than their initial size.

In this example task, the average, minimum and maximum values are archived.
They are kept at the following resolutions (for our 5 minute monitoring):
	Resolution	Samples		Duration
	5 minutes	576			2 days
	30 minutes	672			2 weeks
	2 hours		732			2 months (61 days)
	12 hours	1460		2 years (730 days)

These resolutions can only be set during creation of the database.  If
finer resolutions were required, a new database would have to be created.
---------------------
Ideas
---------------------
* Configuration
	* Resolutions
		Users should be able to change data resolutions
		If they want more details for longer it should be possible.
	* Heartbeats
		Monitoring might be wanted over longer / shorter periods.
* Different data
	* Other data will be monitored.
	* Currently only memory and garbage collections for benchmarking.	