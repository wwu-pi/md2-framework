package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.mD2.ConditionalExpression
import de.wwu.md2.framework.mD2.Or
import de.wwu.md2.framework.mD2.And
import de.wwu.md2.framework.mD2.Not
import de.wwu.md2.framework.mD2.BooleanExpression
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.GuiElementStateExpression
import de.wwu.md2.framework.generator.ios.view.IOSWidgetMapping

class ConditionalExpressionUtil {
	
	def static String getStringRepresentation(ConditionalExpression expression) {
		switch expression {
			Or: return evaluateOr(expression)
			And: return evaluateAnd(expression)
			Not: return evaluateNot(expression)
			BooleanExpression: return evaluateBooleanExpression(expression)
			GuiElementStateExpression: return evaluateGuiElementStateExpression(expression)
			CompareExpression: return evaluateCompareExpression(expression)
			default: {
				GeneratorUtil.printError("ConditionalExpressionUtil encountered unsupported expression: " + expression)
				return ""
			}
		}
	}
	
	def static evaluateAnd(And expression) {
		return "(" + getStringRepresentation(expression.leftExpression) + "&&" 
			+ getStringRepresentation(expression.rightExpression) + ")"
	}
	
	def static evaluateOr(Or expression) {
		return "(" + getStringRepresentation(expression.leftExpression) + "||" 
			+ getStringRepresentation(expression.rightExpression) + ")"
	}
	
	def static evaluateNot(Not expression) {
		return "!(" + getStringRepresentation(expression.expression) + ")"
	}
	
	def static evaluateBooleanExpression(BooleanExpression expression) {
		return expression.value.literal.toLowerCase
	}
	
	def static evaluateGuiElementStateExpression(GuiElementStateExpression expression) {
		val element = "WidgetRegistry.instance.getWidget(WidgetMapping." + IOSWidgetMapping.lookup(expression.reference) + ")!"
		
		switch expression.isState{
			case VALID: return element + ".validate() == true"
			case EMPTY: return "(!(" + element + ".value.isSet()) || " + element + ".value.toString() == '')"
			case SET: return element + ".value.isSet()"
			case DEFAULT_VALUE: {
				GeneratorUtil.printError("ConditionalExpressionUtil: DEFAULT_VALUE unsupported")
				//return element + ".value.equals(MD2String('" + expression.reference.ref... + "'))"
				return ""
			}
			case DISABLED: return element + ".isElementDisabled"
			case ENABLED: return "!(" + element + ".isElementDisabled)"
		}
	}
	
	def static evaluateCompareExpression(CompareExpression expression){
		val expLeft = SimpleExpressionUtil.getStringValue(expression.eqLeft)
		val expRight = SimpleExpressionUtil.getStringValue(expression.eqRight)
		
		switch expression.op {
			case EQUALS: return expLeft + ".equals(" + expRight + ")"
			case GREATER: return expLeft + ".gt(" + expRight + ")"
			case SMALLER: return expLeft + ".lt(" + expRight + ")"
			case GREATER_OR_EQUAL: return expLeft + ".gte(" + expRight + ")"
			case SMALLER_OR_EQUAL: return expLeft + ".lte(" + expRight + ")"
		}
	}
}