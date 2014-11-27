package de.wwu.md2.framework.tests.dsl.view

import com.google.inject.Inject
import de.wwu.md2.framework.MD2InjectorProvider
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.NamedColorDef
import de.wwu.md2.framework.mD2.StyleDefinition
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.WidthParam
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*import de.wwu.md2.framework.mD2.StyleReference

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))

class GridLayoutPaneTest {
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
		val buttonName1 = "myButton"
		val buttonText1 = "MyButton"
		val colorButton1 = "red"
		val fontSize1 = 4.2
		
		val buttonName2 = "myOtherButton"
		val buttonText2 = "MyOther"
		val fontSize2 = 2.0
		val colorButton2 = "blue"
		val textStyle2 = "italic"
		
		val model = '''
			GridLayoutPane MyGridLayoutWithButtonElement(columns 42) {
				Button «buttonName1» ("«buttonText1»") {
					style {
						color «colorButton1»
						fontSize «fontSize1»
						textStyle italic bold
					}
					disabled true 
				}
				
				Button «buttonName2» ("«buttonText2»") {
					style myStyle
					disabled false
					width 42%
				}
			}
			style myStyle {
				color «colorButton2»
				fontSize «fontSize2»
				textStyle «textStyle2»
			}
		'''.parse
		val view = model.modelLayer as View
		val gridLayoutPane = view.viewElements.get(0) as GridLayoutPane
		val elements = gridLayoutPane.elements
		
		// --------------------------
		// test first button
		// --------------------------
		// test name and text
		val button1 = elements.get(0) as Button
		buttonName1.assertEquals(button1.name)
		buttonText1.assertEquals(button1.text)
		true.assertEquals(button1.isDisabled)
		// test style: color
		val style1 = button1.style as StyleDefinition
		val color1 = style1.definition.color as NamedColorDef
		colorButton1.assertEquals(color1.color.literal)
		// test style: font size
		new Double(fontSize1).assertEquals(new Double(style1.definition.fontSize)) // TODO: why deprecated? check that!
		// test style: font style
		true.assertEquals(style1.definition.bold)
		true.assertEquals(style1.definition.italic)
		
		// --------------------------
		// test second button
		// --------------------------
		val button2 = elements.get(1) as Button
		buttonName2.assertEquals(button2.name)
		buttonText2.assertEquals(button2.text)
		false.assertEquals(button2.isDisabled)
		// test style: color
		val style2 = button2.style as StyleReference
		val color2 = style2.reference.body.color as NamedColorDef
		colorButton2.assertEquals(color2.color.literal)
		// test style: font size
		new Double(fontSize2).assertEquals(new Double(style2.reference.body.fontSize)) // TODO: why deprecated? check that!
		// test style: font style
		true.assertEquals(style2.reference.body.italic)
	}
	
}
