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

class ActivityGen {
	def static generateActivities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,	
		Iterable<ContainerElement> rootViews, Iterable<WorkflowElementReference> startableWorkflowElements, Iterable<Entity> entities) {
		
		fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "StartActivity.java",
				generateStartActivity(mainPackage, startableWorkflowElements, entities))
							
		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "Activity.java",
				generateActivity(mainPackage, rv))
		]
	}
	
	def static generateStartActivity(String mainPackage, Iterable<WorkflowElementReference> startableWorkflowElements,Iterable<Entity> entities)'''
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
		       
		       //Sensor TODO: Prüfen ob ein Attribut des Typssensor vorhanden ist 
		       //Benötigt wird: Name des Attributes und der Sensortyp
               SensorHelper meinSensorHelper = new SensorHelper(this, "meinSensor", "luxmeter");
               
               «FOR e: entities»
					«FOR attribute : e.attributes»
			        	«IF attribute.type.toString().contains("SensorTypeImpl")» //TODO
			        		//Sensor erkannt
			        		SensorHelper meinSensorHelper = new SensorHelper(this, «attribute.name», "luxmeter");
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
		
		import «mainPackage».md2.controller.Controller;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		«MD2AndroidLollipopUtil.generateImportAllWidgets»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
				
		public class «rv.name»Activity extends Activity {
		
		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_«rv.name.toLowerCase»);
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«generateAddViewElement(viewElement)»
		        «ENDFOR»
		    }
		
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