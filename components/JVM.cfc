component {
	public JVM function init() {
		variables.jManagementFactory = CreateObject('java', 'java.lang.management.ManagementFactory');
		variables.jRuntimeMXBean = variables.jManagementFactory.getRuntimeMXBean();
		variables.jCompilationMXBean = variables.jManagementFactory.getCompilationMXBean();
		variables.jClassLoadingMXBean = variables.jManagementFactory.getClassLoadingMXBean();
		// sun.management.RuntimeImpl?
		return this;
	}

	public struct function getInfo() {
		return {
			'bootClassPath' = ListToArray(variables.jRuntimeMXBean.getBootClassPath(), ';'),
			'classPath' = ListToArray(variables.jRuntimeMXBean.getClassPath(), ';'),
			'inputArguments' = variables.jRuntimeMXBean.getInputArguments(),
			'libraryPath' = ListToArray(variables.jRuntimeMXBean.getLibraryPath(), ';'),
			'managementSpecVersion' = variables.jRuntimeMXBean.getManagementSpecVersion(),
			'name' = variables.jRuntimeMXBean.getName(),
			'specName' = variables.jRuntimeMXBean.getSpecName(),
			'specVendor' = variables.jRuntimeMXBean.getSpecVendor(),
			'specVersion' = variables.jRuntimeMXBean.getSpecVersion(),
			'startTime' = variables.jRuntimeMXBean.getStartTime(),
			'systemProperties' = variables.jRuntimeMXBean.getSystemProperties(),
			'uptime' = variables.jRuntimeMXBean.getUptime(),
			'vmName' = variables.jRuntimeMXBean.getVmName(),
			'vmVendor' = variables.jRuntimeMXBean.getVmVendor(),
			'vmVersion' = variables.jRuntimeMXBean.getVmVersion(),
			'bootClassPathSupported' = variables.jRuntimeMXBean.isBootClassPathSupported()
		};
	}

	public struct function getCompilationInfo() {
		return {
			'name' = variables.jCompilationMXBean.getName(),
			'totalCompilationTime' = variables.jCompilationMXBean.getTotalCompilationTime(),
			'compilationTimeMonitoringSupported' = variables.jCompilationMXBean.isCompilationTimeMonitoringSupported()
		};
	}

	public struct function getClassLoadingInfo() {
		return {
			'loadedClassCount' = variables.jClassLoadingMXBean.getLoadedClassCount(),
			'totalLoadedClassCount' = variables.jClassLoadingMXBean.getTotalLoadedClassCount(),
			'unloadedClassCount' = variables.jClassLoadingMXBean.getUnloadedClassCount()
		};
	}
}