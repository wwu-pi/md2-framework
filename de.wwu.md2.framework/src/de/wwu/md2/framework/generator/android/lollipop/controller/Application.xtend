package de.wwu.md2.framework.generator.android.lollipop.controller

import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.App

class Application {
	def static generateAppClass(String packageName, App app) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.App.generateAppClass()
		package «packageName»;
		
		import android.app.Application;
		import android.content.Context;
		import android.util.Log;
		
		import «packageName»«Settings.MD2_APP_FILES_CONTROLLER_PACKAGE_NAME»;
		import androidgeneratortestproject.md2.model.sqlite.Md2SQLiteHelperImpl;
		import de.uni_muenster.wi.fabian.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.interfaces.Md2SQLiteHelper;
		import de.uni_muenster.wi.fabian.md2library.view.management.implementation.Md2ViewManager;

		public class «app.name.toFirstUpper» extends Application {
		
			private static Context context;
			private static Md2SQLiteHelper sqLiteHelper;
			
			private static Controller co;
			private static Md2ViewManager vm;
			private static Md2ContentProviderRegistry cpr;
		
		    @Override
		    public void onCreate() {
		        super.onCreate();
		        co = Controller.getInstance();
				vm = Md2ViewManager.getInstance();
				cpr = Md2ContentProviderRegistry.getInstance();
				context = getApplicationContext();
		        Controller.getInstance().run();
		    }
		    
			public static Context getAppContext() {
		        return «app.name.toFirstUpper».context;
		    }
		    
			public static Md2SQLiteHelper getMd2SQLiteHelper() {
		        Log.d("FabianLog", "Citizenapp: getMd2SQLiteHelper");
		        if (sqLiteHelper == null)
		            synchronized («app.name.toFirstUpper».class) {
		                if (sqLiteHelper == null)
		                    sqLiteHelper = new Md2SQLiteHelperImpl(«app.name.toFirstUpper».getAppContext());
		            }
		        return sqLiteHelper;
		    }
		}
	'''
}