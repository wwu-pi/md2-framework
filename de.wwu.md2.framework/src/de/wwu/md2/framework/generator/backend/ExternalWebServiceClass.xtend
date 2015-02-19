package de.wwu.md2.framework.generator.backend

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.TypeResolver.*import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.WSParam

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
			public Response invoke(«FOR param: invoke.params.filter(WSParam) SEPARATOR ","»@FormParam("«param.alias»") «param.field.javaExpressionType» «param.alias»«ENDFOR») {

					return Response
						.status(404)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
			}
			«ENDFOR»			
		}
	'''
}
