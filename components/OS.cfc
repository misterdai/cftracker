component {
	public OS function init() {
		variables.jManagementFactory = CreateObject('java', 'java.lang.management.ManagementFactory');
		variables.jOperatingSystemMXBean = variables.jManagementFactory.getOperatingSystemMXBean();
		return this;
	}

	public string function getArch() {
		return variables.jOperatingSystemMXBean.getArch();
	}

	public numeric function getAvailableProcessors() {
		return variables.jOperatingSystemMXBean.getAvailableProcessors();
	}

	public string function getName() {
		return variables.jOperatingSystemMXBean.getName();
	}

	public string function getVersion() {
		return variables.jOperatingSystemMXBean.getVersion();
	}
}