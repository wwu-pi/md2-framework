package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import org.eclipse.xtend2.lib.StringConcatenation
import de.wwu.md2.framework.mD2.App

class EventHandlerClass {

    def static String generateWorkflowEventHandler(DataContainer dataContainer, App app) {

        // TODO: get the right values here...
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
						workflowStateHandler: null,
						addController: this.addController,
						removeController: this.removeController,
						instance: this,
						resetAll: this.resetAll
					};
				},

				handleEvent: function(event, workflowelement) {
					if
					«FOR wfe : dataContainer.workflowElementsForApp(app) SEPARATOR StringConcatenation::DEFAULT_LINE_DELIMITER + "else if"»
					«IF dataContainer.getEventsFromWorkflowElement(wfe).size==0»
					(false){}
					«ENDIF»
					«FOR event : dataContainer.getEventsFromWorkflowElement(wfe) SEPARATOR StringConcatenation::DEFAULT_LINE_DELIMITER + "else if"»
					(event === "«event.name»" && workflowelement === "«wfe.name»")
					{
					«IF dataContainer.workflowElementsForApp(app).contains(dataContainer.getNextWorkflowElement(wfe, event))»
					var currentController = this.instance.controllers.get("md2.wfe.«wfe.name».Controller");
					var nextController = this.instance.controllers.get("md2.wfe.«dataContainer.getNextWorkflowElement(wfe, event).name».Controller");
					this.workflowStateHandler.changeWorkflowElement(currentController, nextController, "md2_«dataContainer.getNextWorkflowElement(wfe, event).name»");
					«ELSE»
					var currentController = this.instance.controllers.get("md2.wfe.«wfe.name».Controller");
					this.workflowStateHandler.fireEventToBackend(event, workflowelement, currentController, currentController.getTransactionId());
					this.resetAll();
					«ENDIF»
					}
                    «ENDFOR»
                    «ENDFOR»            
				},

				addController: function (controller, properties) {
					this.controllers.set(properties.objectClass[0],controller);
				},

				removeController: function (controller, properties) {
				},

		        resetAll: function(){
		            this.instance.controllers.forEach(function(controller){
		                controller.finish();
		            });
		        }

			});
		});
        '''
    }
}
