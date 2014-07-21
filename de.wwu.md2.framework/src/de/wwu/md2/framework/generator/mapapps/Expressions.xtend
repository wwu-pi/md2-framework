package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.AbstractProviderReference
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.And
import de.wwu.md2.framework.mD2.BooleanExpression
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.ConcatenatedString
import de.wwu.md2.framework.mD2.ConditionalExpression
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.Div
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.GuiElementStateExpression
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.Minus
import de.wwu.md2.framework.mD2.Mult
import de.wwu.md2.framework.mD2.Not
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.Or
import de.wwu.md2.framework.mD2.Plus
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.ViewElementState

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.DateISOFormatter.*
import static extension de.wwu.md2.framework.util.StringExtensions.*

class Expressions {
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Conditional Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def static String generateCondition(ConditionalExpression expression) {
		switch (expression) {
			Or: '''
				(
					«generateCondition(expression.leftExpression)» ||
					«generateCondition(expression.rightExpression)»
				)'''
			And: '''
				«generateCondition(expression.leftExpression)» &&
				«generateCondition(expression.rightExpression)»'''
			Not: '''!(«generateCondition(expression.expression).trimParentheses»)'''
			BooleanExpression: '''«expression.value.toString»'''
			CompareExpression: {
				val operator = switch expression.op {
					case Operator::EQUALS: "equals"
					case Operator::GREATER: "gt"
					case Operator::SMALLER: "lt"
					case Operator::GREATER_OR_EQUAL: "gte"
					case Operator::SMALLER_OR_EQUAL: "lte"
				}
				'''«generateSimpleExpression(expression.eqLeft)».«operator»(«generateSimpleExpression(expression.eqRight)»)'''
			}
			GuiElementStateExpression: '''«generateGUIElementStateExpression(expression)»'''
		}
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// GUI Element State Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static generateGUIElementStateExpression(GuiElementStateExpression expression) {
		val widget = '''this.$.widgetRegistry.getWidget("«getName(resolveViewGUIElement(expression.reference))»")'''
		switch (expression.isState) {
			case ViewElementState::VALID: '''«widget».isValid()'''
			case ViewElementState::EMPTY: '''(!«widget».getValue() || !«widget».getValue().isSet())'''
			case ViewElementState::SET: '''(«widget».getValue() && «widget».getValue().isSet())'''
			case ViewElementState::DEFAULT_VALUE: '''(«widget».getDefaultValue() && «widget».getDefaultValue().equals(«widget».getValue()))'''
			case ViewElementState::DISABLED: '''«widget».isDisabled()'''
			case ViewElementState::ENABLED: '''!«widget».isDisabled()'''
		}
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Simple Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def static String generateSimpleExpression(SimpleExpression expression) {
		switch (expression) {
			// literals
			StringVal: '''this.$.create("string", "«expression.value.escape»")'''
			IntVal: '''this.$.create("integer", «expression.value»)'''
			FloatVal: '''this.$.create("float", «expression.value»)'''
			BooleanVal: '''this.$.create("boolean", «expression.value.toString»)'''
			DateVal: '''this.$.create("date", stamp.fromISOString("«expression.value.toISODate»"))'''
			TimeVal: '''this.$.create("time", stamp.fromISOString("«expression.value.toISOTime»"))'''
			DateTimeVal: '''this.$.create("datetime", stamp.fromISOString("«expression.value.toISODateTime»"))'''
			
			// literals
			AbstractViewGUIElementRef: '''this.$.widgetRegistry.getWidget("«getName(resolveViewGUIElement(expression))»").getValue()'''
			AbstractContentProviderPath: '''this.$.contentProviderRegistry.getContentProvider("«expression.resolveContentProviderName»").getValue("«expression.resolveContentProviderPathAttribute»")'''
			AbstractProviderReference: '''this.$.contentProviderRegistry.getContentProvider("«expression.resolveContentProviderName»").getContent()'''
			
			// concatenated string
			ConcatenatedString: '''this.$.create("string", «generateConcatenatedString(expression)»)'''
			
			// math expressions
			default:  '''this.$.create("float", «generateMathExpression(expression)»)'''
		}
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Concatenated Strings
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static String generateConcatenatedString(ConcatenatedString expression) '''
		«generateSimpleExpression(expression.leftString)».toString()
		.concat(«generateSimpleExpression(expression.rightString)»)
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Math Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static String generateMathExpression(SimpleExpression expression) {
		switch (expression) {
			Plus: '''(«generateSimpleExpression(expression.leftOperand)».getPlatformValue() + «generateSimpleExpression(expression.rightOperand)».getPlatformValue())'''
			Minus: '''(«generateSimpleExpression(expression.leftOperand)».getPlatformValue() - «generateSimpleExpression(expression.rightOperand)».getPlatformValue())'''
			Mult: '''«generateSimpleExpression(expression.leftOperand)».getPlatformValue() * «generateSimpleExpression(expression.rightOperand)».getPlatformValue()'''
			Div: '''«generateSimpleExpression(expression.leftOperand)».getPlatformValue() / «generateSimpleExpression(expression.rightOperand)».getPlatformValue()'''
		}
	}
	
}