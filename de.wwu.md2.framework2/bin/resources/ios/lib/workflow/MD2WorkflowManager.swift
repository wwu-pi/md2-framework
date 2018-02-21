//
//  MD2WorkflowManager.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 14.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// The object managing the workflow process.
class MD2WorkflowManager {
    
    /// The singleton instance
    static let instance: MD2WorkflowManager = MD2WorkflowManager()
    
    /// The current workflow element
    var currentWorkflowElement: MD2WorkflowElement?
    
    /// List of startable workflow elements to present on start screeen
    var startableWorkflowElements: Dictionary<MD2WidgetMapping, (String, MD2WorkflowElement)> = [:]
    
    /// Start screen view to fill with elements
    var startScreen: MD2ViewController?
    
    /// Singleton initializer
    private init() {
        // Private initializer for singleton object
    }
    
    /**
        Add startable workflow element.
    
        :param: workflowElement The startable workflow element
    */
    func addStartableWorkflowElement(workflowElement: MD2WorkflowElement, withCaption: String, forWidget: MD2WidgetMapping) {
        startableWorkflowElements[forWidget] = (withCaption, workflowElement)
    }
    
    /**
        Switch to another workflow element. The currently running workflow element (if existing) is properly ended beforehand.
    
        :param workflowElement The workflow element to start.
    */
    func goToWorkflow(workflowElement: MD2WorkflowElement) {
        println("[WorkflowManager] Switch workflow into '\(workflowElement.name)'")
        
        if let _ = currentWorkflowElement {
            currentWorkflowElement!.end()
        }
        currentWorkflowElement = workflowElement
        currentWorkflowElement!.start()
    }
    
    /**
        End the workflow element. To continue the app flow, the start view is invoked for a new workflow selection.
    
        :param workflowElement The workflow element to end.
    */
    func endWorkflow(workflowElement: MD2WorkflowElement) {
        println("[WorkflowManager] End workflow '\(workflowElement.name)'")

        workflowElement.end()
        currentWorkflowElement = nil
        
        // Go back to startup screen
        MD2ViewManager.instance.goToStartView()
    }
    
    /**
        Generate a view with buttons for all startable workflow elements that is shown on startup
    */
    func generateStartScreen() {
        let outerLayout = MD2FlowLayoutPane(widgetId: MD2WidgetMapping.__startScreen)
        outerLayout.orientation = MD2FlowLayoutPane.Orientation.Vertical
        
        // Add initial Label
        let label = MD2LabelWidget(widgetId: MD2WidgetMapping.__startScreen_Label)
        label.value = MD2String("Select workflow to start")
        label.fontSize = MD2Float(2.0)
		label.widgetElement.textAlignment = .Center
        label.color = MD2String("#000000")
        label.textStyle = MD2WidgetTextStyle.Bold
        outerLayout.addWidget(label)
        MD2WidgetRegistry.instance.add(MD2WidgetWrapper(widget: label))
        
        outerLayout.addWidget(MD2SpacerWidget(widgetId: MD2WidgetMapping.Spacer))
        
        // Add buttons for each startable workflow
        for (widget, (caption, wfe)) in startableWorkflowElements {
            let button = MD2ButtonWidget(widgetId: widget)
            button.value = MD2String(caption)
            outerLayout.addWidget(button)
            
            let buttonWrapper = MD2WidgetWrapper(widget: button)
            MD2WidgetRegistry.instance.add(buttonWrapper)
            
            // Link button click to workflow action
            MD2OnClickHandler.instance.registerAction(MD2SetWorkflowElementAction(actionSignature: "__startScreen_" + wfe.name, workflowElement: wfe), widget: buttonWrapper)
        }
        
        startScreen = MD2ViewManager.instance.setupView("__startScreen", view: outerLayout)
        MD2ViewManager.instance.showStartView("__startScreen")
    }
    
    /**
        Recreate the start screen view with all startable workflow elements
    */
    func updateStartScreen() {
        // MARK Update existing view when remote workflow handling is implemented (currently there is no change)
    }
}
