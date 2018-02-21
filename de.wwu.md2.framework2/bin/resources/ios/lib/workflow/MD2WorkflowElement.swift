//
//  MD2WorkflowElement.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 13.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// A workflow element.
class MD2WorkflowElement {
    
    /// Unique string representation of the element.
    let name: String
    
    /**
        A list of actions to trigger when the workflow is triggered.
    
        *Notice:* Currently preprocessing leaves only one action MD2CustomAction__<WfeName>_startupAction.
    */
    var onInit: Array<MD2Action> = []

    /**
        Object Constructor. The identifier and at least one action to trigger are required.
    
        :param: name The workflow element name as identifier.
        :param: onInit The initial action to trigger when the workflow element is started.
    */    
    init(name: String, onInit: MD2Action) {
        self.name = name
        self.onInit.append(onInit)
    }
    
    /**
        Start the workflow element, i.e. its initial actions.
    */
    func start() {
        for initAction in onInit {
            initAction.execute()
        }
    }
    
    /**
        Eventually perform actions when the workflow element is left.
    */
    func end() {
        // Currently nothing to do
        // There might have some unmapping etc. in future
    }
    
}
