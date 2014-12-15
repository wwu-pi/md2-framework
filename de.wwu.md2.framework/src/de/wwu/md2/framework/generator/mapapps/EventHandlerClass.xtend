package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import org.eclipse.emf.ecore.resource.ResourceSet

class EventHandlerClass {
	
	def static String generateWorkflowEventHandler(DataContainer dataContainer, ResourceSet processedInput) {
		// TODO: get the right values here...
		var event = "THE_EVENT"
		var workflowelement = "THE_WORKFLOW_ELEMENT"
		'''
			define([
			    "dojo/_base/declare", "ct/Hash"
			],
			function(declare, Hash) {
			    
			    return declare([], {
			        constructor: function() {
			            this.controllers = new Hash();
			        },
			        createInstance: function() {
			            alert("hallo");
			            return {
			                handleEvent: this.handleEvent,
			                addController: this.addController,
			                removeController: this.removeController
			            };
			        },
			        
			        handleEvent: function(event, workflowelement) {
			           if (event === "«event»" && workflowelement === "«workflowelement»")
			           {
			               // TODO get correct controller from list this.controllers
			              var wfe = this._mediacapturingController;
			              wfe.activate();
			           }
			        },
			        
			        addController: function (controller, properties) {
			            console.log("controller", controller);
			            console.log("properties", properties);
			            var id = controller.get("id"),
			                    controllers = this.controllers;
			        },
			        
			        removeController: function (controller, properties) {
			        }
			        
			    });
			});
		'''
	}
}