package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.ViewFrame
import org.eclipse.emf.ecore.resource.ResourceSet

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.CombinedAction
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.ElementEventType
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.Controller

class SmartphonePreprocessor extends AbstractPreprocessor {
	
	var static ResourceSet preprocessedModel;
	var static ResourceSet unprocessedModel;
	var static ResourceSet previousInputSet;
	/**
	 * Singleton instance of this preprocessor.
	 */
	private static SmartphonePreprocessor instance
	
	
	def static getPreprocessedModel(ResourceSet input, ResourceSet unprocessedInput) {
		if (!input.equals(previousInputSet)) {
			if (instance === null) {
				//initialize(new MD2ComplexElementFactory)
				instance = new SmartphonePreprocessor
			}
			previousInputSet = input
			unprocessedModel = unprocessedInput
			instance.setNewModel(input)
			println("Smartphone preprocessing running...")
			preprocessedModel = instance.preprocessModel
		}
		return preprocessedModel
	}
	
	/**
	 * Actual preprocessing processChain.
	 */
	private def preprocessModel() {
		transformViewActionsToButtons()
		
		workingInput.resolveAll
		workingInput
	}
	
	def transformViewActionsToButtons(){
		view.eAllContents.toIterable.filter(ViewFrame).map[it.viewActions].flatten.forEach[viewAction |
			// Display viewActions as buttons below other content
			val viewFrame = (viewAction.eContainer as ViewFrame)
			val button = MD2Factory.eINSTANCE.createButton
			button.name = MD2GeneratorUtil.getName(button)
			button.text = viewAction.getTitle()
			viewFrame.elements.add(button) 
			
			// Not so nice workaround using unprocessed model to get from viewFrame to respective workflowElement
			val origController = unprocessedModel.resources.map[it.contents].flatten.filter(MD2Model).map[it.modelLayer].filter(Controller)?.head
			val wfeName = origController.controllerElements.filter(WorkflowElement).filter[it.processChain.map[it.processChainSteps.map[it.view.ref]].flatten.exists[it.name == viewFrame.name]]?.head?.name
		
			val wfes = controller.controllerElements.filter(WorkflowElement).filter[it.name == wfeName]
			wfes.forEach[wfe |
				var currentAction = wfe.initActions.get(0)
				while(currentAction instanceof CombinedAction){
					currentAction = currentAction.actions.get(0)
				}
				
				// Set action
				val actionDef = MD2Factory.eINSTANCE.createActionReference
				actionDef.actionRef = viewAction.action
				val bindTask = MD2Factory.eINSTANCE.createEventBindingTask
				bindTask.actions.add(actionDef)
				
				val viewElementRef = MD2Factory.eINSTANCE.createAbstractViewGUIElementRef
				viewElementRef.ref = button
				val eventDef = MD2Factory.eINSTANCE.createViewElementEventRef
				eventDef.referencedField = viewElementRef
				eventDef.event = ElementEventType.ON_CLICK;
				bindTask.events.add(eventDef)
				
				(currentAction as CustomAction).codeFragments.add(bindTask)
			]
			
			// TODO defaultproceed
		]
		
	}
}