package de.wwu.md2.framework.generator.android.lollipop.view

import de.wwu.md2.framework.generator.android.common.util.MD2AndroidUtil
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.InputElement
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewFrame
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.WorkflowElementReference
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider

class ValueGen {

	def static String generateIdsXml(Iterable<ViewGUIElement> viewGUIElements, Iterable<ViewFrame> rootFrames, Iterable<WorkflowElementReference> wers) '''
		<?xml version="1.0" encoding="utf-8"?>
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateIdsXml() -->
		<resources>
			«FOR wer : wers»
				<item name="startActivity_«wer.workflowElementReference.name»Button" type="id"/>				
			«ENDFOR»
			«FOR ve : rootFrames»
				<item name="«MD2AndroidUtil.getQualifiedNameAsString(ve, "_")»" type="id"/>
				<item name="«MD2AndroidUtil.getQualifiedNameAsString(ve, "_") + "__wrapperFlowLayout"»" type="id"/>
			«ENDFOR»
			«FOR ve : viewGUIElements»
				«val qualifiedName = MD2AndroidUtil.getQualifiedNameAsString(ve, "_")»
				«IF (qualifiedName !== null && !qualifiedName.empty)»
					<item name="«qualifiedName»" type="id"/>
				«ELSEIF ve instanceof Spacer»
					<item name="spacer«MD2GeneratorUtil.getName(ve)»" type="id"/>
				«ENDIF»
			«ENDFOR»
		</resources>
	'''

	def static String generateStringsXml(App app, Iterable<ViewFrame> frames,
		Iterable<ViewGUIElement> viewGUIElements, Iterable<WorkflowElementReference> wers) '''
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateStringsXml() -->
		<resources>
			<string name="app_name">«app.appName»</string>
			«FOR frame : frames»
				<string name="title_activity_«frame.name.toFirstLower»">«frame.title»</string>
			«ENDFOR»
			
			«FOR wer : wers»
				<string name="«MD2AndroidUtil.getQualifiedNameAsString(wer.workflowElementReference, "_")»_alias">«wer.alias»</string>
			«ENDFOR»
			
			«FOR ve : viewGUIElements»
				«generateStringEntry(ve)»
			«ENDFOR»
		</resources>
	'''

	protected def static String generateStringEntry(ViewGUIElement viewGUIElement) {
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		switch viewGUIElement {
			OptionInput:
				return '''
					<string-array name="«qnp.getFullyQualifiedName(viewGUIElement).toString("_")»_entries">
						«IF viewGUIElement.enumBody !== null»
							«FOR elem : viewGUIElement.enumBody.elements»
								<item>«elem»</item>
							«ENDFOR»
						«ENDIF»
						«IF viewGUIElement.enumReference !== null && viewGUIElement.enumReference.enumBody !== null»
							«FOR elem : viewGUIElement.enumReference.enumBody.elements»
								<item>«elem»</item>
							«ENDFOR»
						«ENDIF»
					</string-array>
				'''
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

	def static String generateViewsXml(Iterable<ViewFrame> rootContainerElements, String mainPackage) '''		
		<?xml version="1.0" encoding="utf-8"?>
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateViewsXml() -->
		<resources>
		    <string name="StartActivity">«mainPackage».StartActivity</string>
		    «FOR rce : rootContainerElements»
		    	<string name="«rce.name»Activity">«mainPackage».«rce.name.toFirstUpper»Activity</string>
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
	
	def static String generateColorXml() '''
		<?xml version="1.0" encoding="utf-8"?>
		<!-- generated in de.wwu.md2.framework.generator.android.wearable.view.Values.generateColorsXml() -->
		<resources>
			<color name="background_material_light">#032859</color>
			<color name="foreground_material_light">#ff0909</color>
			<color name="white">#ffffff</color>
		</resources>
	'''
}