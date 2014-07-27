package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.MD2ComplexElementFactory
import de.wwu.md2.framework.mD2.AutoGeneratedContentElement
import de.wwu.md2.framework.mD2.ContainerElementReference
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import java.util.Collection
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet

import static de.wwu.md2.framework.generator.preprocessor.ProcessAutoGenerator.*
import static de.wwu.md2.framework.generator.preprocessor.ProcessCommon.*
import static de.wwu.md2.framework.generator.preprocessor.ProcessController.*
import static de.wwu.md2.framework.generator.preprocessor.ProcessCustomEvents.*
import static de.wwu.md2.framework.generator.preprocessor.ProcessModel.*
import static de.wwu.md2.framework.generator.preprocessor.ProcessView.*
import static de.wwu.md2.framework.generator.preprocessor.ProcessViewReferences.*
import static de.wwu.md2.framework.generator.preprocessor.ProcessWorkflow.*
import static de.wwu.md2.framework.generator.preprocessor.util.Util.*

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

/**
 * Do a Model-to-Model transformation before the actual code generation process
 * to simplify the model.
 */
class MD2Preprocessor {
	
	/**
	 * Factory used by this preprocessor.
	 */
	private final MD2ComplexElementFactory factory = new MD2ComplexElementFactory
	
	/**
	 * Each unique input model is only generated once and stored in this class attribute.
	 */
	private static ResourceSet preprocessedModel
	
	/**
	 * A reference to the previous (unpreprocessed) resource set is stored to compare it with
	 * the current one. If they equal, the preprocessing can be skipped and the stored preprocessedModel
	 * is returned.
	 */
	private static ResourceSet previousInputSet
	
	/**
	 * Singleton instance of this preprocessor.
	 */
	private static MD2Preprocessor instance
	
	
	/**
	 * For each different model resource input, generate the preprocessed model.
	 * The preprocessed ResourceSet is stored in a class attribute, so that for each unique
	 * input model the preprocessor is only run once. Normally, for all generators the input
	 * model is the same so that this factory should be considerably faster.
	 */
	def static ResourceSet getPreprocessedModel(ResourceSet input) {
		if (!input.equals(previousInputSet)) {
			if (instance == null) {
				instance = new MD2Preprocessor
			}
			previousInputSet = input
			preprocessedModel = instance.preprocessModel(input)
		}
		return preprocessedModel
	}
	
	/**
	 * Actual preprocessing workflow.
	 */
	private def ResourceSet preprocessModel(ResourceSet input) {
		
		// Clone the model and perform all operations on the cloned model
		val workingInput = copyModel(input)
		
		
		/////////////////////////////////////////////////////////////////////////////
		//                                                                         //
		// Collections that are shared between tasks throughout the model          //
		// pre-processing workflow                                                 //
		//                                                                         //
		/////////////////////////////////////////////////////////////////////////////
		
		
		// Mapping of cloned (key) and original (value) elements
		// This is necessary to recalculate dependencies such as mappings,
		// event bindings and validator bindings after the cloning of references
		val HashMap<ViewElementType, ViewElementType> clonedElements = newHashMap()
		
		// all autogenerator elements
		val Iterable<AutoGeneratedContentElement> autoGenerators = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(AutoGeneratedContentElement))
		].flatten
		
		// All references to container elements. After cloning the actual containers,
		// the references will be removed in a last step.
		val Iterable<ContainerElementReference> containerRefs = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(ContainerElementReference))
		].flatten.toList
		
		// All references to view elements that have already been processed. After cloning the
		// actual view elements the references will be removed in a last step.
		val Collection<ViewGUIElementReference> viewRefsDone = newHashSet()
		
		// stores the original of all cloned codeFragments mapped to the original of the referenced GUI element
		// ==> that allows to check whether the cloned code fragment references a GUI element that is not child
		//     of any root view. In such cases remove the custom code fragment in another step.
		val clonedCodeFragments = newHashMap
		
		
		/////////////////////////////////////////////////////////////////////////////
		//                                                                         //
		// Preprocessing Workflow                                                  //
		//                                                                         //
		// HINT: The order of the tasks is relevant as tasks might depend on each  //
		//       other                                                             //
		//                                                                         //
		// TODO: Document (maybe enforce) pre-processing task dependencies         //
		//                                                                         //
		/////////////////////////////////////////////////////////////////////////////
		
		createModelViewAndControllerIfNotPresent(factory, workingInput) // new
		
		replaceDefaultProviderTypeWithConcreteDefinition(factory, workingInput) // new
		
		createStartUpActionAndRegisterAsOnInitializedEvent(factory, workingInput) // new
		
		createInitialGotoViewOrSetWorkflowAction(factory, workingInput) // new
		
		transformEventBindingAndUnbindingTasksToOneToOneRelations(factory, workingInput) // new
		
		calculateParameterSignatureForAllSimpleActions(factory, workingInput) // new
		
		transformWorkflowsToSequenceOfCoreLanguageElements(factory, workingInput) // new
		
		transformAllCustomEventsToBasicLanguageStructures(factory, workingInput) // new
		
		transformImplicitEnums(factory, workingInput)
		
		setFlowLayoutPaneDefaultParameters(factory, workingInput) // revisited
		
		duplicateSpacers(factory, workingInput) // refactored
		
		replaceNamedColorsWithHexColors(factory, workingInput) // revisited
		
		replaceCombinedActionWithCustomAction(factory, workingInput) // refactored
		
		createAutoGenerationAction(factory, workingInput, autoGenerators)  // refactored
		
		createViewElementsForAutoGeneratorAction(factory, workingInput, autoGenerators)
		
		cloneContainerElementReferencesIntoParentContainer(factory, workingInput, clonedElements, containerRefs)
		
		cloneViewElementReferencesIntoParentContainer(factory, workingInput, clonedElements, viewRefsDone)
		
		replaceStyleRefernces(factory, workingInput)
		
		simplifyReferencesToAbstractViewGUIElements(factory, workingInput, clonedElements)
		
		createValidatorsForModelConstraints(factory, workingInput)
		
		copyAllCustomCodeFragmentsToClonedGUIElements(factory, workingInput, clonedElements, clonedCodeFragments) // revisited
		
		removeAllCustomCodeFragmentsThatReferenceUnusedGUIElements(factory, workingInput, clonedCodeFragments) // new
		
		transformInputsWithLabelsAndTooltipsToLayouts(factory, workingInput) // new
		
		createDisableActionsForAllDisabledViewElements(factory, workingInput) // new
		
		// Remove redundant elements
		val Collection<EObject> objectsToRemove = newHashSet()
		objectsToRemove.addAll(autoGenerators)
		objectsToRemove.addAll(containerRefs)
		objectsToRemove.addAll(viewRefsDone)
		for (objRemove : objectsToRemove) {
			switch (objRemove) {
				ViewGUIElement: objRemove.remove
				ContainerElementReference: objRemove.remove
				ViewGUIElementReference: objRemove.remove				
			}
		}
		
		// after clean-up calculate all grid and element sizes and fill empty cells with spacers,
		// so that calculations are avoided during the actual generation process
		transformFlowLayoutsToGridLayouts(factory, workingInput) // new
		
		calculateNumRowsAndNumColumnsParameters(factory, workingInput) // new
		
		fillUpGridLayoutsWithSpacers(factory, workingInput) // new
		
		calculateAllViewElementWidths(factory, workingInput) // new
		
		
		// Return new ResourceSet
		workingInput.resolveAll
		workingInput
	}
	
}
