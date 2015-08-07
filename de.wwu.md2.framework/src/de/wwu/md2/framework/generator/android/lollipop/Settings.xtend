package de.wwu.md2.framework.generator.android.lollipop

public class Settings {
	public static String PLATTFORM_PREFIX = "androidLollipop"
	
	public static String MD2_RESOURCE_PATH = "/android/lollipop/"
	
	public static String MD2LIBRARY_DEBUG_NAME = "md2Library-debug.aar"
	public static String MD2LIBRARY_DEBUG_PATH = "/md2Library-debug/"
	public static String MD2LIBRARY_DEBUG_PROJECT = ":md2Library-debug"
	
	public static String MD2_RESOURCE_MIPMAP_PATH = MD2_RESOURCE_PATH + "mipmap/"
	
	public static String APP_PATH = "/app/"
	public static String MAIN_PATH = APP_PATH + "src/main/"
	public static String JAVA_PATH = APP_PATH + "src/main/java/"
	public static String RES_PATH = APP_PATH + "src/main/res/"
	public static String LAYOUT_PATH = RES_PATH + "layout/"
	public static String MENU_PATH = RES_PATH + "menu/"
	public static String VALUES_PATH = RES_PATH + "values/"
	public static String MIPMAP_PATH = RES_PATH + "mipmap/"
		
	public static String ANDROID_MANIFEST_NAME = "AndroidManifest.xml"
	
	public static String GRADLE_BUILD = "build.gradle"
	public static String GRADLE_SETTINGS = "settings.gradle"
	
	public static String PROGUARD_RULES_NAME = "proguard-rules.pro"
	
	public static String IDS_XML_NAME = "ids.xml"
	public static String VIEWS_XML_NAME = "views.xml"
	public static String STRINGS_XML_NAME = "strings.xml"
	public static String STYLES_XML_NAME = "styles.xml"
	public static String DIMENS_XML_NAME = "dimens.xml"
	
	// packages for app generation
	public static String MD2_APP_FILES_PACKAGE = ".md2."
	public static String MD2_APP_FILES_CONTROLLER_PACKAGE_NAME = MD2_APP_FILES_PACKAGE + "controller.Controller"
	public static String MD2_APP_FILES_VIEWMANAGER_PACKAGE_NAME = MD2_APP_FILES_PACKAGE + "view.ViewManager"
}