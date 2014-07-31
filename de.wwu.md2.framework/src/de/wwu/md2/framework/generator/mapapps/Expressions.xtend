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
import java.util.Map

class Expressions {
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Conditional Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def static String generateCondition(ConditionalExpression expression, Map<String, String> imports) {
		switch (expression) {
			Or: '''
				(
					«generateCondition(expression.leftExpression, imports)» ||
					«generateCondition(expression.rightExpression, imports)»
				)'''
			And: '''
				«generateCondition(expression.leftExpression, imports)» &&
				«generateCondition(expression.rightExpression, imports)»'''
			Not: '''!(«generateCondition(expression.expression, imports).trimParentheses»)'''
			BooleanExpression: '''«expression.value.toString»'''
			CompareExpression: {
				val operator = switch expression.op {
					case Operator::EQUALS: "equals"
					case Operator::GREATER: "gt"
					case Operator::SMALLER: "lt"
					case Operator::GREATER_OR_EQUAL: "gte"
					case Operator::SMALLER_OR_EQUAL: "lte"
				}
				'''«generateSimpleExpression(expression.eqLeft, imports)».«operator»(«generateSimpleExpression(expression.eqRight, imports)»)'''
			}
			GuiElementStateExpression: '''«generateGUIElementStateExpression(expression)»'''
		}
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// GUI Element State Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static generateGUIElementStateExpression(GuiElementStateExpression expression) {
		val widget = '''this.$.widgetRegistry.getWidget("«getName(resolveViewElement(expression.reference))»")'''
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
	
	def static String generateSimpleExpression(SimpleExpression expression, Map<String, String> imports) {
		switch (expression) {
			// literals
			StringVal: '''this.$.create("string", "«expression.value.escape»")'''
			IntVal: '''this.$.create("integer", «expression.value»)'''
			FloatVal: '''this.$.create("float", «expression.value»)'''
			BooleanVal: '''this.$.create("boolean", «expression.value.toString»)'''
			DateVal: {
				imports.put("stamp", "dojo/date/stamp")
				'''this.$.create("date", stamp.fromISOString("«expression.value.toISODate»"))'''
			}
			TimeVal: {
				imports.put("stamp", "dojo/date/stamp")
				'''this.$.create("time", stamp.fromISOString("«expression.value.toISOTime»"))'''
			}
			DateTimeVal: {
				imports.put("stamp", "dojo/date/stamp")
				'''this.$.create("datetime", stamp.fromISOString("«expression.value.toISODateTime»"))'''
			}
			
			// literals
			AbstractViewGUIElementRef: '''this.$.widgetRegistry.getWidget("«getName(resolveViewElement(expression))»").getValue()'''
			AbstractContentProviderPath: '''this.$.contentProviderRegistry.getContentProvider("«expression.resolveContentProviderName»").getValue("«expression.resolveContentProviderPathAttribute»")'''
			AbstractProviderReference: '''this.$.contentProviderRegistry.getContentProvider("«expression.resolveContentProviderName»").getContent()'''
			
			// concatenated string
			ConcatenatedString: '''this.$.create("string", «generateConcatenatedString(expression, imports)»)'''
			
			// math expressions
			default:  '''this.$.create("float", «generateMathExpression(expression, imports)»)'''
		}
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Concatenated Strings
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static String generateConcatenatedString(ConcatenatedString expression, Map<String, String> imports) '''
		«generateSimpleExpression(expression.leftString, imports)».toString()
		.concat(«generateSimpleExpression(expression.rightString, imports)»)
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Math Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static String generateMathExpression(SimpleExpression expression, Map<String, String> imports) {
		switch (expression) {
			Plus: '''(«generateSimpleExpression(expression.leftOperand, imports)».getPlatformValue() + «generateSimpleExpression(expression.rightOperand, imports)».getPlatformValue())'''
			Minus: '''(«generateSimpleExpression(expression.leftOperand, imports)».getPlatformValue() - «generateSimpleExpression(expression.rightOperand, imports)».getPlatformValue())'''
			Mult: '''«generateSimpleExpression(expression.leftOperand, imports)».getPlatformValue() * «generateSimpleExpression(expression.rightOperand, imports)».getPlatformValue()'''
			Div: '''«generateSimpleExpression(expression.leftOperand, imports)».getPlatformValue() / «generateSimpleExpression(expression.rightOperand, imports)».getPlatformValue()'''
		}
	}
	
}