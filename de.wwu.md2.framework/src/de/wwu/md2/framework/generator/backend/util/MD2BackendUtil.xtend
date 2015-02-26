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
/**
 * This util class offers helper methods for the MD2 backend development.
 */
class MD2BackendUtil {

	/**
	 * If set retrieve the alias; otherwise the name of the referenced attribute
	 */
	def static String getParamAlias(InvokeWSParam wsParam){
		if (wsParam.alias != null){
			return wsParam.alias
		}
		else{
			return wsParam.field.lastPathTail.getPathTailAsString
		}
	}
	
	/**
	 * Get all entities within invoke definitions of a workflow element
	 */
	def static Set<Entity> getAllEntitiesWithinInvoke(WorkflowElement wfe){
		return wfe.invoke.map[it.allEntities].flatten.toSet
	}
	
	/**
	 * Get all entities within the invoke definition
	 */
	def static dispatch Set<Entity> getAllEntities(InvokeDefinition definition){
 		return definition.params.map[it.allEntities].flatten.toSet
	}
	
	/**
	 * Get all entities within the invoke param
	 */
	def static dispatch Set<Entity> getAllEntities(InvokeParam param){
		switch param {
				InvokeWSParam:  return param.field.getAllEntities
				InvokeDefaultValue: return param.field.getAllEntities
				InvokeSetContentProvider: return param.field.getAllEntities
				default: return new HashSet<Entity>()
		}
	}
	
	/**
	 * Get the rootEntity and all nested entities within a contentProviderPath
	 */
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
	
	/**
	 * Get the rootEntity within a invoke param
	 */
	def static dispatch Entity getRootEntity(InvokeParam param){
		switch param {
				InvokeWSParam:  return param.field.rootEntity
				InvokeDefaultValue: return param.field.rootEntity
				InvokeSetContentProvider: return param.field.rootEntity
		}
	}
	
	/**
	 * Get the rootEntity within a contentProviderPath
	 */
	def static dispatch Entity getRootEntity(ContentProviderPath path){
		return (( path.contentProviderRef.type as ReferencedModelType).entity) as Entity
	}
	
	/**
	 * Get the entity referenced by a contentProviderPath
	 */
	def static Entity getContentProviderEntity(ContentProvider contentProvider){
		 var refModelType = contentProvider.type as ReferencedModelType
		 if (refModelType != null){
		 	return refModelType.entity as Entity
		 } else {
		 	return null
		 }
	}
	
	/**
	 * Get all content providers used within a invoke definition
	 */
	def static Set<ContentProvider> getAllContentProviders(InvokeDefinition definition){
		return definition.params.map[it.field.contentProvider].toSet
	}
	
	/**
	 * Get all contentProviders where a internal bean has to be used, therefore the remoteConnections of the workflowManager
	 * and the contentProvider are compared
	 */
	def static Set<ContentProvider> getInternalContentProviders(WorkflowElement wfe, RemoteConnection workflowManager){
		wfe.invoke.map[it.allContentProviders].flatten.filter[it.connection.equals(workflowManager)].toSet
	}	
	
	/**
	 * Get the contentProvider od a contentProviderPath
	 */
	def static ContentProvider getContentProvider(ContentProviderPath path){
		 return path.contentProviderRef
	}
	
	/**
	 * Get all content providers on the highest order of a invoke definition
	 */
	def static Set<ContentProvider> getRootContentProviders(InvokeDefinition definition){
		var allContentProviders = definition.allContentProviders.toSet
		var superiorCPs = definition.params.filter(InvokeSetContentProvider).map[it.field.contentProvider].toSet
		var inferiorCPs = definition.params.filter(InvokeSetContentProvider).map[it.contentProvider.contentProvider].toSet
		allContentProviders.removeAll(inferiorCPs)
		return (allContentProviders + superiorCPs).toSet
	}
	
	/**
	 * Get the java string to create the value of an invoke value
	 */
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
	
	/**
	 * Retrieve the event description if set, otherwise default
	 */
	def static String getEventDescription(WorkflowElementEntry wfeEntry){
		if (wfeEntry.eventDesc != null){
			wfeEntry.eventDesc.toString()
		} else {
			DEFAULT_INVOKE_EVENT_DESCRIPTION	
		}
	}
}