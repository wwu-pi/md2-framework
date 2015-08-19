package de.wwu.md2.framework.generator.android.lollipop.view

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.FlowDirection
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TextInputType
import de.wwu.md2.framework.mD2.ViewElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import java.io.StringWriter
import javax.xml.parsers.DocumentBuilderFactory
import javax.xml.transform.OutputKeys
import javax.xml.transform.TransformerFactory
import javax.xml.transform.dom.DOMSource
import javax.xml.transform.stream.StreamResult
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.w3c.dom.Document
import org.w3c.dom.Element
import de.wwu.md2.framework.mD2.SubViewContainer
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.ContainerElementReference
import de.wwu.md2.framework.mD2.WidthParam

class Layout {

	def static generateLayouts(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContainerElement> rootViews) {
		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.LAYOUT_PATH + "activity_" + rv.name.toLowerCase + ".xml",
				generateLayout(mainPackage, rv))
		]
	}

	private static def generateLayout(String mainPackage, ContainerElement rv) {
		val docFactory = DocumentBuilderFactory.newInstance
		val docBuilder = docFactory.newDocumentBuilder

		// create doc and set namespace definitions
		val doc = docBuilder.newDocument
		val generationComment = doc.createComment("generated in de.wwu.md2.framework.generator.android.lollipop.view.Layout.generateLayout()")
		doc.appendChild(generationComment)

		// create root element
		var Element rootElement = null
		switch rv {
			FlowLayoutPane: rootElement = createFlowLayoutPaneElement(doc, rv)
			GridLayoutPane: rootElement = createGridLayoutPaneElement(doc, rv)
			default: return ""
		}

		doc.appendChild(rootElement)

		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools", "http://schemas.android.com/tools")

		// depth first search to generate elements for all children
		switch rv {
			ContentContainer:
				for (elem : rv.elements) {
					createChildrenElements(doc, rootElement, elem)
				}
			SubViewContainer:
				for (elem : rv.elements) {
					switch elem {
						ContainerElement: createChildrenElements(doc, rootElement, elem)
						ContainerElementReference: createChildrenElements(doc, rootElement, elem.value)
					}
				}
		}

		// return xml file as string
		val transformerFactory = TransformerFactory.newInstance
		val transformer = transformerFactory.newTransformer
		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes")
		val writer = new StringWriter
		transformer.transform(new DOMSource(doc), new StreamResult(writer))
		return writer.buffer.toString
	}

	private static def void createChildrenElements(Document doc, Element element, ViewElement viewElement) {
		var Element newElement = null
		switch viewElement {
			ViewGUIElementReference:
				createChildrenElements(doc, element, viewElement.value)
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
			default:
				return
		}
		element.appendChild(newElement)
	}


	// not used for now as a FlowLayoutPaneElement is replaced by a GridLayoutPane during pre-processing
	private static def createFlowLayoutPaneElement(Document doc, FlowLayoutPane flp) {
		val flowLayoutPaneElement = doc.createElement(Settings.MD2LIBRARY_VIEW_FLOWLAYOUTPANE)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(flp)

		// id
		flowLayoutPaneElement.setAttribute("android:id", "@id/" + qualifiedName)

		// height and width
		flowLayoutPaneElement.setAttribute("android:layout_width", "match_parent")
		flowLayoutPaneElement.setAttribute("android:layout_height", "match_parent")

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

	private static def createGridLayoutPaneElement(Document doc, GridLayoutPane glp) {
		val gridLayoutPaneElement = doc.createElement(Settings.MD2LIBRARY_VIEW_GRIDLAYOUTPANE)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(glp)

		// id
		gridLayoutPaneElement.setAttribute("android:id", "@id/" + qualifiedName)

		// set width
		gridLayoutPaneElement.setAttribute("android:layout_height", "wrap_content")
		gridLayoutPaneElement.setAttribute("android:layout_width", "match_parent")
		
		// handle parameters
		glp.params.forEach [ p |
			switch p {
				// orientation
				GridLayoutPaneColumnsParam:
					gridLayoutPaneElement.setAttribute("android:columnCount", String.valueOf(p.value))
				GridLayoutPaneRowsParam:
					gridLayoutPaneElement.setAttribute("android:rowCount", String.valueOf(p.value))
				WidthParam:{
					gridLayoutPaneElement.setAttribute("android:layout_columnWeight", String.valueOf(p.width))
					gridLayoutPaneElement.getAttributeNode("android:layout_width").nodeValue = "0dp"
				}
			}
		]
		return gridLayoutPaneElement
	}

	private static def createButtonElement(Document doc, Button button) {
		val buttonElement = doc.createElement(Settings.MD2LIBRARY_VIEW_BUTTON)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(button)

		// id
		buttonElement.setAttribute("android:id", "@id/" + qualifiedName)

		// height and width
		if(button.width == -1){
			buttonElement.setAttribute("android:layout_width", "match_parent")
		}else{
			buttonElement.setAttribute("android:layout_width", "0dp")
			buttonElement.setAttribute("android:layout_columnWeight", String.valueOf(button.width))
		}
		
		buttonElement.setAttribute("android:layout_height", "wrap_content")

		// text
		buttonElement.setAttribute("android:text", "@string/" + qualifiedName + "_text")

		// disabled
		var isEnabled = true
		if (button.isDisabled)
			isEnabled = false

		buttonElement.setAttribute("android:enabled", String.valueOf(isEnabled))

		return buttonElement
	}

	private static def createTextInputElement(Document doc, TextInput textInput) {
		val textInputElement = doc.createElement(Settings.MD2LIBRARY_VIEW_TEXTINPUT)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(textInput)

		// id
		textInputElement.setAttribute("android:id", "@id/" + qualifiedName)

		if(textInput.width == -1){
			textInputElement.setAttribute("android:layout_width", "match_parent")
		}else{
			textInputElement.setAttribute("android:layout_width", "0dp")
			textInputElement.setAttribute("android:layout_columnWeight", String.valueOf(textInput.width))
		}
		textInputElement.setAttribute("android:layout_height", "wrap_content")

		textInputElement.setAttribute("android:hint", "@string/" + qualifiedName + "_tooltip")

		textInputElement.setAttribute("android:text", textInput.defaultValue)

		// disabled
		var isEnabled = true
		if (textInput.isDisabled)
			isEnabled = false

		textInputElement.setAttribute("android:enabled", String.valueOf(isEnabled))

		// type
		switch textInput {
			case textInput.type == TextInputType.PASSWORD:
				textInputElement.setAttribute("android:inputType", "TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_PASSWORD")
			case textInput.type == TextInputType.TEXTAREA:
				textInputElement.setAttribute("android:inputType",
					"TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_NORMAL | TYPE_TEXT_FLAG_MULTI_LINE")
			default:
				textInputElement.setAttribute("android:inputType", "TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_NORMAL")
		}

		return textInputElement
	}
}