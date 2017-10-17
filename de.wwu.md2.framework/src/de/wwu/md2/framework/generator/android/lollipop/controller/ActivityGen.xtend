package de.wwu.md2.framework.generator.android.lollipop.controller

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.generator.android.common.util.MD2AndroidUtil
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WorkflowElementReference
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.ListView
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.SensorType
import de.wwu.md2.framework.mD2.AttrSensorTyp
import de.wwu.md2.framework.mD2.AttrSensorAxis

class ActivityGen {
	
	static boolean FirstCall = true;
	
	def static generateActivities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContainerElement> rootViews, Iterable<WorkflowElementReference> startableWorkflowElements, Iterable<Entity> entities, App app) {
		
		fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "StartActivity.java",
				generateStartActivity(mainPackage, startableWorkflowElements))	
		
		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "Activity.java",
				generateActivity(mainPackage, entities, rv))
				
				if (rv instanceof ListView){
					fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "ListAdapter.java",
					generateListAdapter(mainPackage, rv, app))
				}
		]
		
		FirstCall = true;
	}
	
		//generiert ListAdapter für Inhalt einer Listenansicht
	def static generateListAdapter(String mainPackage, ListView rv, App app)'''
		//generated in de.wwu.md2.framework.generator.android.lollipop.controller.Activity.generateListAdapter()

		package «mainPackage»;
		
		import android.content.Context;
		import android.graphics.Color;
		import android.graphics.Point;
		import android.view.Display;
		import android.view.Gravity;
		import android.view.WindowManager;
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
		import de.uni_muenster.wi.md2library.controller.action.implementation.Md2RefreshListAction;
		
		«IF(!(rv.onClickAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidUtil.getQualifiedNameAsString(rv.onClickAction, "_").toFirstUpper»_Action;
		«ENDIF»
		«IF(!(rv.leftSwipeAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidUtil.getQualifiedNameAsString(rv.leftSwipeAction, "_").toFirstUpper»_Action;
		«ENDIF»
		«IF(!(rv.rightSwipeAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidUtil.getQualifiedNameAsString(rv.rightSwipeAction, "_").toFirstUpper»_Action;
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
				content.addAdapter(this, "«rv.name»ListAdapter");
				swipeHandler = new Md2ButtonOnSwipeHandler();
				clickHandler = new Md2OnClickHandler();
				«IF(!(rv.onClickAction === null))»
					Md2Action ca = new «MD2AndroidUtil.getQualifiedNameAsString(rv.onClickAction, "_").toFirstUpper»_Action();
					clickHandler.registerAction(ca);
				«ENDIF»
				«IF(!(rv.leftSwipeAction === null))»
					Md2Action lsa = new «MD2AndroidUtil.getQualifiedNameAsString(rv.leftSwipeAction, "_").toFirstUpper»_Action();
					swipeHandler.getLeftSwipeHandler().registerAction(lsa);
				«ENDIF»
				«IF(!(rv.rightSwipeAction === null))»
					Md2Action rsa = new «MD2AndroidUtil.getQualifiedNameAsString(rv.rightSwipeAction, "_").toFirstUpper»_Action();
					swipeHandler.getRightSwipeHandler().registerAction(rsa);
				«ENDIF»
			}
			
			@Override
			public void onBindViewHolder(RecyclerView.ViewHolder vh, int i){
				ListItem li = (ListItem) vh;
				if(content.getValue(i,"«rv.connectedProvider.tail.attributeRef.name»") != null){
					li.getButton().setText(content.getValue(i,"«rv.connectedProvider.tail.attributeRef.name»").getString().toString());
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
				Md2RefreshListAction rflaction = new Md2RefreshListAction(this);
				ch.registerAction(rflaction);
				sw.registerAction(rflaction, true);
				sw.registerAction(rflaction, false);
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
					button.setBackgroundColor(Color.TRANSPARENT);
					WindowManager wm = (WindowManager) «app.name.toFirstUpper».getAppContext().getSystemService(Context.WINDOW_SERVICE);
					Display display = wm.getDefaultDisplay();
					Point size = new Point();
					display.getSize(size);
					int width = size.x;
					button.setWidth(width);
					button.setGravity(Gravity.LEFT);
				}
				
				public Md2Button getButton(){
					return button;
				}
				
				
			}
			
		}
		
	'''

	def static generateStartActivity(String mainPackage, Iterable<WorkflowElementReference> startableWorkflowElements)'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Activity.generateStartActivity()
		package «mainPackage»;
		
		import android.app.Activity;
		import android.content.Intent;
		import android.os.Bundle;
		import android.view.View;
		
		import «mainPackage».md2.controller.Controller;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		«MD2AndroidUtil.generateImportAllWidgets»
		«MD2AndroidUtil.generateImportAllTypes»
		«MD2AndroidUtil.generateImportAllEventHandler»
		
		«FOR wer : startableWorkflowElements»		        	
			import «mainPackage».md2.controller.action.«wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action;
		«ENDFOR»
		
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2GoToViewAction;
		
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

	private def static generateActivity(String mainPackage, Iterable<Entity> entities, ContainerElement rv) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Activity.generateActivity()
		package «mainPackage»;
		
		import android.app.Activity;
		import android.content.Intent;
		import android.os.Bundle;
		import android.view.View;
		
		import android.support.v7.widget.RecyclerView;
		import android.support.v7.widget.LinearLayoutManager;
		import android.support.v7.widget.DividerItemDecoration;
		import android.support.v7.widget.DefaultItemAnimator;
		
		import «mainPackage».md2.controller.Controller;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		«MD2AndroidUtil.generateImportAllWidgets»
		«MD2AndroidUtil.generateImportAllTypes»
		«MD2AndroidUtil.generateImportAllEventHandler»
				
		public class «rv.name»Activity extends Activity {
		
			private RecyclerView wrv;
		
			@Override
			protected void onCreate(Bundle savedInstanceState) {
				super.onCreate(savedInstanceState);
				setContentView(R.layout.activity_«rv.name.toLowerCase»);
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
					«generateAddViewElement(viewElement)»
		        «ENDFOR»

		        «IF (rv instanceof ListView)»
				wrv = (RecyclerView) findViewById(R.id.recycler_view_«rv.name»);
				
				final LinearLayoutManager layoutManager = new LinearLayoutManager(getApplicationContext());
				layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
				wrv.setLayoutManager(layoutManager);
				        
				«rv.name»ListAdapter listAdapter = new «rv.name»ListAdapter();
				wrv.setAdapter(listAdapter);
				   	
				wrv.addItemDecoration(new DividerItemDecoration(
					wrv.getContext(),
				   	layoutManager.getOrientation()
				));
				wrv.setItemAnimator(new DefaultItemAnimator());
				«ENDIF»
		    }
		    
		    «IF FirstCall»
				//HardwareSensoren
				«generateSensor(entities)»
			«ENDIF»
		
		    @Override
		    protected void onStart(){
				super.onStart();
		        Md2ViewManager.getInstance().setActiveView(this);
		        
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«generateLoadViewElement(viewElement)»
		        «ENDFOR»
		        
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
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] !== null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}
		
		var String result = ""
		var String type = ""
		
		var qualifiedName = MD2AndroidUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName === null || qualifiedName.empty)
			return ""
		
		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)			
			default: type = getCustomViewTypeNameForViewElementType(vet)			
		}
		
		if(type === null || type.empty)
			return ""
		
		result = '''
			«type» «qualifiedName.toFirstLower» = («type») findViewById(R.id.«qualifiedName»);
			«qualifiedName.toFirstLower».setWidgetId(R.id.«qualifiedName»);
			Md2WidgetRegistry.getInstance().addWidget(«qualifiedName.toFirstLower»);
        '''
        return result
	}
	
	private static def String generateLoadViewElement(ViewElementType vet){
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] !== null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}
		
		var String result = ""
		var String type = ""
		
		var qualifiedName = MD2AndroidUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName === null || qualifiedName.empty)
			return ""		
		
		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)			
			default: type = getCustomViewTypeNameForViewElementType(vet)			
		}
		
		if(type === null || type.empty)
			return ""
		
		result = '''
			«type» «qualifiedName.toFirstLower» = («type») findViewById(R.id.«qualifiedName»);
			Md2WidgetRegistry.getInstance().loadWidget(«qualifiedName.toFirstLower»);
        '''
        
		return result
	}
	
	private static def String generateSaveViewElement(ViewElementType vet){
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] !== null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}
		
		var String result = ""
		var String type = ""
		
		var qualifiedName = MD2AndroidUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName === null || qualifiedName.empty)
			return ""		
		
		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)			
			default: type = getCustomViewTypeNameForViewElementType(vet)			
		}
		
		if(type === null || type.empty)
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
			IntegerInput:
				return "Md2TextInput"
			default: return ""
		}
	}
	
	/**
	 * generateSensor erwartet die Entites aus dem MD2 Modell, um daraus die entsprechenden
	 * Attribute, die als Sensor, gekenzeichnet sind zu generieren. Der fertig generierte Code
	 * wird als String zurückgegeben.
	 */
	private static def String generateSensor(Iterable<Entity> entities){
		var String result = "";
		//Alle Entities durchgehen
		for (e : entities) {
			for (attribute : e.attributes){
				//Nur Attribute vom Typ Sensor bearbeiten
				if(attribute.type instanceof SensorType){
					//Parameter durchgehen
					for(param : (attribute.type as SensorType).params){
						//Parameter vom AttrSensorTyp
						if(param instanceof AttrSensorTyp){
							if(param.accelerometer){
								result += ("SensorHelper meinSensorHelper_" + attribute.name +" = new SensorHelper(this, \"" + attribute.name + "\", \"accelerometer\", \"");
							}
							if(param.gyroskop){
								result += ("SensorHelper meinSensorHelper_" + attribute.name +" = new SensorHelper(this, \"" + attribute.name + "\", \"gyroskop\", \"")
							}
							if(param.heartrate){
								result += ("SensorHelper meinSensorHelper_" + attribute.name +" = new SensorHelper(this, \"" + attribute.name + "\", \"heartrate\");\r\n")
							}
							if(param.proximity){
								result += ("SensorHelper meinSensorHelper_" + attribute.name +" = new SensorHelper(this, \"" + attribute.name + "\", \"proximity\");\r\n")
							}
						}
						//Parameter vom AttrSensorAxis
						if(param instanceof AttrSensorAxis){
							if(param.x){result += ("X\");\r\n")}
							if(param.y){result += ("Y\");\r\n")}
							if(param.z){result += ("Z\");\r\n")}
						}
					}
				}
			}
			println(result)
			return result;
		}
	}
}