package de.wwu.md2.framework.generator.backend

import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.RemoteValidator
import java.util.Collection

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

import static extension de.wwu.md2.framework.util.IterableExtensions.*

class WebServiceClass {
	
	def static createEntityWS(String basePackageName, Entity entity) '''
		package «basePackageName».ws;
		
		import java.util.ArrayList;
		import java.util.List;
		
		import javax.ejb.EJB;
		import javax.ejb.Stateless;
		import javax.ws.rs.Consumes;
		import javax.ws.rs.DELETE;
		import javax.ws.rs.GET;
		import javax.ws.rs.PUT;
		import javax.ws.rs.Path;
		import javax.ws.rs.PathParam;
		import javax.ws.rs.Produces;
		import javax.ws.rs.QueryParam;
		import javax.ws.rs.core.GenericEntity;
		import javax.ws.rs.core.MediaType;
		import javax.ws.rs.core.Response;
		
		import «basePackageName».Config;
		import «basePackageName».beans.«entity.name.toFirstUpper»Bean;
		import «basePackageName».datatypes.InternalIdWrapper;
		import «basePackageName».models.«entity.name.toFirstUpper»;
		
		@Path("/«entity.name.toFirstLower»")
		@Stateless
		public class «entity.name.toFirstUpper»WS {
			
			@EJB
			«entity.name.toFirstUpper»Bean «entity.name.toFirstLower»Bean;
			
			@GET
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response jsonGetAll(@QueryParam("filter") final String filter) {
				final GenericEntity<List<«entity.name.toFirstUpper»>> «entity.name.toFirstLower»s = new GenericEntity<List<«entity.name.toFirstUpper»>>(«entity.name.toFirstLower»Bean.getAll«entity.name.toFirstUpper»s(filter)) {};
				Response response = Response
						.ok()
						.entity(«entity.name.toFirstLower»s)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				return response;
			}
			
			@GET
			@Path("/first")
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response jsonGetFirst(@QueryParam("filter") final String filter) {
				final «entity.name.toFirstUpper» «entity.name.toFirstLower» = «entity.name.toFirstLower»Bean.getFirst«entity.name.toFirstUpper»(filter);
				final List<«entity.name.toFirstUpper»> «entity.name.toFirstLower»List = new ArrayList<«entity.name.toFirstUpper»>();
				«entity.name.toFirstLower»List.add(«entity.name.toFirstLower»);
				final GenericEntity<List<«entity.name.toFirstUpper»>> «entity.name.toFirstLower»Entity = new GenericEntity<List<«entity.name.toFirstUpper»>>(«entity.name.toFirstLower»List) {};
				Response response;
				
				if(«entity.name.toFirstLower» != null) {
					response = Response
						.ok()
						.entity(«entity.name.toFirstLower»Entity)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				} else {
					response = Response
						.status(404)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				}
				
				return response;
			}
			
			@PUT
			@Consumes(MediaType.APPLICATION_JSON)
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response jsonPut(List<«entity.name.toFirstUpper»> «entity.name.toFirstLower»s) {
				final GenericEntity<List<InternalIdWrapper>> ids = new GenericEntity<List<InternalIdWrapper>>(«entity.name.toFirstLower»Bean.put«entity.name.toFirstUpper»s(«entity.name.toFirstLower»s)) {};
				Response response = Response
						.ok()
						.entity(ids)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				return response;
			}
			
			@DELETE
			@Path("{id}")
			public Response jsonDelete(@PathParam("id") String id) {
				Response response;
				
				if(«entity.name.toFirstLower»Bean.delete«entity.name.toFirstUpper»(id)) {
					response = Response
						.noContent()
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				} else {
					response = Response
						.status(404)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				}
				
				return response;
			}
			
		}
	'''
	
	def static createVersionNegotiationWS(String basePackageName) '''
		package «basePackageName».ws;
		
		import javax.ejb.Stateless;
		import javax.ws.rs.GET;
		import javax.ws.rs.Path;
		import javax.ws.rs.Produces;
		import javax.ws.rs.QueryParam;
		import javax.ws.rs.core.GenericEntity;
		import javax.ws.rs.core.MediaType;
		import javax.ws.rs.core.Response;
		
		import «basePackageName».Config;
		import «basePackageName».datatypes.IsValidWrapper;
		
		@Path("/md2_model_version")
		@Stateless
		public class VersionNegotiationWS {
			
			/**
			 * WS that provides the current backend model version.
			 */
			@GET
			@Path(value = "current")
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response jsonGetModelVersion() {
				final GenericEntity<String> entity = new GenericEntity<String>(Config.MODEL_VERSION) {};
				Response response = Response
						.ok()
						.entity(entity)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				return response;
			}
			
			/**
			 * WS checks whether the requested model version is supported by the backend (returns true or false).
			 * @param version String representation of the requested version.
			 */
			@GET
			@Path(value = "is_valid")
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response jsonGetSupportsModelVersion(@QueryParam("version") final String version) {
				final IsValidWrapper entity = new IsValidWrapper(Config.SUPPORTED_MODEL_VERSIONS.contains(version));
				Response response = Response
						.ok()
						.entity(entity)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				return response;
			}
			
		}
	'''
	
	def static createRemoteValidationWS(String basePackageName, Collection<ModelElement> affectedEntities, Collection<RemoteValidator> remoteValidators) '''
		package «basePackageName».ws;
		
		import javax.ejb.EJB;
		import javax.ejb.Stateless;
		import javax.ws.rs.Consumes;
		import javax.ws.rs.GET;
		import javax.ws.rs.Path;
		import javax.ws.rs.Produces;
		import javax.ws.rs.QueryParam;
		import javax.ws.rs.core.MediaType;
		import javax.ws.rs.core.Response;
		
		import «basePackageName».Config;
		import «basePackageName».beans.RemoteValidationBean;
		import «basePackageName».datatypes.ValidationResult;
		«FOR entity : affectedEntities»
			import «basePackageName».models.«entity.name.toFirstUpper»;
		«ENDFOR»
		
		@Path("/md2_validator")
		@Stateless
		public class RemoteValidationWS {
			
			@EJB
			RemoteValidationBean validatorBean;
			
			«FOR validator : remoteValidators»
				«IF validator.contentProvider != null && validator.contentProvider.contentProvider.type instanceof ReferencedModelType»
					@GET
					@Path(value = "«validator.name.toFirstLower»")
					@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
					@Consumes(MediaType.APPLICATION_JSON)
					public Response json«validator.name.toFirstUpper»(«(validator.contentProvider.contentProvider.type as ReferencedModelType).entity.name.toFirstUpper» «(validator.contentProvider.contentProvider.type as ReferencedModelType).entity.name.toFirstLower») {
						
						ValidationResult result = validatorBean.validate«validator.name.toFirstUpper»(«(validator.contentProvider.contentProvider.type as ReferencedModelType).entity.name.toFirstLower»);
						
						Response response = Response
								.ok()
								.entity(result)
								.header("MD2-Model-Version", Config.MODEL_VERSION)
								.build();
						return response;
					}
					
				«ELSE /* based on attributes */»
					@GET
					@Path(value = "«validator.name.toFirstLower»")
					@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
					public Response json«validator.name.toFirstUpper»(
							«validator.provideAttributes.joinWithIdx("", "," + System::getProperty("line.separator"), "", [p, i | '''@QueryParam("«p.contentProviderRef.name + "." + getPathTailAsString(p.tail)»") final String param«i + 1»'''])») {
						
						ValidationResult result = validatorBean.validate«validator.name.toFirstUpper»(«validator.provideAttributes.joinWithIdx("", ", ", "", [s, i | '''param«i + 1»'''])»);
						
						Response response = Response
								.ok()
								.entity(result)
								.header("MD2-Model-Version", Config.MODEL_VERSION)
								.build();
						return response;
					}
					
				«ENDIF»
			«ENDFOR»
		}
	'''
}
