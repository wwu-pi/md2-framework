package de.wwu.md2.framework.generator.android.wearable.controller

import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.SimpleType
import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.generator.android.wearable.util.MD2AndroidWearableUtil

class ControllerGen {
	def static generateController(String mainPackage, App app, DataContainer data)'''
		«var entities = data.entities»
		«var contentProviders = data.contentProviders»
		«var workflowElements = data.workflow.workflowElementEntries.filter(entry | app.workflowElements.map(wfe | wfe.workflowElementReference).contains(entry.workflowElement))»
		
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Md2Controller.generateController()
		package «mainPackage».md2.controller;
		
		import android.app.Activity;
		
		import «mainPackage».«app.name.toFirstUpper»;
		
		«FOR e:entities»
			import «mainPackage».md2.model.«e.name.toFirstUpper»;
		«ENDFOR»
		
		«FOR cp:contentProviders»
			import «mainPackage».md2.model.contentProvider.«cp.name.toFirstUpper»;
		«ENDFOR»
		
		import java.util.ArrayList;
		import java.util.HashSet;
		
		import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2MultiContentProvider;
		import de.uni_muenster.wi.md2library.model.dataStore.implementation.Md2RemoteStoreFactory;
		
		«MD2AndroidLollipopUtil.generateImportAllActions»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllExceptions»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
		«MD2AndroidLollipopUtil.generateImportAllCustomCodeTasks»
		
		import «Settings.MD2LIBRARY_PACKAGE»controller.implementation.AbstractMd2Controller;
		import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.implementation.Md2ContentProviderRegistry;
		import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.interfaces.Md2ContentProvider;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2SQLiteHelper;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.implementation.Md2SQLiteDataStore;
		import «Settings.MD2LIBRARY_PACKAGE»view.management.implementation.Md2ViewManager;
		import «Settings.MD2LIBRARY_PACKAGE»workflow.Md2WorkflowEventRegistry;
		import «Settings.MD2LIBRARY_PACKAGE»workflow.Md2WorkflowElement;
		import «Settings.MD2LIBRARY_PACKAGE»workflow.Md2WorkflowAction;
		import «mainPackage».md2.model.sqlite.Md2LocalStoreFactory;
		
		public class Controller extends AbstractMd2Controller {
		
			protected ArrayList<Md2CustomCodeTask> pendingTasks;
		
		    private static Controller instance;
		
		    private Controller() {
		        pendingTasks = new ArrayList<Md2CustomCodeTask>();
		    }
		
		    public static synchronized Controller getInstance() {
		        if (Controller.instance == null) {
		            Controller.instance = new Controller();
		        }
		        return Controller.instance;
		    }
		
		    @Override
		    public void run() {
		        this.registerContentProviders();
		        this.registerWorkflowEvents();
		    }

		    public void registerContentProviders() {
		        Md2ContentProviderRegistry cpr = Md2ContentProviderRegistry.getInstance();
		        Md2LocalStoreFactory lsf = new Md2LocalStoreFactory(this.instance);
		        Md2RemoteStoreFactory rsf= new Md2RemoteStoreFactory();
		        «FOR cp: contentProviders»
		        	«var typeName = getTypeName(cp)»
		        	«IF cp.type.many»
		        	«IF cp.local»
		        	Md2MultiContentProvider «cp.name.toFirstLower» = new «cp.name.toFirstUpper»( "«cp.name»",lsf.getDataStore("«typeName»"));
		        	«ELSE»
		        	Md2MultiContentProvider «cp.name.toFirstLower» = new «cp.name.toFirstUpper»("«cp.name»", rsf.getDataStore("«cp.connection.uri»",new «typeName»()));
		        			        	
		        	«ENDIF»
		        	cpr.addMultiContentProvider("«cp.name»", «cp.name.toFirstLower»);
		        	«ELSE»
		        	«IF cp.local»
		        	Md2ContentProvider «cp.name.toFirstLower» = new «cp.name.toFirstUpper»("«cp.name»",new «MD2AndroidWearableUtil.getTypeNameForContentProvider(cp)»(),  lsf.getDataStore("«typeName»"));
		        	«ELSE»
		        	Md2ContentProvider «cp.name.toFirstLower» = new «cp.name.toFirstUpper»("«cp.name»",new «MD2AndroidWearableUtil.getTypeNameForContentProvider(cp)»(),  rsf.getDataStore("«cp.connection.uri»",new «typeName»()));
		        			        	
		        	«ENDIF»
		        	cpr.add("«cp.name»", «cp.name.toFirstLower»);
		        	«ENDIF»
		        	
		        	
		        «ENDFOR»
		    }
		    
		    public void registerWorkflowEvents() {
		    	«FOR fireEventEntry : workflowElements.map[wfeEntry | wfeEntry.firedEvents.toList ].flatten»
		    	        
		    	    Md2WorkflowEventRegistry.getInstance().addWorkflowEvent(
		    	        "Md2FireEventAction«fireEventEntry.event.name.toFirstUpper»",
		    	        «IF fireEventEntry.endWorkflow»
		    	        new Md2WorkflowElement("«(fireEventEntry.eContainer as WorkflowElementEntry).workflowElement.name.toFirstUpper»", 
		    	        	new «mainPackage».md2.controller.action.«(fireEventEntry.eContainer as WorkflowElementEntry).workflowElement.name.toFirstUpper»___«(fireEventEntry.eContainer as WorkflowElementEntry).workflowElement.name»_startupAction_Action()),
		    	        Md2WorkflowAction.END);
		    	        «ELSE»
		    	        new Md2WorkflowElement("«fireEventEntry.startedWorkflowElement.name.toFirstUpper»", 
		    	        	new «mainPackage».md2.controller.action.«fireEventEntry.startedWorkflowElement.name.toFirstUpper»___«fireEventEntry.startedWorkflowElement.name»_startupAction_Action()),
		    	        Md2WorkflowAction.START);
		    	        «ENDIF»
		    	«ENDFOR»
		    }
		
		    @Override
		    public Md2SQLiteHelper getMd2SQLiteHelper() {
		        return «app.name.toFirstUpper».getMd2SQLiteHelper();
		    }
		}
	'''
	
	private static def getTypeName(ContentProvider cp){
		var type = cp.type
		switch type{ 
		    ReferencedModelType : type.entity.getName
		    SimpleType : type.type.getName()
		}
	}
}