package de.wwu.md2.framework.generator.mapapps.util

import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.ContentElement
import org.eclipse.emf.ecore.EObject
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.Main

class MD2MapappsUtil {

	def static String getBundleName(WorkflowElement workflowElement)
	'''md2_wfe_«workflowElement.name»'''
	
	def static String getUploadWSPath(ContentElement elem) {
		var EObject e = elem
		while (!(e instanceof MD2Model)) {
			e = e.eContainer
		}
		val models = (e as MD2Model).eResource.contents.filter(MD2Model).toSet
		val controller = models.filter[it.modelLayer instanceof Controller].head.modelLayer as Controller
		var uri = controller.controllerElements.filter(Main).head.fileUploadConnection.uri
		
		if (!uri.endsWith("/")){
			uri = uri + "/"	
		}
		return uri
	}
}