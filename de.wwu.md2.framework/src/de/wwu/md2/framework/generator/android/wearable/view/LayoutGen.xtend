package de.wwu.md2.framework.generator.android.wearable.view

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContainerElementReference
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.ActionDrawer
import de.wwu.md2.framework.mD2.FlowDirection
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.SubViewContainer
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TextInputType
import de.wwu.md2.framework.mD2.ViewElement
import de.wwu.md2.framework.mD2.ViewElementType
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

import de.wwu.md2.framework.mD2.Action

import de.wwu.md2.framework.mD2.ListView
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.ActionDrawerParam
import de.wwu.md2.framework.mD2.ActionDrawerTitleParam
import de.wwu.md2.framework.mD2.impl.ActionDrawerImpl
import de.wwu.md2.framework.mD2.ViewIcon
import de.wwu.md2.framework.mD2.ViewIconActionDrawer
import java.util.List


class LayoutGen {

	def static generateLayouts(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContainerElement> rootViews, Iterable<WorkflowElementReference> startableWorkflowElements) {


		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.LAYOUT_PATH + "activity_" + rv.name.toLowerCase + ".xml",
				generateLayout(mainPackage, rv))

			for(viewElement: rv.eAllContents.toIterable) {
				if (viewElement instanceof ActionDrawer) {
					fsa.generateFile(rootFolder + Settings.MENU_PATH + rv.name.toLowerCase + "_action_drawer_menu.xml",
					generateActionDrawerMenu(mainPackage, rv, startableWorkflowElements))

//					fsa.generateFile(rootFolder + Settings.DRAWABLE_PATH, generateDrawableIcons(mainPackage))
				}
			}
		]
	}


	protected static def generateStartLayout(String mainPackage, Iterable<WorkflowElementReference> wfes) {
		val docFactory = DocumentBuilderFactory.newInstance
		val docBuilder = docFactory.newDocumentBuilder

		// create doc and set namespace definitions
		val doc = docBuilder.newDocument
		val generationComment = doc.createComment("generated in de.wwu.md2.framework.generator.android.wearable.view.Layout.generateStartLayout()")
		doc.appendChild(generationComment)

		// create root element: BoxInsetLayout, FrameLayout as child, ScrollView as Child

		// create BoxInsetLayout
		var Element rootElement = doc.createElement("android.support.wearable.view.BoxInsetLayout")
		// set attributes of BoxInsetLayout
		rootElement.setAttribute("android:layout_height", "match_parent")
		rootElement.setAttribute("android:layout_width", "match_parent")
		rootElement.setAttribute("tools:context", mainPackage + ".StartActivity")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools", "http://schemas.android.com/tools")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:app", "http://schemas.android.com/apk/res-auto")

		// create FrameLayout
		var Element frameElement = doc.createElement("FrameLayout")
		// set attributes of FrameLayout
		frameElement.setAttribute("android:orientation", "vertical")
		frameElement.setAttribute("android:layout_height", "match_parent")
		frameElement.setAttribute("android:layout_width", "match_parent")
		frameElement.setAttribute("app:layout_box", "all")


		//create Scroll View
		var Element scrollView = doc.createElement("ScrollView")
		//set attributes of ScrollView
		scrollView.setAttribute("android:layout_height", "match_parent")
		scrollView.setAttribute("android:layout_width", "match_parent")

		//append
		frameElement.appendChild(scrollView)
		rootElement.appendChild(frameElement)
		doc.appendChild(rootElement)

		var Element rootContainer = doc.createElement(Settings.MD2LIBRARY_VIEW_FLOWLAYOUTPANE)
		rootContainer.setAttribute("android:layout_height", "wrap_content")
		rootContainer.setAttribute("android:layout_width", "match_parent")
		rootContainer.setAttribute("android:orientation", "vertical")
		scrollView.appendChild(rootContainer)


		// add buttons
		for(wfe : wfes){

			var btnElement = doc.createElement(Settings.MD2LIBRARY_VIEW_BUTTON)
			btnElement.setAttribute("android:id", "@id/startActivity_" + wfe.workflowElementReference.name + "Button")
 			btnElement.setAttribute("android:layout_width", "match_parent")
 			btnElement.setAttribute("android:layout_height", "wrap_content")
 			btnElement.setAttribute("android:layout_gravity", "fill_horizontal")
 			btnElement.setAttribute("android:text", "@string/" + MD2AndroidLollipopUtil.getQualifiedNameAsString(wfe, "_") + "_alias")
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

	protected static def generateLayout(String mainPackage, ContainerElement rv) {
		val docFactory = DocumentBuilderFactory.newInstance
		val docBuilder = docFactory.newDocumentBuilder

		// create doc and set namespace definitions
		val doc = docBuilder.newDocument
		val generationComment = doc.createComment("generated in de.wwu.md2.framework.generator.android.wearable.view.Layout.generateLayout()")
		doc.appendChild(generationComment)

		//spezielles Layout für Listview
		if((rv as ContentContainer) instanceof ListView){
		//create WearableDrawerLayout
		var Element rootElement = doc.createElement("android.support.wearable.view.drawer.WearableDrawerLayout")
		rootElement.setAttribute("android:id","@+id/drawer_layout_"+rv.name);
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools", "http://schemas.android.com/tools")
		rootElement.setAttribute("android:layout_height", "match_parent")
		rootElement.setAttribute("android:layout_width", "match_parent")
		rootElement.setAttribute("tools:deviceIds", "wear")
		//create NavigationDrawer
		var Element navElement = doc.createElement("android.support.wearable.view.drawer.WearableNavigationDrawer")
		navElement.setAttribute("android:id", "@+id/navigation_drawer_"+rv.name)
		navElement.setAttribute("android:layout_height", "match_parent")
		navElement.setAttribute("android:layout_width", "match_parent")
		navElement.setAttribute("android:background", "@color/PSWatchappSemiTransparentDarkBlue")
		//create WearableRecyclerView für Listendarstellung
		var Element listElement = doc.createElement("android.support.wearable.view.WearableRecyclerView")
		listElement.setAttribute("android:id","@+id/wearable_recycler_view_"+rv.name)
		listElement.setAttribute("android:layout_height", "match_parent")
		listElement.setAttribute("android:layout_width", "match_parent")
		//append
		rootElement.appendChild(listElement)
		rootElement.appendChild(navElement)
		doc.appendChild(rootElement)
		}

		//StandardLayout
		else{
		// create root element: WearableDrawerLayout, NavigationDrawer + BoxInsetLayout as children, FrameLayout as child of BIL, ScrollView as Child

		//create WearableDrawerLayout
		var Element rootElement = doc.createElement("android.support.wearable.view.drawer.WearableDrawerLayout")
		rootElement.setAttribute("android:id","@+id/drawer_layout_"+rv.name);
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools", "http://schemas.android.com/tools")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:app", "http://schemas.android.com/apk/res-auto")
		rootElement.setAttribute("android:layout_height", "match_parent")
		rootElement.setAttribute("android:layout_width", "match_parent")
		rootElement.setAttribute("tools:deviceIds", "wear")

		//create NavigationDrawer
		var Element navElement = doc.createElement("android.support.wearable.view.drawer.WearableNavigationDrawer")
		navElement.setAttribute("android:id", "@+id/navigation_drawer_"+rv.name)
		navElement.setAttribute("android:layout_height", "match_parent")
		navElement.setAttribute("android:layout_width", "match_parent")

		navElement.setAttribute("android:background", "@color/PSWatchappSemiTransparentDarkBlue")

		//create ActionDrawer
		var Element drawerElement = doc.createElement("android.support.wearable.view.drawer.WearableActionDrawer")
		drawerElement.setAttribute("android:id", "@+id/bottom_action_drawer_" + rv.name)
		drawerElement.setAttribute("android:layout_height", "match_parent")
		drawerElement.setAttribute("android:layout_width", "match_parent")
		drawerElement.setAttribute("app:action_menu", "@menu/" + rv.name.toLowerCase + "_action_drawer_menu")
		drawerElement.setAttribute("android:theme","@style/PSWatchappActionDrawer")
		drawerElement.setAttribute("app:show_overflow_in_peek", "true")
		//Methode zum titel finden und setzen
		//drawerElement.setAttribute("app:drawer_title", rv.name)
        //app:drawer_title="TestTitel des Drawers"

		// create BoxInsetLayout
		var Element boxElement = doc.createElement("android.support.wearable.view.BoxInsetLayout")
		// set attributes of BoxInsetLayout
		boxElement.setAttribute("android:layout_height", "match_parent")
		boxElement.setAttribute("android:layout_width", "match_parent")
		boxElement.setAttribute("tools:context", mainPackage + "." + rv.name + "Activity")
		boxElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		boxElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools", "http://schemas.android.com/tools")
		boxElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:app", "http://schemas.android.com/apk/res-auto")

		// create FrameLayout
		var Element frameElement = doc.createElement("FrameLayout")
		// set attributes of FrameLayout
		frameElement.setAttribute("android:orientation", "vertical")
		frameElement.setAttribute("android:layout_height", "match_parent")
		frameElement.setAttribute("android:layout_width", "match_parent")
		frameElement.setAttribute("app:layout_box", "all")


		//create Scroll View
		var Element scrollView = doc.createElement("ScrollView")
		//set attributes of ScrollView
		scrollView.setAttribute("android:layout_height", "match_parent")
		scrollView.setAttribute("android:layout_width", "match_parent")

		//append
		frameElement.appendChild(scrollView)
		boxElement.appendChild(frameElement)
		rootElement.appendChild(boxElement);
		rootElement.appendChild(navElement);
		for( viewElement: rv.eAllContents.filter(ActionDrawer).toIterable) {
			if (viewElement instanceof ActionDrawer) {
				rootElement.appendChild(drawerElement)
			}
		}
		doc.appendChild(rootElement)

		var Element rootContainer = null

		//sollte man nochmal testen, wie toll diese Layouts auf einer Uhr laufen
		switch rv {
			FlowLayoutPane: rootContainer = createFlowLayoutPaneElement(doc, rv)
			GridLayoutPane: rootContainer = createGridLayoutPaneElement(doc, rv)
			default: return ""
		}

		rootContainer.setAttribute("android:layout_width", "match_parent")
		scrollView.appendChild(rootContainer)

		// depth first search to generate elements for all children
		switch rv {
			ContentContainer:
				for (elem : rv.elements) {
					createChildrenElements(doc, rootContainer, elem)
				}
			SubViewContainer:
				for (elem : rv.elements) {
					switch elem {
						ContainerElement: createChildrenElements(doc, rootContainer, elem)
						ContainerElementReference: createChildrenElements(doc, rootContainer, elem.value)
					}
				}
		}


		//Ende else / Ende StandardLayout
		}


		// return xml file as string
		val transformerFactory = TransformerFactory.newInstance
		val transformer = transformerFactory.newTransformer
		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes")
		val writer = new StringWriter
		transformer.transform(new DOMSource(doc), new StreamResult(writer))
		return writer.buffer.toString
}

	// Generate Action Drawer Menu
	protected static def generateActionDrawerMenu(String mainPackage, ContainerElement rv, Iterable<WorkflowElementReference> wfes) {
		val docFactory = DocumentBuilderFactory.newInstance
		val docBuilder = docFactory.newDocumentBuilder

		// create doc and set namespace definitions
		val doc = docBuilder.newDocument
		val generationComment = doc.createComment("generated in de.wwu.md2.framework.generator.android.wearable.view.Layout.generateActionDrawerMenu()")
		doc.appendChild(generationComment)

		var Element rootElement = doc.createElement("menu")
		rootElement.setAttribute("android:id","@+id/"+ rv.name.toLowerCase + "_action_drawer_menu")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:android",
			"http://schemas.android.com/apk/res/android")
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:tools", "http://schemas.android.com/tools")
		rootElement.setAttribute("android:layout_height", "match_parent")
		rootElement.setAttribute("android:layout_width", "match_parent")
		rootElement.setAttribute("tools:deviceIds", "wear")

		val ActionsIcons = newArrayList()
		val ActionTitel = newArrayList()
		
		//Generate menu items in the menu
		for(viewElement: rv.eAllContents.toIterable) {
			if(viewElement instanceof ActionDrawer) {
				//Titel für die Beschriftung im ActionDrawer
				var ActionDrawerTitel = "";
				var iconAction = "ic_dialog_info"; //default Icon
				
				for (acd : (viewElement as ActionDrawerImpl).params) {
					if(acd instanceof ActionDrawerTitleParam){
						for (title  : acd.values) {
							ActionTitel.add(title.toString);
						}
					}		
					if(acd instanceof ViewIconActionDrawer){
						for (icon  : acd.values) {
							iconAction = icon.toString; //falls ein anderes Icon angegeben wurde wird dies verwendet
							ActionsIcons.add(iconAction);
						}
					}	
						
				}
				
								
				if(!(viewElement.onItemClickAction === null)) {
					var ElementCounter = 0;
					for(itemClickAction: viewElement.onItemClickAction) {
						println("ActionDrawer itemClickAction:" + itemClickAction)
						var Element item = doc.createElement("item")
						item.setAttribute("android:id", ("@+id/" + (itemClickAction.name + "_item" + (ElementCounter++).toString)))
						item.setAttribute("android:icon", ("@android:drawable/" + ActionsIcons.get(ElementCounter-1))) // TODO: Icons auswählen können
						item.setAttribute("android:title", ActionTitel.get(ElementCounter-1));//MD2AndroidLollipopUtil.getQualifiedNameAsString(itemClickAction, "").toFirstUpper)
			 			rootElement.appendChild(item)
					}
		 		}
			}
		}
		
		

		//Append
		doc.appendChild(rootElement)

		// return xml file as string
		val transformerFactory = TransformerFactory.newInstance
		val transformer = transformerFactory.newTransformer
		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes")
		val writer = new StringWriter
		transformer.transform(new DOMSource(doc), new StreamResult(writer))
		return writer.buffer.toString

	}
	/////////////////////creation of children elements completely adopted from lollipop/////////////////////////////

	//call different methods for different types of children
	protected static def void createChildrenElements(Document doc, Element element, ViewElement viewElement) {
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
			IntegerInput: {
				newElement = createIntegerInputElement(doc, viewElement)
			}
			Label: {
				if(viewElement.name.startsWith("_title")) { return } // Skip title label --> landet das irgendwo anders?
				newElement = createLabelElement(doc, viewElement)
			}
			default:
				return
		}
		element.appendChild(newElement)
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
		val qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(glp, "_")
		glpElement.setAttribute("android:id", "@id/" + qualifiedName)

		// set default width and height
		glpElement.setAttribute("android:layout_height", "wrap_content")
		glpElement.setAttribute("android:layout_width", "match_parent")
		glpElement.setAttribute("android:layout_gravity", "fill_horizontal")

		// handle parameters
		glp.params.forEach [ p |
			switch p {
				// orientation
				GridLayoutPaneColumnsParam:
					glpElement.setAttribute("android:columnCount", String.valueOf(p.value))
				GridLayoutPaneRowsParam:
					glpElement.setAttribute("android:rowCount", String.valueOf(p.value))
				// width
				WidthParam:{
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
		if(button.width == -1){
			buttonElement.setAttribute("android:layout_width", "match_parent")
		}else{
			buttonElement.setAttribute("android:layout_width", "0dp")
			buttonElement.setAttribute("android:layout_columnWeight", String.valueOf(button.width))
		}

		buttonElement.setAttribute("android:layout_height", "wrap_content")
		buttonElement.setAttribute("android:layout_gravity", "fill_horizontal")

		// text
		buttonElement.setAttribute("android:text", "@string/" + qualifiedName + "_text")

		// disabled
		var isEnabled = true
		if (button.isDisabled)
			isEnabled = false

		buttonElement.setAttribute("android:enabled", String.valueOf(isEnabled))
		buttonElement.setAttribute("android:textColor", "@color/black");

		return buttonElement
	}

	protected static def createTextInputElement(Document doc, TextInput textInput) {
		val textInputElement = doc.createElement(Settings.MD2LIBRARY_VIEW_TEXTINPUT)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(textInput).toString("_")

		// id
		textInputElement.setAttribute("android:id", "@id/" + qualifiedName)

		if(textInput.width == -1){
			textInputElement.setAttribute("android:layout_width", "match_parent")
		}else{
			textInputElement.setAttribute("android:layout_width", "0dp")
			textInputElement.setAttribute("android:layout_columnWeight", String.valueOf(textInput.width))
		}
		textInputElement.setAttribute("android:layout_height", "wrap_content")
		textInputElement.setAttribute("android:layout_gravity", "fill_horizontal")

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
				textInputElement.setAttribute("android:inputType", "textPassword")
			case textInput.type == TextInputType.TEXTAREA:
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

		if(label.width == -1){
			labelElement.setAttribute("android:layout_width", "match_parent")
		}else{
			labelElement.setAttribute("android:layout_width", "0dp")
			labelElement.setAttribute("android:layout_columnWeight", String.valueOf(label.width))
		}
		labelElement.setAttribute("android:layout_height", "wrap_content")
		labelElement.setAttribute("android:layout_gravity", "fill_horizontal")

		labelElement.setAttribute("android:text", "@string/" + qualifiedName + "_text")

		return labelElement
	}

	protected static def createIntegerInputElement(Document doc, IntegerInput integerInput) {
		val integerInputElement = doc.createElement(Settings.MD2LIBRARY_VIEW_TEXTINPUT)
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		val qualifiedName = qnp.getFullyQualifiedName(integerInput).toString("_")

		// id
		integerInputElement.setAttribute("android:id", "@id/" + qualifiedName)

		
		integerInputElement.setAttribute("android:layout_width", "match_parent")
		
		integerInputElement.setAttribute("android:layout_height", "wrap_content")
		integerInputElement.setAttribute("android:layout_gravity", "fill_horizontal")

		integerInputElement.setAttribute("android:hint", "@string/" + qualifiedName + "_tooltip")

		integerInputElement.setAttribute("android:text", integerInput.defaultValue.toString())
		
		// disabled
		var isEnabled = true
		if (integerInput.isDisabled)
			isEnabled = false

		integerInputElement.setAttribute("android:enabled", String.valueOf(isEnabled))
	
		integerInputElement.setAttribute("android:inputType", "number");
		
		integerInputElement.setAttribute("android:imeOptions","actionDone")
		
		// type ???
		// switch textInput {
		//	case textInput.type == TextInputType.PASSWORD:
		//		textInputElement.setAttribute("android:inputType", "textPassword")
		//	case textInput.type == TextInputType.TEXTAREA:
		//		textInputElement.setAttribute("android:inputType",
		//			"text|textMultiLine")
		//	default:
		//		textInputElement.setAttribute("android:inputType", "text")
		//}

		return integerInputElement
	}
	
	def static generateMaterialIcons(IExtendedFileSystemAccess fsa, String rootFolder) {


		fsa.generateFile(rootFolder + Settings.DRAWABLE_PATH + "ic_add_shopping_cart_white_24dp.xml",
      	generateMaterialIconsXMLStrings("M11,9h2L13,6h3L16,4h-3L13,1h-2v3L8,4v2h3v3zM7,18c-1.1,0 -1.99,0.9 -1.99,2S5.9,22 7,22s2,-0.9 2,-2 -0.9,-2 -2,-2zM17,18c-1.1,0 -1.99,0.9 -1.99,2s0.89,2 1.99,2 2,-0.9 2,-2 -0.9,-2 -2,-2zM7.17,14.75l0.03,-0.12 0.9,-1.63h7.45c0.75,0 1.41,-0.41 1.75,-1.03l3.86,-7.01L19.42,4h-0.01l-1.1,2 -2.76,5L8.53,11l-0.13,-0.27L6.16,6l-0.95,-2 -0.94,-2L1,2v2h2l3.6,7.59 -1.35,2.45c-0.16,0.28 -0.25,0.61 -0.25,0.96 0,1.1 0.9,2 2,2h12v-2L7.42,15c-0.13,0 -0.25,-0.11 -0.25,-0.25z"
		))
		
		fsa.generateFile(rootFolder + Settings.DRAWABLE_PATH + "ic_shopping_cart_white_24dp.xml",
			"<vector xmlns:android=\"http://schemas.android.com/apk/res/android\"
        android:width=\"24dp\"
        android:height=\"24dp\"
        android:viewportWidth=\"24.0\"
        android:viewportHeight=\"24.0\">
    	<path
        android:fillColor=\"@color/white\"
        android:pathData=\"M7,18c-1.1,0 -1.99,0.9 -1.99,2S5.9,22 7,22s2,-0.9 2,-2 -0.9,-2 -2,-2zM1,2v2h2l3.6,7.59 -1.35,2.45c-0.16,0.28 -0.25,0.61 -0.25,0.96 0,1.1 0.9,2 2,2h12v-2L7.42,15c-0.14,0 -0.25,-0.11 -0.25,-0.25l0.03,-0.12 0.9,-1.63h7.45c0.75,0 1.41,-0.41 1.75,-1.03l3.58,-6.49c0.08,-0.14 0.12,-0.31 0.12,-0.48 0,-0.55 -0.45,-1 -1,-1L5.21,4l-0.94,-2L1,2zM17,18c-1.1,0 -1.99,0.9 -1.99,2s0.89,2 1.99,2 2,-0.9 2,-2 -0.9,-2 -2,-2z\"/>
		</vector>")
		
		fsa.generateFile(rootFolder + Settings.DRAWABLE_PATH + "ic_remove_shopping_cart_white_24dp.xml",
			"<vector xmlns:android=\"http://schemas.android.com/apk/res/android\"
        android:width=\"24dp\"
        android:height=\"24dp\"
        android:viewportWidth=\"24.0\"
        android:viewportHeight=\"24.0\">
    	<path
        android:fillColor=\"@color/white\"
        android:pathData=\"M22.73,22.73L2.77,2.77 2,2l-0.73,-0.73L0,2.54l4.39,4.39 2.21,4.66 -1.35,2.45c-0.16,0.28 -0.25,0.61 -0.25,0.96 0,1.1 0.9,2 2,2h7.46l1.38,1.38c-0.5,0.36 -0.83,0.95 -0.83,1.62 0,1.1 0.89,2 1.99,2 0.67,0 1.26,-0.33 1.62,-0.84L21.46,24l1.27,-1.27zM7.42,15c-0.14,0 -0.25,-0.11 -0.25,-0.25l0.03,-0.12 0.9,-1.63h2.36l2,2L7.42,15zM15.55,13c0.75,0 1.41,-0.41 1.75,-1.03l3.58,-6.49c0.08,-0.14 0.12,-0.31 0.12,-0.48 0,-0.55 -0.45,-1 -1,-1L6.54,4l9.01,9zM7,18c-1.1,0 -1.99,0.9 -1.99,2S5.9,22 7,22s2,-0.9 2,-2 -0.9,-2 -2,-2z\"/>
		</vector>")
		
		fsa.generateFile(rootFolder + Settings.DRAWABLE_PATH + "ic_remove_shopping_cart_white_24dp.xml",
			"<vector xmlns:android=\"http://schemas.android.com/apk/res/android\"
        android:width=\"24dp\"
        android:height=\"24dp\"
        android:viewportWidth=\"24.0\"
        android:viewportHeight=\"24.0\">
    	<path
        android:fillColor=\"@color/white\"
        android:pathData=\"M22.73,22.73L2.77,2.77 2,2l-0.73,-0.73L0,2.54l4.39,4.39 2.21,4.66 -1.35,2.45c-0.16,0.28 -0.25,0.61 -0.25,0.96 0,1.1 0.9,2 2,2h7.46l1.38,1.38c-0.5,0.36 -0.83,0.95 -0.83,1.62 0,1.1 0.89,2 1.99,2 0.67,0 1.26,-0.33 1.62,-0.84L21.46,24l1.27,-1.27zM7.42,15c-0.14,0 -0.25,-0.11 -0.25,-0.25l0.03,-0.12 0.9,-1.63h2.36l2,2L7.42,15zM15.55,13c0.75,0 1.41,-0.41 1.75,-1.03l3.58,-6.49c0.08,-0.14 0.12,-0.31 0.12,-0.48 0,-0.55 -0.45,-1 -1,-1L6.54,4l9.01,9zM7,18c-1.1,0 -1.99,0.9 -1.99,2S5.9,22 7,22s2,-0.9 2,-2 -0.9,-2 -2,-2z\"/>
		</vector>")
	}
	
	protected static def generateMaterialIconsXMLStrings(String pathData){
		var head = "<vector xmlns:android=\"http://schemas.android.com/apk/res/android\" android:width=\"24dp\"
        android:height=\"24dp\"
        android:viewportWidth=\"24.0\"
        android:viewportHeight=\"24.0\">
    	<path
        android:fillColor=\"@color/white\"
		android:pathData="
		var tail = "/>	</vector>"
		return head + "\"" + pathData + "\""+ tail
	}
}

