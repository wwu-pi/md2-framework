package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.CommonContainerParam
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.FlowDirection
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.InputElement
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.NamedColor
import de.wwu.md2.framework.mD2.NamedColorDef
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.SubViewContainer
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.WidthParam
import java.util.Collections
import java.util.Map
import java.util.Set
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import de.wwu.md2.framework.mD2.WorkflowElement

class ProcessView extends AbstractPreprocessor {
	
	/**
	 * Check for existence of flowDirection parameter for all FlowLayoutPanes.
	 * Set default flowDirection (HORIZONTAL) if none has been specified by user.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def setFlowLayoutPaneDefaultParameters() {
		val Iterable<FlowLayoutPane> flowLayoutPanes = view.eAllContents.toIterable.filter(typeof(FlowLayoutPane)).toList
		for (flowLayoutPane : flowLayoutPanes) {
			if(!flowLayoutPane.params.exists(p | p instanceof FlowLayoutPaneFlowDirectionParam)) {
				val flowDirectionParam = factory.createFlowLayoutPaneFlowDirectionParam
				flowDirectionParam.setFlowDirection(FlowDirection::HORIZONTAL)
				flowLayoutPane.params.add(flowDirectionParam)
			}
		}
	}
	
	/**
	 * Duplicate spacer according to the specified number of spacers.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def duplicateSpacers() {
		
		val spacers = view.eAllContents.toIterable.filter(Spacer)
		
		for (spacer : spacers) {
			if (spacer.number > 1) {
				// if we found a spacer, get the list of its containing feature and replace the single spacer by
				// the specified number of spacers
				val lst = spacer.eContainer.eGet(spacer.eContainingFeature) as EList<EObject>
				val width = spacer.width
				val idx = lst.indexOf(spacer)
				var i = 0
				while (i < spacer.number) {
					val newSpacer = factory.createSpacer
					newSpacer.setNumber(1)
					newSpacer.setWidth(width)
					lst.add(idx, newSpacer)
					i = i + 1
				}
				spacer.remove
			}
		}
	}
	
	/**
	 * Transform all flowLayouts to gridLayouts, so that the generators only have to deal with one layout type.
	 * Horizontal flow layouts are transformed into a gridLayout with one row and as many columns as the number of contained elements.
	 * Vertical flow layouts are transformed into a gridLayout with one column and as many rows as the number of contained elements.
	 * 
	 * Copies all tab specific parameters and all child elements of the FlowLayout to the new GridLayout. Furthermore, all cross references
	 * that use the FloatLayout are updated to the newly created GridLayout.
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>setFlowLayoutPaneDefaultParameters</i> - This step relies on the FlowDirection parameter without further checks.
	 *   </li>
	 *   <li>
	 *     <i>duplicateSpacers</i> - This step requires the spacers to be already duplicated in order to calculate the number of contained elements properly.
	 *   </li>
	 * </ul>
	 */
	def transformFlowLayoutsToGridLayouts() {
		
		// Store a mapping for all replaced floatLayouts to the newly created GridLayout.
		// This information is required to update all cross references after the replacement process.
		val rememberReplacedFloatLayoutsMap = newHashMap
		
		var iterator = view.eAllContents
		while(iterator.hasNext) {
			val next = iterator.next
			if (next instanceof FlowLayoutPane) {
				val flowLayoutPane = next as FlowLayoutPane
				
				// reset iterator after each match to avoid concurrent modification exceptions
				// => is iterating over the tree while replacing flowLayouts with gridLayouts
				// TODO can be really slow on big trees (optimization by only iterating views)
				iterator = view.eAllContents
				
				// calculate columns and rows params for the new GridLayout
				val numberOfContainedElements = flowLayoutPane.elements.size
				val directionParameter = flowLayoutPane.params.filter(typeof(FlowLayoutPaneFlowDirectionParam)).last
				val columnsParam = factory.createGridLayoutPaneColumnsParam
				val rowsParam = factory.createGridLayoutPaneRowsParam
				
				switch (directionParameter.flowDirection) {
					case FlowDirection::HORIZONTAL: {
						columnsParam.setValue(numberOfContainedElements)
						rowsParam.setValue(1)
					}
					case FlowDirection::VERTICAL: {
						columnsParam.setValue(1)
						rowsParam.setValue(numberOfContainedElements)
					}
				}
				
				// Create new GridLayout and copy attributes
				val newGridLayoutPane = factory.createGridLayoutPane
				newGridLayoutPane.setName(flowLayoutPane.name)
				val commonParams = flowLayoutPane.params.filter(typeof(CommonContainerParam))
				newGridLayoutPane.params.addAll(commonParams)
				
				// copy child elements
				val elements = flowLayoutPane.elements
				newGridLayoutPane.elements.addAll(elements)
				
				// set calculated columns and rows parameter and replace the FlowLayout with the newly created GridLayout
				newGridLayoutPane.params.addAll(columnsParam, rowsParam)
				flowLayoutPane.replace(newGridLayoutPane)
				
				rememberReplacedFloatLayoutsMap.put(flowLayoutPane, newGridLayoutPane)
			}
		}
		
		// Change all cross references to the new grid layout
		val usageReferencesMap = EcoreUtil.UsageCrossReferencer.findAll(rememberReplacedFloatLayoutsMap.keySet, workingInput)
		usageReferencesMap.forEach[ key, value$collectionOfCrossRefs |
			for (eStructuralFeature : value$collectionOfCrossRefs) {
				eStructuralFeature.replace(key, rememberReplacedFloatLayoutsMap.get(key))
			}
		]
	}
	
	/**
	 * Explicitly calculate the number of rows and the number of columns for each GridLayout. This step ensures that the generators can rely on
	 * both parameters being set. Validators in the language have to enforce that at least one of these parameters is set. If the pane is empty,
	 * i.e. it has no elements, a minimum size of at least 1x1 is enforced. This single grid cell is then populated with a spacer in the
	 * fillUpGridLayoutsWithSpacers step. If either the row number or the column number is set to zero, it is changed to 1, so that at least one row
	 * and/or one column is enforced.
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>transformFlowLayoutsToGridLayouts</i> - This step expects that all layouts are already transformed to grid layouts. If GridLayouts
	 *     are added after this step, the parameters will not be calculated.
	 *   </li>
	 * </ul>
	 */
	def calculateNumRowsAndNumColumnsParameters() {
		val gridLayoutPanes = view.eAllContents.toIterable.filter(GridLayoutPane).toList
		
		for (gridLayoutPane : gridLayoutPanes) {
			var numberOfContainedElements = gridLayoutPane.elements.size
			val columnsParams = gridLayoutPane.params.filter(GridLayoutPaneColumnsParam)
			val rowsParams = gridLayoutPane.params.filter(GridLayoutPaneRowsParam)
			
			// enforce minimum grid size
			if (numberOfContainedElements == 0) {
				numberOfContainedElements = 1
			}
			if (!columnsParams.empty && columnsParams.last.value == 0) {
				columnsParams.last.setValue(1)
			}
			if (!rowsParams.empty && rowsParams.last.value == 0) {
				rowsParams.last.setValue(1)
			}
			
			// calculate and add missing parameter
			if (columnsParams.empty) {
				val newColumnsParam = factory.createGridLayoutPaneColumnsParam
				var numberOfColumns = Math.ceil(numberOfContainedElements.doubleValue / rowsParams.last.value).intValue
				newColumnsParam.setValue(numberOfColumns)
				gridLayoutPane.params.add(newColumnsParam)
			}
			else if (rowsParams.empty) {
				val newRowsParam = factory.createGridLayoutPaneRowsParam
				val numberOfRows = Math.ceil(numberOfContainedElements.doubleValue / columnsParams.last.value).intValue
				newRowsParam.setValue(numberOfRows)
				gridLayoutPane.params.add(newRowsParam)
			}
		}
	}
	
	/**
	 * Calculates the number of cells in a GridLayout and compares it with the number of its direct child elements. If the grid is
	 * not completely populated, fill up the remaining cells with spacers.
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>calculateNumRowsAndNumColumnsParameters</i> - For the calculation of the grid size this method relies on the rows and the columns parameter.
	 *   </li>
	 * </ul>
	 */
	def fillUpGridLayoutsWithSpacers() {
		val Iterable<GridLayoutPane> gridLayoutPanes = view.eAllContents.toIterable.filter(GridLayoutPane).toList
		
		for (gridLayoutPane : gridLayoutPanes) {
			val numberOfContainedElements = gridLayoutPane.elements.size
			val columns = gridLayoutPane.params.filter(GridLayoutPaneColumnsParam).last.value
			val rows = gridLayoutPane.params.filter(GridLayoutPaneRowsParam).last.value
			
			val numberOfRequiredSpacers = rows * columns - numberOfContainedElements
			var i = 0
			while (i < numberOfRequiredSpacers) {
				val newSpacer = factory.createSpacer
				newSpacer.setNumber(1)
				gridLayoutPane.elements.add(newSpacer)
				i = i + 1
			}
		}
	}
	
	/**
	 * Calculate the width of all view elements. If the width of a view element is not explicitly defined it is calculated by the following
	 * algorithm:
	 * <ol>
	 *   <li>Find all view container elements. For each view container, so row-wise:</li>
	 *     <li>Find all view elements in the parent container and sum up the widths of all view elements for which it is explicitly defined (!= -1).</li>
	 *     <li>If the summed up width of all elements is > 100% or all elements have the width value explicitly set, all widths are normalized so that they sum up to 100%.</li>
	 *     <li>The remaining space is distributed evenly over all other elements without an explicitly defined width. E.g. there are three view elements
	 *         A, B and C with A having an explicit width of 30%. Then B and C share the remaining space and get 35% each. If the sum of all other elements
	 *         already sums up to 100% the remaining elements get no space (However, such behavior should be caught by a validation warning).</li>
	 * </ol>
	 * 
	 * If the parent of the container element is the View itself or a Tab-/AlternativesPane, set the width to 100%.
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>cloneViewElementReferencesIntoParentContainer</i> - It is presumed that there are no references to other view elements (ViewElementRef) in the containers
	 *     anymore, but that all references were explicitly cloned. Presumes that there are only child elements of type ViewElementDef.
	 *   </li>
	 *   <li>
	 *     <i>calculateNumRowsAndNumColumnsParameters</i> - This step presumes that there are no flow layouts to check anymore and that all row and column parameters
	 *     are calculated explicitly, because this method calculates the widths row-wise.
	 *   </li>
	 *   <li>
	 *     <i>fillUpGridLayoutsWithSpacers</i> - As the width calculation is based on the number of elements in each row, it is required that all rows are filled up
	 *     with spacers properly.
	 *   </li>
	 *   <li>
	 *     <i>createViewElementsForAutoGeneratorAction</i> - As the width calculation is based on the number of elements in each row, it is required that all
	 *     auto-generated fields are already present.
	 *   </li>
	 * </ul>
	 */
	def calculateAllViewElementWidths() {
		
		// step 1
		val containerElements = view.eAllContents.toIterable.filter(ContainerElement).filter[ce | !(ce instanceof TabbedAlternativesPane)].toList
		
		for (contentContainer : containerElements.filter(GridLayoutPane)) {
			val allChilds = contentContainer.elements.filter(ViewGUIElement).toList
			
			// get a sublist of elements for each row
			val rowWiseList = newArrayList
			val rows = contentContainer.params.filter(GridLayoutPaneRowsParam).last.value
			val cols = contentContainer.params.filter(GridLayoutPaneColumnsParam).last.value
			var i = 0
			while (i < rows * cols) {
				rowWiseList.add(allChilds.subList(i, i + cols))
				i = i + cols
			}
			
			// row-wise width calculation of the elements in the list
			for (rowChilds : rowWiseList) {
				var sumOfWidths = 0
				val elementsWithImplicitWidthMap = newLinkedHashMap
				val elementsWithExplicitWidthMap = newLinkedHashMap
				
				// step 2 - calculate overall width and collect child elements
				for (childElement : rowChilds) {
					switch(childElement) {
						ContentElement: {
							if (childElement.width == -1) {
								elementsWithImplicitWidthMap.put(childElement, -1)
							} else {
								sumOfWidths = sumOfWidths + childElement.width
								elementsWithExplicitWidthMap.put(childElement, childElement.width)
							}
						}
						ContainerElement: {
							var widthParam = switch(childElement) {
								GridLayoutPane: childElement.params.filter(WidthParam).last
								AlternativesPane: childElement.params.filter(WidthParam).last
							}
							if (widthParam == null) {
								widthParam = factory.createWidthParam
								switch(childElement) {
									GridLayoutPane: childElement.params.add(widthParam)
									AlternativesPane: childElement.params.add(widthParam)
								}
							}
							if (widthParam.width == -1) {
								elementsWithImplicitWidthMap.put(widthParam, -1)
							} else {
								sumOfWidths = sumOfWidths + widthParam.width
								elementsWithExplicitWidthMap.put(widthParam, widthParam.width)
							}
						}
					}
				}
				
				// step 3 - normalize widths
				if(sumOfWidths > 100 || elementsWithImplicitWidthMap.empty) {
					// reduce or increase all width values 
					val factor = 100d / sumOfWidths
					elementsWithExplicitWidthMap.forEach[k, v |
						elementsWithExplicitWidthMap.put(k, Math.round(v * factor).intValue)
					]
					distributeTotalErrorOfElements(elementsWithExplicitWidthMap.entrySet, 100)
					
					// set value
					elementsWithExplicitWidthMap.forEach[element, widthValue |
						switch(element) {
							WidthParam: element.setWidth(widthValue)
							ContentElement: element.setWidth(widthValue)
						}
					]
					
					sumOfWidths = 100
				}
				
				// step 4 - calculate widths
				if(sumOfWidths == 100) {
					elementsWithImplicitWidthMap.forEach[ k, v | elementsWithImplicitWidthMap.put(k, 0) ]
				} else {
					// sumOfWidths < 100 as the case > 100 was already handled in step 3
					val remainingSpace = 100 - sumOfWidths
					val sizePerElement = Math.round(remainingSpace.doubleValue / elementsWithImplicitWidthMap.size).intValue
					elementsWithImplicitWidthMap.forEach[ k, v | elementsWithImplicitWidthMap.put(k, sizePerElement) ]
					distributeTotalErrorOfElements(elementsWithImplicitWidthMap.entrySet, remainingSpace)
				}
				
				// step 4 - set value
				elementsWithImplicitWidthMap.forEach[element, widthValue |
					switch(element) {
						WidthParam: element.setWidth(widthValue)
						ContentElement: element.setWidth(widthValue)
					}
				]
			}
		}
		
		// If the parent of the container element is the View itself or a Tab-/AlternativesPane, set the width to 100%
		for (containerElement : containerElements) {
			// two times .eContainer, because we have to navigate out of the wrapping ContainerElementType
			if(containerElement.eContainer instanceof View || containerElement.eContainer instanceof SubViewContainer) {
				var widthParam = switch(containerElement) {
					GridLayoutPane: containerElement.params.filter(WidthParam).last
					AlternativesPane: containerElement.params.filter(WidthParam).last
				}
				if(widthParam == null) {
					widthParam = factory.createWidthParam
					switch(containerElement) {
						GridLayoutPane: containerElement.params.add(widthParam)
						AlternativesPane: containerElement.params.add(widthParam)
					}
				}
				widthParam.setWidth(100)
			}
		}
	}
	
	/**
	 * If the the <i>label</i> or the <i>tooltip</i> attributes are set for an input element, it is wrapped with a grid layout of the following format.
	 * 
	 * If both a label and a tooltip are defined, the grid has the following format:
	 * <pre>
	 *  --------------------------------------------------------------
	 * |     Label 40%      |        Input 50%          | Tooltip 10% |
	 *  --------------------------------------------------------------
	 * </pre>
	 * 
	 * If only the tooltip is set, the grid has the following format:
	 * <pre>
	 *  --------------------------------------------------------------
	 * |                    Input 90%                   | Tooltip 10% |
	 *  --------------------------------------------------------------
	 * </pre>
	 * 
	 * If only the label is set, a spacer is placed in lieu of the tooltip element.
	 * <pre>
	 *  --------------------------------------------------------------
	 * |     Label 40%      |        Input 50%          |  Spacer 10% |
	 *  --------------------------------------------------------------
	 * </pre>
	 * 
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>createViewElementsForAutoGeneratorAction</i> - The AutoGenerator creates inputs with labels and tooltips. Thus, they have to be created before the
	 *     transformation in this step.
	 *   </li>
	 * </ul>
	 */
	def transformInputsWithLabelsAndTooltipsToLayouts() {
	    
	    val inputs = view.eAllContents.toIterable.filter(InputElement).toList
		
		for (input : inputs) {
			if(input.eIsSet(MD2Package.eINSTANCE.inputElement_LabelText) || input.eIsSet(MD2Package.eINSTANCE.inputElement_TooltipText)) {
				
				// position of input element in container
				val lst = input.eContainer.eGet(input.eContainingFeature) as EList<EObject>
				val position = lst.indexOf(input)
				
				// configure layout panel
				val gridLayout = factory.createGridLayoutPane
				val columnsParam = factory.createGridLayoutPaneColumnsParam
				val rowsParam = factory.createGridLayoutPaneRowsParam
				val numOfCols = if (input.eIsSet(MD2Package.eINSTANCE.inputElement_LabelText)) 3 else 2
				gridLayout.setName("__Container" + input.name)
				columnsParam.setValue(numOfCols)
				rowsParam.setValue(1)
				gridLayout.params.addAll(columnsParam, rowsParam)
				if (input.eIsSet(MD2Package.eINSTANCE.contentElement_Width)) {
					val widthParam = factory.createWidthParam
					val width = input.width
					widthParam.setWidth(width)
					gridLayout.params.add(widthParam)
				}
				
				// add label
				if (input.eIsSet(MD2Package.eINSTANCE.inputElement_LabelText)) {
					val label = factory.createLabel
					label.setName("__Label" + input.name)
					label.setText(input.labelText)
					label.setWidth(40)
					gridLayout.elements.add(label)
				}
				
				// add this input
				val width = if (input.eIsSet(MD2Package.eINSTANCE.inputElement_LabelText)) 50 else 90
				input.setWidth(width)
				gridLayout.elements.add(input)
				
				// add tooltip or spacer if no tooltip is set
				if (input.eIsSet(MD2Package.eINSTANCE.inputElement_TooltipText)) {
					val tooltip = factory.createTooltip
					tooltip.setName("__Tooltip" + input.name)
					tooltip.setText(input.tooltipText)
					tooltip.setWidth(10)
					gridLayout.elements.add(tooltip)
				} else {
					val spacer = factory.createSpacer
					spacer.setNumber(1)
					spacer.setWidth(10)
					gridLayout.elements.add(spacer)
				}
				
				lst.add(position, gridLayout)
			}
		}
	}
	
	/**
	 * Creates a <code>DisableAction</code> in the <i>__startupAction</i> for all view elements that are disabled.
	 * Currently, only InputElements and Buttons can be disabled. However, if new disableable GUI elements are added,
	 * this method has to be adapted accordingly.
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>createStartUpActionAndRegisterAsOnInitializedEvent</i> - Require <i>__startupAction</i> to place the
	 *     DisableAction call tasks.
	 *   </li>
	 *   <li>
	 *     <i>createViewElementsForAutoGeneratorAction</i> - An AutoGeneratorAction can be disabled as a whole. If that
	 *     is the case, all created elements are disabled (<code>isDisabled=true</code>) by default.
	 *   </li>
	 * </ul>
	 */
	def createDisableActionsForAllDisabledViewElements(WorkflowElement wfe) {
		
		// get all views that are accessed by GotoViewActions at some time
		val accessibleViews = wfe.eAllContents.filter(CustomAction).map[ customAction |
			customAction.eAllContents.toIterable].filter(GotoViewAction).map[ gotoView |
				resolveContainerElement(gotoView.view)
			].toSet
		
		// get all GUI elements that are contained in an accessible view
		val guiElements = view.eAllContents.filter(ViewGUIElement).filter[viewGuiElement |
			var EObject eObject = viewGuiElement
			var isContained = false
			while (!(eObject instanceof View) && !isContained) {
				isContained = accessibleViews.contains(eObject)
				eObject = eObject.eContainer
			}
			isContained
		]
		

		
		//TODO: code fragment in comment can be totally removed when DSL is changed 
		//-> we probably only need one initAction per workflow element
		//		val startupAction = wfe.eAllContents.filter(CustomAction).filter[
		//			action | action.name.equals(ProcessController::startupActionName)
		//		]

		val startupAction = wfe.initActions.filter(CustomAction).head
		
		for (guiElement : guiElements.toList) {
			
			val isDisabled = switch (guiElement) {
				InputElement: guiElement.isDisabled
				Button: guiElement.isDisabled
				default: false
			}
			
			// if GUI element is disabled => create DisableAction and add it to startupAction
			if (isDisabled) {
				val callTask = factory.createCallTask
				val simpleActionRef = factory.createSimpleActionRef
				val disableAction = factory.createDisableAction
				val abstractViewGUIElementRef = factory.createAbstractViewGUIElementRef
				abstractViewGUIElementRef.setRef(guiElement)
				callTask.setAction(simpleActionRef)
				simpleActionRef.setAction(disableAction)
				disableAction.setInputField(abstractViewGUIElementRef)
				startupAction.codeFragments.add(0, callTask);
			}
		}
	}
	
	/**
	 * Replace all named colors by their hex color equivalents.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def replaceNamedColorsWithHexColors() {		
		val namedColorDefs = view.eAllContents.toIterable.filter(NamedColorDef).toList
		
		for (namedColorDef : namedColorDefs) {
			val hexColorDef = factory.createHexColorDef
			hexColorDef.color = colorNameHexMap().get(namedColorDef.color)
			namedColorDef.replace(hexColorDef)
		}
	}
	
	/**
	 * Map all supported named colors to their according hex color.
	 */
	private def colorNameHexMap() {
		val Map<NamedColor, String> map = newHashMap
		map.put(NamedColor::AQUA, "#00ffff")
		map.put(NamedColor::BLACK, "#000000")
		map.put(NamedColor::BLUE, "#0000ff")
		map.put(NamedColor::FUCHSIA, "#ff00ff")
		map.put(NamedColor::GRAY, "#808080")
		map.put(NamedColor::GREEN, "#008000")
		map.put(NamedColor::LIME, "#00ff00")
		map.put(NamedColor::MAROON, "#800000")
		map.put(NamedColor::NAVY, "#000080")
		map.put(NamedColor::OLIVE, "#808000")
		map.put(NamedColor::PURPLE, "#800080")
		map.put(NamedColor::RED, "#ff0000")
		map.put(NamedColor::SILVER, "#c0c0c0")
		map.put(NamedColor::TEAL, "#008080")
		map.put(NamedColor::WHITE, "#ffffff")
		map.put(NamedColor::YELLOW, "#ffff00")
		return Collections::unmodifiableMap(map)
	}
	
	/**
	 * All values were rounded to the closest integer => it can happen that the new summed up value is not exactly 100
	 * e.g. (34, 34, 33) * (100 / 101) = (33,66, 33,66, 32,67) will be round up again to (34, 34, 33) with sum 101.
	 * In these cases substract or add 1 to each width value until the sum is exactly 100.
	 * 
	 * This method is slow for big errors! Thus, reduce error before calling this method.
	 */
	private def distributeTotalErrorOfElements(Set<Map.Entry<EObject, Integer>> iterable, int total) {
		val newSum = iterable.map[m | m.value].reduce[v1, v2| v1 + v2]
		val error = newSum - total;
		val iterations = if (error >= 0) error else error * -1
		var i = 0
		while(i < iterations) {
			val index = i % iterable.size
			val op = if (error >= 0) -1 else 1
			iterable.get(index).setValue(iterable.get(index).value + op)
			i = i + 1
		}
	}
	
}
