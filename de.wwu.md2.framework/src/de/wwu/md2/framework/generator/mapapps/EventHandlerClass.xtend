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
			            return {
			                handleEvent: this.handleEvent,
			                addController: this.addController,
			                removeController: this.removeController,
			                instance: this
			            };
			        },
			        
			        handleEvent: function(event, workflowelement) {
			           if (event === "«event»" && workflowelement === "«workflowelement»")
			           {
							this.instance.controllers.get("md2.wfe.Locationdetection.Controller").closeWindow();
			              	this.instance.controllers.get("md2.wfe.Locationdetection.Controller")._isFirstExecution = true;
			            	this.instance.controllers.get("md2.wfe.MediaCapturing.Controller").openWindow();
			           }
			        },
			        
			        addController: function (controller, properties) {
							this.controllers.set(properties.objectClass[0],controller);
			        },
			        
			        removeController: function (controller, properties) {
			        }
			        
			    });
			});
		'''
	}
}