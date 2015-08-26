package de.wwu.md2.framework.generator.android.lollipop.controller

import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil

class Md2Controller {
	def static generateController(String mainPackage, App app, Iterable<Entity> entities, Iterable<ContentProvider> contentProviders)'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Md2Controller.generateController()
		package «mainPackage».md2.controller;
		
		import android.app.Activity;
		import android.util.Log;
		
		import «mainPackage».«app.name.toFirstUpper»;
		
		«FOR e:entities»
			import «mainPackage».md2.model.«e.name.toFirstUpper»;
		«ENDFOR»
		
		«FOR cp:contentProviders»
			import «mainPackage».md2.model.contentProvider.«cp.name.toFirstUpper»;
		«ENDFOR»
		
		import java.util.ArrayList;
		import java.util.HashSet;
		
		«MD2AndroidLollipopUtil.generateImportAllActions»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllExceptions»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
		«MD2AndroidLollipopUtil.generateImportAllCustomActions»
		
		import de.uni_muenster.wi.fabian.md2library.controller.implementation.AbstractMd2Controller;
		import de.uni_muenster.wi.fabian.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
		import de.uni_muenster.wi.fabian.md2library.model.contentProvider.interfaces.Md2ContentProvider;
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.implementation.Md2LocalStoreFactory;
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.interfaces.Md2SQLiteHelper;
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.implementation.Md2SQLiteDataStore;
		import de.uni_muenster.wi.fabian.md2library.view.management.implementation.Md2ViewManager;
		
		public class Controller extends AbstractMd2Controller {
		
			protected ArrayList<Md2CustomCodeAction> pendingActions;
		
		    private static Controller instance;
		
		    private Controller() {
		        Log.d("FabianLog", "Controller: constructor");
		        pendingActions = new ArrayList<Md2CustomCodeAction>();
		    }
		
		    public static synchronized Controller getInstance() {
		        if (Controller.instance == null) {
		            Controller.instance = new Controller();
		        }
		        Log.d("FabianLog", "Controller: return instance");
		        return Controller.instance;
		    }
		
		    @Override
		    public void run() {
		        Log.d("FabianLog", "Controller run()");
		        this.registerContentProviders();
		    }

		    public void registerContentProviders() {
		        Log.d("FabianLog", "Controller: registerContentProviders()");
		        Md2ContentProviderRegistry cpr = Md2ContentProviderRegistry.getInstance();
		        Md2LocalStoreFactory lsf = new Md2LocalStoreFactory(this.instance);
		        
		        «FOR cp: contentProviders»
		        	«»
		        	Md2ContentProvider «cp.name.toFirstLower» = new «cp.name.toFirstUpper»(new «MD2AndroidLollipopUtil.getTypeNameForContentProvider(cp)»(), (Md2SQLiteDataStore) lsf.getDataStore());
		        	cpr.add("«cp.name»", «cp.name.toFirstLower»);
		        «ENDFOR»
		    }
		
		    @Override
		    public Md2SQLiteHelper getMd2SQLiteHelper() {
		        return «app.name.toFirstUpper».getMd2SQLiteHelper();
		    }
		
		    public void addPendingAction(Md2CustomCodeAction action){
		        this.pendingActions.add(action);
		    }
		
		    public void tryExecutePendingActions(){
		        Log.d("FabianLog", "Controller: tryExecutePendingActions()");
		        HashSet<Md2CustomCodeAction> remove = new HashSet<>();
		        for(Md2CustomCodeAction action : pendingActions){
		            try{
		                action.execute();
		                Log.d("FabianLog", "Controller: tryExecutePendingActions(): executed --> remove");
		                remove.add(action);
		            } catch (WidgetNotCreatedException e) {
		                // remains in list
		                Log.d("FabianLog", "Controller: tryExecutePendingActions(): widgetNotCreatedException --> remains in list");
		            }
		        }
		        pendingActions.removeAll(remove);
		    }
		}
	'''
}