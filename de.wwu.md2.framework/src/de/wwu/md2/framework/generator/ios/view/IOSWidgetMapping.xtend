package de.wwu.md2.framework.generator.ios.view

import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContainerElementReference
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.SubViewContainer
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.impl.ViewImpl
import java.lang.invoke.MethodHandles
import java.util.Collection

class IOSWidgetMapping {
	
	static def generateClass(View view) {
		var viewElements = newArrayList
		var viewElementNames = newArrayList
		
		for (rootView : view.viewElements.filter(ViewElementType)) {
			getSubGUIElementsRecursive(rootView, viewElements)
		}
		
		// Retrieve name once to increase performance
		for(i : 0..<viewElements.length){
			if(viewElements.get(i).name != null){
				viewElementNames.add(fullPathForViewElement(viewElements.get(i)).toFirstUpper)
			}
		}
		
		return generateClassContent(viewElementNames)
	}
	
	static def void getSubGUIElementsRecursive(ViewElementType element, Collection<ViewElementType> targetContainer) {
		switch element {
			ViewGUIElement: {
				switch (element as ViewGUIElement) {
					ContainerElement: {
						targetContainer.add(element as ContainerElement)
						switch (element as ContainerElement) {
							GridLayoutPane, 
							FlowLayoutPane: (element as ContentContainer).elements.forEach[ elem | 
								getSubGUIElementsRecursive(elem, targetContainer)
							]
							AlternativesPane,
							TabbedAlternativesPane: (element as SubViewContainer).elements.forEach[ elem | 
								if(elem instanceof ContainerElement) {
									getSubGUIElementsRecursive(elem as ContainerElement, targetContainer)
								} else if (elem instanceof ContainerElementReference){
									getSubGUIElementsRecursive(elem.value, targetContainer)	
								}
							]
						}
					}
					ContentElement: {
						targetContainer.add(element as ContentElement)
					}
				}
			}
			ViewGUIElementReference: {
				getSubGUIElementsRecursive((element as ViewGUIElementReference).value, targetContainer) 
			}
		}
	}
	
	static def generateClassContent(Iterable<String> viewElementNames) '''
«GeneratorUtil.generateClassHeaderComment("WorkflowEvent", MethodHandles.lookup.lookupClass)»

enum WidgetMapping: Int {
    
    // A list of all widget elements used in the application
    // Needed for the identification of widgets and views (widgetId) which can only be of integer type due to platform restrictions on the widget tags
	case NotFound = 0
	case Spacer = 1 // Dummy because spacers have no given name
    «FOR i : 2..viewElementNames.length»
    case «viewElementNames.get(i - 2)» = «i»
    «ENDFOR»
    
    // There is currently no introspection into enums
    // Therefore computed property to establish a link of type enum -> string representation
    var description: String {
        switch self {
        case .Spacer: return "Spacer"
        «FOR i : 2..viewElementNames.length»
        case .«viewElementNames.get(i - 2)»: return "«viewElementNames.get(i - 2)»"
    	«ENDFOR»
    	default: return "NotFound"
        }
    }
    
    // There is currently no introspection into enums
    // Therefore static method to establish a backward link of type raw int value -> enum
    static func fromRawValue(value: Int) -> WidgetMapping {
        switch(value){
        case 1: return .Spacer
    	«FOR i : 2..viewElementNames.length»
    	case «i»: return .«viewElementNames.get(i - 2)»
    	«ENDFOR»
    	default: return .NotFound
        }
    }
}
	'''
	
	// Lookup real widget name for view element
	def static lookup(AbstractViewGUIElementRef ref) {
		return fullPathForViewElement(ref.ref)
	}
	
	def static String fullPathForViewElement(ViewElementType element) {
		if(element.eContainer instanceof ViewImpl) {
			// Stop
			return element.name
		} else if (element.name == null) {
			// Special case for elements like spacers which have no identifier
			return null
		} else {
			return fullPathForViewElement(element.eContainer as ViewElementType) + "_" + element.name 
		}
	}
	
}