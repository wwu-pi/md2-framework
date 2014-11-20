package de.wwu.md2.framework.tests

import com.google.inject.Inject
import de.wwu.md2.framework.MD2InjectorProvider
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.WidthParam
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.StyleBody
import de.wwu.md2.framework.mD2.Color
import de.wwu.md2.framework.mD2.NamedColor
import de.wwu.md2.framework.mD2.NamedColorDef
import de.wwu.md2.framework.mD2.StyleDefinition

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))

class ViewTests {
	@Inject extension ParseHelper<MD2Model>	
	
	@Test
	def gridLayoutColumnValueTest() {
		val model = '''GridLayoutPane MyGridLayout (columns 42) {}'''.parse
		val view = model.modelLayer as View
		val gridLayoutPane = view.viewElements.head as GridLayoutPane
		val gridColumnParam = gridLayoutPane.params.head as GridLayoutPaneColumnsParam
		42.assertEquals(gridColumnParam.value)
	}
	
	@Test
	def gridLayoutRowValueTest() {
		val model = '''GridLayoutPane MyGridLayout (rows 42) {}'''.parse
		val view = model.modelLayer as View
		val gridLayoutPane = view.viewElements.head as GridLayoutPane
		val gridRowParam = gridLayoutPane.params.head as GridLayoutPaneRowsParam
		42.assertEquals(gridRowParam.value)
	}
		
	@Test
	def gridLayoutNameTest() {
		val layoutName = "MyGridLayout"
		val model = '''GridLayoutPane «layoutName» {columns 2}'''.parse
		val view = model.modelLayer as View
		val gridLayoutPane = view.viewElements.get(0) as GridLayoutPane
		layoutName.assertEquals(gridLayoutPane.name)
	}
	
	@Test
	def gridLayoutWidthTest() {
		val int widthValue = 84
		val width = widthValue + "%"
		val model = '''GridLayoutPane MyGridLayoutWithWidth (rows 22, width «width») {}'''.parse
		val view = model.modelLayer as View
		val gridLayoutPane = view.viewElements.get(0) as GridLayoutPane
		val widthParam = gridLayoutPane.params.get(1) as WidthParam
		widthValue.assertEquals(widthParam.width)
	}
	
	@Test
	def gridlayoutWithButtonTest() {
		val buttonName = "myButton"
		val buttonText = "MyButton"
		val colorRed = "red"
		val fontSize = 4.2
		
		val model = '''
			GridLayoutPane MyGridLayoutWithButtonElement(columns 42) {
				Button «buttonName» ("«buttonText»") {
					style {
						color «colorRed»
						fontSize «fontSize»
						textStyle italic bold
					}
					disabled true 
				}
				
				Button myOtherButton ("MyOther") {
					style myStyle
					disabled false
					width 42%
				}
			}
			style myStyle {
				color green
				fontSize 2.0
				textStyle normal
			}
		'''.parse
		val view = model.modelLayer as View
		val gridLayoutPane = view.viewElements.get(0) as GridLayoutPane
		val elements = gridLayoutPane.elements
		
		// --------------------------
		// test first button
		// --------------------------
		// test name and text
		val button = elements.get(0) as Button
		buttonName.assertEquals(button.name)
		buttonText.assertEquals(button.text)
		// test style: color
		val style = button.style as StyleDefinition
		val color = style.definition.color as NamedColorDef
		colorRed.assertEquals(color.color.literal)
		// test style: fontSize
		fontSize.assertEquals(style.definition.fontSize) // TODO: why deprecated? check that!
	}
	
}
