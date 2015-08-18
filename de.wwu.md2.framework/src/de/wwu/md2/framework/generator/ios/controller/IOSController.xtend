package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.generator.ios.Settings
import java.lang.invoke.MethodHandles
import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.generator.ios.view.IOSView
import de.wwu.md2.framework.mD2.Style

class IOSController {
	
	static var className = ""
	
	def static generateStartupController(DataContainer data) {
		className = Settings.PREFIX_GLOBAL + "Controller"
		
		generateClassContent(data)
	} 
	
	def static generateClassContent(DataContainer data) '''
«GeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

func run(window: UIWindow) {
        // Initialize the widget registry
        var widgetRegistry = WidgetRegistry.instance

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
        let oneComplaintContentProvider = ComplaintContentProvider(content: Complaint())
        ContentProviderRegistry.instance.addContentProvider("ComplaintProvider", provider: oneComplaintContentProvider)
        
        let address = Address()
        //address.internalId = MD2Integer(1)
        address.set("myCity", value: MD2String("Muenster"))
        let oneAddressContentProvider = AddressContentProvider(content: address)
        ContentProviderRegistry.instance.addContentProvider("AddressProvider", provider: oneAddressContentProvider)
        
        //oneAddressContentProvider.save()
        
        let secondAddressContentProvider = AddressContentProvider(content: address)
        //secondAddressContentProvider.load()
        println(secondAddressContentProvider.content?.toString())
        
        
        /***************************************************
		 * 
		 * Initialize view manager and all views
		 * 
		 ***************************************************/
        var viewManager = ViewManager.instance
        viewManager.window = window
        
        viewManager.setupView("LocationDetectionView", view: locationDetectionView)
        viewManager.setupView("LocationVerifyView", view: locationVerifyView)
        
        /***************************************************
		 * 
		 * Initialize process chains and workflowElements
		 * 
		 ***************************************************/
        let pcLocationDetection_LocationProcessChain = ProcessChain(processChainSignature: "LocationDetection_LocationProcessChain")
        let step1 = pcLocationDetection_LocationProcessChain.addProcessChainStep("LocationDetection", viewName: "LocationDetectionView")
        step1.addGoTo(ProcessChainStep.GoToType.Proceed, eventType: EventType.OnClick, widget: WidgetMapping.LocationDetectionView_Next, action: CustomAction_SaveComplaint(), goToStep: nil)
        
        let step2 = pcLocationDetection_LocationProcessChain.addProcessChainStep("LocationVerify", viewName: "LocationVerifyView")
        step2.addGoTo(ProcessChainStep.GoToType.Reverse, eventType: EventType.OnClick, widget: WidgetMapping.LocationVerifyView_Previous, action: nil, goToStep: nil)
        
        ProcessChainRegistry.instance.addProcessChain(pcLocationDetection_LocationProcessChain)
        
        let wfeLocationDetection = WorkflowElement(name: "LocationDetection", onInit: CustomAction_Init(), defaultProcessChain: pcLocationDetection_LocationProcessChain)
        wfeLocationDetection.addInitialAction(CustomAction_ButtonInit())
        
        // Register workflowEvents
        WorkflowEventHandler.instance.registerWorkflowElement(
            WorkflowEvent.LocationDetection_DoneEvent,
            actionType: WorkflowActionType.End,
            workflowElement: wfeLocationDetection)
        WorkflowEventHandler.instance.registerWorkflowElement(
            WorkflowEvent.LocationDetection_CancelWorkflowEvent,
            actionType: WorkflowActionType.End,
            workflowElement: wfeLocationDetection)
        
        /***************************************************
		 * 
		 * Start initial workflow of the app
		 * 
		 ***************************************************/
        SetWorkflowElementAction(actionSignature: "InitialAction", workflowElement: wfeLocationDetection).execute()
        
        println("[Controller] Startup completed")
    }
}
	'''
}