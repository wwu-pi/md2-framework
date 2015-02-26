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
	
	def public static createCallExternalWSProxy(String basePackage) '''
		package «basePackage».ws;
		
		import org.json.simple.JSONValue;
		
		import java.io.BufferedReader;
		import java.io.IOException;
		import java.io.InputStreamReader;
		import java.io.OutputStream;
		import java.net.HttpURLConnection;
		import java.net.MalformedURLException;
		import java.net.URL;
		import java.util.HashMap;
		import java.util.Map.Entry;
		import java.util.logging.Logger;
		
		import javax.ejb.Stateless;
		import javax.ws.rs.Consumes;
		import javax.ws.rs.POST;
		import javax.ws.rs.Path;
		import javax.ws.rs.Produces;
		import javax.ws.rs.core.MediaType;
		import javax.ws.rs.core.Response;
		
		import «basePackage».Config;
		import «basePackage».entities.RequestDTO;
		import «basePackage».entities.RequestDTO.RequestMethod;
		
		@Path("/externalWS")
		@Stateless
		public class CallExternalWebServiceWS {
		
			private final static Logger LOGGER = Logger.getLogger(CallExternalWebServiceWS.class.getName());
		
		/**
		 * Receives a json-encoded object containing a url, a REST method type and a set of parameters.
		 * Based on this data, a new request is created.
		 * @param dto contains the request data.
		 * @return A response signaling success or failure of the request.
		 */
		@POST
		@Path("/callExternalWS")
		@Consumes(MediaType.APPLICATION_JSON)
		@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
		public Response getMethod(RequestDTO dto) {
			Boolean responseOk = false;
			int code = 0;
			try {
				URL url;
				RequestMethod type = dto.getRequestMethod();
				
				// Add query parameters to URL
				if(dto.getQueryParams() != null){
					String urlParams = buildUrlParameters(dto.getQueryParams());
					url = new URL(dto.getUrl() + urlParams);
				} else {
					url = new URL(dto.getUrl());
				}
		
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod(type.toString());
			
			if(type != RequestMethod.GET){
			// Only support JSON-encoded body data
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setDoOutput(true);
			
			// JSON-encode body content
			if(dto.getBody() != null){
				String postParams = JSONValue.toJSONString(dto.getBody());
				OutputStream os = conn.getOutputStream();
				os.write(postParams.getBytes());
				os.flush();
			}
			} else {
				conn.setDoOutput(false);
			}
			
			// Check if request was successful
			code = conn.getResponseCode();
			responseOk = (code == 200);
			
			// TODO: Implement real logging of requests
			logRequestResult(conn);
			
			conn.disconnect();
		
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		if (responseOk) {
			return Response.ok()
					.header("MD2-Model-Version", Config.MODEL_VERSION).build();
		} else {
			return Response.status(code) // TODO: Change status here
					.header("MD2-Model-Version", Config.MODEL_VERSION).build();
		}
		}
		
		/**
		 * Creates a string containing URL parameters, that can be added to a normal URL.
		 * Example: {"hello": "world", "example": 42} will return '?hello=world&example=42'
		 * @param params a HashMap containing all query parameters
		 * @return a String containing query parameters
		 */
		private String buildUrlParameters(HashMap<String, Object> params){
			String urlParams = "?";
		
		for (Entry<String, Object> entry : params.entrySet()) {
			urlParams += entry.getKey() + "=" + entry.getValue() + "&";
		}
		// remove trailing "&"
		urlParams = urlParams.substring(0, urlParams.length() - 1);
		return urlParams;
		}
		
		/**
		 * Logs the result of a HttpURLConnection
		 * @param conn the HttpURLConnection
		 * @throws IOException when the inputStream cannot be read
		 */
		private void logRequestResult(HttpURLConnection conn) throws IOException {
			String output;
			try {
				BufferedReader br = new BufferedReader(new InputStreamReader(
						(conn.getInputStream())));
				LOGGER.info("Server response content:");
				while ((output = br.readLine()) != null) {
					LOGGER.info(output);
				}
			} catch (IOException e) {
				throw e;
			}
		}
		}	
		
	'''
}
