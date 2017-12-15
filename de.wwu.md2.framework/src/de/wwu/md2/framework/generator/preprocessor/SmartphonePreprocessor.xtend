package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.ViewFrame
import org.eclipse.emf.ecore.resource.ResourceSet

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

class SmartphonePreprocessor extends AbstractPreprocessor {
	
	var static ResourceSet preprocessedModel;
	var static ResourceSet previousInputSet;
	/**
	 * Singleton instance of this preprocessor.
	 */
	private static SmartphonePreprocessor instance
	
	
	def static getPreprocessedModel(ResourceSet input) {
		if (!input.equals(previousInputSet)) {
			if (instance == null) {
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
		]
		
	}
}