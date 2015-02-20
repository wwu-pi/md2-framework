package de.wwu.md2.framework.generator.backend

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.generator.backend.util.MD2BackendUtil.*
import static extension de.wwu.md2.framework.util.TypeResolver.*import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.InvokeWSParam
import de.wwu.md2.framework.mD2.InvokeDefaultValue
import de.wwu.md2.framework.mD2.AbstractContentProviderPath

class ExternalWebServiceClass {
	
	def static createExternalWorkflowElementWS(String basePackageName, WorkflowElement wfe) '''
		package «basePackageName».ws.external;
				
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
		
		«FOR entity : wfe.allEntitiesWithinInvoke»
		import «basePackageName».entities.models.«entity.name.toFirstUpper»;
		«ENDFOR»
		
		import «basePackageName».Config;
		
		@Path("/«wfe.name.toFirstLower»")
		@Stateless
		public class «wfe.name.toFirstUpper»ExternalWS {
			
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
				«param.rootEntity.name.toFirstLower».set«param.field.resolveContentProviderPathAttribute.toFirstUpper»(«param.value»);
			«ENDFOR»
					return Response
						.status(404)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
			}
			«ENDFOR»			
		}
	'''
}
