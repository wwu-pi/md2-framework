package de.wwu.md2.framework.generator.android.lollipop.view

import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.InputElement
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewGUIElement
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import de.wwu.md2.framework.mD2.WorkflowElementReference

class Values {

	def static String generateIdsXml(Iterable<ViewGUIElement> viewGUIElements, Iterable<WorkflowElementReference> wers) '''
		«val qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider»
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateIdsXml() -->
		<?xml version="1.0" encoding="utf-8"?>
		<resources>
			«FOR wer : wers»
				<item name="startActivity_«wer.workflowElementReference.name»Button" type="id"/>				
			«ENDFOR»
			«FOR ve : viewGUIElements»
				«val qualifiedName = qualifiedNameProvider.getFullyQualifiedName(ve)»
				«IF (qualifiedName != null && !qualifiedName.empty)»
					<item name="«qualifiedName»" type="id"/>
				«ENDIF»
			«ENDFOR»
		</resources>
	'''

	def static String generateStringsXml(App app, Iterable<ContainerElement> rootContainerElements,
		Iterable<ViewGUIElement> viewGUIElements) '''
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateStringsXml() -->
		<resources>
			<string name="app_name">«app.appName»</string>
			«FOR rce : rootContainerElements»
				<string name="@string/title_activity_«rce.name.toFirstLower»">«rce.name»</string>
			«ENDFOR»
			«FOR ve : viewGUIElements»
				«generateStringEntry(ve)»
			«ENDFOR»
		</resources>
	'''

	def private static String generateStringEntry(ViewGUIElement viewGUIElement) {
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		switch viewGUIElement {
			InputElement:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_label">«viewGUIElement.labelText»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_tooltip">«viewGUIElement.tooltipText»</string>
				'''
			Image:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_src">«viewGUIElement.src»</string>
				'''
			Button:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_text">«viewGUIElement.text»</string>
				'''
			Label:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_label">«viewGUIElement.text»</string>
				'''
			Tooltip:
				return '''
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_title">«viewGUIElement.name»</string>
					<string name="«qnp.getFullyQualifiedName(viewGUIElement)»_text">«viewGUIElement.text»</string>
				'''
		}
	}

	def static String generateViewsXml(Iterable<ContainerElement> rootContainerElements, String mainPackage) '''
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateViewsXml() -->
		<?xml version="1.0" encoding="utf-8"?>
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
		    <style name="AppTheme" parent="android:Theme.Holo.Light.DarkActionBar">
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