package de.wwu.md2.framework.generator.android.lollipop.view

import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.InputElement
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.WorkflowElementReference
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import de.wwu.md2.framework.mD2.ContentContainer

class ValueGen {

	def static String generateIdsXml(Iterable<ViewGUIElement> viewGUIElements, Iterable<WorkflowElementReference> wers) '''
		<?xml version="1.0" encoding="utf-8"?>
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateIdsXml() -->
		<resources>
			«FOR wer : wers»
				<item name="startActivity_«wer.workflowElementReference.name»Button" type="id"/>				
			«ENDFOR»
			«FOR ve : viewGUIElements»
				«val qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(ve, "_")»
				«IF (qualifiedName != null && !qualifiedName.empty)»
					<item name="«qualifiedName»" type="id"/>
				«ENDIF»
			«ENDFOR»
		</resources>
	'''

	def static String generateStringsXml(App app, Iterable<ContainerElement> rootContainerElements,
		Iterable<ViewGUIElement> viewGUIElements, Iterable<WorkflowElementReference> wers) '''
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateStringsXml() -->
		<resources>
			<string name="app_name">«app.appName»</string>
			«FOR rce : rootContainerElements»
				<string name="title_activity_«rce.name.toFirstLower»">«getActivityTitle(rce)»</string>
			«ENDFOR»
			
			«FOR wer : wers»
				<string name="«MD2AndroidLollipopUtil.getQualifiedNameAsString(wer, "_")»_alias">«wer.alias»</string>
			«ENDFOR»
			
			«FOR ve : viewGUIElements»
				«generateStringEntry(ve)»
			«ENDFOR»
		</resources>
	'''
	
	def static getActivityTitle(ContainerElement element) {
		switch element {
			ContentContainer: {
				if(element.elements.filter(Label).findFirst[label | label.name.startsWith("_title")] != null){
					return element.elements.filter(Label).findFirst[label | label.name.startsWith("_title")].text
				} else {
					return ""
				}
			}
		}
		return element.name
	}

	protected def static String generateStringEntry(ViewGUIElement viewGUIElement) {
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		switch viewGUIElement {
			InputElement:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_label">«viewGUIElement.labelText»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_tooltip">«viewGUIElement.tooltipText»</string>
				'''
			Image:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_src">«viewGUIElement.src»</string>
				'''
			Button:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_text">«viewGUIElement.text»</string>
				'''
			Label:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_text">«viewGUIElement.text»</string>
				'''
			Tooltip:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_text">«viewGUIElement.text»</string>
				'''
		}
	}

	def static String generateViewsXml(Iterable<ContainerElement> rootContainerElements, String mainPackage) '''		
		<?xml version="1.0" encoding="utf-8"?>
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateViewsXml() -->
		<resources>
		    <string name="StartActivity">«mainPackage».StartActivity</string>
		    «FOR rce : rootContainerElements»
		    	<string name="«rce.name»Activity">«mainPackage».«rce.name»Activity</string>
			«ENDFOR»
		</resources>
	'''

	def static String generateStylesXml() '''
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateStylesXml() -->
		<resources>
		    <style name="AppTheme" parent="android:Theme.Material.Light.DarkActionBar">
		    </style>		
		</resources>
	'''

	def static String generateDimensXml() '''
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateDimensXml() -->
		<resources>
		    <dimen name="activity_horizontal_margin">16dp</dimen>
		    <dimen name="activity_vertical_margin">16dp</dimen>
		</resources>
	'''
}