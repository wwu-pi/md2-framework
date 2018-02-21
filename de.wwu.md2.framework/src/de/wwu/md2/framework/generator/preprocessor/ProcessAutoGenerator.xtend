package de.wwu.md2.framework.generator.preprocessor

import com.google.common.collect.Lists
import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.AutoGeneratedContentElement
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EntityPath
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.FlowDirection
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.InputElement
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.PathTail
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.SimpleDataType
import de.wwu.md2.framework.mD2.SimpleType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.WorkflowElement
import java.util.Collection
import org.eclipse.xtend.lib.annotations.Accessors

import static de.wwu.md2.framework.generator.preprocessor.util.Util.*

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class ProcessAutoGenerator extends AbstractPreprocessor {
	
	@Accessors
	public String autoGenerationActionName = "__autoGenerationAction"
	
	int autoGenerationCounter = 0
	
	/**
	 * If there are any AutoGenerator elements in the model, create CustomAction named <i>__autoGenerationAction</i>
	 * for mappings and validators and register it in the __startUpAction.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>createStartUpActionAndRegisterAsOnInitializedEvent</i> - The AutoGenerationAction is added to the __startUpAction.
	 *   </li>
	 * </ul>
	 */
	def createAutoGenerationAction(Iterable<AutoGeneratedContentElement> autoGenerators, WorkflowElement wfe) {		
		// Avoid creation of autogeneratedAction if no
		// AutoGeneratedContentElement exist in the model
		
		if (!autoGenerators.empty && wfe.getAutoGenAction === null) {	
			val startupAction = wfe.initActions.filter(CustomAction).head
				
			// create __autoGenerationAction
			val autoGenAction = factory.createCustomAction();
			autoGenAction.setName(autoGenerationActionName)			
			wfe.actions += autoGenAction
				
			// add __autoGenerationAction action to __startupAction
			val autoGenCallTask = factory.createCallTask
			val autoGenActionReference = factory.createActionReference
			autoGenActionReference.setActionRef(autoGenAction)
			autoGenCallTask.setAction(autoGenActionReference)
			startupAction.codeFragments.add(0, autoGenCallTask);
		}
	}
	
	/**
	 * Create view elements for AutoGeneratorPane and add MappingTasks
	 */
	def createViewElementsForAutoGeneratorAction(Iterable<AutoGeneratedContentElement> autoGenerators, WorkflowElement wfe) {
		
		// autoGenerators to remain as view, because new (superfluous) generators might be created later when resolving
		// view references (generators are only deleted at the end) toList only for iteration without concurrent modification
		autoGenerators.toList.forEach [ autoGenerator | 
			
			// Search for parent container => do not hard code to reflect potential changes in the grammar
			// Assumed structure at the moment: ContainerElement -> AutoGeneratedContentElement
			var parentContainer = autoGenerator.eContainer
			while (!(parentContainer instanceof ContentContainer)) {
				parentContainer = parentContainer.eContainer
			}
			
			val elements = (parentContainer as ContentContainer).elements
			
			// TODO -- refactor/comment to make it better understandable
			val pos = elements.indexOf(autoGenerator)
			autoGenerator.contentProvider.forEach [ contentProviderReference |
				val contentProvider = contentProviderReference.contentProvider
				val pathDefinition = factory.createContentProviderPath
				pathDefinition.setContentProviderRef(contentProvider)
				switch (contentProvider.type) {
					ReferencedModelType: {
						val modelElement = (contentProvider.type as ReferencedModelType).entity
						val Collection<EntityPath> filteredAttributes = newHashSet()
						if (autoGenerator.filteredAttributes.size > 0) {
							if (autoGenerator.exclude) {
								filteredAttributes.addAll(autoGenerator.filteredAttributes) 
							} else {
								val entityPathDefinition = factory.createEntityPath
								entityPathDefinition.entityRef = modelElement as Entity
								filteredAttributes.addAll(entityToPathDefinition(entityPathDefinition, modelElement as Entity))
								val iter = filteredAttributes.iterator
								while (iter.hasNext) {
									val obj = iter.next
									var continue = false
									for (includePathDefinition : autoGenerator.filteredAttributes) {
										if (!continue && MD2GeneratorUtil::equals(obj, includePathDefinition)) {
											iter.remove
											continue = true
										} 
									}
								} 
							}
						}
						val viewDefs = modelToView(modelElement, pathDefinition, filteredAttributes, wfe).toList						
						elements.addAll(pos, viewDefs);
						// do not remove autoGenerator here, because its containment hierarchy is still needed for resolving GUI references
						// autoGenerators will be removed at the end of preprocessing
						
//						if (it.type.many) {
//							pathDefinition.tail = factory.createPathTail()
//							pathDefinition.tail.attributeRef = {
//								val AttributeType attr = (modelElement as Entity).attributes.filter([!filteredAttributes.map([it.referencedAttribute]).toList.contains(it)]).map([it.type]).findFirst([!it.eAllContents.filter(typeof(AttrIdentifier)).empty])
//								if (attr != null) attr.eContainer as Attribute else (modelElement as Entity).attributes.head
//							}
//							val viewElementDef = factory.createViewElementDef()					
//							viewElementDef.value = factory.createEntitySelector()
//							viewElementDef.value.name = modelElement.name.toFirstLower + "EntitySelector"
//							(viewElementDef.value as EntitySelector).textProposition = pathDefinition
//							elements.add(pos, viewElementDef);
//						}					
					}
					SimpleType: {
						val simpleDataType = (contentProvider.type as SimpleType).type
						val viewDef = modelToView2(wfe, simpleDataType, pathDefinition)
						// TODO: Generate EntitySelector
						//if (it.type.many) viewDef = wrapIntoMultiPane(factory, viewDef, simpleDataType.name + "MultiPane")
						elements.add(pos, viewDef); // do not remove autoGenerator here
					}
				}
			]
		]
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	/// Helper methods
	////////////////////////////////////////////////////////////////////////////
	
	def private getAutoGenAction(WorkflowElement wfe) {
	    val customActions = wfe.actions.filter(typeof(CustomAction))
	    val actions = customActions.filter(a | a.name == autoGenerationActionName)
	    actions.last
	}
	
	def private Collection<EntityPath> entityToPathDefinition(EntityPath pathDefinition, Entity element) { 
		val Collection<EntityPath> entityPathes = newHashSet()
		element.attributes.forEach [
			val iterPathDefinition = copyElement(pathDefinition) as EntityPath
			if (iterPathDefinition.lastPathTail === null) {
				iterPathDefinition.tail = factory.createPathTail() 
			} else {
				iterPathDefinition.lastPathTail.tail = factory.createPathTail()
			}
			iterPathDefinition.lastPathTail.setAttributeRef(it)
			entityPathes.add(iterPathDefinition)
			if (it instanceof ReferencedType && (it as ReferencedType).element instanceof Entity) {
				entityPathes.addAll(entityToPathDefinition(iterPathDefinition, (it as ReferencedType).element as Entity))
			}
		]
		entityPathes
	}
	
	def private modelToView(
		ModelElement m, ContentProviderPath pathDefinition,	Collection<EntityPath> filteredAttributes, WorkflowElement wfe
	) {
		modelToView(m, pathDefinition, filteredAttributes, null, wfe)
	}
	
	def private Iterable<ViewGUIElement> modelToView(
		ModelElement m, ContentProviderPath pathDefinition, Collection<EntityPath> filteredAttributes, String labelPrefix, WorkflowElement wfe
	) {
		val viewElements = Lists::newArrayList
		if (m instanceof Entity) {
			(m as Entity).attributes.forEach [ a |
				
				
				// New PathDefinition for every attribute
				val pathDefinitionIter = copyElement(pathDefinition) as ContentProviderPath
				val PathTail pathTail = factory.createPathTail()
				pathTail.setAttributeRef(a)
				if (pathDefinitionIter.getTail === null) pathDefinitionIter.setTail(pathTail)
				else getLastPathTail(pathDefinitionIter).setTail(pathTail)
				
				var boolean skip = false
				for (filterPathDefinition : filteredAttributes) {
					if (MD2GeneratorUtil::equals(pathDefinitionIter, filterPathDefinition)) skip = true
				}
				if (!skip) {
					var ViewGUIElement guiElementToAdd;
//					if (a.type.many) {
//						viewElementDef.value = factory.createEntitySelector()
//						viewElementDef.value.name = a.name + "EntitySelector"
//						(viewElementDef.value as EntitySelector).textProposition = pathDefinitionIter
//					} else {
						switch (a.type) {
							ReferencedType: {
								if ((a.type as ReferencedType).element instanceof Entity) {
									val flowLayoutPane = factory.createFlowLayoutPane()
									flowLayoutPane.name = a.name + "FlowLayoutPane"
									// Recursive modelToView for referenced entities
									for (childElem : modelToView((a.type as ReferencedType).element, copyElement(pathDefinitionIter) as ContentProviderPath, filteredAttributes, a.labelText + " - ", wfe)) {
										flowLayoutPane.elements.add(childElem)
									}
									flowLayoutPane.params.add(factory.createFlowLayoutPaneFlowDirectionParam)
									(flowLayoutPane.params.get(0) as FlowLayoutPaneFlowDirectionParam).flowDirection = FlowDirection::VERTICAL
									guiElementToAdd = flowLayoutPane
								} else if ((a.type as ReferencedType).element instanceof Enum) {
									guiElementToAdd = factory.createOptionInput().applyLabelAndTooltip(a, labelPrefix)
									guiElementToAdd.name = "__" + a.name + "OptionInput" + "_" + autoGenerationCounter.toString;
									(guiElementToAdd as OptionInput).enumReference = ((a.type as ReferencedType).element as Enum)
								}
							}
							BooleanType: {
								guiElementToAdd = factory.createBooleanInput().applyLabelAndTooltip(a, labelPrefix)
								guiElementToAdd.name = "__" + a.name + "BooleanInput" + "_" + autoGenerationCounter.toString
							}
							IntegerType: {
								guiElementToAdd = factory.createIntegerInput().applyLabelAndTooltip(a, labelPrefix)
								guiElementToAdd.name = "__" + a.name + "IntegerInput" + "_" + autoGenerationCounter.toString
							}
							FloatType: {
								guiElementToAdd = factory.createNumberInput().applyLabelAndTooltip(a, labelPrefix)
								guiElementToAdd.name = "__" + a.name + "NumberInput" + "_" + autoGenerationCounter.toString
							}
							StringType: {
								guiElementToAdd = factory.createTextInput().applyLabelAndTooltip(a, labelPrefix)
								guiElementToAdd.name = "__" + a.name + "TextInput" + "_" + autoGenerationCounter.toString
							}
							DateType: {
								guiElementToAdd = factory.createDateInput().applyLabelAndTooltip(a, labelPrefix)
								guiElementToAdd.name = "__" + a.name + "DateInput" + "_" + autoGenerationCounter.toString
							}
							TimeType: {
								guiElementToAdd = factory.createTimeInput().applyLabelAndTooltip(a, labelPrefix)
								guiElementToAdd.name = "__" + a.name + "TimeInput" + "_" + autoGenerationCounter.toString
							}
							DateTimeType: {
								guiElementToAdd = factory.createDateTimeInput().applyLabelAndTooltip(a, labelPrefix)
								guiElementToAdd.name = "__" + a.name + "DateTimeInput" + "_" + autoGenerationCounter.toString
							}
							EnumType: {
								System::err.println("[M2M] Oops: Encountered implicit enum " + a.name + ". Should be transformed already.")
							}
							default: {
								System::err.println("[M2M] Oops: Encountered unsupported Attribute type " + a.type.eClass.name + ".")
							}
						}
						addDataMapping(wfe, guiElementToAdd, pathDefinitionIter)				
//					}
					viewElements.add(guiElementToAdd)							
				}
			]
		}
		autoGenerationCounter = autoGenerationCounter + 1
		viewElements
	}
	
	def private modelToView2 (WorkflowElement wfe, SimpleDataType s, ContentProviderPath pathDefinition) {
		var ViewGUIElement viewElement;
		switch (s) {
			case INTEGER: viewElement = factory.createIntegerInput()
			case FLOAT: viewElement = factory.createNumberInput()
			case STRING: viewElement = factory.createTextInput()
			case BOOLEAN: viewElement = factory.createBooleanInput()
			case DATE: viewElement = factory.createDateInput()
			case TIME: viewElement = factory.createTimeInput()
			case DATE_TIME: viewElement = factory.createDateTimeInput()
			case SENSOR: viewElement = factory.createTextInput()
		}
		viewElement.name = "__" + pathDefinition.contentProviderRef.name + viewElement.eClass.name + "_" + autoGenerationCounter.toString
		addDataMapping(wfe, viewElement, pathDefinition)
		autoGenerationCounter = autoGenerationCounter + 1
		viewElement
	}
	
	def private addDataMapping(WorkflowElement wfe, ViewGUIElement guiElem, ContentProviderPath pathDefinition) {
		val autoGenAction = wfe.getAutoGenAction
		if (autoGenAction === null) return null
		val mappingTask = factory.createMappingTask()
		mappingTask.referencedViewField = factory.createAbstractViewGUIElementRef()
		mappingTask.referencedViewField.ref = guiElem
		mappingTask.pathDefinition = pathDefinition as ContentProviderPath
		autoGenAction.codeFragments.add(mappingTask)
	}
	
	def private applyLabelAndTooltip(ContentElement contentElement, Attribute attr, String labelPrefix) {
		val labelText = (labelPrefix?:"") + attr.labelText
		switch (contentElement) {
			InputElement: {
				contentElement.labelText = labelText
				contentElement.tooltipText = attr.description
			}
		}
		contentElement
	}
	
	def private getLabelText(Attribute attr) {
		switch (attr.extendedName) {
			String: attr.extendedName
			default: attr.name.toFirstUpper.replaceAll("(.)([A-Z])","$1 $2")
		}
	}
	
}
