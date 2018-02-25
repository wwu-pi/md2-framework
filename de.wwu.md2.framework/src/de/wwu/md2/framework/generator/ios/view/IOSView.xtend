package de.wwu.md2.framework.generator.ios.view

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.BooleanInput
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.DateInput
import de.wwu.md2.framework.mD2.DateTimeInput
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
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
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewFrame
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WidthParam
import java.util.Map

/**
 * Generate the definition of the view element hierarchy for the MD2Controller class.
 */
class IOSView {
	
	/**
	 * A list of known styles to facilitate view element styling.
	 */
	static Map<String, Style> styles = newHashMap
	
	/**
	 * Entry point for the view generation.
	 * 
	 * @param rootView The rootView to generate.
	 * @param styles A list of all styles used within the app.
	 * @return The view declaration block for the MD2Controller class.
	 */
	def static String generateView(ViewFrame frame, Iterable<Style> styles){
		// Prepare styles
		styles.forEach[ style |
			IOSView.styles.put(style.name, style)
		]
		
		return generateViewElement(frame.elements.get(0), null) // TODO generate all elements
	}
	
	/**
	 * Generate an abstract view element declaration.
	 * 
	 * @param element The view element to generate.
	 * @param container The container element to the current view element (if exists).
	 * @return The Swift code to programmatically create the view element.
	 */
	def static String generateViewElement(ViewElementType element, ContainerElement container) {
		switch element {
			ViewGUIElement:	return generateViewGUIElement(element, container)
			ViewGUIElementReference: return generateViewGUIElement(element.value, container)
			default: {
				IOSGeneratorUtil.printError("IOSView encountered unknown ViewElement: " + element)
				return ""
			}
		}
	}
	
	/**
	 * Generate a view element declaration, either a container element or a content element.
	 * 
	 * @param element The view element to generate.
	 * @param container The container element to the current view element (if exists).
	 * @return The Swift code to programmatically create the view element.
	 */
	def static String generateViewGUIElement(ViewGUIElement element, ContainerElement container) {
		switch element {
			ContainerElement: return generateContainerElement(element, container)
			ContentElement:	return generateContentElement(element, container)
			default: {
				IOSGeneratorUtil.printError("IOSView encountered unknown ViewGUIElement: " + element)
				return ""
			}
		}
	}
	
	/**
	 * Generate a container element declaration, including its contained elements.
	 * 
	 * TODO Currently, only grid layouts and flow layouts are supported.
	 * 
	 * @param element The container element to generate.
	 * @param container The container element to the current element (if exists).
	 * @return The Swift code to programmatically create the container element and its sub-elements.
	 */
	def static String generateContainerElement(ContainerElement element, ContainerElement container) {
		switch element {
			GridLayoutPane: return generateGridLayoutPane(element, container)
			FlowLayoutPane:	return generateFlowLayoutPane(element, container)
			//AlternativesPane: return generateAlternative(element, container)
			//TabbedAlternativesPane: return generateTabbedALternativesPane(element, container)
			default: {
				IOSGeneratorUtil.printError("IOSView encountered unsupported ContainerElement: " + element)
				return ""
			}
		}
	}
	
	/**
	 * Generate a content element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateContentElement(ContentElement element, ContainerElement container) {
		switch element {
			Spacer: return generateSpacer(element, container)
			Label:	return generateLabel(element, container)
			Image:	return generateImage(element, container)
			Button:	return generateButton(element, container)
			// Tooltips are no separate elements in iOS ->
			// nothing to do (tooltips are dealt with in respective widget methods)
			Tooltip: return ""
			BooleanInput: return generateBooleanInput(element, container)
			TextInput: return generateTextInput(element, container)
			IntegerInput: return generateIntegerInput(element, container)
			NumberInput: return generateNumberInput(element, container)
			DateInput: return generateDateInput(element, container)
			TimeInput: return generateTimeInput(element, container)
			DateTimeInput: return generateDateTimeInput(element, container)
			OptionInput: return generateOptionInput(element, container)
			default: {
				IOSGeneratorUtil.printError("IOSView encountered unsupported ContentElement: " + element)
				return ""
			}
		}
	}
	
	/**
	 * Generate a grid layout declaration including sub-elements.
	 * 
	 * @param element The grid layout element to generate.
	 * @param container The container element to the current grid layout element.
	 * @return The Swift code to programmatically create the container element and its contained elements.
	 */
	def static String generateGridLayoutPane(GridLayoutPane element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2GridLayoutPane(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Grid columns»»»
		«IF qualifiedName.startsWith("__Container") && element.params.filter(GridLayoutPaneColumnsParam).length > 0»
		«««This is an autogenerated tooltip container which will add a unused tooltip element in the grid»»»
		«qualifiedName».columns = MD2Integer(«element.params.filter(GridLayoutPaneColumnsParam).get(0).value - 1»)
		«ELSEIF element.params.filter(GridLayoutPaneColumnsParam).length > 0»
		«qualifiedName».columns = MD2Integer(«element.params.filter(GridLayoutPaneColumnsParam).get(0).value»)
		«ENDIF»
		«««Grid rows»»»
		«IF element.params.filter(GridLayoutPaneRowsParam).length > 0»
		«qualifiedName».rows = MD2Integer(«element.params.filter(GridLayoutPaneRowsParam).get(0).value»)
		«ENDIF»
		«««Element width»»»
		«IF element.params.filter(WidthParam).length > 0 && element.params.filter(WidthParam).get(0).width > 0»
		«qualifiedName».width = Float(1/100 * «element.params.filter(WidthParam).get(0).width»)
		«ENDIF»	
		«««Add to surrounding container»»»
		«IF container !== null»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«MD2GeneratorUtil.getName(element).toFirstLower»)
		«ENDIF»
		«««Generate Subelements»»
		«FOR subElem : element.elements»
		«generateViewElement(subElem, element)»
		«ENDFOR»
		
		
	'''
	
	/**
	 * Generate a flow layout declaration including sub-elements.
	 * 
	 * @param element The flow layout element to generate.
	 * @param container The container element to the current flow layout element.
	 * @return The Swift code to programmatically create the container element  and its contained elements.
	 */
	def static String generateFlowLayoutPane(FlowLayoutPane element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2FlowLayoutPane(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Flow orientation»»»
		«IF element.params.filter(FlowLayoutPaneFlowDirectionParam).length > 0»
		«qualifiedName».orientation = MD2FlowLayoutPane.Orientation.«element.params.filter(FlowLayoutPaneFlowDirectionParam).get(0).flowDirection.literal.toLowerCase.toFirstUpper»
		«ELSE»
		«qualifiedName».orientation = MD2FlowLayoutPane.Orientation.Horizontal
		«ENDIF»	
		«««Element width»»»
		«IF element.params.filter(WidthParam).length > 0 && element.params.filter(WidthParam).get(0).width > 0»
		«qualifiedName».width = Float(1/100 * «element.params.filter(WidthParam).get(0).width»)
		«ENDIF»	
		«««Add to surrounding container»»»
		«IF container !== null»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«MD2GeneratorUtil.getName(element).toFirstLower»)
		«ENDIF»
		«««Generate Subelements»»
		«FOR subElem : element.elements»
		«generateViewElement(subElem, element)»
		«ENDFOR»
		
		
	'''
	
	/**
	 * Generate a spacer element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateSpacer(Spacer element, ContainerElement container) '''
		«««Spacers have no name»»
		«val qualifiedName = MD2GeneratorUtil.getName(container).toFirstLower + "_Spacer" + MD2GeneratorUtil.getName(element)»
		let «qualifiedName» = MD2SpacerWidget(widgetId: MD2WidgetMapping.Spacer)
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate a label element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateLabel(Label element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2LabelWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2String("«element.text»")
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«««Generate styles»»»
		«generateStyles(qualifiedName, element.style)»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		widgetRegistry.add(MD2WidgetWrapper(widget: «qualifiedName»))
		
		
	'''
	
	/**
	 * Generate an image element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateImage(Image element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2ImageWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2String("«element.src»")
		«««Element height»»»
		«IF element.height > 0»
			«qualifiedName».height = Float(«element.height»)
		«ELSEIF element.imgHeight > 0»
			«qualifiedName».height = Float(«element.imgHeight»)
		«ENDIF»
		«««Element width»»»
		«IF element.imgWidth > 0»
			«qualifiedName».width = Float(«element.imgWidth»)
		«ELSEIF element.width> 0»
			«qualifiedName».width = Float(«element.width»)
		«ENDIF»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		widgetRegistry.add(MD2WidgetWrapper(widget: «qualifiedName»))
		
		
	'''
	
	/**
	 * Generate a button element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateButton(Button element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2ButtonWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2String("«element.text»")
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«««Generate styles»»»
		«generateStyles(qualifiedName, element.style)»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate a boolean input element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateBooleanInput(BooleanInput element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2SwitchWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«IF element.tooltipText !== null && element.tooltipText != ""»«qualifiedName».tooltip = MD2String("«element.tooltipText»")«ENDIF»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate a spacer text input element declaration.
	 * TODO Add support for the "textInputType" attribute.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */ 
	def static String generateTextInput(TextInput element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2TextFieldWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2String("«element.defaultValue»")
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«IF element.tooltipText !== null && element.tooltipText != ""»«qualifiedName».tooltip = MD2String("«element.tooltipText»")«ENDIF»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate a integer input element declaration.
	 * // TODO There is no IsIntegerValidator, therefore check is added against numeric values.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateIntegerInput(IntegerInput element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2TextFieldWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2Integer(«element.defaultValue»)
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«IF element.tooltipText !== null && element.tooltipText != ""»«qualifiedName».tooltip = MD2String("«element.tooltipText»")«ENDIF»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		wrapper_«qualifiedName».addValidator(MD2IsNumberValidator(identifier: MD2String("«qualifiedName»_auto_number"), 
				message: nil))
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate a number input element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateNumberInput(NumberInput element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2TextFieldWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2Float(Float(«element.defaultValue»))
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«IF element.tooltipText !== null && element.tooltipText != ""»«qualifiedName».tooltip = MD2String("«element.tooltipText»")«ENDIF»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		wrapper_«qualifiedName».addValidator(MD2IsNumberValidator(identifier: MD2String("«qualifiedName»_auto_number"), 
				message: nil))
		«IF element.places > 0»
			wrapper_«qualifiedName».addValidator(MD2StringRangeValidator(identifier: MD2String("«qualifiedName»_auto_places"), 
				message: nil, 
				minLength: MD2Integer(0), 
				maxLength: MD2Integer(«element.places»)))
		«ENDIF»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate a date input element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateDateInput(DateInput element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2DateTimePickerWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2String(«element.defaultValue»)
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«IF element.tooltipText !== null && element.tooltipText != ""»«qualifiedName».tooltip = MD2String("«element.tooltipText»")«ENDIF»
		«qualifiedName».pickerMode = UIDatePickerMode.Date
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate a time element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateTimeInput(TimeInput element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2DateTimePickerWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2String(«element.defaultValue»)
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«IF element.tooltipText !== null && element.tooltipText != ""»«qualifiedName».tooltip = MD2String("«element.tooltipText»")«ENDIF»
		«qualifiedName».pickerMode = UIDatePickerMode.Time
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate a datetime input element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateDateTimeInput(DateTimeInput element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2DateTimePickerWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2String(«element.defaultValue»)
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«IF element.tooltipText !== null && element.tooltipText != ""»«qualifiedName».tooltip = MD2String("«element.tooltipText»")«ENDIF»
		«qualifiedName».pickerMode = UIDatePickerMode.DateAndTime
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''
	
	/**
	 * Generate an option input element declaration.
	 * 
	 * @param element The content element to generate.
	 * @param container The container element to the current view element.
	 * @return The Swift code to programmatically create the content element.
	 */
	def static String generateOptionInput(OptionInput element, ContainerElement container) '''
		«val qualifiedName = MD2GeneratorUtil.getName(element).toFirstLower»
		let «qualifiedName» = MD2OptionWidget(widgetId: MD2WidgetMapping.«qualifiedName.toFirstUpper»)
		«««Set initial value»»»
		«qualifiedName».value = MD2String(«element.defaultValue»)
		«««Element width»»»
		«IF element.width < 100»«qualifiedName».width = Float(1/100 * «element.width»)«ENDIF»
		«IF element.tooltipText !== null && element.tooltipText != ""»«qualifiedName».tooltip = MD2String("«element.tooltipText»")«ENDIF»
		«««Set available options»»»
		«IF element.enumReference !== null»
		«qualifiedName».options = «Settings.PREFIX_ENUM + element.enumReference.name.toFirstUpper».EnumType.getAllValues()
		«ELSE»
		«qualifiedName».options = [«FOR option : element.enumBody.elements SEPARATOR ", "»«option»«ENDFOR»]
		«ENDIF»
		«««Add to surrounding container»»»
		«MD2GeneratorUtil.getName(container).toFirstLower».addWidget(«qualifiedName»)
		let wrapper_«qualifiedName» = MD2WidgetWrapper(widget: «qualifiedName»)
		wrapper_«qualifiedName».isElementDisabled = «element.isDisabled»
		widgetRegistry.add(wrapper_«qualifiedName»)
		
		
	'''

	/**
	 * Generate styling information to an already defined content element.
	 * 
	 * @param elementName The Swift variable name.
	 * @param style The style to add.
	 * @return The Swift code for styling the element.
	 */
	def static String generateStyles(String elementName, StyleAssignment style) {
		// No style -> skip
		if(style === null) return ""
		
		// Style reference
		var StyleBody styleBody = null
		if(style instanceof StyleReference) {
			styleBody = style.reference.body
		} else if(style instanceof StyleDefinition) {
			styleBody = style.definition
		}
		
		var result = ""
		if(styleBody.fontSize > 0) {
			result += elementName + ".fontSize = MD2Float(" + styleBody.fontSize + ")\n"
		}
		
		if(styleBody.color !== null) {
			if(styleBody.color instanceof HexColorDef){
				result += elementName + '.color = MD2String("' + (styleBody.color as HexColorDef).color + '")\n'
			} else {
				IOSGeneratorUtil.printError("IOSView encountered unsupported style: " + styleBody.color)
			}
		}
		
		if(styleBody.italic && styleBody.bold) {
			result += elementName + ".textStyle = MD2WidgetTextStyle.BoldItalic\n"	
		} else if(styleBody.italic){
			result += elementName + ".textStyle = MD2WidgetTextStyle.Italic\n"
		} else if(styleBody.italic){
			result += elementName + ".textStyle = MD2WidgetTextStyle.Bold\n"
		}
		return result
	}
}