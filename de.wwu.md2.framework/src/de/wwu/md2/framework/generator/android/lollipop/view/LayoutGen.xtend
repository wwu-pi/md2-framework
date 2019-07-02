package de.wwu.md2.framework.generator.android.lollipop.view

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.common.util.MD2AndroidUtil
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.BooleanInput
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.FlowDirection
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.ListView
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.InputType
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewFrame
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WidthParam
import de.wwu.md2.framework.mD2.WorkflowElementReference
import java.io.StringWriter
import javax.xml.parsers.DocumentBuilderFactory
import javax.xml.transform.OutputKeys
import javax.xml.transform.TransformerFactory
import javax.xml.transform.dom.DOMSource
import javax.xml.transform.stream.StreamResult
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.w3c.dom.Document
import org.w3c.dom.Element

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class LayoutGen {
	
	final static String elementMarginBottom = "20dp"

	def static generateLayouts(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ViewFrame> rootViews, Iterable<WorkflowElementReference> startableWorkflowElements) {
			
		fsa.generateFile(rootFolder + Settings.LAYOUT_PATH + "activity_start.xml",
				generateStartLayout(mainPackage, startableWorkflowElements))
				
		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.LAYOUT_PATH + "activity_" + rv.name.toLowerCase + ".xml",
				generateLayout(mainPackage, rv))
		]
	}

	
	protected static def generateStartLayout(String mainPackage, Iterable<WorkflowElementReference> wfes) {
		val docFactory = DocumentBuilderFactory.newInstance
		val docBuilder = docFactory.newDocumentBuilder

		// create doc and set namespace definitions
		val doc = docBuilder.newDocument
		val generationComment = doc.createComment("generated in de.wwu.md2.framework.generator.android.lollipop.view.Layout.generateStartLayout()")
		doc.appendChild(generationComment)

		// create root element
		var Element rootElement = doc.createElement("ScrollView")
		
		// set attributes
		rootElement.setAttribute("android:paddingBottom", "@dimen/activity_vertical_margin")
		rootElement.setAttribute("android:paddingLeft", "@dimen/activity_horizontal_margin")
		rootElement.setAttribute("android:paddingRight", "@dimen/activity_horizontal_margin")
		rootElement.setAttribute("android:paddingTop", "@dimen/activity_vertical_margin")
		rootElement.setAttribute("android:layout_height", "match_parent")
		rootElement.setAttribute("android:layout_width", "match_parent")
		rootElement.setAttribute("android:orientation", "vertical")		
		rootElement.setAttribute("tools:context", mainPackage + ".StartActivity")

		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools", "http://schemas.android.com/tools")

		doc.appendChild(rootElement)
		
		var Element rootContainer = doc.createElement(Settings.MD2LIBRARY_VIEW_FLOWLAYOUTPANE)
		rootContainer.setAttribute("android:layout_height", "wrap_content")
		rootContainer.setAttribute("android:layout_width", "match_parent")
		rootContainer.setAttribute("android:orientation", "vertical")		
		rootElement.appendChild(rootContainer)
		
		// add buttons
		for(wfe : wfes){
			var btnElement = doc.createElement(Settings.MD2LIBRARY_VIEW_BUTTON)
			btnElement.setAttribute("android:id", "@id/startActivity_" + wfe.workflowElementReference.name + "Button")
 			btnElement.setAttribute("android:layout_width", "match_parent")
 			btnElement.setAttribute("android:layout_height", "wrap_content")
 			btnElement.setAttribute("android:layout_gravity", "fill_horizontal")
 			btnElement.setAttribute("android:text", "@string/" + MD2AndroidUtil.getQualifiedNameAsString(wfe.workflowElementReference, "_") + "_alias")
 			rootContainer.appendChild(btnElement);
		}

		// return xml file as string
		val transformerFactory = TransformerFactory.newInstance
		val transformer = transformerFactory.newTransformer
		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes")
		val writer = new StringWriter
		transformer.transform(new DOMSource(doc), new StreamResult(writer))
		return writer.buffer.toString
	}

	protected static def generateLayout(String mainPackage, ViewFrame frame) {
		val docFactory = DocumentBuilderFactory.newInstance
		val docBuilder = docFactory.newDocumentBuilder

		// create doc and set namespace definitions
		val doc = docBuilder.newDocument
		val generationComment = doc.createComment("generated in de.wwu.md2.framework.generator.android.lollipop.view.Layout.generateLayout()")
		doc.appendChild(generationComment)

		var rootElement = doc.createElement("ScrollView")
		
		// special settings for root attributes
		rootElement.setAttribute("android:layout_width", "match_parent")
		rootElement.setAttribute("android:layout_height", "match_parent")
		rootElement.setAttribute("tools:context", mainPackage + "." + frame.name.toFirstUpper + "Activity")
		rootElement.setAttribute("xmlns:md2library", "http://schemas.android.com/apk/res-auto")

		doc.appendChild(rootElement)

		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools", "http://schemas.android.com/tools")

		// Scrollview must have a single child -> wrapper flowlayoutpane
		var wrapperLayout = MD2Factory.eINSTANCE.createFlowLayoutPane
		wrapperLayout.name = frame.name + "__wrapperFlowLayout"
		
		var flowDirection = MD2Factory.eINSTANCE.createFlowLayoutPaneFlowDirectionParam
		flowDirection.flowDirection = FlowDirection.VERTICAL
		wrapperLayout.params.add(flowDirection)
		
		var wrapperElement = createFlowLayoutPaneElement(doc, wrapperLayout)
		wrapperElement.setAttribute("android:paddingBottom", "@dimen/activity_vertical_margin")
		wrapperElement.setAttribute("android:paddingLeft", "@dimen/activity_horizontal_margin")
		wrapperElement.setAttribute("android:paddingRight", "@dimen/activity_horizontal_margin")
		wrapperElement.setAttribute("android:paddingTop", "@dimen/activity_vertical_margin")
		
		rootElement.appendChild(wrapperElement)
		
//		if (frame.elements.filter(ListView).length > 0) {
//			//TODO spezielles Layout für Listview
//			
//			var listElement = doc.createElement("android.support.v7.widget.RecyclerView")
//			listElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
//				"http://schemas.android.com/apk/res/android")
//			listElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools",
//				"http://schemas.android.com/tools")
//			
//			listElement.setAttribute("android:id", "@+id/recycler_view_" + frame.name)
//			listElement.setAttribute("android:layout_width", "match_parent")
//			listElement.setAttribute("android:layout_height", "match_parent")
//			listElement.setAttribute("android:paddingBottom", "@dimen/activity_vertical_margin")
//			listElement.setAttribute("android:paddingLeft", "@dimen/activity_horizontal_margin")
//			listElement.setAttribute("android:paddingRight", "@dimen/activity_horizontal_margin")
//			listElement.setAttribute("android:paddingTop", "@dimen/activity_vertical_margin")
//			listElement.setAttribute("android:scrollbars", "vertical")
//			listElement.setAttribute("tools:context", mainPackage + "." + frame.name + "Activity")
//	
//			wrapperElement.appendChild(listElement)
//			
//			// Generate children
//			for(elem : frame.elements){
//				createChildrenElements(doc, wrapperElement, elem)
//			}
//		} else {
			
			// Generate children
			for(elem : frame.elements){
				createChildrenElements(doc, wrapperElement, elem)
			}
//		}
//			switch frame {
//				FlowLayoutPane: rootContainer = createFlowLayoutPaneElement(doc, frame)
//				GridLayoutPane: rootContainer = createGridLayoutPaneElement(doc, frame)
//				default: return ""
//			}
//			
//			rootContainer.setAttribute("android:layout_width", "match_parent")
//			rootElement.appendChild(rootContainer)
//	
//			// depth first search to generate elements for all children
//			switch frame {
//				ContentContainer:
//					for (elem : frame.elements) {
//						createChildrenElements(doc, rootContainer, elem)
//					}
//				SubViewContainer:
//					for (elem : frame.elements) {
//						switch elem {
//							ContainerElement: createChildrenElements(doc, rootContainer, elem)
//							ContainerElementReference: createChildrenElements(doc, rootContainer, elem.value)
//						}
//					}
//			}
		
		// return xml file as string
		val transformerFactory = TransformerFactory.newInstance
		val transformer = transformerFactory.newTransformer
		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes")
		val writer = new StringWriter
		transformer.transform(new DOMSource(doc), new StreamResult(writer))
		return writer.buffer.toString
	}

	protected static def void createChildrenElements(Document doc, Element parent, ViewElementType viewElement) {
		var Element newElement = null
		switch viewElement {
			ViewGUIElementReference:
				createChildrenElements(doc, parent, viewElement.value)
			FlowLayoutPane: {
				newElement = createFlowLayoutPaneElement(doc, viewElement)
				for (elem : viewElement.elements) {
					createChildrenElements(doc, newElement, elem)
				}
			}
			GridLayoutPane: {
				newElement = createGridLayoutPaneElement(doc, viewElement)
				for (elem : viewElement.elements) {
					createChildrenElements(doc, newElement, elem)
				}
			}
			Button: {
				newElement = createButtonElement(doc, viewElement)
			}
			TextInput: {
				newElement = createTextInputElement(doc, viewElement)
			}
			IntegerInput: {
				newElement = createIntegerInputElement(doc, viewElement)
			}
			Label: {
				if(viewElement.name.startsWith("_title")) { return } // Skip title label
				newElement = createLabelElement(doc, viewElement)
			}
			OptionInput: {
				newElement = createOptionInputElement(doc, viewElement)
			}
			Spacer: {
				newElement = createSpacerElement(doc, viewElement)
			}
			BooleanInput: {
				newElement = createBooleanInputElement(doc, viewElement)
			}
			ListView: {
				newElement = createListViewElement(doc, viewElement)
			}
			default:
				return
		}
		parent.appendChild(newElement)
	}


	protected static def createFlowLayoutPaneElement(Document doc, FlowLayoutPane flp) {
		val flowLayoutPaneElement = doc.createElement(Settings.MD2LIBRARY_VIEW_FLOWLAYOUTPANE)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(flp).toString("_")

		// id
		flowLayoutPaneElement.setAttribute("android:id", "@id/" + qualifiedName)

		// height and width
		flowLayoutPaneElement.setAttribute("android:layout_width", "match_parent")
		flowLayoutPaneElement.setAttribute("android:layout_height", "wrap_content")
		flowLayoutPaneElement.setAttribute("android:layout_gravity", "fill_horizontal")

		// handle parameters
		flp.params.forEach [
			switch it {
				// orientation
				FlowLayoutPaneFlowDirectionParam case it.flowDirection == FlowDirection.VERTICAL:
					flowLayoutPaneElement.setAttribute("android:orientation", "vertical")
				FlowLayoutPaneFlowDirectionParam case it.flowDirection == FlowDirection.HORIZONTAL:
					flowLayoutPaneElement.setAttribute("android:orientation", "horizontal")
			}
		]
		return flowLayoutPaneElement
	}

	protected static def createGridLayoutPaneElement(Document doc, GridLayoutPane glp) {
		// create element
		val glpElement = doc.createElement(Settings.MD2LIBRARY_VIEW_GRIDLAYOUTPANE)		

		// assign id
		val qualifiedName = MD2AndroidUtil.getQualifiedNameAsString(glp, "_")
		glpElement.setAttribute("android:id", "@id/" + qualifiedName)

		// set default width and height
		glpElement.setAttribute("android:layout_height", "wrap_content")
		glpElement.setAttribute("android:layout_width", "match_parent")
		glpElement.setAttribute("android:layout_gravity", "fill_horizontal")
		glpElement.setAttribute("android:layout_marginTop", "5dp")
		glpElement.setAttribute("android:layout_marginBottom", "15dp")
		
		// handle parameters
		glp.params.forEach [ p |
			switch p {
				// orientation
				GridLayoutPaneColumnsParam:
					glpElement.setAttribute("android:columnCount", String.valueOf(p.value))
				GridLayoutPaneRowsParam:
					glpElement.setAttribute("android:rowCount", String.valueOf(p.value))
				// width
				WidthParam case p.width > 0:{
					glpElement.setAttribute("android:layout_columnWeight", String.valueOf(p.width))
					glpElement.getAttributeNode("android:layout_width").nodeValue = "0dp"
				}
			}
		]
		return glpElement
	}

	protected static def createButtonElement(Document doc, Button button) {
		val buttonElement = doc.createElement(Settings.MD2LIBRARY_VIEW_BUTTON)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(button).toString("_")

		// id
		buttonElement.setAttribute("android:id", "@id/" + qualifiedName)

		// height and width
		if(button.width <= 0){
			buttonElement.setAttribute("android:layout_width", "match_parent")
		}else{
			buttonElement.setAttribute("android:layout_width", "0dp")
			buttonElement.setAttribute("android:layout_columnWeight", String.valueOf(button.width))
		}
		
		if(button.focusNext !== null){
			buttonElement.setAttribute("android:nextFocusForward", "@id/" + qnp.getFullyQualifiedName(button.focusNext).toString("_"))
		} // TODO fallback solution when nextFocusForward is not specified -> use next ContentElement (potentially in following containers) 
		
		buttonElement.setAttribute("android:layout_height", "wrap_content")
		buttonElement.setAttribute("android:layout_gravity", "fill_horizontal")
		buttonElement.setAttribute("android:layout_marginBottom", elementMarginBottom)

		// text
		buttonElement.setAttribute("android:text", "@string/" + qualifiedName + "_text")

		// disabled
		var isEnabled = true
		if (button.isDisabled)
			isEnabled = false
			
		// style
		if(!button?.style?.body?.icon.nullOrEmpty){
			buttonElement.setAttribute("android:drawableLeft", "@md2library:drawable/" + button.style.body.icon + "_black")
		}

		buttonElement.setAttribute("android:enabled", String.valueOf(isEnabled))

		return buttonElement
	}

	protected static def createTextInputElement(Document doc, TextInput textInput) {
		val textInputElement = doc.createElement(Settings.MD2LIBRARY_VIEW_TEXTINPUT)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(textInput).toString("_")

		// id
		textInputElement.setAttribute("android:id", "@id/" + qualifiedName)

		if(textInput.width <= 0){
			textInputElement.setAttribute("android:layout_width", "match_parent")
		}else{
			textInputElement.setAttribute("android:layout_width", "0dp")
			textInputElement.setAttribute("android:layout_columnWeight", String.valueOf(textInput.width))
		}
		textInputElement.setAttribute("android:layout_height", "wrap_content")
		textInputElement.setAttribute("android:layout_gravity", "fill_horizontal")
		textInputElement.setAttribute("android:layout_marginBottom", elementMarginBottom)

		textInputElement.setAttribute("android:hint", "@string/" + qualifiedName + "_tooltip")

		textInputElement.setAttribute("android:text", textInput.defaultValue)
		
		// disabled
		var isEnabled = true
		if (textInput.isDisabled)
			isEnabled = false

		textInputElement.setAttribute("android:enabled", String.valueOf(isEnabled))

		// type
		switch textInput {
			case textInput.type == InputType.PASSWORD:
				textInputElement.setAttribute("android:inputType", "textPassword")
			case textInput.type == InputType.TEXTAREA:
				textInputElement.setAttribute("android:inputType",
					"text|textMultiLine")
			default:
				textInputElement.setAttribute("android:inputType", "text")
		}
		
		textInputElement.setAttribute("android:imeOptions","actionDone")

		return textInputElement
	}
	
	protected static def createLabelElement(Document doc, Label label) {
		val labelElement = doc.createElement(Settings.MD2LIBRARY_VIEW_LABEL)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(label).toString("_")

		// id
		labelElement.setAttribute("android:id", "@id/" + qualifiedName)

		if(label.width <= 0){
			labelElement.setAttribute("android:layout_width", "match_parent")
		}else{
			labelElement.setAttribute("android:layout_width", "0dp")
			labelElement.setAttribute("android:layout_columnWeight", String.valueOf(label.width))
		}
		labelElement.setAttribute("android:layout_height", "wrap_content")
		labelElement.setAttribute("android:layout_gravity", "fill_horizontal")
		
		labelElement.setAttribute("android:textSize", "18sp")
    	labelElement.setAttribute("android:text", "@string/" + qualifiedName + "_text")

		return labelElement
	}
	
	protected static def createOptionInputElement(Document doc, OptionInput optionInput) {
		val optionInputElement = doc.createElement(Settings.MD2LIBRARY_VIEW_OPTIONINPUT)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(optionInput).toString("_")

		// id
		optionInputElement.setAttribute("android:id", "@id/" + qualifiedName)

		if(optionInput.width <= 0){
			optionInputElement.setAttribute("android:layout_width", "match_parent")
		}else{
			optionInputElement.setAttribute("android:layout_width", "0dp")
			optionInputElement.setAttribute("android:layout_columnWeight", String.valueOf(optionInput.width))
		}
		optionInputElement.setAttribute("android:layout_height", "wrap_content")
		optionInputElement.setAttribute("android:layout_marginBottom", elementMarginBottom)
		
		optionInputElement.setAttribute("android:entries", "@array/" + qualifiedName + "_entries")
		
		// disabled 
		//TODO working on Spinners?
		var isEnabled = true
		if (optionInput.isDisabled)
			isEnabled = false

		optionInputElement.setAttribute("android:enabled", String.valueOf(isEnabled))

		return optionInputElement
	}
	
	protected static def createIntegerInputElement(Document doc, IntegerInput integerInput) {
		val integerInputElement = doc.createElement(Settings.MD2LIBRARY_VIEW_TEXTINPUT)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(integerInput).toString("_")

		// id
		integerInputElement.setAttribute("android:id", "@id/" + qualifiedName)

		
		if(integerInput.width <= 0){
			integerInputElement.setAttribute("android:layout_width", "match_parent")
		}else{
			integerInputElement.setAttribute("android:layout_width", "0dp")
			integerInputElement.setAttribute("android:layout_columnWeight", String.valueOf(integerInput.width))
		}
		
		integerInputElement.setAttribute("android:layout_height", "wrap_content")
		integerInputElement.setAttribute("android:layout_gravity", "fill_horizontal")
		integerInputElement.setAttribute("android:layout_marginBottom", elementMarginBottom)

		integerInputElement.setAttribute("android:hint", "@string/" + qualifiedName + "_tooltip")

		integerInputElement.setAttribute("android:text", integerInput.defaultValue.toString())
		
		// disabled
		var isEnabled = true
		if (integerInput.isDisabled)
			isEnabled = false

		integerInputElement.setAttribute("android:enabled", String.valueOf(isEnabled))
	
		integerInputElement.setAttribute("android:inputType", "number");
		
		integerInputElement.setAttribute("android:imeOptions","actionDone")

		return integerInputElement
	}
	
	protected static def createBooleanInputElement(Document doc, BooleanInput booleanInput) {
		val booleanInputElement = doc.createElement(Settings.MD2LIBRARY_VIEW_BOOLEANINPUT)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(booleanInput).toString("_")

		// id
		booleanInputElement.setAttribute("android:id", "@id/" + qualifiedName)

		if(booleanInput.width <= 0){
			booleanInputElement.setAttribute("android:layout_width", "50dp")
		}else{
			booleanInputElement.setAttribute("android:layout_width", "50dp")
			booleanInputElement.setAttribute("android:layout_columnWeight", String.valueOf(booleanInput.width))
		}
		booleanInputElement.setAttribute("android:layout_height", "wrap_content")
		booleanInputElement.setAttribute("android:layout_gravity", "start")
		booleanInputElement.setAttribute("android:layout_marginBottom", elementMarginBottom)

		booleanInputElement.setAttribute("android:hint", "@string/" + qualifiedName + "_tooltip")

		// disabled
		var isEnabled = true
		if (booleanInput.isDisabled)
			isEnabled = false

		booleanInputElement.setAttribute("android:enabled", String.valueOf(isEnabled))
		
		booleanInputElement.setAttribute("android:imeOptions","actionDone")

		return booleanInputElement
	}
	
	protected static def createListViewElement(Document doc, ListView listView) {
		var listElement = doc.createElement("android.support.v7.widget.RecyclerView")
		listElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		listElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools",
			"http://schemas.android.com/tools")
		
		listElement.setAttribute("android:id", "@+id/recycler_view_" + (listView.eContainer as ViewFrame).name)
		listElement.setAttribute("android:layout_width", "match_parent")
		listElement.setAttribute("android:layout_height", "match_parent")
		listElement.setAttribute("android:paddingBottom", "@dimen/activity_vertical_margin")
		listElement.setAttribute("android:paddingLeft", "@dimen/activity_horizontal_margin")
		listElement.setAttribute("android:paddingRight", "@dimen/activity_horizontal_margin")
		listElement.setAttribute("android:paddingTop", "@dimen/activity_vertical_margin")
		listElement.setAttribute("android:scrollbars", "vertical")
		//listElement.setAttribute("tools:context", mainPackage + "." + frame.name + "Activity")

		return listElement
	}
	
	protected static def createSpacerElement(Document doc, Spacer spacer) {
		val spacerElement = doc.createElement("android.widget.Space")
		val qualifiedName = "spacer" + MD2GeneratorUtil.getName(spacer); // Spacer has no name in model

		// id
		spacerElement.setAttribute("android:id", "@id/" + qualifiedName)

		spacerElement.setAttribute("android:layout_width", "0dp")
		//spacerElement.setAttribute("android:layout_width", "match_parent")
		spacerElement.setAttribute("android:layout_height", "35dp")
		
		return spacerElement
	}
	
//	def static generateMaterialIcons(IExtendedFileSystemAccess fsa, String rootFolder) {
//		fsa.generateFile(rootFolder + Settings.DRAWABLE_PATH + "ic_add_shopping_cart_white_24dp.xml",
//      	generateMaterialIconsXMLStrings("M11,9h2L13,6h3L16,4h-3L13,1h-2v3L8,4v2h3v3zM7,18c-1.1,0 -1.99,0.9 -1.99,2S5.9,22 7,22s2,-0.9 2,-2 -0.9,-2 -2,-2zM17,18c-1.1,0 -1.99,0.9 -1.99,2s0.89,2 1.99,2 2,-0.9 2,-2 -0.9,-2 -2,-2zM7.17,14.75l0.03,-0.12 0.9,-1.63h7.45c0.75,0 1.41,-0.41 1.75,-1.03l3.86,-7.01L19.42,4h-0.01l-1.1,2 -2.76,5L8.53,11l-0.13,-0.27L6.16,6l-0.95,-2 -0.94,-2L1,2v2h2l3.6,7.59 -1.35,2.45c-0.16,0.28 -0.25,0.61 -0.25,0.96 0,1.1 0.9,2 2,2h12v-2L7.42,15c-0.13,0 -0.25,-0.11 -0.25,-0.25z", "white"
//		))
//
//	}
//	
//	protected static def generateMaterialIconsXMLStrings(String pathData, String color){
//		var head = "<vector xmlns:android=\"http://schemas.android.com/apk/res/android\" android:width=\"24dp\"
//        android:height=\"24dp\"
//        android:viewportWidth=\"24.0\"
//        android:viewportHeight=\"24.0\">
//    	<path
//        android:fillColor=\"@color/"+ color + "\"
//		android:pathData="
//		var tail = "/>	</vector>"
//		return head + "\"" + pathData + "\""+ tail
//	}
}