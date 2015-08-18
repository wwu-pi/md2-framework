package de.wwu.md2.framework.generator.ios.view

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.mD2.BooleanInput
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.DateInput
import de.wwu.md2.framework.mD2.DateTimeInput
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.HexColorDef
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.NumberInput
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.Style
import de.wwu.md2.framework.mD2.StyleAssignment
import de.wwu.md2.framework.mD2.StyleBody
import de.wwu.md2.framework.mD2.StyleDefinition
import de.wwu.md2.framework.mD2.StyleReference
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TimeInput
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewElement
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WidthParam
import java.util.Map

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
			Image:	return generateImage(element, container)
			Button:	return generateButton(element, container)
			Tooltip: return "" // Tooltips are no separate elements in iOS // TODO
			BooleanInput: return generateBooleanInput(element, container)
			TextInput: return generateTextInput(element, container)
			IntegerInput: return generateIntegerInput(element, container)
			NumberInput: return generateNumberInput(element, container)
			DateInput: return generateDateInput(element, container)
			TimeInput: return generateTimeInput(element, container)
			DateTimeInput: return generateDateTimeInput(element, container)
			OptionInput: return generateOptionInput(element, container)
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
		
		«««Generate Subelements»»
		«FOR subElem : element.elements»
		«generateViewElement(subElem, element)»
		«ENDFOR»
		
	'''
	
	def static String generateFlowLayoutPane(FlowLayoutPane element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = FlowLayoutPane(widgetId: WidgetMapping.«qualifiedName»)
		
		«IF element.params.filter(FlowLayoutPaneFlowDirectionParam).length > 0»
		«qualifiedName».orientation = FlowLayoutPane.Orientation.«element.params.filter(FlowLayoutPaneFlowDirectionParam).get(0).flowDirection.literal.toLowerCase.toFirstUpper»
		«ELSE»
		«qualifiedName».orientation = FlowLayoutPane.Orientation.Horizontal
		«ENDIF»	
		
		«IF element.params.filter(WidthParam).length > 0»
		«qualifiedName».width = Float(0.«element.params.filter(WidthParam).get(0).width»)
		«ENDIF»	
		
		«IF container != null»
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«IOSWidgetMapping.fullPathForViewElement(element)»)
		«ENDIF»
		
		«««Generate Subelements»»
		«FOR subElem : element.elements»
		«generateViewElement(subElem, element)»
		«ENDFOR»
		
	'''
	
	// Content elements
	def static String generateSpacer(Spacer element, ContainerElement container) '''
		«««Spacers have no name»»
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(container).toFirstLower + "_Spacer" + GeneratorUtil.randomId()»
		let «qualifiedName» = SpacerWidget(widgetId: WidgetMapping.Spacer)
		
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		
		
	'''
	
	def static String generateLabel(Label element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = LabelWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2String("«element.text»")
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«generateStyles(qualifiedName, element.style)»
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		widgetRegistry.add(WidgetWrapper(widget: «qualifiedName»))
		
		
	'''
	
	def static String generateImage(Image element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = ImageWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2String("«element.src»")
		
		«IF element.height > 0»
			«qualifiedName».height = Float(«element.height»)
		«ELSEIF element.imgHeight > 0»
			«qualifiedName».height = Float(«element.imgHeight»)
		«ENDIF»
		
		«IF element.imgWidth > 0»
			«qualifiedName».width= Float(«element.imgWidth»)
		«ELSEIF element.width> 0»
			«qualifiedName».width= Float(«element.width»)
		«ENDIF»
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		widgetRegistry.add(WidgetWrapper(widget: «qualifiedName»))
		
		
	'''
	
	// TODO
	def static String generateButton(Button element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = LabelWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2String("«element.text»")
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«generateStyles(qualifiedName, element.style)»
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	def static String generateBooleanInput(BooleanInput element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = SwitchWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«IF element.isDisabled»«qualifiedName».disable()«ENDIF»
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«qualifiedName».tooltip = MD2String("«element.tooltipText»")
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	// TODO textInputType keyword 
	def static String generateTextInput(TextInput element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = LabelWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2String("«element.defaultValue»")
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«qualifiedName».tooltip = MD2String("«element.tooltipText»")
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
	'''
	
	// TODO add validator
	def static String generateIntegerInput(IntegerInput element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = TextFieldWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2Integer(«element.defaultValue»)
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«qualifiedName».tooltip = MD2String("«element.tooltipText»")
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	// TODO add validator
	// TODO places keyword
	def static String generateNumberInput(NumberInput element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = TextFieldWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2Float(Float(«element.defaultValue»))
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«qualifiedName».tooltip = MD2String("«element.tooltipText»")
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	def static String generateDateInput(DateInput element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = DateTimePickerWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2String(«element.defaultValue»)
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«qualifiedName».tooltip = MD2String("«element.tooltipText»")
		«qualifiedName».pickerMode = UIDatePickerMode.Date
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	def static String generateTimeInput(TimeInput element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = DateTimePickerWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2String(«element.defaultValue»)
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«qualifiedName».tooltip = MD2String("«element.tooltipText»")
		«qualifiedName».pickerMode = UIDatePickerMode.Time
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	def static String generateDateTimeInput(DateTimeInput element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = DateTimePickerWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2String(«element.defaultValue»)
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«qualifiedName».tooltip = MD2String("«element.tooltipText»")
		«qualifiedName».pickerMode = UIDatePickerMode.DateAndTime
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	def static String generateOptionInput(OptionInput element, ContainerElement container) '''
		«val qualifiedName = IOSWidgetMapping.fullPathForViewElement(element).toFirstLower»
		let «qualifiedName» = OptionWidget(widgetId: WidgetMapping.«qualifiedName»)
		
		«qualifiedName».value = MD2String(«element.defaultValue»)
		«IF element.width > 0»«qualifiedName».width = Float(0.«element.width»)«ENDIF»
		«qualifiedName».tooltip = MD2String("«element.tooltipText»")
		
		«IF element.enumReference != null»
		«qualifiedName».options = «Settings.PREFIX_ENUM + element.enumReference.name.toFirstUpper».EnumType.getAllValues()
		«ELSE»
		«qualifiedName».options = [«FOR option : element.enumBody.elements SEPARATOR ", "»«option»«ENDFOR»]
		«ENDIF»
		
		«IOSWidgetMapping.fullPathForViewElement(container)».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''

	// Styling
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
			if(styleBody.color instanceof HexColorDef){
				result += elementName + '.color = MD2String("' + (styleBody.color as HexColorDef).color + '")\n'
			} else {
				GeneratorUtil.printError("IOSView encountered unsupported style: " + styleBody.color)
			}
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