package de.wwu.md2.framework.generator.android.lollipop.controller

import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.App

class Application {
	def static generateAppClass(String packageName, App app) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.App.generateAppClass()
		package «packageName»;
		
		import android.app.Application;
		
		import «packageName»«Settings.MD2_APP_FILES_CONTROLLER_PACKAGE_NAME»;

		public class «app.name.toFirstUpper» extends Application {
		
		    @Override
		    public void onCreate() {
		        super.onCreate();
		        Controller.getInstance().run();
		    }
		}
	'''
}