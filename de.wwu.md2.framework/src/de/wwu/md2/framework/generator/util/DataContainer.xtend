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

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.WorkflowElement
import java.util.Map
import java.util.HashMap

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
	
	@Property
	private Collection<View> views
	
	@Property
	private Collection<Controller> controllers
	
	@Property
	private Collection<Model> models
	
	@Property
	private Collection<Workflow> workflows
	
	
	///////////////////////////////////////
	// Controller Elements
	///////////////////////////////////////
	
	@Property
	private Main main
	
	@Property
	private Collection<ContentProvider> contentProviders
	
	@Property
	private Collection<CustomAction> customActions
	
	@Property
	private Collection<RemoteValidator> remoteValidators
	
	@Property
	private Collection<WorkflowElement> workflowElements
	
	
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
	@Property
	private Map<WorkflowElement, Set<ContainerElement>> rootViewContainers
	
	
	///////////////////////////////////////
	// Model Elements
	///////////////////////////////////////
	
	@Property
	private Collection<Entity> entities
	
	@Property
	private Collection<Enum> enums
	
	
	///////////////////////////////////////
	// Workflow Elements
	///////////////////////////////////////
	
	@Property
	private Collection<App> apps
	
	
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
		
		views = newHashSet()
		controllers = newHashSet()
		models = newHashSet()
		workflows = newHashSet()
		
		val md2models = input.resources.map[ r |
			r.contents.filter(MD2Model)
		].flatten
		
		md2models.forEach[ md2model |
			val modelLayer = md2model.modelLayer
			switch modelLayer {
				View : views.add(modelLayer)
				Model : models.add(modelLayer)
				Controller : controllers.add(modelLayer)
				Workflow : workflows.add(modelLayer)
			}
		]
	}
	
	/**
	 * Get the only main block of the app. This allows to easily access information such as the app name
	 * and app version without iterating over the object tree over and over again.
	 */
	def private extractUniqueMain() {
		main = controllers.map[ ctrl |
			ctrl.controllerElements.filter(Main)
		].flatten.head
	}
	
	/**
	 * Iterate over all controllers and collect relevant elements for the generation process.
	 */
	def private extractElementsFromControllers() {
		customActions = newHashSet
		contentProviders = newHashSet
		remoteValidators = newHashSet
		workflowElements = newHashSet
		
		customActions = controllers.map[ ctrl |
			ctrl.controllerElements.filter(CustomAction)
		].flatten.toSet
		
		contentProviders = controllers.map[ ctrl |
			ctrl.controllerElements.filter(ContentProvider)
		].flatten.toSet
		
		remoteValidators = controllers.map[ ctrl |
			ctrl.controllerElements.filter(RemoteValidator)
		].flatten.toSet
		
		workflowElements = controllers.map[ ctrl | 
			ctrl.controllerElements.filter(WorkflowElement)
		].flatten.toSet
	}
	
	/**
	 * Extract all entities and enums.
	 */
	def private extractElementsFromModels() {
		entities = newHashSet
		enums = newHashSet
		
		entities = models.map[ model |
			model.modelElements.filter(Entity)
		].flatten.toSet
		
		enums = models.map[ model |
			model.modelElements.filter(Enum)
		].flatten.toSet
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
		
		apps = workflows.map[ workflow |
			 workflow.apps
		].flatten.toSet
	}
	
	
}
