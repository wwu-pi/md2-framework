package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import org.eclipse.emf.ecore.resource.ResourceSet

class SmartwatchPreprocessor extends AbstractPreprocessor {
	
	var static ResourceSet preprocessedModel;
	var static ResourceSet previousInputSet;
	/**
	 * Singleton instance of this preprocessor.
	 */
	static SmartwatchPreprocessor instance
	
	
	def static getPreprocessedModel(ResourceSet input) {
		if (!input.equals(previousInputSet)) {
			if (instance === null) {
				//initialize(new MD2ComplexElementFactory)
				instance = new SmartwatchPreprocessor
			}
			previousInputSet = input
			instance.setNewModel(input)
			println("Smartwatch preprocessing running...")
			preprocessedModel = instance.preprocessModel
		}
		return preprocessedModel
	}
	
	/**
	 * Actual preprocessing processChain.
	 */
	private def preprocessModel() {
		// Nothing to do at the moment
		
		//workingInput.resolveAll
		workingInput
	}
}