package de.wwu.md2.framework.generator.backend.util

import de.wwu.md2.framework.mD2.WorkflowElementimport de.wwu.md2.framework.mD2.InvokeParam
import de.wwu.md2.framework.mD2.InvokeWSParam

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.LocationProviderPath
import de.wwu.md2.framework.mD2.InvokeDefaultValue
import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.DataType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.InvokeDefinition
import static extension de.wwu.md2.framework.util.TypeResolver.*
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.DateTimeType
import java.util.Set
import java.util.HashSet
import de.wwu.md2.framework.mD2.InvokeSetContentProvider
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.RemoteConnection

class MD2BackendUtil {

	def static String getParamAlias(InvokeWSParam wsParam){
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
	
	def static Set<Entity> getAllEntitiesWithinInvoke(WorkflowElement wfe){
		return wfe.invoke.map[it.allEntities].flatten.toSet
	}
	
	def static dispatch Set<Entity> getAllEntities(InvokeDefinition definition){
 		return definition.params.map[it.allEntities].flatten.toSet
	}
	
	def static dispatch Set<Entity> getAllEntities(InvokeParam param){
		switch param {
				InvokeWSParam: {
					var field = param.field
					switch field {
						LocationProviderPath: throw new RuntimeException("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
						ContentProviderPath: return field.getAllEntities
					}
				}
				InvokeDefaultValue: return param.field.getAllEntities
				InvokeSetContentProvider: return param.field.getAllEntities
				default: return new HashSet<Entity>()
		}
	}
	
	def static dispatch Set<Entity> getAllEntities(AbstractContentProviderPath path){
		var DataType rootType = null
		switch (path) {
			LocationProviderPath: throw new RuntimeException("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
			ContentProviderPath: rootType = path.contentProviderRef.type
		}
		if (rootType != null) {
			var modelElement = (rootType as ReferencedModelType).entity
			if (modelElement == null) {
				return new HashSet<Entity>()
			} else {
				var list = rootType.eAllContents.filter(Entity).toSet
				if (modelElement as Entity != null) {
					list.add(modelElement as Entity)
				}
				return list
			}
		}
	}
	
	def static dispatch Entity getRootEntity(InvokeParam param){
		switch param {
				InvokeWSParam: {
					var field = param.field
					switch field {
						LocationProviderPath: throw new RuntimeException("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
						ContentProviderPath: return field.rootEntity
					}
				}
				InvokeDefaultValue: return param.field.rootEntity
				InvokeSetContentProvider: {
					var field = param.field
					switch field {
						LocationProviderPath: throw new RuntimeException("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
						ContentProviderPath: return field.rootEntity
					}
				}
		}
	}
	
	def static dispatch Entity getRootEntity(AbstractContentProviderPath path){
		switch (path) {
			LocationProviderPath: throw new RuntimeException("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
			ContentProviderPath: return (( path.contentProviderRef.type as ReferencedModelType).entity) as Entity
		}
	}
	
	def static Entity getContentProviderEntity(ContentProvider contentProvider){
		 var refModelType = contentProvider.type as ReferencedModelType
		 if (refModelType != null){
		 	return refModelType.entity as Entity
		 } else {
		 	return null
		 }
	}
	
	def static Set<ContentProvider> getAllContentProviders(InvokeDefinition definition){
		return definition.params.map[it.field.contentProvider].toSet
	}
	
	def static Set<ContentProvider> getInternalContentProviders(WorkflowElement wfe, RemoteConnection workflowManager){
		wfe.invoke.map[it.allContentProviders].flatten.filter[it.connection.equals(workflowManager)].toSet
	}
	
	def static Set<ContentProvider> getExternalContentProviders(WorkflowElement wfe, RemoteConnection workflowManager){
		wfe.invoke.map[it.allContentProviders].flatten.filter[!it.connection.equals(workflowManager)].toSet
	}
	
	
	def static ContentProvider getContentProvider(AbstractContentProviderPath path){
		switch (path) {
			LocationProviderPath: throw new RuntimeException("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
			ContentProviderPath: return path.contentProviderRef
			}
	}
	
	def static Set<ContentProvider> getRootContentProviders(InvokeDefinition definition){
		var allContentProviders = definition.allContentProviders.toSet
		var superiorCPs = definition.params.filter(InvokeSetContentProvider).map[it.field.contentProvider].toSet
		var inferiorCPs = definition.params.filter(InvokeSetContentProvider).map[it.contentProvider.contentProvider].toSet
		allContentProviders.removeAll(inferiorCPs)
		return (allContentProviders + superiorCPs).toSet
	}
	
	def static String getValue(InvokeDefaultValue value){
		var path = value.field
		switch (path) {
			LocationProviderPath: throw new RuntimeException("LocationProviderPath is not allowed within this webservice since it provides a readonly attribute")
			ContentProviderPath: {
				var type = path.tail.resolveAttribute
				switch (type){
					IntegerType: value.intValue+""
					FloatType: value.floatValue+""
					StringType: '''"«value.stringValue»"'''
					BooleanType: value.booleanValue.literal
					DateType: '''new Date(«value.dateValue.time»L)'''
					TimeType: '''new Date(«value.timeValue.time»L)'''
					DateTimeType: '''new Date(«value.datetimeValue.time»L)'''
				}
			}
		}
	}
}