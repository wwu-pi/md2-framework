package de.wwu.md2.framework.generator.android.wearable.controller

import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.mD2.App

class ApplicationGen {
	def static generateAppClass(String packageName, App app) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.App.generateAppClass()
		package «packageName»;
		
		import android.app.Application;
		import android.content.Context;
		
		import «packageName»«Settings.MD2_APP_FILES_CONTROLLER_PACKAGE_NAME»;
		import «packageName».md2.model.sqlite.Md2SQLiteHelperImpl;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2SQLiteHelper;
		import «Settings.MD2LIBRARY_CONTENTPROVIDERREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.implementation.VolleyQueue;
		import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.implementation.Polling;
		

		public class «app.name.toFirstUpper» extends Application {
		
			private static Context context;
			private static Md2SQLiteHelper sqLiteHelper;
			
			private static Controller co;
			private static Md2ViewManager vm;
			private static Md2ContentProviderRegistry cpr;
			private static Md2TaskQueue tq;
			private static Md2WidgetRegistry wr;
		
		    @Override
		    public void onCreate() {
		        super.onCreate();
		        co = Controller.getInstance();
				vm = Md2ViewManager.getInstance();
				cpr = Md2ContentProviderRegistry.getInstance();
				tq = Md2TaskQueue.getInstance();
				wr = Md2WidgetRegistry.getInstance();
				context = getApplicationContext();
				VolleyQueue.getInstance(context);
		        Controller.getInstance().run();
		        Thread t = new Thread(new Polling(cpr));
		        t.start();
		        
		    }
		    
			public static Context getAppContext() {
		        return «app.name.toFirstUpper».context;
		    }
		    
			public static Md2SQLiteHelper getMd2SQLiteHelper() {
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