package de.wwu.md2.framework.generator.preprocessor.util

import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.View
import java.util.Set
import org.eclipse.emf.ecore.resource.ResourceSet

import static de.wwu.md2.framework.generator.preprocessor.util.Util.*

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
	 * Set of all models.
	 */
	protected static Set<Model> models
	
	/**
	 * Set of all controllers.
	 */
	protected static Set<Controller> controllers
	
	/**
	 * Set of all views.
	 */
	protected static Set<View> views
	
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
		createModelViewAndControllerIfNotPresent
	}
	
	/**
	 * Collect all controllers, models and views to avoid that they have to
	 * be recollected over and over again throughout the preprocessing process.
	 */
	private def extractModels() {
		views = newHashSet()
		controllers = newHashSet()
		models = newHashSet()
		
		val md2models = workingInput.resources.map[ r |
			r.contents.filter(MD2Model)
		].flatten
		
		md2models.forEach[ md2model |
			val modelLayer = md2model.modelLayer
			switch modelLayer {
				View : views.add(modelLayer)
				Model : models.add(modelLayer)
				Controller : controllers.add(modelLayer)
			}
		]
	}
	
	/**
	 * It might happen that there are no Controller, Model or View elements present at all if the according files are missing
	 * or if no elements are specified in the controller, model or view file. However, it is desirable that all further steps as well
	 * as the generators can rely on the fact that all of these root elements are present at least once.
	 * 
	 * Currently, the Controller, Model or View element are added to any random resource which is appropriate for the current
	 * state of MD2, but is no optimal solution when it comes to extensibility.
	 */
	private def createModelViewAndControllerIfNotPresent() {
		
		if (controllers.empty) {
			val md2model = factory.createMD2Model
			val controller = factory.createController
			md2model.setModelLayer(controller)
			workingInput.resources.head.contents.add(md2model);
		}
		
		if (models.empty) {
			val md2model = factory.createMD2Model
			val model = factory.createModel
			md2model.setModelLayer(model)
			workingInput.resources.head.contents.add(md2model);
		}
		
		if (views.empty) {
			val md2model = factory.createMD2Model
			val view = factory.createView
			md2model.setModelLayer(view)
			workingInput.resources.head.contents.add(md2model);
		}
		
	}
	
}