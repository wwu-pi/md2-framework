package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil
import de.wwu.md2.framework.generator.ios.view.IOSView
import de.wwu.md2.framework.generator.ios.view.IOSWidgetMapping
import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.RemoteConnection
import de.wwu.md2.framework.mD2.Style
import java.lang.invoke.MethodHandles

class IOSController {
	
	static var className = ""
	static var hasRemoteContentProviders = false
	
	def static generateStartupController(DataContainer data, App app) {
		className = Settings.PREFIX_GLOBAL + "Controller"
		
		hasRemoteContentProviders = data.contentProviders.exists[ c |
			c.type instanceof ReferencedModelType
			&& !c.local
		]
			
		generateClassContent(data, app)
	} 
	
	def static generateClassContent(DataContainer data, App app) '''
«IOSGeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

import UIKit

class MD2Controller {
    func run(window: UIWindow) {
        // Initialize the widget registry
        var widgetRegistry = MD2WidgetRegistry.instance

		/***************************************************
		 * 
		 * Initialize all view elements
		 * 
		 ***************************************************/
        «FOR view : data.rootViewContainers.values.flatten»
        // View: «view.name»
        «IOSView.generateView(view, data.view.eAllContents.filter(Style).toList)»
        «ENDFOR»
        
    	/***************************************************
		 * 
		 * Initialize content providers
		 * 
		 ***************************************************/
		«FOR contentProvider: data.contentProviders»
		MD2ContentProviderRegistry.instance.addContentProvider("«contentProvider.name»", 
			provider: «Settings.PREFIX_CONTENT_PROVIDER + contentProvider.name.toFirstUpper»(
			content: «Settings.PREFIX_ENTITY + (contentProvider.type as ReferencedModelType).entity.name.toFirstUpper»()))
        «ENDFOR»
        
		«IF hasRemoteContentProviders»
		// There are remote content providers -> Check for model version
		«FOR connection : data.controller.controllerElements.filter(RemoteConnection)»
		    if !MD2RestClient.instance.testModelVersion("«data.main.modelVersion»", basePath: "«connection.uri»") {
		       	fatalError("The data model version is not supported by the backend (or the server could not be reached): «connection.uri»")
		    }
		«ENDFOR»
		«ENDIF»
        
        /***************************************************
		 * 
		 * Initialize view manager and all views
		 * 
		 ***************************************************/
        var viewManager = MD2ViewManager.instance
        viewManager.window = window
        
        «FOR rootView : data.rootViewContainers.values.flatten»
        viewManager.setupView("«IOSWidgetMapping.fullPathForViewElement(rootView).toFirstUpper»", view: «IOSWidgetMapping.fullPathForViewElement(rootView).toFirstLower»)
        «ENDFOR»
        
        /***************************************************
		 * 
		 * Initialize workflow elements
		 * 
		 ***************************************************/
        
        «IOSWorkflow.generateWorkflowElements(data.workflowElements)»
        
        // Register workflow events
        «IOSWorkflow.generateWorkflowEventRegistration(data.workflow.workflowElementEntries)»
        
        /***************************************************
		 * 
		 * Start initial workflow of the app
		 * 
		 ***************************************************/
		 
		// Execute startup action for first WFE
		// TODO Construct workflow element selection screen
		
		«val initialWfe = app.workflowElements.filter[wfe | wfe.startable].head.workflowElementReference»
		MD2SetWorkflowElementAction(actionSignature: "SetWorkflow«initialWfe.name.toFirstUpper»Action", workflowElement: wfe«initialWfe.name.toFirstUpper»).execute()
		
		println("[Controller] Startup completed")
    }
}
	'''
}