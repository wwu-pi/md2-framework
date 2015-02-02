package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.FireEventAction
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.WorkflowEvent
import org.eclipse.xtend2.lib.StringConcatenation
import de.wwu.md2.framework.mD2.App

class EventHandlerClass {

    def static String generateWorkflowEventHandler(DataContainer dataContainer, App app) {

        // TODO: get the right values here...
        '''
		define([
				"dojo/_base/declare", "ct/Hash", "ct/request"
				],
		function(declare, Hash, ct_request) {

			return declare([], {
				constructor: function() {
					this.controllers = new Hash();
				},
				createInstance: function() {  
					return {
						handleEvent: this.handleEvent,
							$: null, // injected by MD2MainWidget
							addController: this.addController,
							removeController: this.removeController,
							changeWorkflowElement: this.changeWorkflowElement,
							fireEventToBackend: this.fireEventToBackend,
							instance: this
						};
					},

				handleEvent: function(event, workflowelement) {
					if
					«FOR wfe : dataContainer.workflowElementsForApp(app) SEPARATOR StringConcatenation::DEFAULT_LINE_DELIMITER + "else if"»
					«FOR event : dataContainer.getEventsFromWorkflowElement(wfe) SEPARATOR StringConcatenation::DEFAULT_LINE_DELIMITER + "else if"»
					(event === "«event.name»" && workflowelement === "«wfe.name»")
					{
					«IF dataContainer.workflowElementsForApp(app).contains(dataContainer.getNextWorkflowElement(wfe, event))»
					this.changeWorkflowElement("md2.wfe.«wfe.name».Controller", "md2.wfe.«dataContainer.getNextWorkflowElement(wfe, event).name».Controller", "md2_«dataContainer.getNextWorkflowElement(wfe, event).name»");
					«ELSE»
					this.fireEventToBackend(event, workflowelement, "md2.wfe.«wfe.name».Controller");
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

				changeWorkflowElement: function(previousControllerId, nextControllerId, nextWorflowElement) {
					var previousController = this.instance.controllers.get(previousControllerId);
					var nextController = this.instance.controllers.get(nextControllerId);  
					nextController._startedWorkflowInstanceId = previousController._startedWorkflowInstanceId;
					previousController.closeWindow();
					previousController._isFirstExecution = true;
					this.instance.workflowStateHandler.setResumeWorkflowElement(nextController._startedWorkflowInstanceId, nextWorflowElement);
					nextController.openWindow();
				},
			        
				fireEventToBackend: function(event, workflowElement, currentControllerId){
					var currentController = this.instance.controllers.get(currentControllerId);
					currentController.closeWindow();
					currentController._isFirstExecution = true;
					var parameters = {
						instanceId: currentController._startedWorkflowInstanceId,
						lastEventFired: event,
						currentWfe: workflowElement
					};
					var requestArgs = {
						url: this.url,
						content: parameters,
						handleAs: "json"
					};
					return ct_request(requestArgs,{usePost:true});
				}

			});
		});
        '''
    }
}
