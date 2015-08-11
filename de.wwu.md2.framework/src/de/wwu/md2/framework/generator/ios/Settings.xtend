package de.wwu.md2.framework.generator.ios

class Settings {
	public static Boolean PRINT_DEBUG_INFO = true
	
	// Used to identify platform content, e.g. for folder structure src-gen/appname.PREFIX
	public static String PLATTFORM_PREFIX = "ios"
	public static String STATIC_CODE_PATH = "lib/" // relative to ios resource root 
	
	// Paths to platform-specific subfolders
	public static String MODEL_PATH = "model/"
	public static String CONTROLLER_PATH = "controller/"
	public static String VIEW_PATH = "view/"
	
}