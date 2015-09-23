package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.ConcatenatedString
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.generator.ios.view.WidgetMapping

class SimpleExpressionUtil {
	
	// MARK only a subset of available expressions are implemented yet
	def static getStringValue(SimpleExpression expression){
		return '"' + recursiveExpressionBuilder(expression) + '"'
	}
	
	def static String recursiveExpressionBuilder(SimpleExpression expression) {
		switch expression {
			StringVal: return expression.value
			BooleanVal: return expression.value.toString
			DateVal: return expression.value.toString
			TimeVal: return expression.value.toString
			DateTimeVal: return expression.value.toString
			ConcatenatedString: {
				return recursiveExpressionBuilder(expression.leftString) 
					+ ' ' 
					+ recursiveExpressionBuilder(expression.rightString)
				}
			AbstractViewGUIElementRef: {
				return  '\\(MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.' 
					+ WidgetMapping.lookup(expression)
					+ ')!.value.toString())'
			}
			ContentProviderPath: {
				return '" + MD2ContentProviderRegistry.instance.getContentProvider("'
					+ expression.contentProviderRef.name
					+ '")!.getValue("' 
					+ expression.tail.attributeRef.name + '")!.toString() + "'
			}
			default: {
				IOSGeneratorUtil.printError("SimpleExpressionUtil encountered unsupported expression: " + expression)
				return ""
			}
		}
	}
}