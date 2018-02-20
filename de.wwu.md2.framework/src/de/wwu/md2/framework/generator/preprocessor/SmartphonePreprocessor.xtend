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

class SmartphonePreprocessor extends AbstractPreprocessor {
	
	var static ResourceSet preprocessedModel;
	var static ResourceSet previousInputSet;
	/**
	 * Singleton instance of this preprocessor.
	 */
	private static SmartphonePreprocessor instance
	
	
	def static getPreprocessedModel(ResourceSet input) {
		if (!input.equals(previousInputSet)) {
			if (instance === null) {
				//initialize(new MD2ComplexElementFactory)
				instance = new SmartphonePreprocessor
			}
			previousInputSet = input
			instance.setNewModel(input)
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
			val button = MD2Factory.eINSTANCE.createButton
			button.name = MD2GeneratorUtil.getName(button)
			button.text = viewAction.getTitle()
			(viewAction.eContainer as ViewFrame).elements.add(button) 
			
			// Move action bindings
			// TODO switch order of preprocessing first smartphone then general resolution of elements (here no process chains remain)
			//val wfes2 = controller.controllerElements.filter(WorkflowElement)
			//val wfe3 = wfes2.map[it.processChain.map[it.processChainSteps.map[it.view.ref]].flatten]
			val wfes = controller.controllerElements.filter(WorkflowElement).filter[it.processChain.map[it.processChainSteps.map[it.view.ref]].flatten.exists[true]]
			wfes.forEach[wfe |
				var currentAction = wfe.initActions.get(0)
				while(currentAction instanceof CombinedAction){
					currentAction = (currentAction as CombinedAction).actions.get(0)
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
				
				(currentAction as CustomAction).codeFragments.add(bindTask)
			]
			
			// TODO defaultproceed
		]
		
	}
}