package de.wwu.md2.framework.generator.util.preprocessor

import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.CommonContainerParam
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.FlowDirection
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.NamedColor
import de.wwu.md2.framework.mD2.NamedColorDef
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.SubViewContainer
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewElementDef
import de.wwu.md2.framework.mD2.WidthParam
import java.util.Collections
import java.util.Map
import java.util.Set
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

class ProcessView {
	
	/**
	 * Check for existence of flowDirection parameter for all FlowLayoutPanes.
	 * Set default flowDirection (HORIZONTAL) if none has been specified by user.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def static void setFlowLayoutPaneDefaultParameters(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<FlowLayoutPane> flowLayoutPanes = workingInput.resources.map(r|r.allContents.toIterable.filter(typeof(FlowLayoutPane))).flatten
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
	def static void duplicateSpacers(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<Spacer> spacers = workingInput.resources.map(r|r.allContents.toIterable.filter(typeof(Spacer))).flatten
		for (spacer : spacers) {
			if (spacer.number > 1) {
				// if we found a spacer, get the list of its containing feature and replace the single spacer by
				// the specified number of spacers
				val lst = spacer.eContainer.eContainer.eGet(spacer.eContainer.eContainingFeature) as EList<Object>
				val idx = lst.indexOf(spacer.eContainer)
				var i = 0
				while (i < spacer.number) {
					val newSpacer = factory.createSpacer
					newSpacer.setNumber(1)
					val newViewElementType = factory.createViewElementDef
					newViewElementType.value = newSpacer
					lst.add(idx, newViewElementType)
					i = i + 1
				}
				spacer.eContainer.remove
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
	def static void transformFlowLayoutsToGridLayouts(MD2Factory factory, ResourceSet workingInput) {
		
		val Iterable<FlowLayoutPane> flowLayoutPanes = workingInput.resources.map[r |
			r.allContents.toIterable.filter(typeof(FlowLayoutPane))
		].flatten
		
		// Store a mapping for all replaced floatLayouts to the newly created GridLayout.
		// This information is required to update all cross references after the replacement process.
		val rememberReplacedFloatLayoutsMap = newHashMap
		
		for (flowLayoutPane : flowLayoutPanes) {
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
			val copier = new EcoreUtil.Copier()
			flowLayoutPane.elements.addAll(copier.copyAll(newGridLayoutPane.elements))
			
			// set calculated columns and rows parameter and replace the FlowLayout with the newly created GridLayout
			newGridLayoutPane.params.addAll(columnsParam, rowsParam)
			flowLayoutPane.replace(newGridLayoutPane)
			
			rememberReplacedFloatLayoutsMap.put(flowLayoutPane, newGridLayoutPane)
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
	def static void calculateNumRowsAndNumColumnsParameters(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<GridLayoutPane> gridLayoutPanes = workingInput.resources.map[r |
			r.allContents.toIterable.filter(typeof(GridLayoutPane))
		].flatten
		
		for (gridLayoutPane : gridLayoutPanes) {
			var numberOfContainedElements = gridLayoutPane.elements.size
			val columnsParams = gridLayoutPane.params.filter(typeof(GridLayoutPaneColumnsParam))
			val rowsParams = gridLayoutPane.params.filter(typeof(GridLayoutPaneColumnsParam))
			
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
	def static void fillUpGridLayoutsWithSpacers(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<GridLayoutPane> gridLayoutPanes = workingInput.resources.map[r |
			r.allContents.toIterable.filter(typeof(GridLayoutPane))
		].flatten
		
		for (gridLayoutPane : gridLayoutPanes) {
			val numberOfContainedElements = gridLayoutPane.elements.size
			val columns = gridLayoutPane.params.filter(typeof(GridLayoutPaneColumnsParam)).last.value
			val rows = gridLayoutPane.params.filter(typeof(GridLayoutPaneRowsParam)).last.value
			
			val numberOfRequiredSpacers = rows * columns - numberOfContainedElements
			var i = 0
			while (i < numberOfRequiredSpacers) {
				val newSpacer = factory.createSpacer
				newSpacer.setNumber(1)
				val newViewElement = factory.createViewElementDef
				newViewElement.setValue(newSpacer)
				gridLayoutPane.elements.add(newViewElement)
				i = i + 1
			}
		}
	}
	
	/**
	 * Calculate the width of all view elements. If the width of a view element is not explicitly defined it is calculated by the following
	 * algorithm:
	 * <ol>
	 *   <li>Find all view container elements. For each view container:</li>
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
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def static void calculateAllViewElementWidths(MD2Factory factory, ResourceSet workingInput) {
		
		// step 1
		val Iterable<ContainerElement> containerElements = workingInput.resources.map[r |
			r.allContents.toIterable.filter(typeof(ContainerElement)).filter(containerElem | !(containerElem instanceof TabbedAlternativesPane))
		].flatten
		
		for (contentContainer : containerElements.filter(typeof(ContentContainer))) {
			val allChilds = contentContainer.elements.filter(typeof(ViewElementDef))
			var sumOfWidths = 0
			val elementsWithImplicitWidthMap = newLinkedHashMap
			val elementsWithExplicitWidthMap = newLinkedHashMap
			
			// step 2 - calculate overall width and collect child elements
			for (child : allChilds) {
				val childElement = child.value
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
						val widthParam = switch(childElement) {
							GridLayoutPane: childElement.params.filter(typeof(WidthParam)).last
							FlowLayoutPane: childElement.params.filter(typeof(WidthParam)).last
							AlternativesPane: childElement.params.filter(typeof(WidthParam)).last
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
		
		// If the parent of the container element is the View itself or a Tab-/AlternativesPane, set the width to 100%
		for (containerElement : containerElements) {
			if(containerElement.eContainer instanceof View || containerElement.eContainer instanceof SubViewContainer) {
				var widthParam = switch(containerElement) {
					GridLayoutPane: containerElement.params.filter(typeof(WidthParam)).last
					FlowLayoutPane: containerElement.params.filter(typeof(WidthParam)).last
					AlternativesPane: containerElement.params.filter(typeof(WidthParam)).last
				}
				if(widthParam == null) {
					widthParam = factory.createWidthParam
					switch(containerElement) {
						GridLayoutPane: containerElement.params.add(widthParam)
						FlowLayoutPane: containerElement.params.add(widthParam)
						AlternativesPane: containerElement.params.add(widthParam)
					}
				}
				widthParam.setWidth(100)
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
	def static void replaceNamedColorsWithHexColors(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<NamedColorDef> namedColorDefs = workingInput.resources.map(r|r.allContents.toIterable.filter(typeof(NamedColorDef))).flatten
		for (namedColorDef : namedColorDefs) {
			val hexColorDef = factory.createHexColorDef
			hexColorDef.color = colorNameHexMap().get(namedColorDef.color)
			namedColorDef.replace(hexColorDef)
		}
	}
	
	/**
	 * Map all supported named colors to their according hex color.
	 */
	def private static colorNameHexMap() {
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
	def private static void distributeTotalErrorOfElements(Set<Map.Entry<EObject,Integer>> iterable, int total) {
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
