package de.wwu.md2.framework.generator.ios.view

import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContainerElementReference
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.SubViewContainer
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WorkflowElementReference
import java.lang.invoke.MethodHandles
import java.util.Collection

/**
 * Generates the MD2WidgetMapping.swift enumeration type.
 */
class WidgetMapping {
	
	/**
	 * Generates the MD2WidgetMapping Swift type.
	 * Prepares the class generation by composing all view elements and call the template.
	 * 
	 * @param view The main view element of the app to generate.
	 * @param startableWorkflowElements A list of startable workflow elements.
	 * @return The file content.
	 */
	static def generateClass(View view, Iterable<WorkflowElementReference> startableWorkflowElements) {
		var viewElements = newArrayList
		var viewElementNames = newArrayList
		
		for (rootView : view.viewElements.filter(ViewElementType)) {
			getSubGUIElementsRecursive(rootView, viewElements)
		}
		
		// Retrieve name once to increase performance
		for(i : 0..<viewElements.length){
			if(viewElements.get(i).name !== null){
				viewElementNames.add(MD2GeneratorUtil.getName(viewElements.get(i)).toFirstUpper)
			}
		}
		
		// Add buttons for every startable workflow element
		for(wfe : startableWorkflowElements){
			viewElementNames.add("__startScreen_Button_" + wfe.workflowElementReference.name)
		}
		
		return generateClassContent(viewElementNames)
	}
	
	/**
	 * Adds all layout containers and content elements within a view element to a provided container.
	 * 
	 * @param element The view element to analyze
	 * @param targetContainer The list of view elements to add newly found elements recursively. 
	 */
	static def void getSubGUIElementsRecursive(ViewElementType element, Collection<ViewElementType> targetContainer) {
		switch element {
			ViewGUIElement: {
				switch (element) {
					ContainerElement: {
						targetContainer.add(element)
						switch (element) {
							GridLayoutPane, 
							FlowLayoutPane: element.elements.forEach[ elem | 
								getSubGUIElementsRecursive(elem, targetContainer)
							]
							AlternativesPane,
							TabbedAlternativesPane: element.elements.forEach[ elem | 
								if(elem instanceof ContainerElement) {
									getSubGUIElementsRecursive(elem, targetContainer)
								} else if (elem instanceof ContainerElementReference){
									getSubGUIElementsRecursive(elem.value, targetContainer)	
								}
							]
						}
					}
					ContentElement: {
						targetContainer.add(element)
					}
				}
			}
			ViewGUIElementReference: {
				getSubGUIElementsRecursive(element.value, targetContainer) 
			}
		}
	}
	
	/**
	 * Template to output the MD2WidgetMapping type.
	 * 
	 * @param workflowEvents A list of all view element names in the MD2 model.
	 * @return The file content.
	 */
	static def generateClassContent(Iterable<String> viewElementNames) '''
«IOSGeneratorUtil.generateClassHeaderComment("WorkflowEvent", MethodHandles.lookup.lookupClass)»

/**
    Enumeration type to identify all view elements in the app.
    
    **IMPORTANT** Needed for the identification of widgets and views (widgetId) which can only be passed as integer type due to platform restrictions on the widget tags.
*/
enum MD2WidgetMapping: Int {
    
    case NotFound = 0
	case Spacer = 1 // Dummy because spacers have no given name
    case __startScreen = 2
    case __startScreen_Label = 3
    «FOR i : 4..viewElementNames.length + 3»
    case «viewElementNames.get(i - 4)» = «i»
    «ENDFOR»
    
    /**
        There is currently no introspection into enums.
        Therefore computed property to establish a link of type enum -> string representation.
    */
    var description: String {
        switch self {
        case .Spacer: return "Spacer"
        case .__startScreen: return "__startScreen"
        case .__startScreen_Label: return "__startScreen_Label"
        «FOR i : 4..viewElementNames.length + 3»
        case .«viewElementNames.get(i - 4)»: return "«viewElementNames.get(i - 4)»"
    	«ENDFOR»
    	default: return "NotFound"
        }
    }
    
    /**
        There is currently no introspection into enums.
        Therefore static method to establish a backward link of type raw int value -> enum.
    */
    static func fromRawValue(value: Int) -> MD2WidgetMapping {
        switch(value){
        case 1: return .Spacer
        case 2: return .__startScreen
        case 4: return .__startScreen_Label
    	«FOR i : 4..viewElementNames.length + 3»
    	case «i»: return .«viewElementNames.get(i - 4)»
    	«ENDFOR»
    	default: return .NotFound
        }
    }
}
	'''
}