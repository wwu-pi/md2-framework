package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.ConcatenatedString
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.generator.ios.model.IOSWidgetMapping

class SimpleExpressionUtil {
	
	// TODO only for subset of expressions yet
	def static getStringValue(SimpleExpression expression){
		return recursiveExpressionBuilder(expression)
	}
	
	def static String recursiveExpressionBuilder(SimpleExpression expression) {
		switch expression {
			StringVal: return (expression as StringVal).value
			BooleanVal: return (expression as BooleanVal).value.toString  
			DateVal: return (expression as DateVal).value.toString
			TimeVal: return (expression as TimeVal).value.toString
			DateTimeVal: return (expression as DateTimeVal).value.toString
			ConcatenatedString: {
				return (expression as ConcatenatedString).leftString 
					+ recursiveExpressionBuilder((expression as ConcatenatedString).rightString)
				}
			AbstractViewGUIElementRef: {
				return  '" + WidgetRegistry.instance.getWidget(WidgetMapping.' 
					+ IOSWidgetMapping.lookup(expression as AbstractViewGUIElementRef)
					+ ')!.value.toString() + "'
			}  
			default: {
				GeneratorUtil.printError("SimpleExpressionUtil encountered unsupported expression: " + expression)
				return ""
			}
		}
	}
}