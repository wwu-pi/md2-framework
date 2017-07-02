package de.wwu.md2.framework.generator.android.wearable.controller

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WorkflowElementReference
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.SensorType
import de.wwu.md2.framework.mD2.ListView

class ActivityGen {
	
	static boolean FirstCall = true; 
	
	def static generateActivities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,	
		Iterable<ContainerElement> rootViews, Iterable<WorkflowElementReference> startableWorkflowElements, Iterable<Entity> entities) {
		
		fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "NavigationAdapter.java",
			generateNavigationAdapter(mainPackage, startableWorkflowElements))
		
		//fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "StartActivity.java",
			//	generateStartActivity(mainPackage, startableWorkflowElements,  entities))	
		
		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "Activity.java",
				generateActivity(mainPackage, rv, entities, FirstCall))
				
				if (rv instanceof ListView){
				fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "ListAdapter.java",
				generateListAdapter(mainPackage, rv))
				} 
		]
	}
		
		//generiert ListAdapter für Inhalt einer Listenansicht
		def static generateListAdapter(String mainPackage, ListView rv)'''
		//generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateListAdapter()
		package «mainPackage»;
		
		import android.support.v7.widget.RecyclerView;
		import android.view.View;
		import android.view.ViewGroup;
		import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2ButtonOnSwipeHandler;
		import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnClickHandler;
		import de.uni_muenster.wi.md2library.view.widgets.implementation.Md2Button;
		import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
		import de.uni_muenster.wi.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
		import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;
		import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2MultiContentProvider;
		import de.uni_muenster.wi.md2library.controller.action.implementation.Md2UpdateListIndexAction;
		«IF(!(rv.onClickAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.onClickAction, "_").toFirstUpper»_Action;
		«ENDIF»
		«IF(!(rv.leftSwipeAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.leftSwipeAction, "_").toFirstUpper»_Action;
		«ENDIF»
		«IF(!(rv.rightSwipeAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.rightSwipeAction, "_").toFirstUpper»_Action;
		«ENDIF»
		
		public class «rv.name»ListAdapter extends RecyclerView.Adapter{
			
			private Md2MultiContentProvider content;
			private Md2ButtonOnSwipeHandler swipeHandler;
			private Md2OnClickHandler clickHandler;
			
			public Md2ButtonOnSwipeHandler getOnSwipeHandler(){
				return swipeHandler;
			}
			
			public Md2OnClickHandler getOnClickHandler(){
				return clickHandler;
			}
			
			public «rv.name»ListAdapter(){
				content = Md2ContentProviderRegistry.getInstance().getContentMultiProvider("«rv.connectedProvider.contentProviderRef.name»");
				swipeHandler = new Md2ButtonOnSwipeHandler();
				clickHandler = new Md2OnClickHandler();
				«IF(!(rv.onClickAction === null))»
					Md2Action ca = new «MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.onClickAction, "_").toFirstUpper»_Action();
					clickHandler.registerAction(ca);
				«ENDIF»
				«IF(!(rv.leftSwipeAction === null))»
					Md2Action lsa = new «MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.leftSwipeAction, "_").toFirstUpper»_Action();
					swipeHandler.getLeftSwipeHandler().registerAction(lsa);
				«ENDIF»
				«IF(!(rv.rightSwipeAction === null))»
					Md2Action rsa = new «MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.rightSwipeAction, "_").toFirstUpper»_Action();
					swipeHandler.getRightSwipeHandler().registerAction(rsa);
				«ENDIF»
			}
			
			@Override
			public void onBindViewHolder(RecyclerView.ViewHolder vh, int i){
				ListItem li = (ListItem) vh;
				if(content.getContentsList().get(i).get("«rv.connectedProvider.tail.attributeRef.name»") != null){
					li.getButton().setText(content.getContentsList().get(i).get("«rv.connectedProvider.tail.attributeRef.name»").getString().toString());
				} else {
					li.getButton().setText("Fehler");
				}
				//Listener hinzufügen
				Md2UpdateListIndexAction indexAction = new Md2UpdateListIndexAction("«rv.name»", i, content);
				Md2OnClickHandler ch = new Md2OnClickHandler();
				Md2ButtonOnSwipeHandler sw = new Md2ButtonOnSwipeHandler();
				ch.registerAction(indexAction);
				ch.addActions(clickHandler.getActions());
				sw.registerAction(indexAction, true);
				sw.registerAction(indexAction, false);
				sw.getLeftSwipeHandler().addActions(swipeHandler.getLeftSwipeHandler().getActions());
				sw.getRightSwipeHandler().addActions(swipeHandler.getRightSwipeHandler().getActions());
				li.getButton().setOnClickHandler(ch);
				li.getButton().setOnSwipeHandler(sw);
			}
			
			@Override
			public int getItemCount() {
				return content.getContents().size();
			}
			
			@Override
			public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup vg, int i){
				Md2Button b = new Md2Button (vg.getContext());
				ListItem li = new ListItem(b);
				return li;
			}
			
			public class ListItem extends RecyclerView.ViewHolder{
				
				private Md2Button button;
				
				public ListItem(View itemView){
					super(itemView);
					button = (Md2Button) itemView;
				}
				
				public Md2Button getButton(){
					return button;
				}
				
				
			}
			
		}
		
'''
		
		
		//generiert NavigationAdapter als Singleton, ersetzt die urspr«ngliche StartActivity
		//startActions werden in Konstruktor »bergeben
	def static generateNavigationAdapter(String mainPackage, Iterable<WorkflowElementReference> startableWorkflowElements)'''
		// generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateStartActivity()
				package «mainPackage»;
				
				import android.graphics.drawable.Drawable;
				import android.support.wearable.view.drawer.WearableNavigationDrawer;
				import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
				import java.util.ArrayList;
				«FOR wer : startableWorkflowElements»		        	
					import «mainPackage».md2.controller.action.«wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action;
				«ENDFOR»
				
				public class NavigationAdapter extends WearableNavigationDrawer.WearableNavigationDrawerAdapter{
					
					private static NavigationAdapter instance;
					private int active;
					private int selected;
					private ArrayList<String> names;
					private ArrayList<Md2Action> actions;
					private boolean isFirstStart;
					
					
					public static synchronized NavigationAdapter getInstance(){
					        if (NavigationAdapter.instance == null) {
					            NavigationAdapter.instance = new NavigationAdapter();
					        }
					        return instance;
					}
					
					private NavigationAdapter(){
						active = 0;
						selected = 0;
						isFirstStart = true;
						names = new ArrayList<String>();
						actions = new ArrayList<Md2Action>();
						«FOR wer : startableWorkflowElements»
							names.add("«wer.workflowElementReference.name.toFirstUpper»");
							actions.add(new «wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action());
						«ENDFOR»
					}
					
					@Override
					public int getCount() {
						return actions.size();
					}
					
					@Override
					public void onItemSelected(int position) {
						selected = position;
					}
					
					@Override
					public String getItemText(int pos) {
						return names.get(pos);
					}
					
					@Override
					public Drawable getItemDrawable(int position) {
					    return null;
					}
					
					public int getActive(){
						return active;
					}
					
					public int getSelected(){
						return selected;
					}
					
					public void maybeFirstStart(){
						if(isFirstStart){
							actions.get(0).execute();
							isFirstStart = false;
						}
					}
					
					public boolean close(){
						if (active != selected){
							active = selected;
							actions.get(active).execute();
							return true;
						} else {
							return false;
						}
					}
					
				}
				
			'''
	
	def static generateStartActivity(String mainPackage, Iterable<WorkflowElementReference> startableWorkflowElements, Iterable<Entity> entities)'''
		// generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateStartActivity()
		package «mainPackage»;
		
		import android.os.Bundle;
		import android.app.Activity;
		import android.content.Intent;
		
		import android.view.View;
		
		//Sensoren
		import android.hardware.Sensor;
		import android.hardware.SensorEvent;
		import android.hardware.SensorEventListener;
		import android.hardware.SensorManager;
		
		import «mainPackage».md2.controller.Controller;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		«MD2AndroidLollipopUtil.generateImportAllWidgets»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
		
		«FOR wer : startableWorkflowElements»		        	
			import «mainPackage».md2.controller.action.«wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action;
		«ENDFOR»
		
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2GoToViewAction;
		import «Settings.MD2LIBRARY_PACKAGE»model.SensorHelper;
		
		public class StartActivity extends Activity {
		
			
		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_start);
		        «FOR wer : startableWorkflowElements»
		        	Md2Button «wer.workflowElementReference.name»Button = (Md2Button) findViewById(R.id.startActivity_«wer.workflowElementReference.name»Button);
		        	«wer.workflowElementReference.name»Button.setWidgetId(R.id.startActivity_«wer.workflowElementReference.name»Button);
		        	Md2WidgetRegistry.getInstance().addWidget(«wer.workflowElementReference.name»Button);
		        «ENDFOR»
		       
		       
           «FOR e: entities»
				«FOR attribute : e.attributes»
        			«IF attribute.type instanceof SensorType»
    		«IF attribute.type.eContents.toString().contains("accelerometer: true")»
    			SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "accelerometer");
    		«ENDIF»
    		«IF attribute.type.eContents.toString().contains("gyroskop: true")»
    			SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "gyroskop");
    		«ENDIF»
			«IF attribute.type.eContents.toString().contains("compass: true")»
    			SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "compass");
    		«ENDIF»
    		«IF attribute.type.eContents.toString().contains("pulsmesser: true")»
    			SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "pulsmesser");
    		«ENDIF»
    		«IF attribute.type.eContents.toString().contains("schrittzaehler: true")»
    			SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "schrittzaehler");
    		«ENDIF»
    		«IF attribute.type.eContents.toString().contains("luxmeter: true")»
    			SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "luxmeter");
    					«ENDIF»
        			«ENDIF»
				«ENDFOR»
           	«ENDFOR»
		    }
		
		    @Override
		    protected void onStart(){
				super.onStart();
				Md2ViewManager.getInstance().setActiveView(this);
		        
		        // TODO move startableWorkflowElements to Md2WorkflowManager
				«FOR wer : startableWorkflowElements»
					Md2Button «wer.workflowElementReference.name»Button = (Md2Button) findViewById(R.id.startActivity_«wer.workflowElementReference.name»Button);
					«wer.workflowElementReference.name»Button.getOnClickHandler().registerAction(new «wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action());
		        «ENDFOR»
		        
		        }   
				Md2TaskQueue.getInstance().tryExecutePendingTasks();
		    }
		    
			@Override
		    protected void onPause(){
		        super.onPause();
			«FOR wer : startableWorkflowElements»
				Md2Button «wer.workflowElementReference.name»Button = (Md2Button) findViewById(R.id.startActivity_«wer.workflowElementReference.name»Button);
				Md2WidgetRegistry.getInstance().saveWidget(«wer.workflowElementReference.name»Button);
			«ENDFOR»
		    }
		    
		    @Override
			public void onBackPressed() {
				// remain on start screen
			}
		}
	'''
	
	private def static generateActivity(String mainPackage, ContainerElement rv, Iterable<Entity> entities, boolean FirstCall) '''
		// generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateActivity()
		package «mainPackage»;
		
		import android.app.Activity;
		import android.content.Intent;
		import android.os.Bundle;
		import android.view.View;
		import android.view.Gravity;
		import android.support.wearable.view.drawer.WearableDrawerLayout;
		import android.support.wearable.view.drawer.WearableDrawerView;
		import android.support.wearable.view.drawer.WearableNavigationDrawer;
		import android.support.wearable.view.CurvedChildLayoutManager;
		import android.support.wearable.view.WearableRecyclerView;
		
		import «mainPackage».md2.controller.Controller;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		«MD2AndroidLollipopUtil.generateImportAllWidgets»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
		
		import «Settings.MD2LIBRARY_PACKAGE»model.SensorHelper;
				
		public class «rv.name»Activity extends Activity {
			
			private WearableDrawerLayout drawerLayout;	
			private WearableNavigationDrawer navigationDrawer;
			private NavigationAdapter adapter;
			
		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_«rv.name.toLowerCase»);
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«generateAddViewElement(viewElement)»
		        «ENDFOR»
		        
	     		drawerLayout = (WearableDrawerLayout) findViewById(R.id.drawer_layout_«rv.name»);
	        	drawerLayout.setDrawerStateCallback(new WearableDrawerLayout.DrawerStateCallback() {
	           		@Override
	            	public void onDrawerOpened(View view) {
	            		navigationDrawer.setCurrentItem(adapter.getActive(), true);
	            	}
	            	@Override
	            	public void onDrawerClosed(View view) {
	                	if(adapter.close()){
	                		«rv.name»Activity.this.finish();
	                	}
	            	}
	            	@Override
	            	public void onDrawerStateChanged(@WearableDrawerView.DrawerState int i) {
	            		if(i == 0){
	            		   if(!navigationDrawer.isOpened()) {
                          	 navigationDrawer.closeDrawer();
                          }
                       }
	            	}
	        	});		        
		        
		        navigationDrawer = (WearableNavigationDrawer) findViewById(R.id.navigation_drawer_«rv.name»);
		        adapter = NavigationAdapter.getInstance();
		        navigationDrawer.setAdapter(adapter);
		        navigationDrawer.setCurrentItem(adapter.getActive(), true);

			«FOR e: entities»
			«FOR attribute : e.attributes»
				«IF attribute.type instanceof SensorType»
					«IF attribute.type.eContents.toString().contains("accelerometer: true")»
					SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "accelerometer");
					«ENDIF»
					«IF attribute.type.eContents.toString().contains("gyroskop: true")»
					SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "gyroskop");
					«ENDIF»
					«IF attribute.type.eContents.toString().contains("heartrate: true")»
					SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "heartrate");
					«ENDIF»
					«IF attribute.type.eContents.toString().contains("proximity: true")»
					SensorHelper meinSensorHelper_«attribute.name» = new SensorHelper(this, "«attribute.name»", "proximity");
					«ENDIF»
				«ENDIF»
			«ENDFOR»
			«ENDFOR»
			
			«IF (rv instanceof ListView)»
					    	WearableRecyclerView wrv = (WearableRecyclerView) findViewById(R.id.wearable_recycler_view_«rv.name»);
					    	«rv.name»ListAdapter listAdapter = new «rv.name»ListAdapter();
						   	wrv.setAdapter(listAdapter);
					    	wrv.setCenterEdgeItems(true);
					    	CurvedChildLayoutManager clm = new CurvedChildLayoutManager(this);
					    	wrv.setLayoutManager(clm);
			«ENDIF»
			
		    }
		
		    @Override
		    protected void onStart(){
				super.onStart();
		        Md2ViewManager.getInstance().setActiveView(this);
		        
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«generateLoadViewElement(viewElement)»
		        «ENDFOR»
		        
		        adapter.maybeFirstStart();
		        
		        Md2TaskQueue.getInstance().tryExecutePendingTasks();
		        
		      
		    }
		    
			@Override
		    protected void onPause(){
		        super.onPause();
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«generateSaveViewElement(viewElement)»
		        «ENDFOR»
		    }
		    
		    @Override
			public void onBackPressed() {
				// go back to start screen
				Md2ViewManager.getInstance().goTo(getString(R.string.StartActivity));
			}
		}
	'''
	
	private static def String generateAddViewElement(ViewElementType vet){
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] != null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}
		
		var String result = ""
		var String type = ""
		
		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName == null || qualifiedName.empty)
			return ""
		
		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)			
			default: type = getCustomViewTypeNameForViewElementType(vet)			
		}
		
		if(type == null || type.empty)
			return ""
		
		result = '''
			«type» «qualifiedName.toFirstLower» = («type») findViewById(R.id.«qualifiedName»);
			«qualifiedName.toFirstLower».setWidgetId(R.id.«qualifiedName»);
			Md2WidgetRegistry.getInstance().addWidget(«qualifiedName.toFirstLower»);
        '''
        return result
	}
	
	private static def String generateLoadViewElement(ViewElementType vet){
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] != null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}
		
		var String result = ""
		var String type = ""
		
		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName == null || qualifiedName.empty)
			return ""		
		
		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)			
			default: type = getCustomViewTypeNameForViewElementType(vet)			
		}
		
		if(type == null || type.empty)
			return ""
		
		result = '''
			«type» «qualifiedName.toFirstLower» = («type») findViewById(R.id.«qualifiedName»);
			Md2WidgetRegistry.getInstance().loadWidget(«qualifiedName.toFirstLower»);
        '''
        
		return result
	}
	
	private static def String generateSaveViewElement(ViewElementType vet){
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] != null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}
		
		var String result = ""
		var String type = ""
		
		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName == null || qualifiedName.empty)
			return ""		
		
		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)			
			default: type = getCustomViewTypeNameForViewElementType(vet)			
		}
		
		if(type == null || type.empty)
			return ""
		
		result = '''
			«type» «qualifiedName.toFirstLower» = («type») findViewById(R.id.«qualifiedName»);
			Md2WidgetRegistry.getInstance().saveWidget(«qualifiedName.toFirstLower»);
        '''
        
		return result
	}
	
	private static def String getCustomViewTypeNameForViewElementType(ViewElementType vet){
		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)
			GridLayoutPane:
				return "Md2GridLayoutPane"
			Button:
				return "Md2Button"
			Label:
				return "Md2Label"
			TextInput:
				return "Md2TextInput"
			default: return ""
		}
	}
}