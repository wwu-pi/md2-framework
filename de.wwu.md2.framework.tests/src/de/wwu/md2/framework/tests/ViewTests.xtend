package de.wwu.md2.framework.tests

import com.google.inject.Inject
import de.wwu.md2.framework.MD2InjectorProvider
import de.wwu.md2.framework.mD2.MD2Model
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import static extension org.junit.Assert.*
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam

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
	
	
	
}
