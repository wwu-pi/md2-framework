package de.wwu.md2.framework.generator.backend.util

import de.wwu.md2.framework.mD2.WorkflowElementimport de.wwu.md2.framework.mD2.InvokeParam
import de.wwu.md2.framework.mD2.InvokeWSParam

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.InvokeDefaultValue
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.InvokeDefinition
import java.util.Set
import java.util.HashSet
import de.wwu.md2.framework.mD2.InvokeSetContentProvider
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.RemoteConnection
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.InvokeIntValue
import de.wwu.md2.framework.mD2.InvokeFloatValue
import de.wwu.md2.framework.mD2.InvokeStringValue
import de.wwu.md2.framework.mD2.InvokeBooleanValue
import de.wwu.md2.framework.mD2.InvokeDateValue
import de.wwu.md2.framework.mD2.InvokeDateTimeValue
import de.wwu.md2.framework.mD2.InvokeTimeValue
import de.wwu.md2.framework.mD2.InvokeValue

class MD2BackendUtil {

	def static String getParamAlias(InvokeWSParam wsParam){
		if (wsParam.alias != null){
			return wsParam.alias
		}
		else{
			return wsParam.field.lastPathTail.getPathTailAsString
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
				InvokeWSParam:  return param.field.getAllEntities
				InvokeDefaultValue: return param.field.getAllEntities
				InvokeSetContentProvider: return param.field.getAllEntities
				default: return new HashSet<Entity>()
		}
	}
	
	def static dispatch Set<Entity> getAllEntities(ContentProviderPath path){
		var rootType = path.contentProviderRef.type
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
				InvokeWSParam:  return param.field.rootEntity
				InvokeDefaultValue: return param.field.rootEntity
				InvokeSetContentProvider: return param.field.rootEntity
		}
	}
	
	def static dispatch Entity getRootEntity(ContentProviderPath path){
		return (( path.contentProviderRef.type as ReferencedModelType).entity) as Entity
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
	
	
	def static ContentProvider getContentProvider(ContentProviderPath path){
		 return path.contentProviderRef
	}
	
	def static Set<ContentProvider> getRootContentProviders(InvokeDefinition definition){
		var allContentProviders = definition.allContentProviders.toSet
		var superiorCPs = definition.params.filter(InvokeSetContentProvider).map[it.field.contentProvider].toSet
		var inferiorCPs = definition.params.filter(InvokeSetContentProvider).map[it.contentProvider.contentProvider].toSet
		allContentProviders.removeAll(inferiorCPs)
		return (allContentProviders + superiorCPs).toSet
	}
	
	def static String getStringValue(InvokeValue invokeValue){
		switch (invokeValue){
			InvokeIntValue: invokeValue.value+""
			InvokeFloatValue: invokeValue.value+""
			InvokeStringValue: '''"«invokeValue.value»"'''
			InvokeBooleanValue: invokeValue.value.literal
			InvokeDateValue: '''new Date(«invokeValue.value.time»L)'''
			InvokeTimeValue: '''new Date(«invokeValue.value.time»L)'''
			InvokeDateTimeValue: '''new Date(«invokeValue.value.time»L)'''
		}
	}
	
	private static final String DEFAULT_INVOKE_EVENT_DESCRIPTION = "__invokedByWS"
	
	def static String getEventDescription(WorkflowElementEntry wfeEntry){
		if (wfeEntry.eventDesc != null){
			wfeEntry.eventDesc.toString()
		} else {
			DEFAULT_INVOKE_EVENT_DESCRIPTION	
		}
	}
}