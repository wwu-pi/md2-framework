package de.wwu.md2.framework.generator.ios.view

import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.Style
import de.wwu.md2.framework.mD2.ViewElement
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import java.util.Map
import de.wwu.md2.framework.mD2.StyleDefinition
import de.wwu.md2.framework.mD2.StyleAssignment
import de.wwu.md2.framework.mD2.StyleReference
import de.wwu.md2.framework.mD2.StyleBody

class IOSView {
	
	static Map<String, Style> styles = newHashMap
	
	def static String generateView(ContainerElement rootView, Iterable<Style> styles){
		// Prepare styles
		styles.forEach[ style |
			IOSView.styles.put(style.name, style)
		]
		
		return generateViewElement(rootView, null)
	}
	
	def static String generateViewElement(ViewElement element, ContainerElement container) {
		switch element {
			ViewGUIElement:	return generateViewGUIElement(element, container)
			ViewGUIElementReference: return generateViewGUIElement((element as ViewGUIElementReference).value, container)
			default: {
				GeneratorUtil.printError("IOSView encountered unknown ViewElement: " + element)
				return ""
			}
		}
	}
	
	def static String generateViewGUIElement(ViewGUIElement element, ContainerElement container) {
		switch element {
			ContainerElement: return generateContainerElement(element, container)
			ContentElement:	return generateContentElement(element, container)
			default: {
				GeneratorUtil.printError("IOSView encountered unknown ViewGUIElement: " + element)
				return ""
			}
		}
	}
	
	def static String generateContainerElement(ContainerElement element, ContainerElement container) {
		switch element {
			GridLayoutPane: return generateGridLayoutPane(element, container)
			FlowLayoutPane:	return generateFlowLayoutPane(element, container)
			//AlternativesPane: return generateAlternative(element, container)
			//TabbedAlternativesPane: return generateTabbedALternativesPane(element, container)
			default: {
				GeneratorUtil.printError("IOSView encountered unsupported ContainerElement: " + element)
				return ""
			}
		}
	}
	
	def static String generateContentElement(ContentElement element, ContainerElement container) {
		switch element {
			Spacer: return generateSpacer(element, container)
			Label:	return generateLabel(element, container)
			default: {
				GeneratorUtil.printError("IOSView encountered unsupported ContentElement: " + element)
				return ""
			}
		}
	}
	
	// Container elements
	def static String generateGridLayoutPane(GridLayoutPane element, ContainerElement container) '''
	let locationDetectionView_addressData = GridLayoutPane(widgetId: WidgetMapping.LocationDetectionView_AddressData)
	locationDetectionView_addressData.columns = MD2Integer(2)
	locationDetectionView.addWidget(locationDetectionView_addressData)
	
	// TODO	
	«IF container != null»
	«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«IOSWidgetMapping.fullPathForViewElement(element)»)
	«ENDIF»
	
	'''
	
	def static String generateFlowLayoutPane(FlowLayoutPane element, ContainerElement container) '''
	let locationDetectionView = FlowLayoutPane(widgetId: WidgetMapping.LocationDetectionView)
	locationDetectionView.orientation = FlowLayoutPane.Orientation.Vertical
	
	// TODO
	«IF container != null»
	«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«IOSWidgetMapping.fullPathForViewElement(element)»)
	«ENDIF»
	
	'''
	
	// Content elements
	def static String generateSpacer(Spacer element, ContainerElement container) '''
	let «IOSWidgetMapping.fullPathForViewElement(element)» = SpacerWidget(widgetId: WidgetMapping.«IOSWidgetMapping.fullPathForViewElement(element)»)
	«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«IOSWidgetMapping.fullPathForViewElement(element)»)
	
	'''
	
	def static String generateLabel(Label element, ContainerElement container) '''
	let «val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element)» = LabelWidget(widgetId: WidgetMapping.«qualifiedName»)
	
	«qualifiedName».value = MD2String(«element.text»)
	«generateStyles(qualifiedName, element.style)»
	«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
	widgetRegistry.add(WidgetWrapper(widget: «qualifiedName»))
	
	'''
	
	def static String generateStyles(String elementName, StyleAssignment style) {
		// No style -> skip
		if(style == null) return ""
		
		// Style reference
		var StyleBody styleBody = null
		if(style instanceof StyleReference) {
			styleBody = style.reference.body
		} else if(style instanceof StyleDefinition) {
			styleBody = style.definition
		}
		
		var result = ""
		result += elementName + ".textSize = MD2Float(" + styleBody.fontSize + ")\n"
		if(styleBody.color != null) {
			result += elementName + '.color = MD2String("' + styleBody.color + '")\n'
		}
		
		if(styleBody.italic && styleBody.bold) {
			result += elementName + ".textStyle = WidgetTextStyle.BoldItalic\n"	
		} else if(styleBody.italic){
			result += elementName + ".textStyle = WidgetTextStyle.Italic\n"
		} else if(styleBody.italic){
			result += elementName + ".textStyle = WidgetTextStyle.Bold\n"
		}
		return result
	}
}