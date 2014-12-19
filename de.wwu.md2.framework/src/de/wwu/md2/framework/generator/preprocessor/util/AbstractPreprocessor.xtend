package de.wwu.md2.framework.generator.preprocessor.util

import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.View
import org.eclipse.emf.ecore.resource.ResourceSet

import static de.wwu.md2.framework.generator.preprocessor.util.Util.*
import static extension org.eclipse.emf.ecore.util.EcoreUtil.*import de.wwu.md2.framework.mD2.Workflow

abstract class AbstractPreprocessor {
	
	private static boolean isInitialized = false;
	
	/**
	 * The cloned working set.
	 */
	protected static ResourceSet workingInput
	
	/**
	 * The element factory to be used.
	 */
	protected static MD2ComplexElementFactory factory
	
	/**
	 * Model containing modelElements of all modelLayers of type Model.
	 */
	protected static Model model
	
	/**
	 * Controller containing controllerElements of all modelLayers of type Controller.
	 */
	protected static Controller controller
	
	/**
	 * Workflow containing workflowElementEntries and apps of all modelLayers of type Workflow.
	 */
	protected static Workflow workflow
	
	/**
	 * View containing viewElements of all modelLayers of type View.
	 */
	protected static View view
	
	/**
	 * Constructor ensures that the model was initialized.
	 */
	new() {
		if (!isInitialized) {
			throw new Error("The preprocessor has not been initialized yet!")
		}
	}
	
	/**
	 * Initialize the preprocessor with the factory to be used to generate new model
	 * elements. Only after initializing new instances of the preprocessor can be created.
	 */
	def static initialize(MD2ComplexElementFactory md2Factory) {
		factory = md2Factory;
		isInitialized = true;
	}
	
	/**
	 * Clone the model and perform all operations on the cloned model. Then collect all controllers,
	 * models and views to avoid that they have to be recollected over and over again throughout the
	 * preprocessing process. If any of the collections of model elements is empty, it is populated with
	 * a controller, model or view respectively to ensure that each model element is present throughout
	 * the preprocessing as well as in the preprocessed model.
	 */
	def setNewModel(ResourceSet input) {
		workingInput = copyModel(input)
		extractModels
		removeEmptyResources
	}
	
	/**
	 * Collect all controllers, models, workfloes and views and reunite all of their contents to one single model with the respective modelLayer. 
	 * This is done to avoid that they have to be recollected over and over again throughout the preprocessing process.
	 */
	private def extractModels() {

		// Save current md2models
		val md2models = workingInput.resources.map [ r |
			r.contents.filter(MD2Model)
		].flatten.toList

		// Initialize new dummy models
		initializeModels

		// Add resources to dummy model
		md2models.forEach [ md2model |
			val modelLayer = md2model.modelLayer
			switch modelLayer {
				View: {
					view.viewElements += modelLayer.viewElements
					if((view.eContainer as MD2Model).package == null) (view.eContainer as MD2Model).package = md2model.
						package
				}
				Model: {
					model.modelElements += modelLayer.modelElements
					if((model.eContainer as MD2Model).package == null) (model.eContainer as MD2Model).package = md2model.
						package
				}
				Controller: {
					controller.controllerElements += modelLayer.controllerElements
					if((controller.eContainer as MD2Model).package == null) (controller.eContainer as MD2Model).package = md2model.
						package
				}
				Workflow: {
					workflow.workflowElementEntries += modelLayer.workflowElementEntries
					workflow.apps += modelLayer.apps
					if((workflow.eContainer as MD2Model).package == null) (workflow.eContainer as MD2Model).package = md2model.
						package
				}
			}
		]

		// In the end remove the former models, since they are completely represented by the dummy models
		while (md2models.size > 0) {
			md2models.head.remove
			md2models.remove(md2models.head)
		}

	}
	
	/**
	 * It might happen that there are no Controller, Model, Workflow or View elements present at all if the according files are missing
	 * or if no elements are specified in the controller, model, workflow or view file. However, it is desirable that all further steps as well
	 * as the generators can rely on the fact that all of these root elements are present.
	 * 
	 * In this step, dummy models are generated to which all resources of modelLayers of the same type are added later on.
	 * 
	 * Currently, the Controller, Model or View element are added to any random resource which is appropriate for the current
	 * state of MD2, but is no optimal solution when it comes to extensibility.
	 */	
	private def initializeModels() {
		val md2modelController = factory.createMD2Model
		controller = factory.createController
		md2modelController.setModelLayer(controller)
		workingInput.resources.head.contents.add(md2modelController)
	
		val md2modelModel = factory.createMD2Model
		model = factory.createModel
		md2modelModel.setModelLayer(model)
		workingInput.resources.head.contents.add(md2modelModel)
	
		val md2modelView = factory.createMD2Model
		view = factory.createView
		md2modelView.setModelLayer(view)
		workingInput.resources.head.contents.add(md2modelView)
	
		val md2modelWorkflow = factory.createMD2Model
		workflow = factory.createWorkflow
		md2modelWorkflow.setModelLayer(workflow)
		workingInput.resources.head.contents.add(md2modelWorkflow)
	}
	
	
	/**
	 * Remove resources that don't contain any content.
	 */
	private def removeEmptyResources(){
		val resourcesToBeDeleted = newHashSet
		workingInput.resources.forEach[res| 
			if (res.contents.size == 0) {
				resourcesToBeDeleted.add(res)
			}
		]
		resourcesToBeDeleted.forEach[res |
			workingInput.resources.remove(res)
		]
	}
	
}