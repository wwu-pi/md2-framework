package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.generator.android.templates.StringsXmlTemplate
import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.CheckBox
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.EntitySelector
import de.wwu.md2.framework.mD2.FlowDirection
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.HexColorDef
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.StyleBody
import de.wwu.md2.framework.mD2.StyleDefinition
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewElementDef
import de.wwu.md2.framework.mD2.ViewElementRef
import de.wwu.md2.framework.mD2.ViewElementType
import java.util.Collection
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.Property

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static de.wwu.md2.framework.mD2.TextInputType.*

import static extension de.wwu.md2.framework.util.IterableExtensions.*

class LayoutXml {
	
	boolean isRootGenerated
	
	StringsXmlTemplate strings
	
	@Property
	Collection<ContainerElement> newFragmentsToGenerate
		
	new(StringsXmlTemplate stringsTemplate) {
		isRootGenerated = false
		newFragmentsToGenerate = newHashSet
		
		strings = stringsTemplate
	}
	
	def text(EObject obj, String text) {
		strings.addForXml(getName(obj) + "_text", text)
	}
	
	def generateLayoutXml(ContainerElement baseViewElem) '''
		<?xml version="1.0" encoding="utf-8"?>
		«generateElem(baseViewElem)»
	'''
	
	
	/////////////////////////////////////////////////////////
	// Content Elements
	/////////////////////////////////////////////////////////
	
	def private dispatch CharSequence generateElem(TextInput elem) '''
		«IF elem.labelText != null || elem.tooltipText != null || elem.type == DATE || elem.type == TIME || elem.type == DATE_TIME»
			<LinearLayout
				style="@style/ContainerDefault"
				android:orientation="horizontal">
		«ENDIF»
		
		«IF elem.labelText != null»
			«generateLabel(elem.labelText)»
		«ENDIF»
		
		«generateTextInput(elem)»
		
		«IF elem.tooltipText != null»
			«generateToolTip(getName(elem) + "ToolTip")»
		«ENDIF»
		
		«IF elem.labelText != null || elem.tooltipText != null || elem.type == DATE || elem.type == TIME || elem.type == DATE_TIME»
			</LinearLayout>
		«ENDIF»
	'''
	
	def private generateTextInput(TextInput elem) '''
		<EditText
			android:id="@+id/«getName(elem)»"
			style="@style/ContentDefault.EditTextDefault"
			android:inputType="«getInputType(elem)»" />
			
			«IF elem.type == DATE || elem.type == TIME || elem.type == DATE_TIME»
				<Button
					android:id="@+id/«getName(elem)»SetButton"
					style="@style/ContentDefault"
					android:text="«strings.addForXml('dateOrTimeFieldBtn_commonText', 'Set')»" />
			«ENDIF»
	'''
	
	def private dispatch CharSequence generateElem(OptionInput elem) '''
		«IF elem.labelText != null || elem.tooltipText != null»
			<LinearLayout
				style="@style/ContainerDefault"
				android:orientation="horizontal">
		«ENDIF»
		
		«IF elem.labelText != null»
			«generateLabel(elem.labelText)»
		«ENDIF»
		
		«generateOptionInput(elem)»
		
		«IF elem.tooltipText != null»
			«generateToolTip(getName(elem) + "ToolTip")»
		«ENDIF»
		
		«IF elem.labelText != null || elem.tooltipText != null»
			</LinearLayout>
		«ENDIF»
	'''
	
	def private generateOptionInput(OptionInput elem) '''
		<Spinner
			android:id="@+id/«getName(elem)»"
			style="@style/ContentDefault" />
	'''

	def private dispatch CharSequence generateElem(Label elem) {
		if(elem.style != null) {
			val StyleDefinition styleDef = elem.style as StyleDefinition
			val styleBody = styleDef.definition
			generateLabel(getName(elem), elem.text, generateStyle(styleBody))
		}
		else {
			generateLabel(getName(elem), elem.text, null);
		}
	}
	
	def private generateLabel(String text) {
		generateLabel(null, text, null)
	}

	def private generateLabel(String name, String text, CharSequence style) '''
		<TextView
			«IF name != null»
				android:id="@+id/«name»"
			«ENDIF»
			style="@style/ContentDefault"
			«IF style != null»
				«style»
			«ENDIF»
			android:text="«strings.addForXml(if(name!=null) name+"_text" else '''label«anonymousName»_text''', text)»" />
	'''
	
	def private dispatch CharSequence generateElem(Image elem) '''
		<ImageView
			android:id="@+id/«getName(elem)»"
			«IF elem.width == 0»
				android:layout_width="wrap_content"
		«ELSE»
				android:layout_width="«elem.width»dp"
			«ENDIF»
			«IF elem.height == 0»
				android:layout_height="wrap_content"
			«ELSE»
				android:layout_height="«elem.height»dp"
			«ENDIF»
			android:src="@drawable/«elem.src.replaceAll("^\\./", "").replaceAll(".\\w*$", "")»" />
	'''
	
	/**
	 * Returns an empty element as spacer
	 */
	def private dispatch CharSequence generateElem(Spacer elem) '''
		<TextView />
	'''
	
	def private dispatch CharSequence generateElem(Button elem) '''
		<Button
			android:id="@+id/«getName(elem)»"
			style="@style/ContentDefault"
			«IF elem.style != null»
				«val StyleDefinition styleDef = elem.style as StyleDefinition»
				«val styleBody = styleDef.definition»
				«generateStyle(styleBody)»
			«ENDIF»
			android:text="«elem.text(elem.text)»" />
	'''
	
	def private dispatch CharSequence generateElem(CheckBox elem) '''
		«IF elem.tooltipText != null»
			<LinearLayout
				style="@style/ContainerDefault"
				android:orientation="horizontal">
		«ENDIF»
		
		<CheckBox
			android:id="@+id/«getName(elem)»"
			style="@style/ContentDefault"
			«IF elem.labelText != null»
				android:text="«elem.text(elem.labelText)»"
			«ENDIF»
			«IF elem.checked»
				android:checked="true"
			«ENDIF»
			 />
		
		«IF elem.tooltipText != null»
			«generateToolTip(getName(elem) + "ToolTip")»
		«ENDIF»
		
		«IF elem.tooltipText != null»
			</LinearLayout>
		«ENDIF»
	'''
	
	def private dispatch CharSequence generateElem(Tooltip elem) {
		generateToolTip(getName(elem))
	}
	
	
	def generateToolTip(String name) '''
		<ImageButton 
		    android:id="@+id/«name»"
			style="@style/ContentDefault.ToolTipDefault"
			android:contentDescription="«strings.addForXml('''tooltipImage_contentDesc''', "Tooltip")»" />
	'''
	
	def private dispatch CharSequence generateElem(EntitySelector elem) '''
		<Spinner
			android:id="@+id/«getName(elem)»"
			style="@style/ContentDefault" />
	'''
	
	def private getInputType(TextInput elem) {
		// TODO Replace with working code ==> see and probably extend type enum as introduced in grammar
		switch elem.type {
			case DATE: "date"
			case TIME: "time"
			case DATE_TIME: "datetime"
			
			
//			case "String": "text"
//			case "MultiLine": "textMultiLine"
//			case "Integer": "number"
//			case "Password": "textPassword"
//			case "Email": "textEmailAddress"
//			case "Phone": "phone"
			case DEFAULT: "text"
			default: "text"
		}
		// More types: http://developer.android.com/reference/android/widget/TextView.html#attr_android:inputType
	}
	
	def private generateStyle(StyleBody style) '''
		«IF style.fontSize != 0»
			android:textSize="«style.fontSize»sp"
		«ENDIF»
		«IF style.color != null»
			android:textColor="«(style.color as HexColorDef).color»"
		«ENDIF»
		«IF style.bold && style.italic»
			android:textStyle="italic|bold"
		«ELSEIF style.bold»
			android:textStyle="bold"
		«ELSEIF style.italic»
			android:textStyle="italic"
		«ENDIF»
	'''
	
	
	/////////////////////////////////////////////////////////
	// Container Elements
	/////////////////////////////////////////////////////////
	
	def private dispatch CharSequence generateElem(GridLayoutPane elem) '''
		<TableLayout«if (!checkIsRootGenerated) ' xmlns:android="http://schemas.android.com/apk/res/android"'»
			android:id="@+id/«getName(elem)»"
			style="@style/ContainerDefault">
			
			«var i = 0»
			«FOR row : elem.elements.slice(getColumnsCount(elem)) SEPARATOR("\n")»
				<TableRow
					android:id="@+id/«getName(elem)»Row«i = i + 1»"
					style="@style/ContainerDefault">
					
					«FOR viewElemType : row SEPARATOR("\n")»
						«generateElem(getViewGUIElement(viewElemType))»
					«ENDFOR»
					
				</TableRow>
			«ENDFOR»
			
		</TableLayout>
	'''
	
	def private dispatch CharSequence generateElem(FlowLayoutPane elem) '''
		<LinearLayout«if (!checkIsRootGenerated) ' xmlns:android="http://schemas.android.com/apk/res/android"'»
			android:id="@+id/«getName(elem)»"
			style="@style/ContainerDefault"
			android:orientation="«getFlowDirection(elem)»">
			
			«FOR viewElemType : elem.elements SEPARATOR("\n")»
				«generateElem(getViewGUIElement(viewElemType))»
			«ENDFOR»
			
		</LinearLayout>
	'''
	
	def private dispatch CharSequence generateElem(AlternativesPane elem) '''
	'''
	
	def private dispatch CharSequence generateElem(TabbedAlternativesPane elem) '''
	'''
	
	def private getViewGUIElement(ViewElementType viewElemType) {
		switch viewElemType {
			ViewElementRef: viewElemType.value
			ViewElementDef: viewElemType.value
		}
	}
	
	def private getColumnsCount(GridLayoutPane grdPane) {
		var int colCount
		var int rowCount
		
		for(param : grdPane.params) {
			switch param {
				GridLayoutPaneRowsParam: rowCount = param.value
				GridLayoutPaneColumnsParam: colCount = param.value
			}
		}
		
		// if only rows or columns are defined, calculate the other value
		if(colCount == 0) {
			Math::ceil(grdPane.elements.size.doubleValue / rowCount as Integer).intValue
		}
		else {
			colCount
		}
	}
	
	def private getFlowDirection(FlowLayoutPane flowPane) {
		val flowDirection = flowPane.params.filter(typeof(FlowLayoutPaneFlowDirectionParam)).last.flowDirection
		
		switch (flowDirection) {
			case FlowDirection::HORIZONTAL: "horizontal"
			case FlowDirection::VERTICAL: "vertical"
		}
	}
	
	def private checkIsRootGenerated() {
		if(!isRootGenerated) {
			isRootGenerated = true
			false
		}
		else {
			true
		}
	}
}