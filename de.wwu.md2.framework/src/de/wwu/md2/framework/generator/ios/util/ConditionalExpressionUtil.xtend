package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.And
import de.wwu.md2.framework.mD2.BooleanExpression
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.ConditionalExpression
import de.wwu.md2.framework.mD2.GuiElementStateExpression
import de.wwu.md2.framework.mD2.Not
import de.wwu.md2.framework.mD2.Or

/**
 * Generate ConditionalExpression MD2 language elements.
 */
class ConditionalExpressionUtil {
	
	/**
	 * Generate a Swift representation for a ConditionalExpression element.
	 *
	 * @param expression The expression to generate.
	 * @return The Swift string representing the expression.
	 */
	def static String getStringRepresentation(ConditionalExpression expression) {
		switch expression {
			Or: return evaluateOr(expression)
			And: return evaluateAnd(expression)
			Not: return evaluateNot(expression)
			BooleanExpression: return evaluateBooleanExpression(expression)
			GuiElementStateExpression: return evaluateGuiElementStateExpression(expression)
			CompareExpression: return evaluateCompareExpression(expression)
			default: {
				IOSGeneratorUtil.printError("ConditionalExpressionUtil encountered unsupported expression: " + expression)
				return ""
			}
		}
	}
	
	/**
	 * Generate an And-Operator.
	 * 
	 * @param expression The And-expression to generate.
	 * @return The Swift string representing the expression.
	 */
	def static evaluateAnd(And expression) {
		return "(" + getStringRepresentation(expression.leftExpression) + " && " 
			+ getStringRepresentation(expression.rightExpression) + ")"
	}
	
	/**
	 * Generate an And-Operator.
	 * 
	 * @param expression The Or-expression to generate.
	 * @return The Swift string representing the expression.
	 */
	def static evaluateOr(Or expression) {
		return "(" + getStringRepresentation(expression.leftExpression) + " || " 
			+ getStringRepresentation(expression.rightExpression) + ")"
	}
	
	/**
	 * Generate an Not-Operator.
	 * 
	 * @param expression The Not-expression to generate.
	 * @return The Swift string representing the expression.
	 */
	def static evaluateNot(Not expression) {
		return "!(" + getStringRepresentation(expression.expression) + ")"
	}
	
	/**
	 * Generate a boolean expression.
	 * 
	 * @param expression The boolean expression to generate.
	 * @return The Swift string representing the expression.
	 */
	def static evaluateBooleanExpression(BooleanExpression expression) {
		return expression.value.literal.toLowerCase
	}
	
	/**
	 * Generate a GuiElementState expression.
	 * TODO Default values are not yet supported.
	 * 
	 * @param expression The expression to generate.
	 * @return The Swift string representing the expression.
	 */
	def static evaluateGuiElementStateExpression(GuiElementStateExpression expression) {
		val element = "MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping." + MD2GeneratorUtil.getName(expression.reference.tail.viewElementRef).toFirstUpper + ")!"
		
		switch expression.isState{
			case VALID: return element + ".validate() == true"
			case EMPTY: return "(!(" + element + ".value.isSet()) || " + element + ".value.toString() == '')"
			case SET: return element + ".value.isSet()"
			case DEFAULT_VALUE: {
				IOSGeneratorUtil.printError("ConditionalExpressionUtil: DEFAULT_VALUE unsupported")
				//TODO return element + ".value.equals(MD2String('" + expression.reference.ref... + "'))"
				return ""
			}
			case DISABLED: return element + ".isElementDisabled"
			case ENABLED: return "!(" + element + ".isElementDisabled)"
		}
	}
	
	/**
	 * Generate a Compare expression.
	 * 
	 * @param expression The expression to generate.
	 * @return The Swift string representing the expression.
	 */
	def static evaluateCompareExpression(CompareExpression expression){
		/* Currently there is no better way to compare arbitrary expressions than casting both
		 * values to generic MD2 strings and compare them */  
		val expLeft = "MD2String(" + SimpleExpressionUtil.getStringValue(expression.eqLeft) + ")"
		val expRight = "MD2String(" + SimpleExpressionUtil.getStringValue(expression.eqRight) + ")"
		
		switch expression.op {
			case EQUALS: return expLeft + ".equals(" + expRight + ")"
			case GREATER: return expLeft + ".gt(" + expRight + ")"
			case SMALLER: return expLeft + ".lt(" + expRight + ")"
			case GREATER_OR_EQUAL: return expLeft + ".gte(" + expRight + ")"
			case SMALLER_OR_EQUAL: return expLeft + ".lte(" + expRight + ")"
		}
	}
}