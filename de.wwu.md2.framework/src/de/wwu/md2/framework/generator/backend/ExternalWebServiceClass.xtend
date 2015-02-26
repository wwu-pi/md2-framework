package de.wwu.md2.framework.generator.backend

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.generator.backend.util.MD2BackendUtil.*
import static extension de.wwu.md2.framework.util.TypeResolver.*import de.wwu.md2.framework.mD2.InvokeWSParam
import de.wwu.md2.framework.mD2.InvokeDefaultValue
import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.InvokeSetContentProvider
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.RemoteConnection
import de.wwu.md2.framework.mD2.WorkflowElementEntry

class ExternalWebServiceClass {
	
	def static createExternalWorkflowElementWS(String basePackageName, WorkflowElementEntry wfeEntry, RemoteConnection workflowManager) '''
		«var wfe = wfeEntry.workflowElement»
		package «basePackageName».ws.external;
		
		«IF wfe.getInternalContentProviders(workflowManager).size>0»
		import javax.ejb.EJB;
		«ENDIF»
		import javax.ejb.Stateless;
		«FOR method: wfe.invoke.map[it.method].toSet»
		import javax.ws.rs.«method»;
		«ENDFOR»
		import javax.ws.rs.Path;
		import javax.ws.rs.FormParam;
		import javax.ws.rs.Produces;
		import javax.ws.rs.core.MediaType;
		import javax.ws.rs.core.Response;
		«IF wfe.eAllContents.filter(AbstractContentProviderPath).map[it.javaExpressionType].toSet.contains("Date")»
		import java.util.Date;
		«ENDIF»
		«FOR cp: wfe.getInternalContentProviders(workflowManager)»
		import «basePackageName».beans.«cp.contentProviderEntity.name.toFirstUpper»Bean;
		«ENDFOR»
		import CurrentStateProject.backend.beans.WorkflowStateBean;
		
		«FOR entity : wfe.allEntitiesWithinInvoke»
		import «basePackageName».entities.models.«entity.name.toFirstUpper»;
		«ENDFOR»
		
		import «basePackageName».Config;
		
		@Path("/«wfe.name.toFirstLower»")
		@Stateless
		public class «wfe.name.toFirstUpper»ExternalWS {
			
			«FOR cp: wfe.getInternalContentProviders(workflowManager)»
				«IF cp.contentProviderEntity!=null»
				@EJB
				«cp.contentProviderEntity.name.toFirstUpper»Bean «cp.contentProviderEntity.name.toFirstLower»Bean;
			«ENDIF»
			«ENDFOR»
			
			@EJB
			WorkflowStateBean workflowStateBean;
			
			«FOR invoke : wfe.invoke»
			@«invoke.method»
			«IF invoke.path != null»
			@Path("«invoke.path»")
			«ENDIF»
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response invoke(«FOR param: invoke.params.filter(InvokeWSParam) SEPARATOR ", "»@FormParam("«param.paramAlias»") «param.field.javaExpressionType» «param.paramAlias»«ENDFOR») {
				«FOR entity : invoke.allEntities»
					«entity.name.toFirstUpper» «entity.name.toFirstLower» = new «entity.name.toFirstUpper»();
				«ENDFOR»
				«FOR param: invoke.params.filter(InvokeWSParam)»
					«param.rootEntity.name.toFirstLower».set«param.field.resolveContentProviderPathAttribute.toFirstUpper»(«param.paramAlias»);
				«ENDFOR»
				«FOR param: invoke.params.filter(InvokeDefaultValue)»
					«param.rootEntity.name.toFirstLower».set«param.field.resolveContentProviderPathAttribute.toFirstUpper»(«param.invokeValue.stringValue»);
				«ENDFOR»
				«FOR param: invoke.params.filter(InvokeSetContentProvider)»
					«createSaveContentProvider(param.contentProvider.contentProvider, workflowManager)»
					«param.rootEntity.name.toFirstLower».set«param.field.resolveContentProviderPathAttribute.toFirstUpper»(«param.contentProvider.contentProvider.contentProviderEntity.name.toFirstLower»);
				«ENDFOR»
				«FOR cp: invoke.rootContentProviders»
					«createSaveContentProvider(cp, workflowManager)»
				«ENDFOR»
				
				String id = java.util.UUID.randomUUID().toString();
				
				«IF invoke.allContentProviders.size>0»
				String contentProviderIds = "{"+
				«FOR cp:invoke.allContentProviders SEPARATOR",\"+"»"\"«cp.name.toFirstLower»\":"+«cp.contentProviderEntity.name.toFirstLower».getInternal__id()+"«ENDFOR»}";
				«ELSE»
				String contentProviderIds = "{}";
				«ENDIF»
				
				workflowStateBean.createOrUpdateWorkflowState("«wfeEntry.eventDescription»",id,"«wfeEntry.eventDescription»",contentProviderIds);
				
				return Response
					.status(404)
					.header("MD2-Model-Version", Config.MODEL_VERSION)
					.build();
			}
			«ENDFOR»			
		}
	'''
	
	def static createSaveContentProvider(ContentProvider contentProvider, RemoteConnection backendConnection)'''
		«var entity =contentProvider.contentProviderEntity»
		«IF contentProvider.connection.equals(backendConnection) && entity != null »
		«entity.name.toFirstLower» = «entity.name.toFirstLower»Bean.createOrUpdate«entity.name.toFirstUpper»(«entity.name.toFirstLower»);
		«ENDIF»
	'''
}
