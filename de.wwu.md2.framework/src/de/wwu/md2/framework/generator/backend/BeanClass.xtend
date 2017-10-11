package de.wwu.md2.framework.generator.backend

import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.RemoteValidator
import java.util.Collection

import static extension de.wwu.md2.framework.util.IterableExtensions.*

class BeanClass {
	
	def static createEntityBean(String basePackageName, Entity entity) '''
		package «basePackageName».beans;
		
		import java.util.ArrayList;
		import java.util.List;
		
		import javax.ejb.Stateless;
		import javax.persistence.EntityManager;
		import javax.persistence.PersistenceContext;
		import javax.persistence.TypedQuery;
		
		import «basePackageName».Utils;
		import «basePackageName».datatypes.InternalIdWrapper;
		import «basePackageName».entities.models.«entity.name.toFirstUpper»;
		
		@Stateless
		public class «entity.name.toFirstUpper»Bean {
			
			@PersistenceContext(unitName = "«basePackageName»")
		    EntityManager em;
			
			/*
			 * TODO Implement backend logic for the «entity.name.toFirstUpper» entity here.
			 * These bean methods should be accessed from the web services.
			 */
			
			
			/*
			 * Default logic to get and set «entity.name.toFirstUpper» entities
			 */
			
			public List<«entity.name.toFirstUpper»> getAll«entity.name.toFirstUpper»s(String filter,boolean deleted, int limit) {
				TypedQuery<«entity.name.toFirstUpper»> query = em.createQuery("SELECT t FROM «entity.name.toFirstUpper» t " + Utils.buildWhereParameterFromFilterString(filter, deleted), «entity.name.toFirstUpper».class);
				
				if (limit > 0) {
					query.setMaxResults(limit);
				}
				
				return query.getResultList();
			}
			
			public «entity.name.toFirstUpper» get«entity.name.toFirstUpper»(int id, boolean deleted) {
				«entity.name.toFirstUpper» «entity.name.toFirstLower» = em.find(«entity.name.toFirstUpper».class, id);
				if(«entity.name.toFirstLower».getDeleted()==deleted){
				return «entity.name.toFirstLower»;	
				}
				else{
				return null;	
				}
			}
			
			public List<«entity.name.toFirstUpper»> get«entity.name.toFirstUpper»s(List<Integer> ids) {
				List<«entity.name.toFirstUpper»> result;
				if (ids.size()==1){
					result = new ArrayList<«entity.name.toFirstUpper»>();
					result.add(em.find(«entity.name.toFirstUpper».class, ids.get(0)));
				}else{
					result = em.createQuery("SELECT t FROM «entity.name.toFirstUpper» t WHERE t.__internalId IN :ids", «entity.name.toFirstUpper».class)
					.setParameter("ids", ids).getResultList();
				}
				
				return result;
			}
			
			public List<InternalIdWrapper> createOrUpdate«entity.name.toFirstUpper»s(List<«entity.name.toFirstUpper»> «entity.name.toFirstLower»s) {
				ArrayList<InternalIdWrapper> ids = new ArrayList<InternalIdWrapper>();
				
				for(«entity.name.toFirstUpper» «entity.name.toFirstLower» : «entity.name.toFirstLower»s) {
					«entity.name.toFirstLower» = em.merge(«entity.name.toFirstLower»);
										
					ids.add(new InternalIdWrapper(«entity.name.toFirstLower».get__internalId()));
				}
				return ids;
			}
			
			public «entity.name.toFirstUpper» createOrUpdate«entity.name.toFirstUpper»(«entity.name.toFirstUpper» «entity.name.toFirstLower») {
				«entity.name.toFirstLower» = em.merge(«entity.name.toFirstLower»);

				return «entity.name.toFirstLower»;
			}
			
			public boolean delete«entity.name.toFirstUpper»s(List<Integer> ids) {
				
				Long count = em.createQuery("SELECT COUNT(t) FROM «entity.name.toFirstUpper» t WHERE t.__internalId IN :ids", Long.class)
					.setParameter("ids", ids)
					.getSingleResult();
				
				if(count == ids.size()) {
					
					em.createQuery("UPDATE «entity.name.toFirstUpper» t SET IS_DELETED=true WHERE t.__internalId IN :ids AND IS_DELETED=false")
						.setParameter("ids", ids)
						.executeUpdate();
					return true;
				} else {
					return false;
				}
			}
		}
	'''
	
	def static createRemoteValidationBean(String basePackageName, Collection<ModelElement> affectedEntities, Collection<RemoteValidator> remoteValidators) '''
		package «basePackageName».beans;
		
		import javax.ejb.Stateless;
		import javax.persistence.EntityManager;
		import javax.persistence.PersistenceContext;
		
		import «basePackageName».datatypes.ValidationResult;
		«FOR entity : affectedEntities»
			import «basePackageName».entities.models.«entity.name.toFirstUpper»;
		«ENDFOR»
		
		/**
		 * Implement backend logic for the remote validators here.
		 * These bean methods should be accessed from the RemoteValidation web service.
		 */git
		@Stateless
		public class RemoteValidationBean {
			
			@PersistenceContext(unitName = "«basePackageName»")
		    EntityManager em;
			
			
			/*
			 * Stubs: Implement remote validators here
			 */
			
			«FOR validator : remoteValidators»
				«IF validator.contentProvider != null && validator.contentProvider.contentProvider.type instanceof ReferencedModelType»
					public ValidationResult validate«validator.name.toFirstUpper»(«(validator.contentProvider.contentProvider.type as ReferencedModelType).entity.name.toFirstUpper» «(validator.contentProvider.contentProvider.type as ReferencedModelType).entity.name.toFirstLower») {
						
						// TODO implement
						
						return new ValidationResult(true);
					}
					
				«ELSE /* based on attributes */»
					public ValidationResult validate«validator.name.toFirstUpper»(«validator.provideAttributes.joinWithIdx("", ", ", "", [s, i | '''String param«i + 1»'''])») {
						
						// TODO implement
						
						return new ValidationResult(true);
					}
					
				«ENDIF»
			«ENDFOR»
		}
	'''
	
	def static createWorkflowStateBean(String basePackageName) '''
		package «basePackageName».beans;
		
		import java.util.ArrayList;
		import java.util.HashMap;
		import java.util.List;
		import java.util.Date;
		
		import javax.ejb.Stateless;
		import javax.persistence.EntityManager;
		import javax.persistence.PersistenceContext;
		import javax.persistence.TypedQuery;
		
		import «basePackageName».Config;
		import «basePackageName».entities.WorkflowState;
		
		@Stateless
		public class WorkflowStateBean {
			
			@PersistenceContext(unitName = "«basePackageName»")
		    EntityManager em;
			
			/*
			 * Default logic to get and set Complaint entities
			 */
			
			
			public List<WorkflowState> getAllWorkflowStates(String app){
				List<WorkflowState> states = new ArrayList<WorkflowState>();
				if(app == null || app.equals("")){
					TypedQuery<WorkflowState> query = em.createQuery("SELECT ws FROM WorkflowState ws", WorkflowState.class);
					return query.getResultList();
				}
				
				// app name was set:
				String[] wfes = Config.APP_WORKFLOWELEMENT_RELATIONSHIP.get(app);
				if (wfes == null) {
					throw new RuntimeException("The app " + app + " is not registered with this backend.");
				}
				for(String s:wfes)
				{
					TypedQuery<WorkflowState> query = em.createQuery("SELECT ws FROM WorkflowState ws WHERE ws.currentWorkflowElement = :wfe AND ws.finished = false", WorkflowState.class)
						.setParameter("wfe", s);
					states.addAll(query.getResultList());
				}
			
				return states;
			}
			
			public WorkflowState getWorkflowState(String instanceId){
				TypedQuery<WorkflowState> query = em.createQuery("SELECT ws FROM WorkflowState ws WHERE ws.instanceId = :id", WorkflowState.class)
						.setParameter("id", instanceId);
				List<WorkflowState> states = query.getResultList();
				
				return (states.size() > 0) ? states.get(0) : null;
			}
			
			/**
			 * Creates a new workflowState if it does not exist yet.
			 * Otherwise, the current workflowState is updated.
			 * @param lastEventFired
			 * @param instanceId
			 * @param wfe the current workflowElement
			 * @return current workflowState
			 */
			public WorkflowState createOrUpdateWorkflowState(String lastEventFired, String instanceId, String wfe, String contentProviderIds){
				
				HashMap<String, String> eventSuccessorMap = Config.WORKFLOWELEMENT_EVENT_SUCCESSION.get(wfe);
				if (eventSuccessorMap == null) {
					throw new RuntimeException("No events are registered for the workflow element " + wfe + ".");
				}
				
				String succeedingWfe = eventSuccessorMap.get(lastEventFired);
				if (succeedingWfe == null) {
					throw new RuntimeException("The event " + lastEventFired + " is not registered for the workflow element " + wfe + ".");
				}
				
				WorkflowState ws = getWorkflowState(instanceId);
				if(ws == null){
					ws = new WorkflowState(lastEventFired, instanceId, succeedingWfe, contentProviderIds);
					if (succeedingWfe.equals("_terminate")) {
						ws.setFinished();
					}
					em.persist(ws);
				}
				else {
					// set last updated to current date
					ws.setLastUpdated(new Date());
					// set to succeeding workflow element -- i.e. describe, what status the instance is in now.
					ws.setCurrentWorkflowElement(succeedingWfe);
					ws.setLastEventFired(lastEventFired); // in fact, this information is useless, but probably nice for display :)
					ws.setContentProviderIds(contentProviderIds);
					if (succeedingWfe.equals("_terminate")) {
						ws.setFinished();
					}
					em.merge(ws);
				}
				return ws;
			}
			
			public boolean deleteWorkflowStates(List<Integer> ids) {
				
				Long count = em.createQuery("SELECT COUNT(t) FROM WorkflowState t WHERE t.__internalId IN :ids", Long.class)
					.setParameter("ids", ids)
					.getSingleResult();
				
				if(count == ids.size()) {
					em.createQuery("DELETE FROM WorkflowState t WHERE t.__internalId IN :ids")
						.setParameter("ids", ids)
						.executeUpdate();
					return true;
				} else {
					return false;
				}
			}
		}
	'''
}
