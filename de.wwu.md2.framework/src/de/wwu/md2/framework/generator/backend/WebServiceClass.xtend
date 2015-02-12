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
		
		import java.util.List;
		
		import javax.ejb.EJB;
		import javax.ejb.Stateless;
		import javax.ws.rs.Consumes;
		import javax.ws.rs.DELETE;
		import javax.ws.rs.GET;
		import javax.ws.rs.POST;
		import javax.ws.rs.Path;
		import javax.ws.rs.PathParam;
		import javax.ws.rs.FormParam;
		import javax.ws.rs.Produces;
		import javax.ws.rs.QueryParam;
		import javax.ws.rs.core.GenericEntity;
		import javax.ws.rs.core.MediaType;
		import javax.ws.rs.core.Response;
		
		import «basePackageName».Config;
		import «basePackageName».beans.«entity.name.toFirstUpper»Bean;
		import «basePackageName».datatypes.InternalIdWrapper;
		import «basePackageName».entities.models.«entity.name.toFirstUpper»;
		
		@Path("/«entity.name.toFirstLower»")
		@Stateless
		public class «entity.name.toFirstUpper»WS {
			
			@EJB
			«entity.name.toFirstUpper»Bean «entity.name.toFirstLower»Bean;
			
			@GET
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response getAll(@QueryParam("filter") final String filter, @QueryParam("limit") final int limit) {
				final GenericEntity<List<«entity.name.toFirstUpper»>> «entity.name.toFirstLower»s =
						new GenericEntity<List<«entity.name.toFirstUpper»>>(«entity.name.toFirstLower»Bean.getAll«entity.name.toFirstUpper»s(filter, limit)) {};
				return Response
						.ok()
						.entity(«entity.name.toFirstLower»s)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
			}
			
			@GET
			@Path("{id}")
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response get(@PathParam("id") Integer id) {
				final «entity.name.toFirstUpper» «entity.name.toFirstLower» = «entity.name.toFirstLower»Bean.get«entity.name.toFirstUpper»(id);
				
				if («entity.name.toFirstLower» != null) {
					return Response
						.ok()
						.entity(new GenericEntity<«entity.name.toFirstUpper»>(«entity.name.toFirstLower») {})
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				} else {
					return Response
						.status(404)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				}
		
			}
			
			/**
			* Possibly needs to be extended by a filter parameter
			*/
			@POST
			@Path("ids")
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response get(@FormParam("ids") List<Integer> ids) {
				final List<«entity.name.toFirstUpper»> «entity.name.toFirstLower»s = «entity.name.toFirstLower»Bean.get«entity.name.toFirstUpper»s(ids);
				
				return Response
						.ok()
						.entity(«entity.name.toFirstLower»s)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
			}
			
			/**
			 * Exemplary input format:
			 * [
			 *   {
			 *	   "firstName": "John",
			 *	   "lastName": "Doe",
			 *	   "customerId": "2443232",
			 *     "dateOfBirth": "1954-07-18"
			 *   }
			 * ]
			 */
			@POST
			@Consumes(MediaType.APPLICATION_JSON)
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response createOrUpdate(List<«entity.name.toFirstUpper»> «entity.name.toFirstLower»s) {
				final GenericEntity<List<InternalIdWrapper>> ids =
						new GenericEntity<List<InternalIdWrapper>>(«entity.name.toFirstLower»Bean.createOrUpdate«entity.name.toFirstUpper»s(«entity.name.toFirstLower»s)) {};
				return Response
						.ok()
						.entity(ids)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
			}
			
			@DELETE
			public Response delete(@QueryParam("id") List<Integer> ids) {
				if («entity.name.toFirstLower»Bean.delete«entity.name.toFirstUpper»s(ids)) {
					return Response
						.noContent()
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				} else {
					return Response
						.status(409)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				}
			}
			
			/**
			 * Workaround for ESRI proxy that forwards DELETE requests as GET requests!
			 */
			@GET
			@Path("delete")
			public Response deleteWithGet(@QueryParam("id") List<Integer> ids) {
				return delete(ids);
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
			import «basePackageName».entities.models.«entity.name.toFirstUpper»;
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
	
	def public static createEventHandlerWS(String basePackage) '''
		package «basePackage».ws;
		
		import javax.ejb.EJB;
		import javax.ejb.Stateless;
		import javax.ws.rs.FormParam;
		import javax.ws.rs.POST;
		import javax.ws.rs.Path;
		import javax.ws.rs.Produces;
		import javax.ws.rs.core.MediaType;
		import javax.ws.rs.core.Response;
		
		import «basePackage».Config;
		import «basePackage».beans.WorkflowStateBean;
		
		@Path("/eventHandler")
		@Stateless
		public class EventHandlerWS {
			
			@EJB
			WorkflowStateBean workflowStateBean;
			
		
			
			/**
			 * Receives workflowInstanceId, lastEventFired and the current workflowElement and starts their persistence.
			 */
			
			@POST
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response createOrUpdate(@FormParam("instanceId") String id, @FormParam("lastEventFired") String event,
					@FormParam("currentWfe") String wfe, @FormParam("contentProviderIds") String contentProviderIds) {
		
				workflowStateBean.createOrUpdateWorkflowState(event, id, wfe, contentProviderIds);
						
				return Response
						.ok()
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
			}
		}
	'''
	
	def public static createWorkflowStateWS(String basePackage) '''
		package «basePackage».ws;
		
		import java.util.ArrayList;
		import java.util.List;
		
		import javax.ejb.EJB;
		import javax.ejb.Stateless;
		import javax.ws.rs.GET;
		import javax.ws.rs.Path;
		import javax.ws.rs.PathParam;
		import javax.ws.rs.Produces;
		import javax.ws.rs.QueryParam;
		import javax.ws.rs.core.GenericEntity;
		import javax.ws.rs.core.MediaType;
		import javax.ws.rs.core.Response;
		
		import «basePackage».Config;
		import «basePackage».beans.WorkflowStateBean;
		import «basePackage».entities.WorkflowState;
		
		@Path("/workflowState")
		@Stateless
		public class WorkflowStateWS {
			
			@EJB
			WorkflowStateBean workflowStateBean;
			
			/**
			 * 
			 * @return all open issues
			 */
			@GET
			@Path("all")
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response getAllOpenIssues() {
				
				final List<WorkflowState> workflowStates =
						new ArrayList<WorkflowState>(workflowStateBean.getAllWorkflowStates(""));
					
						
				return Response
						.ok()
						.entity(workflowStates)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
			}
			
			@GET
			@Path("filteredOpenIssues")
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response getFilteredOpenIssues(@QueryParam("app") String app) {
				
				final List<WorkflowState> workflowStates =
						new ArrayList<WorkflowState>(workflowStateBean.getAllWorkflowStates(app));
					
						
				return Response
						.ok()
						.entity(workflowStates)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
			}
			
			@GET
			@Path("{id}")
			@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
			public Response get(@PathParam("id") String id) {
				final WorkflowState workflowState = workflowStateBean.getWorkflowState(id);
				
				if (workflowState != null) {
					return Response
						.ok()
						.entity(new GenericEntity<WorkflowState>(workflowState) {})
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				} else {
					return Response
						.status(404)
						.header("MD2-Model-Version", Config.MODEL_VERSION)
						.build();
				}
			}
			
		}
	'''
}
