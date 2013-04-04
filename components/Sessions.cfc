component displayName = 'Sessions' hint = 'Provides access to Session instances that currently exist within this CFML instance.' output = false {

	public Sessions function init(
	)	description = 'Initialises the Sessions component.'
		hint = 'This is required for creation of several Java objects used
			throughout the component.'
		output = false
	{
		variables.version = server.coldfusion.productVersion;
		variables.mirror = [];
		variables.methods = {};
		variables.fields = {};

		// Used for processing dates
		variables.epoch = DateConvert('utc2Local', 'January 1 1970 00:00');

		// The ACF Application scope tracker.
		variables.jAppTracker = CreateObject('java', 'coldfusion.runtime.ApplicationScopeTracker');
		// Need the Session tracker as well for the count of sessions per app
		variables.jSessTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');

		local.class = variables.mirror.getClass().forName('coldfusion.runtime.SessionScope');
		/*
			mStartTime: Appears to be the time the session was created. Tested
				getElapsedTime but result wasn't static.
			mLastAccess: Time it was last accessed to work around similar issue
				to above with getTimeSinceLastAccess.
			mTable: Allows scope access.  Much faster alternative than using
				getValueWIthoutChange and still provides the benefit of not
				updating the last accessed timestamp.
		 */
		variables.fields.created = local.class.getDeclaredField('mStartTime');
		variables.fields.created.setAccessible(true);
		variables.fields.accessed = local.class.getDeclaredField('mLastAccess');
		variables.fields.accessed.setAccessible(true);
		variables.fields.scope = local.class.getDeclaredField('mTable');
		variables.fields.scope.setAccessible(true);

		variables.methods.timeout = local.class.getMethod('getMaxInactiveInterval', variables.mirror);
		variables.methods.expired = local.class.getMethod('expired', variables.mirror);
		variables.methods.clientIp = local.class.getMethod('getClientIp', variables.mirror);
		variables.methods.idFromUrl = local.class.getMethod('isIdFromURL', variables.mirror);
		variables.methods.new = local.class.getMethod('isNew', variables.mirror);
		variables.methods.j2eeSession = local.class.getMethod('IsJ2eeSession', variables.mirror);
		variables.methods.sessionId = local.class.getMethod('getSessionId', variables.mirror);

		return this;
	}

	public array function getSessions(
		array filters = []
			hint = 'Array of Structures, ',
		string sort = 'name',
		string direction = 'asc',
		numeric from = 1,
		numeric amount = 10
	)	description = 'Retrieves filtered, sorted & paginated array of
			session instance details.'
		output = false
	{
		local.aspects = {
			sessionid = { // .sessionId
				retrieve = true,
				sortType = 'textnocase'
			},
			name = { // identifier in session collection
				retrieve = true,
				sortType = 'textnocase'
			},
			application = { // App instance the session belongs to
				retrieve = true,
				sortType = 'textnocase'
			},
			new = {
				retrieve = false,
				sortType = 'textnocase'
			},
			timeout = {
				retrieve = false,
				sortType = 'numeric'
			},
			expired = { // NOTE: Not entirely sure this is applicable anymore
				retrieve = false,
				sortType = 'textnocase'
			},
			created = {
				retrieve = false,
				sortType = 'numeric'
			},
			accessed = {
				retrieve = false,
				sortType = 'numeric'
			},
			clientIp = {
				retrieve = false,
				sortType = 'textnocase'
			},
			idFromUrl = {
				retrieve = false,
				sortType = 'textnocase'
			},
			j2eeSession = {
				retrieve = true,
				sortType = 'textnocase'
			}
		};

		// Iterate the filters to check which we need to retrieve
		for (local.f = ArrayLen(arguments.filters); local.f; local.f--) {
			local.aspects[arguments.filters[local.f].aspect].retrieve = true;
		}
		// Also retrieve the sort aspect
		local.aspects[arguments.sort].retrieve = true;

		local.preSort = {};

		// Iterator for application names
		local.iAppNames = variables.jAppTracker.getApplicationKeys();
		while (local.iAppNames.hasMoreElements()) {
			local.appName = local.iAppNames.nextElement();
			local.appSessions = variables.jSessTracker.getSessionCollection(local.appName);
			for (local.name in local.appSessions) {
				local.instance = local.appSessions[local.name];
				local.sessionId = variables.methods.sessionId.invoke(local.instance, variables.mirror);
				if (Find(local.appName & '_', local.sessionId) == 1) {
					local.sessionId = Replace(local.sessionId, local.appName & '_', '', 'one');
				}
				local.info = {
					'application' = local.appName,
					'context' = 'Adobe',
					'name' = local.name,
					'sessionId' = local.sessionId
				};
				if (local.aspects.timeout.retrieve)
					local.info['timeout'] = JavaCast('int', variables.methods.timeout.invoke(local.instance, variables.mirror) / 1000);
				if (local.aspects.expired.retrieve)
					local.info['expired'] = variables.methods.expired.invoke(local.instance, variables.mirror);
				if (local.aspects.created.retrieve)
					local.info['created'] = DateAdd('s', variables.fields.created.get(local.instance) / 1000, variables.epoch);
				if (local.aspects.accessed.retrieve)
					local.info['accessed'] = DateAdd('s', variables.fields.accessed.get(local.instance) / 1000, variables.epoch);
				if (local.aspects.clientIp.retrieve)
					local.info['clientIp'] = variables.methods.clientIp.invoke(local.instance, variables.mirror);
				if (local.aspects.idFromUrl.retrieve)
					local.info['idFromUrl'] = variables.methods.idFromUrl.invoke(local.instance, variables.mirror);
				if (local.aspects.new.retrieve)
					local.info['new'] = variables.methods.new.invoke(local.instance, variables.mirror);
				if (local.aspects.j2eeSession.retrieve)
					local.info['j2eeSession'] = variables.methods.j2eeSession.invoke(local.instance, variables.mirror);

				local.failed = false;
				for (local.f = ArrayLen(arguments.filters); local.f; local.f--) {
					local.filter = arguments.filters[local.f];

					if (local.aspects[local.filter.aspect].sortType == 'numeric') {
						// Numeric
						if (local.filter.condition == '>' && !(local.filter.value > local.info[local.filter.aspect])) {
							local.failed = true;
						} else if (local.filter.condition == '<' && !(local.filter.value < local.info[local.filter.aspect])) {
							local.failed = true;
						} else if (local.filter.condition == '>=' && !(local.filter.value >= local.info[local.filter.aspect])) {
							local.failed = true;
						} else if (local.filter.condition == '<=' && !(local.filter.value <= local.info[local.filter.aspect])) {
							local.failed = true;
						} else if (local.filter.condition == '==' && !(local.filter.value == local.info[local.filter.aspect])) {
							local.failed = true;
						} else if (local.filter.condition == '!=' && !(local.filter.value != local.info[local.filter.aspect])) {
							local.failed = true;
						}
					} else {
						// String
						if (local.filter.condition == 'regex' && !ReFindNoCase(local.filter.value, local.info[local.filter.aspect])) {
							local.failed = true;
						} else if (local.filter.condition == 'equal' && local.filter.value != local.info[local.filter.aspect]) {
							local.failed = true;
						} else if (local.filter.condition == 'contains' && !(local.info[local.filter.aspect] CONTAINS local.filter.value)) {
							local.failed = true;
						}
					}

					if (local.failed) {
						StructDelete(local, 'info');
						break;
					}
				}
				if (StructKeyExists(local, 'info')) {
					// The thread wasn't filtered out so store the data.
					local.preSort[local.info.name] = Duplicate(local.info);
				}
			}
		}

		// Perform sorting against the required thread infomation.
		local.keys = StructSort(
			local.preSort,
			local.aspects[arguments.sort].sortType,
			arguments.direction,
			arguments.sort
		);
		// Slice the array of sorted thread ID's for pagination.
		if (arguments.from > ArrayLen(local.keys)) {
			return [];
		}
		local.paged = local.keys.subList(arguments.from, Min(arguments.from + arguments.amount, ArrayLen(local.keys)));
		// Array used to return the data collected.		
		local.data = [];

		/*
			Loop over each thread ID left from being filtered, sorted and 
			paginated.  Grab any remaining data for those threads and copy into
			the return array.
		 */
		for (local.i = ArrayLen(local.paged); local.i; local.i--) {
			local.info = local.preSort[local.paged[local.i]];
			local.instance = variables.jSessTracker.getSession(local.info.application, local.info.sessionId);
			if (Not local.aspects.timeout.retrieve)
				local.info['timeout'] = JavaCast('int', variables.methods.timeout.invoke(local.instance, variables.mirror) / 1000);
			if (Not local.aspects.expired.retrieve)
				local.info['expired'] = variables.methods.expired.invoke(local.instance, variables.mirror);
			if (Not local.aspects.created.retrieve)
				local.info['created'] = DateAdd('s', variables.fields.created.get(local.instance) / 1000, variables.epoch);
			if (Not local.aspects.created.retrieve)
				local.info['accessed'] = DateAdd('s', variables.fields.accessed.get(local.instance) / 1000, variables.epoch);
			if (Not local.aspects.clientIp.retrieve)
				local.info['clientIp'] = variables.methods.clientIp.invoke(local.instance, variables.mirror);
			if (Not local.aspects.idFromUrl.retrieve)
				local.info['idFromUrl'] = variables.methods.idFromUrl.invoke(local.instance, variables.mirror);
			if (Not local.aspects.new.retrieve)
				local.info['new'] = variables.methods.new.invoke(local.instance, variables.mirror);
			if (Not local.aspects.j2eeSession.retrieve)
				local.info['j2eeSession'] = variables.methods.j2eeSession.invoke(local.instance, variables.mirror);
			local.data[local.i] = local.info;
		}
		return local.data;
	}

	private function getSessionInstance(
		required string appName,
		required string sessionId
	) {
		local.instance = variables.jSeeTracker.getSession(arguments.appName, arguments.sessionId);
		if (Not StructKeyExists(local, 'instance')) {
			return false;
		} else {
			return local.instance;
		}
	}

	public struct function getSession(
		required string appName,
		required string sessionId
	)	output = false
	{
		local.instance = variables.getSessionInstance(arguments.appName, arguments.sessionId);
		local.info = {};
		if (Not IsBoolean(local.instance)) {
			local.sessionId = variables.methods.sessionId.invoke(local.instance, variables.mirror);
			if (Find(local.appName & '_', local.sessionId) == 1) {
				local.sessionId = Replace(local.sessionId, local.appName & '_', '', 'one');
			}
			local.info = {
				'application' = arguments.appName,
				'context' = 'Adobe',
				'name' = arguments.appName & '_' & local.sessionId,
				'sessionId' = local.sessionId
			};
			local.info['timeout'] = JavaCast('int', variables.methods.timeout.invoke(local.instance, variables.mirror) / 1000);
			local.info['expired'] = variables.methods.expired.invoke(local.instance, variables.mirror);
			local.info['created'] = DateAdd('s', variables.fields.created.get(local.instance) / 1000, variables.epoch);
			local.info['accessed'] = DateAdd('s', variables.fields.accessed.get(local.instance) / 1000, variables.epoch);
			local.info['clientIp'] = variables.methods.clientIp.invoke(local.instance, variables.mirror);
			local.info['idFromUrl'] = variables.methods.idFromUrl.invoke(local.instance, variables.mirror);
			local.info['new'] = variables.methods.new.invoke(local.instance, variables.mirror);
			local.info['j2eeSession'] = variables.methods.j2eeSession.invoke(local.instance, variables.mirror);
		}
		return local.info;
	}

	public struct function getScope(
		required string appName,
		required string sessionId
	)	output = false
	{
		local.instance = variables.getSessionInstance(arguments.appName, arguments.sessionId);
		local.scope = {};
		if (Not IsBoolean(local.instance)) {
			local.scope = variables.fields.scope.get(local.instance);
		}
		return local.scope;
	}

	private function getAppInstance(
		required string appName
	)	output = false
	{
		local.instance = variables.jAppTracker.getApplicationScope(JavaCast('string', arguments.appName));
		if (Not StructKeyExists(local, 'instance')) {
			return false;
		} else {
			return local.instance;
		}
	}

	public boolean function stop(
		required string appName,
		required string sessionId,
		boolean fireOnSessionEnd = true
	)	output = false
	{
		local.instance = variables.getAppInstance(arguments.appName);
		local.sessionInstance = variables.getSessionInstance(arguments.appName, arguments.sessionId);
		if (Not IsBoolean(local.instance) && Not IsBoolean(local.sessionInstance)) {
			if (arguments.fireOnSessionEnd) {
				local.eventInvoker = local.instance.getEventInvoker();
				local.eventArgs = [local.instance, local.sessionInstance];
				local.eventInvoker.onSessionEnd(local.eventArgs);
			}
			variables.jSessTracker.cleanUp(arguments.appName, arguments.sessionId);
			return true;
		} else {
			return false;
		}
	}

	public boolean function touch(
		required string appName,
		required string sessionId
	)	output = false
	{
		local.instance = variables.getSessionInstance(arguments.appName, arguments.sessionId);
		if (Not IsBoolean(local.instance)) {
			local.instance.setLastAccess();
			return true;
		} else {
			return false;
		}
	}

	/* Statistic Methods */
	public numeric function count(
		string appName
	) {
		local.count = 0;
		if (StructKeyExists(arguments, 'appName')) {
			local.count = StructCount(variables.jSessTracker.getSessionCollection(local.appName));
		} else {
			local.iAppNames = variables.jAppTracker.getApplicationKeys();
			while (local.iAppNames.hasMoreElements()) {
				local.appName = local.iAppNames.nextElement();
				local.count += StructCount(variables.jSessTracker.getSessionCollection(local.appName));
			}
		}
		return local.count;
	}

	public numeric function countCreated(
		required numeric sinceSecondsAgo
	) {
		local.count = 0;
		local.now = Now().getTime();
		if (StructKeyExists(arguments, 'appName')) {
			local.count = StructCount(variables.jSessTracker.getSessionCollection(local.appName));
		} else {
			local.iAppNames = variables.jAppTracker.getApplicationKeys();
			while (local.iAppNames.hasMoreElements()) {
				local.appName = local.iAppNames.nextElement();
				local.appSessions = variables.jSessTracker.getSessionCollection(local.appName);
				for (local.key in local.appSessions) {
					local.seconds = variables.fields.created.get(local.appSessions[local.key]);
					local.seconds = (local.now - local.seconds) / 1000;
					if (arguments.sinceSecondsAgo >= local.seconds) {
						local.count++;
					}
				}
			}
		}
		return local.count;
	}

	public numeric function countAccessed(
		required numeric sinceSecondsAgo
	) {
		local.count = 0;
		local.now = Now().getTime();
		if (StructKeyExists(arguments, 'appName')) {
			local.count = StructCount(variables.jSessTracker.getSessionCollection(local.appName));
		} else {
			local.iAppNames = variables.jAppTracker.getApplicationKeys();
			while (local.iAppNames.hasMoreElements()) {
				local.appName = local.iAppNames.nextElement();
				local.appSessions = variables.jSessTracker.getSessionCollection(local.appName);
				for (local.key in local.appSessions) {
					local.seconds = variables.fields.accessed.get(local.appSessions[local.key]);
					local.seconds = (local.now - local.seconds) / 1000;
					if (arguments.sinceSecondsAgo >= local.seconds) {
						local.count++;
					}
				}
			}
		}
		return local.count;
	}
}