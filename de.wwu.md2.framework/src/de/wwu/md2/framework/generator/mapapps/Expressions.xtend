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
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.ViewElementState
import java.util.Map

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.DateISOFormatter.*
import static extension de.wwu.md2.framework.util.StringExtensions.*

class Expressions {
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Conditional Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def static String generateCondition(ConditionalExpression expression, String varName, Map<String, String> imports) {
		switch (expression) {
			Or: {
				val leftBoolVar = getUnifiedName("bool")
				val rightBoolVar = getUnifiedName("bool")
				'''
					«generateCondition(expression.leftExpression, leftBoolVar, imports)»
					«generateCondition(expression.rightExpression, rightBoolVar, imports)»
					var «varName» = «leftBoolVar» || «rightBoolVar»;
				'''
			}
			And: {
				val leftBoolVar = getUnifiedName("bool")
				val rightBoolVar = getUnifiedName("bool")
				'''
					«generateCondition(expression.leftExpression, leftBoolVar, imports)»
					«generateCondition(expression.rightExpression, rightBoolVar, imports)»
					var «varName» = «leftBoolVar» && «rightBoolVar»;
				'''
			}
			Not: {
				val boolVar = getUnifiedName("bool")
				'''
					«generateCondition(expression.expression, boolVar, imports)»
					var «varName» = !«boolVar»;
				'''
			}
			BooleanExpression: '''
				var «varName» = «expression.value.toString»;
			'''
			CompareExpression: {
				val leftExprVar = getUnifiedName("expr")
				val rightExprVar = getUnifiedName("expr")
				val operator = switch expression.op {
					case Operator::EQUALS: "equals"
					case Operator::GREATER: "gt"
					case Operator::SMALLER: "lt"
					case Operator::GREATER_OR_EQUAL: "gte"
					case Operator::SMALLER_OR_EQUAL: "lte"
				}
				'''
					«generateSimpleExpression(expression.eqLeft, leftExprVar, imports)»
					«generateSimpleExpression(expression.eqRight, rightExprVar, imports)»
					var «varName» = «leftExprVar».«operator»(«rightExprVar»);
				'''
			}
			GuiElementStateExpression: '''
				«generateGUIElementStateExpression(expression, varName)»
			'''
		}
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// GUI Element State Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static generateGUIElementStateExpression(GuiElementStateExpression expression, String varName) {
		val widgetVar = getUnifiedName("widget")
		val exprStr = switch (expression.isState) {
			case ViewElementState::VALID: '''«widgetVar».isValid()'''
			case ViewElementState::EMPTY: '''!«widgetVar».getValue() || !«widgetVar».getValue().isSet()'''
			case ViewElementState::SET: '''«widgetVar».getValue() && «widgetVar».getValue().isSet()'''
			case ViewElementState::DEFAULT_VALUE: '''«widgetVar».getDefaultValue() && «widgetVar».getDefaultValue().equals(«widgetVar».getValue())'''
			case ViewElementState::DISABLED: '''«widgetVar».isDisabled()'''
			case ViewElementState::ENABLED: '''!«widgetVar».isDisabled()'''
		}
		'''
			var «widgetVar» = this.$.widgetRegistry.getWidget("«getName(resolveViewElement(expression.reference))»");
			var «varName» = «exprStr»;
		'''
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Simple Expressions => Constant Literals
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def static dispatch String generateSimpleExpression(StringVal expression, String varName, Map<String, String> imports) '''
		var «varName» = this.$.create("string", "«expression.value.escape»");
	'''
	
	def static dispatch String generateSimpleExpression(IntVal expression, String varName, Map<String, String> imports) '''
		var «varName» = this.$.create("integer", «expression.value»);
	'''
	
	def static dispatch String generateSimpleExpression(FloatVal expression, String varName, Map<String, String> imports) '''
		var «varName» = this.$.create("float", «expression.value»);
	'''
	
	def static dispatch String generateSimpleExpression(BooleanVal expression, String varName, Map<String, String> imports) '''
		var «varName» = this.$.create("boolean", «expression.value.toString»);
	'''
	
	def static dispatch String generateSimpleExpression(DateVal expression, String varName, Map<String, String> imports) {
		imports.put("stamp", "dojo/date/stamp")
		'''
			var «varName» = this.$.create("date", stamp.fromISOString("«expression.value.toISODate»"));
		'''
	}
	
	def static dispatch String generateSimpleExpression(TimeVal expression, String varName, Map<String, String> imports) {
		imports.put("stamp", "dojo/date/stamp")
		'''
			var «varName» = this.$.create("time", stamp.fromISOString("«expression.value.toISOTime»"));
		'''
	}
	
	def static dispatch String generateSimpleExpression(DateTimeVal expression, String varName, Map<String, String> imports) {
		imports.put("stamp", "dojo/date/stamp")
		'''
			var «varName» = this.$.create("datetime", stamp.fromISOString("«expression.value.toISODateTime»"));
		'''
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Simple Expressions => Variable Literals
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def static dispatch String generateSimpleExpression(AbstractViewGUIElementRef expression, String varName, Map<String, String> imports) '''
		var «varName» = this.$.widgetRegistry.getWidget("«getName(resolveViewElement(expression))»").getValue();
	'''
	
	def static dispatch String generateSimpleExpression(AbstractContentProviderPath expression, String varName, Map<String, String> imports) '''
		var «varName» = this.$.contentProviderRegistry.getContentProvider("«expression.resolveContentProviderName»").getValue("«expression.resolveContentProviderPathAttribute»");
	'''
	
	def static dispatch String generateSimpleExpression(AbstractProviderReference expression, String varName, Map<String, String> imports) '''
		var «varName» = this.$.contentProviderRegistry.getContentProvider("«expression.resolveContentProviderName»").getContent();
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Simple Expressions => Concatenated Strings
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def static dispatch String generateSimpleExpression(ConcatenatedString expression, String varName, Map<String, String> imports) {
		val leftStrVar = getUnifiedName("str")
		val rightStrVar = getUnifiedName("str")
		'''
			«generateSimpleExpression(expression.leftString, leftStrVar, imports)»
			«generateSimpleExpression(expression.rightString, rightStrVar, imports)»
			var «varName» = this.$.create("string", «leftStrVar».toString().concat(«rightStrVar»));
		'''
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Simple Expressions => Math Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def static dispatch String generateSimpleExpression(Plus expression, String varName, Map<String, String> imports) {
		val leftOperandVar = getUnifiedName("math")
		val rightOperandVar = getUnifiedName("math")
		'''
			«generateSimpleExpression(expression.leftOperand, leftOperandVar, imports)»
			«generateSimpleExpression(expression.rightOperand, rightOperandVar, imports)»
			var «varName» = this.$.create("float", «leftOperandVar».getPlatformValue() + «rightOperandVar».getPlatformValue());
		'''
	}
	
	def static dispatch String generateSimpleExpression(Minus expression, String varName, Map<String, String> imports) {
		val leftOperandVar = getUnifiedName("math")
		val rightOperandVar = getUnifiedName("math")
		'''
			«generateSimpleExpression(expression.leftOperand, leftOperandVar, imports)»
			«generateSimpleExpression(expression.rightOperand, rightOperandVar, imports)»
			var «varName» = this.$.create("float", «leftOperandVar».getPlatformValue() - «rightOperandVar».getPlatformValue());
		'''
	}
	
	def static dispatch String generateSimpleExpression(Mult expression, String varName, Map<String, String> imports) {
		val leftOperandVar = getUnifiedName("math")
		val rightOperandVar = getUnifiedName("math")
		'''
			«generateSimpleExpression(expression.leftOperand, leftOperandVar, imports)»
			«generateSimpleExpression(expression.rightOperand, rightOperandVar, imports)»
			var «varName» = this.$.create("float", «leftOperandVar».getPlatformValue() * «rightOperandVar».getPlatformValue());
		'''
	}
	
	def static dispatch String generateSimpleExpression(Div expression, String varName, Map<String, String> imports) {
		val leftOperandVar = getUnifiedName("math")
		val rightOperandVar = getUnifiedName("math")
		'''
			«generateSimpleExpression(expression.leftOperand, leftOperandVar, imports)»
			«generateSimpleExpression(expression.rightOperand, rightOperandVar, imports)»
			var «varName» = this.$.create("float", «leftOperandVar».getPlatformValue() / «rightOperandVar».getPlatformValue());
		'''
	}
	
}