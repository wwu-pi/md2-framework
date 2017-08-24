package de.wwu.md2.framework.generator.android.wearable

public class Settings {
	/***
	 * Generator
	 */
	public static String PLATTFORM_PREFIX = "androidWearable"
	public static String MD2_RESOURCE_PATH = "android/wear/"
	public static String MD2_RESOURCE_PATH_LOLLIPOP = "android/lollipop/"
	public static String MD2_RESOURCE_MIPMAP_PATH = MD2_RESOURCE_PATH_LOLLIPOP + "mipmap/"
	public static String MD2_RESOURCE_DRAWABLE_PATH = MD2_RESOURCE_PATH_LOLLIPOP + "drawable/"

	/***
	 * MD2Library for android
	 */
	// library
	public static String MD2LIBRARY_DEBUG_NAME = "md2Library-debug.aar"
	public static String MD2LIBRARY_DEBUG_PATH = "md2Library-debug/"
	public static String MD2LIBRARY_DEBUG_PROJECT = ":md2Library-debug"
	public static String MD2LIBRARY_PACKAGE = "de.uni_muenster.wi.md2library."

	// packages (for imports etc.)
	public static String MD2LIBRARY_DATAMAPPER_PACKAGE_NAME = MD2LIBRARY_PACKAGE + "controller.datamapper.Md2DataMapper"
	public static String MD2LIBRARY_ABSTRACTMD2ACTION_PACKAGE_NAME = MD2LIBRARY_PACKAGE +
		"controller.action.implementation.AbstractMd2Action"
	public static String MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME = MD2LIBRARY_PACKAGE +
		"view.management.implementation.Md2ViewManager"
	public static String MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME = MD2LIBRARY_PACKAGE +
		"view.management.implementation.Md2WidgetRegistry"
	public static String MD2LIBRARY_CONTENTPROVIDERREGISTRY_PACKAGE_NAME = MD2LIBRARY_PACKAGE +
		"model.contentProvider.implementation.Md2ContentProviderRegistry"
	public static String MD2LIBRARY_TASKQUEUE_PACKAGE_NAME = MD2LIBRARY_PACKAGE +
		"controller.action.implementation.customCode.Md2TaskQueue"

	// view content elements
	public static String MD2LIBRARY_VIEW_PACKAGE = MD2LIBRARY_PACKAGE + "view.widgets.implementation."
	public static String MD2LIBRARY_VIEW_FLOWLAYOUTPANE = MD2LIBRARY_VIEW_PACKAGE + "Md2FlowLayoutPane"
	public static String MD2LIBRARY_VIEW_GRIDLAYOUTPANE = MD2LIBRARY_VIEW_PACKAGE + "Md2GridLayoutPane"
	public static String MD2LIBRARY_VIEW_BUTTON = MD2LIBRARY_VIEW_PACKAGE + "Md2Button"
	public static String MD2LIBRARY_VIEW_TEXTINPUT = MD2LIBRARY_VIEW_PACKAGE + "Md2TextInput"
	public static String MD2LIBRARY_VIEW_LABEL = MD2LIBRARY_VIEW_PACKAGE + "Md2Label"

	/***
	 * Android app
	 */
	// paths
	public static String APP_PATH = "wear/"
	public static String MAIN_PATH = APP_PATH + "src/main/"
	public static String JAVA_PATH = APP_PATH + "src/main/java/"
	public static String RES_PATH = APP_PATH + "src/main/res/"
	public static String LAYOUT_PATH = RES_PATH + "layout/"
	public static String MENU_PATH = RES_PATH + "menu/"
	public static String VALUES_PATH = RES_PATH + "values/"
	public static String DRAWABLE_PATH = RES_PATH + "drawable/"
	public static String MIPMAP_PATH = RES_PATH

	// files
	public static String ANDROID_MANIFEST_NAME = "AndroidManifest.xml"

	public static String GRADLE_BUILD_NAME = "build.gradle"
	public static String GRADLE_SETTINGS_NAME = "settings.gradle"

	public static String PROGUARD_RULES_NAME = "proguard-rules.pro"

	public static String IDS_XML_NAME = "ids.xml"
	public static String VIEWS_XML_NAME = "views.xml"
	public static String STRINGS_XML_NAME = "strings.xml"
	public static String STYLES_XML_NAME = "styles.xml"
	public static String DIMENS_XML_NAME = "dimens.xml"
	public static String COLORS_XML_NAME = "colors.xml"

	// packages for app generation
	public static String MD2_APP_FILES_PACKAGE = ".md2."
	public static String MD2_APP_FILES_CONTROLLER_PACKAGE_NAME = MD2_APP_FILES_PACKAGE + "controller.Controller"
}	
