package de.wwu.md2.framework.generator.android.wearable.controller

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ActionDrawer
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WorkflowElementReference
import de.wwu.md2.framework.mD2.ContentContainer

class ActivityGen {
	
	def static generateActivities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContainerElement> rootViews, Iterable<WorkflowElementReference> startableWorkflowElements) {
		
		fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "NavigationAdapter.java",
			generateNavigationAdapter(mainPackage, startableWorkflowElements))
		
		//fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "StartActivity.java",
		//		generateStartActivity(mainPackage, startableWorkflowElements))	
		
		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "Activity.java",
				generateActivity(mainPackage, rv))
		]
	}
	
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
			
			public static synchronized NavigationAdapter getInstance(){
			        if (NavigationAdapter.instance == null) {
			            NavigationAdapter.instance = new NavigationAdapter();
			        }
			        return instance;
			}
			
			private NavigationAdapter(){
				active = 0;
				selected = 0;
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
			
			public boolean close(){
				if (active != selected){
					active = selected;
					actions.get(selected).execute();
					return true;
				} else {
					return false;
				}
			}
			
			public void open(){
				selected = 0;
			}
			
		}
		
	'''
	
	def static generateStartActivity(String mainPackage, Iterable<WorkflowElementReference> startableWorkflowElements)'''
		// generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateStartActivity()
		package «mainPackage»;
		
		import android.os.Bundle;
		import android.app.Activity;
		import android.content.Intent;
		
		import android.view.View;
		
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

	private def static generateActivity(String mainPackage, ContainerElement rv) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Activity.generateActivity()
		package «mainPackage»;
		
		import android.app.Activity;
		import android.content.Intent;
		import android.os.Bundle;
		import android.view.View;
		import android.view.Gravity;
		import android.support.wearable.view.drawer.WearableDrawerLayout;
		import android.support.wearable.view.drawer.WearableDrawerView;
		import android.support.wearable.view.drawer.WearableNavigationDrawer;
		
		import «mainPackage».md2.controller.Controller;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		«MD2AndroidLollipopUtil.generateImportAllWidgets»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
				
		public class «rv.name»Activity extends Activity {
			
			private WearableDrawerLayout drawerLayout;	
			private WearableNavigationDrawer navigationDrawer;
			private NavigationAdapter adapter;
			private WearableActionDrawer actionDrawer;
			
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
				adapter.open();
				}
				@Override
				public void onDrawerClosed(View view) {
				if(adapter.close()){
			                		«rv.name»Activity.this.finish();
				}
			}
			
			@Override
			public void onDrawerStateChanged(@WearableDrawerView.DrawerState int i) {
			}
			});		        
		        
		        navigationDrawer = (WearableNavigationDrawer) findViewById(R.id.navigation_drawer_«rv.name»);
		        adapter = NavigationAdapter.getInstance();
		        navigationDrawer.setAdapter(adapter);
		        
		    }
		
		    @Override
		    protected void onStart(){
				super.onStart();
		        Md2ViewManager.getInstance().setActiveView(this);
		        
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«generateLoadViewElement(viewElement)»
		        «ENDFOR»
		        
		        drawerLayout.peekDrawer(Gravity.TOP);
		        
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
		
		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
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
		
		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
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
		
		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
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
			default: return ""
		}
	}
}