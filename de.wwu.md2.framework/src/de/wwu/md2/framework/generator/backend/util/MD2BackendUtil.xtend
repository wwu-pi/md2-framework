package de.wwu.md2.framework.generator.backend.util

import de.wwu.md2.framework.mD2.WorkflowElementimport de.wwu.md2.framework.mD2.InvokationParam
import de.wwu.md2.framework.mD2.WSParam

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.LocationProviderPath

class MD2BackendUtil {

	def static String getParamAlias(WSParam wsParam){
		if (wsParam.alias != null){
			return wsParam.alias
		}
		else{
		val attributePath = wsParam.field
			switch attributePath {
				LocationProviderPath: return attributePath.locationField.toString
				ContentProviderPath: return attributePath.lastPathTail.getPathTailAsString
				}
		}
	}
}