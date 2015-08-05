package de.wwu.md2.framework.generator.android.lollipop.view

import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.InputElement
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewElement

class Values {
	
	def static String generateIdsXml(Iterable<ViewElement> viewElements) '''
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateIdsXml() -->
		<?xml version="1.0" encoding="utf-8"?>
		<resources>
			«FOR ve : viewElements»
				<item name="«ve.name»" type="id"/>
			«ENDFOR»
		</resources>
	'''
	
	def static String generateStringsXml(App app, Iterable<ViewElement> viewElements) '''
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.view.Values.generateStringsXml() -->
		<resources>
			<string name="app_name">«app.appName»</string>
			«FOR ve : viewElements»
				«generateStringEntry(ve)»
			«ENDFOR»
		</resources>
	'''

	def private static String generateStringEntry(ViewElement viewElement){
		switch viewElement{
			InputElement:
				return '''
					<string name="«viewElement.name»_label">«viewElement.labelText»</string>
					<string name="«viewElement.name»_tooltip">«viewElement.tooltipText»</string>
				'''
			Image:
				return '''
					<string name="«viewElement.name»_src">«viewElement.src»</string>
				'''
			Button:
				return '''
					<string name="«viewElement.name»_text">«viewElement.text»</string>
				'''
			Label:
				return '''
					<string name="«viewElement.name»_label">«viewElement.text»</string>
				'''
			Tooltip:
				return '''
					<string name="«viewElement.name»_text">«viewElement.text»</string>
				'''			
		}
	}
	
	def static String generateViewsXml(Iterable<ContainerElement> rootContainerElements, String mainPackage) '''
		<?xml version="1.0" encoding="utf-8"?>
		<resources>
		    <string name="StartActivity">«mainPackage».StartActivity</string>
		    «FOR rce : rootContainerElements»
		    <string name="«rce.name»Activity">«mainPackage».«rce.name»Activity</string>
			«ENDFOR»
		</resources>
	'''
}