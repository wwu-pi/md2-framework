package de.wwu.md2.framework.generator.util

import de.wwu.md2.framework.mD2.AlternativesPane
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
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.View
import java.util.Collection
import java.util.List
import java.util.Set
import org.eclipse.emf.ecore.resource.ResourceSet

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

/**
 * Singleton DataContainer to store data that are used throughout the
 * generation process.
 */
class DataContainer
{
	///////////////////////////////////////
	// Data Container
	///////////////////////////////////////
	
	@Property
	private Collection<View> views
	
	@Property
	private Collection<Controller> controllers
	
	@Property
	private Collection<Model> models
	
	
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
	
	
	///////////////////////////////////////
	// View Elements
	///////////////////////////////////////
	
	@Property
	private Set<ContainerElement> rootViewContainers
	
	@Property
	private TabbedAlternativesPane tabbedAlternativesPane
	
	@Property
	private List<ContainerElement> tabbedViewContent
	
	@Property
	private Set<ContainerElement> viewContainersInAnyAlternativesPane
	
	@Property
	private Set<ContainerElement> viewContainersNotInAnyAlternativesPane
	
	
	///////////////////////////////////////
	// Model Elements
	///////////////////////////////////////
	
	@Property
	private Collection<Entity> entities
	
	@Property
	private Collection<Enum> enums
	
	
	
	/**
	 * Initializes the lists offered by the data container
	 */
	new(ResourceSet input) {
		intializeModelTypedLists(input)
		
		extractUniqueMain
		
		if(main == null) {
			return
		}
		
		extractElementsFromControllers
		
		extractElementsFromModels
		
		postProcessViewCollection
	}
	
	/**
	 * Provide sets which are populated with all views, collections and models respectively.
	 */
	def private intializeModelTypedLists(ResourceSet input) {
		views = newHashSet()
		controllers = newHashSet()
		models = newHashSet()
		val Iterable<MD2Model> parts = input.resources.map(r | r.allContents.toIterable.filter(typeof(MD2Model))).flatten
		for(md2model : parts) {
			switch md2model.modelLayer {
				// Xtend resolves runtime argument type for modelLayer
				View : views.add(md2model.modelLayer as View)
				Model : models.add(md2model.modelLayer as Model)
				Controller : controllers.add(md2model.modelLayer as Controller)
			}
		}
	}
	
	/**
	 * Get the only main block of the app. This allows to easily access information such as the app name
	 * and app version without iterating over the object tree over and over again.
	 */
	def private extractUniqueMain() {
		val controllerContainingMain = controllers.findFirst(ctrl | ctrl.controllerElements.exists(ctrlElem | ctrlElem instanceof Main))
		if(controllerContainingMain != null) {
			main = controllerContainingMain.controllerElements.findFirst(ctrlElem | ctrlElem instanceof Main) as Main
		}
	}
	
	/**
	 * Iterate over all controllers and collect relevant information:
	 * About the views that have to be generated:
	 *    Generate views => get start view and all called views in work flow steps and change view actions
	 */
	def private extractElementsFromControllers() {
		
		rootViewContainers = newHashSet
		customActions = newHashSet
		contentProviders = newHashSet
		remoteValidators = newHashSet
		
		rootViewContainers.add(resolveContainerElement(main.startView));
		for (controller : controllers) {
			for (controllerElement : controller.controllerElements) {
				switch controllerElement {
					CustomAction: {
						// Get all root views (all views that are accessed by GotoViewActions at some time)
						controllerElement.eAllContents.toIterable.filter(typeof(GotoViewAction)).forEach [gotoViewAction |
							rootViewContainers.add(resolveContainerElement(gotoViewAction.view))
						]
						
						// Store custom actions to generate
						customActions.add(controllerElement)
					}
					
					ContentProvider: {
						contentProviders.add(controllerElement)
					}
					
					RemoteValidator: {
						remoteValidators.add(controllerElement)
					}
				}
			}
		}
	}
	
	/**
	 * Extract all entities and enums.
	 */
	def private extractElementsFromModels() {
		
		entities = newHashSet
		enums = newHashSet
		
		for (model : models) {
			for (modelElement : model.modelElements) {
				switch modelElement {
					Entity: {
						entities.add(modelElement)
					}
					
					Enum: {
						enums.add(modelElement)
					}
				}
			}
		}
	}
	
	def void postProcessViewCollection() {
		// Post-processing of view collection
		// => 1. get ordered list of all views that are in the tabbed pane
		tabbedViewContent = newArrayList
		views.forEach [view |
			val tabbedPane = view.viewElements.filter(typeof(TabbedAlternativesPane)).last
			if(tabbedPane != null) {
				// Save the TabbedAlternativesPane
				tabbedAlternativesPane = tabbedPane
				
				// Add all tabs to the respective list
				tabbedViewContent.addAll(tabbedPane.elements.filter(typeof(ContainerElement)))
				// Additionally add the tabs to the set of view containers (if they are already in there, they will not be added again since viewContainers is a set)
				rootViewContainers.addAll(tabbedPane.elements.filter(typeof(ContainerElement)))
			}
		]
		
		// => 2. extract all views that are direct children of an alternatives pane or tabbed alternatives pane from the set of views to generate
		viewContainersInAnyAlternativesPane = newHashSet
		viewContainersInAnyAlternativesPane.addAll(rootViewContainers.filter(c | c.eContainer.eContainer instanceof AlternativesPane))
		if(tabbedViewContent != null) {
			viewContainersInAnyAlternativesPane.addAll(tabbedViewContent)
		}
		
		// => 3. get set difference of (2.) and the set of views to generate
		viewContainersNotInAnyAlternativesPane = newHashSet
		viewContainersNotInAnyAlternativesPane.addAll(rootViewContainers)
		viewContainersNotInAnyAlternativesPane.removeAll(viewContainersInAnyAlternativesPane)
	}
}
