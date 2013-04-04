component displayName = 'QueryCache' hint = 'Provides access to the Query Cache that currently exist within this CFML instance.' output = false {

	public QueryCache function init(
	)	description = 'Initialises the QueryCache component.'
		hint = 'This is required for creation of several Java objects used
			throughout the component.'
		output = false
	{
		variables.jDataSourceService = CreateObject('java', 'coldfusion.server.ServiceFactory').getDataSourceService();
		return this;
	}

	public function get() {
		return variables.jDataSourceService;
	}

	public array function getDatasources() {
		return variables.jDataSourceService.getDatasources();
	}

	public array function getApps(
		array filters = []
			hint = 'Array of Structures, ',
		string sort = 'name',
		string direction = 'asc',
		numeric from = 1,
		numeric amount = 10
	)	description = 'Retrieves filtered, sorted & paginated array of
			application instance details.'
		output = false
	{
		local.aspects = {
			context = {
				retrieve = true,
				sortType = 'textnocase'
			},
			name = {
				retrieve = true,
				sortType = 'textnocase'
			},
			initialised = {
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
			sessions = {
				retrieve = false,
				sortType = 'numeric'
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
			local.instance = variables.getAppInstance(local.appName);
			if (Not IsBoolean(local.instance)) {
				// We have an instance
				local.info = {
					'name' = local.appName,
					'context' = 'Adobe'
				};
				if (local.aspects.initialised.retrieve)
					local.info['initialised'] = variables.methods.initialised.invoke(local.instance, variables.mirror);
				if (local.aspects.timeout.retrieve)
					local.info['timeout'] = JavaCast('int', variables.methods.timeout.invoke(local.instance, variables.mirror) / 1000);
				if (local.aspects.expired.retrieve)
					local.info['expired'] = variables.methods.expired.invoke(local.instance, variables.mirror);
				if (local.aspects.created.retrieve)
					local.info['created'] = DateAdd('s', variables.fields.created.get(local.instance) / 1000, variables.epoch);
				if (local.aspects.accessed.retrieve)
					local.info['accessed'] = DateAdd('s', variables.fields.accessed.get(local.instance) / 1000, variables.epoch);
				if (local.aspects.sessions.retrieve)
					local.info['sessions'] = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', local.appName)));

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
			local.instance = variables.getAppInstance(local.info.name);
			if (Not local.aspects.initialised.retrieve)
				local.info['initialised'] = variables.methods.initialised.invoke(local.instance, variables.mirror);
			if (Not local.aspects.timeout.retrieve)
				local.info['timeout'] = JavaCast('int', variables.methods.timeout.invoke(local.instance, variables.mirror) / 1000);
			if (Not local.aspects.expired.retrieve)
				local.info['expired'] = variables.methods.expired.invoke(local.instance, variables.mirror);
			if (Not local.aspects.created.retrieve)
				local.info['created'] = DateAdd('s', variables.fields.created.get(local.instance) / 1000, variables.epoch);
			if (Not local.aspects.created.retrieve)
				local.info['accessed'] = DateAdd('s', variables.fields.accessed.get(local.instance) / 1000, variables.epoch);
			if (Not local.aspects.sessions.retrieve)
				local.info['sessions'] = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', local.appName)));
			local.data[local.i] = local.info;
		}
		return local.data;
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

	public struct function getApp(
		required string appName
	)	output = false
	{
		local.instance = variables.getAppInstance(arguments.appName);
		local.item = {};
		if (Not IsBoolean(local.instance)) {
			local.item['name'] = arguments.appName;
			local.item['context'] = 'Adobe';
			local.item['initialised'] = variables.methods.initialised.invoke(local.instance, variables.mirror);
			local.item['timeout'] = JavaCast('int', variables.methods.timeout.invoke(local.instance, variables.mirror) / 1000);
			local.item['expired'] = variables.methods.expired.invoke(local.instance, variables.mirror);
			local.item['created'] = DateAdd('s', variables.fields.created.get(local.instance) / 1000, variables.epoch);
			local.item['accessed'] = DateAdd('s', variables.fields.accessed.get(local.instance) / 1000, variables.epoch);
			local.item['sessions'] = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName)));
		}
		return local.item;
	}

	public struct function getSettings(
		required string appName
	)	output = false
	{
		local.instance = variables.getAppInstance(arguments.appName);
		local.settings = {};
		if (Not IsBoolean(local.instance)) {
			local.settings = variables.methods.settings.invoke(local.instance, variables.mirror);
			if (ListFirst(variables.version) < 10) {
				// Very odd issue with existing keys with null values.
				local.keys = StructKeyArray(local.settings);
				for (local.i = ArrayLen(local.keys); local.i; local.i--) {
					if (Not StructKeyExists(local.settings, local.keys[local.i])) {
						StructDelete(local.settings, local.keys[local.i]);
					}
				}
			}
		}
		return local.settings;
	}

	public struct function getScope(
		required string appName
	)	output = false
	{
		local.instance = variables.getAppInstance(arguments.appName);
		local.scope = {};
		if (Not IsBoolean(local.instance)) {
			local.scope = variables.fields.scope.get(local.instance);
		}
		return local.scope;
	}

	public boolean function stop(
		required string appName,
		boolean fireOnApplicationEnd = true
	)	output = false
	{
		local.instance = variables.getAppInstance(arguments.appName);
		if (Not IsBoolean(local.instance)) {
			if (arguments.fireOnApplicationEnd) {
				local.eventInvoker = local.instance.getEventInvoker();
				local.eventArgs = [local.instance];
				local.eventInvoker.onApplicationEnd(local.eventArgs);
			}
			variables.jAppTracker.cleanUp(local.instance);
			return true;
		} else {
			return false;
		}
	}

	public boolean function restart(
		required string appName,
		boolean fireOnApplicationEnd = false
	)	output = false
	{
		local.instance = variables.getAppInstance(arguments.appName);
		if (Not IsBoolean(local.instance)) {
			if (arguments.fireOnApplicationEnd) {
				local.eventInvoker = local.instance.getEventInvoker();
				local.eventArgs = [local.instance];
				local.eventInvoker.onApplicationEnd(local.eventArgs);
			}
			local.instance.setIsInited(false);
			return true;
		} else {
			return false;
		}
	}

	public boolean function touch(
		required string appName
	)	output = false
	{
		local.instance = variables.getAppInstance(arguments.appName);
		if (Not IsBoolean(local.instance)) {
			local.instance.setLastAccess();
			return true;
		} else {
			return false;
		}
	}

	/* Statistic Methods */
	public numeric function count() {
		local.count = 0;
		local.iAppNames = variables.jAppTracker.getApplicationKeys();
		while (local.iAppNames.hasMoreElements()) {
			local.iAppNames.nextElement();
			local.count++;
		}
		return local.count;
	}

	public numeric function countCreated(
		required numeric sinceSecondsAgo
	) {
		local.count = 0;
		local.now = Now().getTime();
		local.iAppNames = variables.jAppTracker.getApplicationKeys();
		while (local.iAppNames.hasMoreElements()) {
			local.instance = variables.getAppInstance(local.iAppNames.nextElement());
			if (Not IsBoolean(local.instance)) {
				local.seconds = variables.fields.created.get(local.instance);
				local.seconds = (local.now - local.seconds) / 1000;
				if (arguments.sinceSecondsAgo >= local.seconds) {
					local.count++;
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
		local.iAppNames = variables.jAppTracker.getApplicationKeys();
		while (local.iAppNames.hasMoreElements()) {
			local.instance = variables.getAppInstance(local.iAppNames.nextElement());
			if (Not IsBoolean(local.instance)) {
				local.seconds = variables.fields.accessed.get(local.instance);
				local.seconds = (local.now - local.seconds) / 1000;
				if (arguments.sinceSecondsAgo >= local.seconds) {
					local.count++;
				}
			}
		}
		return local.count;
	}
}