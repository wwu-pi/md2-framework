package de.wwu.md2.framework.generator.android.lollipop.controller

class Md2Controller {
	def static generateController(String mainPackage)'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Md2Controller.generateController()
		package «mainPackage».md2.controller;
		
		import android.app.Activity;
		import android.util.Log;
		
		import «mainPackage».CitizenApp;
		import «mainPackage».md2.model.Address;
		import «mainPackage».md2.model.contentProvider.AddressLocalContentProvider;
		import de.uni_muenster.wi.fabian.md2library.annotation.Md2Controller;
		import de.uni_muenster.wi.fabian.md2library.controller.implementation.AbstractMd2Controller;
		import de.uni_muenster.wi.fabian.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
		import de.uni_muenster.wi.fabian.md2library.model.contentProvider.interfaces.Md2ContentProvider;
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.implementation.Md2LocalStoreFactory;
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.interfaces.Md2SQLiteHelper;
		import de.uni_muenster.wi.fabian.md2library.view.management.implementation.ViewManager;
		
		@Md2Controller
		public class Controller extends AbstractMd2Controller {
		
		    private static Controller instance;
		
		    private Controller() {
		        Log.d("FabianLog", "Controller: constructor");
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
		        this.setupViews();
		        this.registerContentProviders();
		    }
		
		    protected void setupViews() {
		        Log.d("FabianLog", "Controller: setupViews()");
		
		        ViewManager vm = ViewManager.getInstance();
		
		        if (vm != null) {
		            Log.d("FabianLog", "Controller: setupView() startAct");
		            //ViewManager.getInstance().setupView(new String("de.uni_muenster.wi.fabian.citizenapp.StartActivity"));
		
		
		            //Log.d("FabianLog", str.getPlatformValue());
		            //vm.setupView(new String ("de.uni_muenster.wi.fabian.citizenapp.StartActivity"));
		            vm.setupView("startActivity");
		            vm.setupView("EnterLocationActivity");
		        }
		
		        Log.d("FabianLog", "Controller: setupView() nothing");
		/*
		
		            vm.setupView(new String("de.uni_muenster.wi.fabian.citizenapp.StartActivity"));
		            vm.setupView(new String("de.uni_muenster.wi.fabian.citizenapp.StartActivityEnterLocationActivity"));
		*/
		    }
		
		    public void setActiveView(Activity activeView) {
		        ViewManager.getInstance().setActiveView(activeView);
		    }
		
		    public void registerContentProviders() {
		        Log.d("FabianLog", "Controller: registerContentProviders()");
		        Md2ContentProviderRegistry cpr = Md2ContentProviderRegistry.getInstance();
		        Md2LocalStoreFactory lsf = new Md2LocalStoreFactory();
		        Md2ContentProvider addressLocalProvider = new AddressLocalContentProvider(lsf.getDataStore());
		        cpr.add("addressLocal", addressLocalProvider);
		    }
		
		    @Override
		    public Md2SQLiteHelper getMd2SQLiteHelper() {
		        return CitizenApp.getMd2SQLiteHelper();
		    }
		}
	'''
}