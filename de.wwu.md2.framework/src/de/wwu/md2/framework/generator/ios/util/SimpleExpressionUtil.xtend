package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.ConcatenatedString
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TimeVal

/**
 * Generate SimpleExpression MD2 language elements.
 */
class SimpleExpressionUtil {
	
	/**
	 * Generate a Swift representation for a SimpleExpression element.
	 *
	 * @param expression The expression to generate.
	 * @return The Swift string representing the expression.
	 */
	def static getStringValue(SimpleExpression expression){
		return '"' + recursiveExpressionBuilder(expression) + '"'
	}
	
	/**
	 * Recursive function to create a Swift representation for a SimpleExpression (sub-)expression.
	 * TODO Only a subset is implemented yet. 
	 *  
	 * @param expression The expression to generate.
	 * @return The Swift string representing the expression.
	 */
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
			// Use string interpolation to facilitate generation (no need to create the string concatenation)
			AbstractViewGUIElementRef: {
				return  '\\(MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.' 
					+ MD2GeneratorUtil.getName(expression.ref).toFirstUpper
					+ ')!.value.toString())'
			}
			/* Content providers cannot be used in combination with string interpolation because of the
			 * unsupported quotation marks in the provider lookup -> use traditional string concatenation */ 
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