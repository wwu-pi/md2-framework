package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.View
import org.eclipse.emf.ecore.resource.ResourceSet

class ProcessCommon {
	
	/**
	 * It might happen that there are no Controller, Model or View elements present at all if the according files are missing
	 * or if no elements are specified in the controller, model or view file. However, it is desirable that all further steps as well
	 * as the generators can rely on the fact that all of these root elements are present at least once.
	 * 
	 * Currently, the Controller, Model or View element are added to any random resource which is appropriate for the current
	 * state of MD2, but is no optimal solution when it comes to extensibility.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def static void createModelViewAndControllerIfNotPresent(MD2Factory factory, ResourceSet workingInput) {
		
		val md2models = workingInput.resources.map[ r |
			r.contents.filter(typeof(MD2Model))
		].flatten
		
		if (!md2models.exists(m | m.modelLayer instanceof Controller)) {
			val md2model = factory.createMD2Model
			val controller = factory.createController
			md2model.setModelLayer(controller)
			workingInput.resources.head.contents.add(md2model);
		}
		
		if (!md2models.exists(m | m.modelLayer instanceof Model)) {
			val md2model = factory.createMD2Model
			val model = factory.createModel
			md2model.setModelLayer(model)
			workingInput.resources.head.contents.add(md2model);
		}
		
		if (!md2models.exists(m | m.modelLayer instanceof View)) {
			val md2model = factory.createMD2Model
			val view = factory.createView
			md2model.setModelLayer(view)
			workingInput.resources.head.contents.add(md2model);
		}
		
	}
	
}