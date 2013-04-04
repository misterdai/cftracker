component {
	variables.timers = [];

	function log(
		required string message
	) {
		local.now = GetTickCount() / 1000;
		local.timerLen = ArrayLen(variables.timers);
		if (local.timerLen > 0) {
			local.duration = NumberFormat(local.now - variables.timers[local.timerLen].now, '_.999') & ' ms';
		} else {
			local.duration = '0.000 ms';
		}
		ArrayAppend(variables.timers, {
			'message' = arguments.message,
			'sinceLast' = local.duration,
			'now' = local.now
		});
	}

	function get() {
		return variables.timers;
	}
}