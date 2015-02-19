package de.wwu.md2.framework.generator.backend.util

import de.wwu.md2.framework.mD2.WorkflowElementimport de.wwu.md2.framework.mD2.InvokationParam
import de.wwu.md2.framework.mD2.WSParam

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.LocationProviderPath
import de.wwu.md2.framework.mD2.DefaultValue
import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.DataType
import java.util.List
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ReferencedModelType
import java.util.ArrayList

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
	
	def static dispatch List<Entity> getAllEntities(InvokationParam param){
		switch param {
				WSParam: {
					var field = param.field
					switch field {
						LocationProviderPath: throw new RuntimeException("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
						ContentProviderPath: return field.getAllEntities
					}
				}
				DefaultValue: return param.field.getAllEntities
		}
	}
	
	def static dispatch List<Entity> getAllEntities(AbstractContentProviderPath path){
		var DataType rootType = null
		switch (path) {
			LocationProviderPath: System::err.println("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
			ContentProviderPath: rootType = path.contentProviderRef.type
		}
		if (rootType != null) {
			var modelElement = (rootType as ReferencedModelType).entity
			if (modelElement == null) {
				return new ArrayList<Entity>()
			} else {
				var list = rootType.eAllContents.filter(Entity).toList
				if (modelElement as Entity != null) {
					list.add(modelElement as Entity)
				}
				return list
			}
		}
	}
}