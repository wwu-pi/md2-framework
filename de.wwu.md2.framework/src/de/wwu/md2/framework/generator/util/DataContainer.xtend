package de.wwu.md2.framework.generator.util

import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.Main
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.RemoteValidator
import de.wwu.md2.framework.mD2.View
import java.util.Collection
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtend.lib.annotations.Accessors

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.WorkflowElement
import java.util.Map
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.FireEventAction
import de.wwu.md2.framework.mD2.WorkflowEvent
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.CallTask

/**
 * DataContainer to store data that are used throughout the generation process.
 * That avoids that all these elements have to be extracted over and over again in the actual generators.
 * Hint: From the sets in this file it can be inferred which elements have to be generated, i.e. a class for
 * CustomActions, ContentProviders, RemoteValidators, Views and Entities have to be generated as they are the only
 * none-static elements in MD2.
 */
class DataContainer {
	
	///////////////////////////////////////
	// Data Container
	///////////////////////////////////////
	
	@Accessors
	public View view
	
	@Accessors
	public Controller controller
	
	@Accessors
	public Model model
	
	@Accessors
	public Workflow workflow
	
	
	///////////////////////////////////////
	// Controller Elements
	///////////////////////////////////////
	
	@Accessors
	public Main main
	
	@Accessors
	public Collection<ContentProvider> contentProviders
	
	@Accessors
	public Collection<CustomAction> customActions
	
	@Accessors
	public Collection<RemoteValidator> remoteValidators
	
	@Accessors
	public Collection<WorkflowElement> workflowElements
	
	
	///////////////////////////////////////
	// View Elements
	///////////////////////////////////////
	
	/**
	 * View panes that are at the root level, i.e. they have no containing container.
	 * Only those are taken into account that are accessed via a GotoViewAction (after
	 * preprocessing, i.e. views that are accessed via workflows are included) or that
	 * have any TabbedAlternativesPane or AlternativesPane as a child element that contain
	 * any view containers that are accessed by a GotoViewAction.
	 */
	@Accessors
	public Map<WorkflowElement, Set<ContainerElement>> rootViewContainers
	
	
	///////////////////////////////////////
	// Model Elements
	///////////////////////////////////////
	
	@Accessors
	public Collection<Entity> entities
	
	@Accessors
	public Collection<Enum> enums
	
	
	///////////////////////////////////////
	// Workflow Elements
	///////////////////////////////////////
	
	@Accessors
	public Collection<App> apps
	
	
	/**
	 * Initializes the sets offered by the data container
	 */
	new(ResourceSet input) {
		
		intializeModelTypedLists(input)
		
		extractUniqueMain
		
		extractElementsFromControllers
		
		extractElementsFromModels
		
		extractRootViews
		
		extractElementsFromWorkflows
	
	}
	
	/**
	 * Provide sets which are populated with all views, collections and models respectively.
	 */
	def private intializeModelTypedLists(ResourceSet input) {
		
		val md2models = input.resources.map[ r |
			r.contents.filter(MD2Model)
		].flatten
		
		md2models.forEach[ md2model |
			val modelLayer = md2model.modelLayer
			switch modelLayer {
				View : view = modelLayer
				Model : model = modelLayer
				Controller : controller = modelLayer
				Workflow : workflow = modelLayer
			}
		]
	}
	
	/**
	 * Get the only main block of the app. This allows to easily access information such as the app name
	 * and app version without iterating over the object tree over and over again.
	 */
	def private extractUniqueMain() {
	    main = controller.controllerElements.filter(Main).head
	}
	
	/**
	 * Iterate over all controllers and collect relevant elements for the generation process.
	 */
	def private extractElementsFromControllers() {
		customActions = newHashSet
		contentProviders = newHashSet
		remoteValidators = newHashSet
		workflowElements = newHashSet
		
		var ce = controller.controllerElements 
		
		customActions     = ce.filter(CustomAction).toSet
		contentProviders  = ce.filter(ContentProvider).toSet
		remoteValidators  = ce.filter(RemoteValidator).toSet
		workflowElements  = ce.filter(WorkflowElement).toSet
	}
	
	/**
	 * Extract all entities and enums.
	 */
	def private extractElementsFromModels() {
		entities = newHashSet
		enums = newHashSet
		
		entities = model.modelElements.filter(Entity).toSet
		enums = model.modelElements.filter(Enum).toSet
	}
	
	/**
	 * View panes that are at the root level, i.e. they have no containing container.
	 * Only those are taken into account that are accessed via a GotoViewAction (after
	 * preprocessing, i.e. views that are accessed via workflows are included) or that
	 * have any TabbedAlternativesPane or AlternativesPane as a child element that contain
	 * any view containers that are accessed by a GotoViewAction.
	 */
	def private extractRootViews() {
		
		rootViewContainers = newHashMap
			
		for (WorkflowElement workflowElement : workflowElements){
			// Get all views that are accessed by GotoViewActions at some time
			val containers = (workflowElement.actions + workflowElement.initActions).filter(CustomAction).map[ customAction |
					customAction.eAllContents.toIterable
				].flatten.filter(GotoViewAction).map[ gotoView |
					resolveContainerElement(gotoView.view)
				]
			
			// Calculate root view for each view that is accessed via a GotoViewAction
			rootViewContainers.put(workflowElement, containers.map[ container |
				var EObject elem = container
				while (!(elem.eContainer instanceof View)) {
					elem = elem.eContainer
				}
				elem as ContainerElement
			].toSet)
		}
	}
	
	/**
	 * Extract all apps.
	 */
	def private extractElementsFromWorkflows() {
		apps = newHashSet
		apps = workflow.apps.toSet
	}
	
	/**
	 * Returns all workflows associated with the current app.
	 */
	def public workflowElementsForApp(App app) {
	    val wfes = app.workflowElements.map[it.workflowElementReference].toSet
	    return wfes
	}
	
	/**
	 * Return all events declared in a workflowElement.
	 */
    def public Iterable<WorkflowEvent> getEventsFromWorkflowElement(WorkflowElement wfe) {
       
       var wfeEntry = workflow.workflowElementEntries.filter[it.workflowElement.equals(wfe)].head
       
       return wfeEntry.firedEvents.map[it.event]
    }

    
    /**
	 * Return the workflowElement that is started by an event.
	 */
    def public WorkflowElement getNextWorkflowElement(WorkflowElement wfe, WorkflowEvent e) {
        var wfes = workflow.workflowElementEntries

        for (WorkflowElementEntry entry : wfes) {
            if (entry.workflowElement.equals(wfe)) {
                var searchedEvent = entry.firedEvents.filter[fe|fe.event.name.equals(e.name)].head
                return searchedEvent.startedWorkflowElement
            }
        }
        return null;
    }
}
