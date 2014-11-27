package de.wwu.md2.framework.tests.dsl.view

import com.google.inject.Inject
import de.wwu.md2.framework.MD2InjectorProvider
import de.wwu.md2.framework.mD2.FlowDirection
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPaneFlowDirectionParam
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.WidthParam
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))

class FlowLayoutPaneTest {
	@Inject extension ParseHelper<MD2Model>	
	
	@Test
	def flowLayoutColumnHorizontalTest() {
		val model = '''FlowLayoutPane MyFlowLayoutHorizontal ( horizontal ) { }'''.parse
		val view = model.modelLayer as View
		val flowLayoutPane = view.viewElements.head as FlowLayoutPane
		val flowParam = flowLayoutPane.params.head as FlowLayoutPaneFlowDirectionParam 
		FlowDirection.HORIZONTAL.assertEquals(flowParam.flowDirection)
	}
	
	@Test
	def flowLayoutColumnVerticalTest() {
		val model = '''FlowLayoutPane MyFlowLayoutVertical ( vertical ) { }'''.parse
		val view = model.modelLayer as View
		val flowLayoutPane = view.viewElements.head as FlowLayoutPane
		val flowParam = flowLayoutPane.params.head as FlowLayoutPaneFlowDirectionParam 
		FlowDirection.VERTICAL.assertEquals(flowParam.flowDirection)
	}
	
	@Test
	def flowLayoutColumnWidthTest() {
		val width = 42
		val model = '''FlowLayoutPane MyFlowLayoutWidth ( width «width»% ) { }'''.parse
		val view = model.modelLayer as View
		val flowLayoutPane = view.viewElements.head as FlowLayoutPane
		val flowParam = flowLayoutPane.params.head as WidthParam 
		width.assertEquals(flowParam.width)
	}
}
