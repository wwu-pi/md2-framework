package de.wwu.md2.framework.generator.mapapps.util

import de.wwu.md2.framework.mD2.WorkflowElement

class MD2MapappsUtil {

	def static String getBundleName(WorkflowElement workflowElement)
	'''md2_wfe_«workflowElement.name»'''
}