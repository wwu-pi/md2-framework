package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.And
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.BooleanExpression
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.ConcatenatedString
import de.wwu.md2.framework.mD2.ConditionalCodeFragment
import de.wwu.md2.framework.mD2.ConditionalExpression
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderEventRef
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.ContentProviderResetAction
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.CustomizedValidatorType
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.DisableAction
import de.wwu.md2.framework.mD2.DisplayMessageAction
import de.wwu.md2.framework.mD2.Div
import de.wwu.md2.framework.mD2.EnableAction
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.GlobalEventRef
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.GuiElementStateExpression
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.MappingTask
import de.wwu.md2.framework.mD2.MathLiteral
import de.wwu.md2.framework.mD2.MathSubExpression
import de.wwu.md2.framework.mD2.Minus
import de.wwu.md2.framework.mD2.Mult
import de.wwu.md2.framework.mD2.Not
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.Or
import de.wwu.md2.framework.mD2.Plus
import de.wwu.md2.framework.mD2.RemoteValidator
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.StandardDateRangeValidator
import de.wwu.md2.framework.mD2.StandardDateTimeRangeValidator
import de.wwu.md2.framework.mD2.StandardNotNullValidator
import de.wwu.md2.framework.mD2.StandardNumberRangeValidator
import de.wwu.md2.framework.mD2.StandardRegExValidator
import de.wwu.md2.framework.mD2.StandardStringRangeValidator
import de.wwu.md2.framework.mD2.StandardTimeRangeValidator
import de.wwu.md2.framework.mD2.StandardValidatorType
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.UnmappingTask
import de.wwu.md2.framework.mD2.ValidatorBindingTask
import de.wwu.md2.framework.mD2.ValidatorMaxDateParam
import de.wwu.md2.framework.mD2.ValidatorMaxDateTimeParam
import de.wwu.md2.framework.mD2.ValidatorMaxLengthParam
import de.wwu.md2.framework.mD2.ValidatorMaxParam
import de.wwu.md2.framework.mD2.ValidatorMaxTimeParam
import de.wwu.md2.framework.mD2.ValidatorMessageParam
import de.wwu.md2.framework.mD2.ValidatorMinDateParam
import de.wwu.md2.framework.mD2.ValidatorMinDateTimeParam
import de.wwu.md2.framework.mD2.ValidatorMinLengthParam
import de.wwu.md2.framework.mD2.ValidatorMinParam
import de.wwu.md2.framework.mD2.ValidatorMinTimeParam
import de.wwu.md2.framework.mD2.ValidatorRegExParam
import de.wwu.md2.framework.mD2.ValidatorType
import de.wwu.md2.framework.mD2.ValidatorUnbindTask
import de.wwu.md2.framework.mD2.Value
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.ViewElementSetTask
import de.wwu.md2.framework.mD2.ViewElementState
import de.wwu.md2.framework.mD2.ViewGUIElement
import org.eclipse.emf.common.util.EList
import org.eclipse.xtend2.lib.StringConcatenation

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.DateISOFormatter.*
import static extension de.wwu.md2.framework.util.StringExtensions.*

class CustomActionClass {
	
	def static generateCustomAction(CustomAction customAction, DataContainer dataContainer) '''
		«val hasDateValue = !customAction.eAllContents.filter[ e |
			e instanceof DateVal || e instanceof TimeVal || e instanceof DateTimeVal ||
			e instanceof ValidatorMinDateParam || e instanceof ValidatorMaxDateParam ||
			e instanceof ValidatorMinTimeParam || e instanceof ValidatorMaxTimeParam ||
			e instanceof ValidatorMinDateTimeParam || e instanceof ValidatorMaxDateTimeParam
		].empty»
		define([
			"dojo/_base/declare",
			«IF hasDateValue»"dojo/date/stamp",«ENDIF»
			"../../md2_runtime/actions/_Action"
		],
		function(declare, «IF hasDateValue»stamp, «ENDIF»_Action) {
			
			return declare([_Action], {
				
				_actionSignature: "«customAction.name»",
				
				execute: function() {
					
					«generateCodeBlock(customAction.codeFragments)»
					
				}
				
			});
		});
	'''
	
	def private static String generateCodeBlock(EList<CustomCodeFragment> codeFragments) '''
		«FOR codeFragment : codeFragments SEPARATOR StringConcatenation::DEFAULT_LINE_DELIMITER»
			«generateCodeFragment(codeFragment)»
		«ENDFOR»
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Custom Code Fragments
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch generateCodeFragment(EventBindingTask task) '''
		«FOR event : task.events»
			«FOR action : task.actions»
				«generateEventBindingCodeFragment(event, action, true)»
			«ENDFOR»
		«ENDFOR»
	'''
	
	def private static dispatch generateCodeFragment(EventUnbindTask task) '''
		«FOR event : task.events»
			«FOR action : task.actions»
				«generateEventBindingCodeFragment(event, action, false)»
			«ENDFOR»
		«ENDFOR»
	'''
	
	def private static dispatch generateCodeFragment(ValidatorBindingTask task) '''
		«FOR validator : task.validators»
			«FOR field : task.referencedFields»
				«val validatorVar = getUnifiedName("validator")»
				«generateValidatorCodeFragment(validator, validatorVar)»
				«val widgetVar = getUnifiedName("widget")»
				«generateWidgetCodeFragment(resolveViewGUIElement(field), widgetVar)»
				«widgetVar».addValidator(«validatorVar»);
			«ENDFOR»
		«ENDFOR»
	'''
	
	def private static dispatch generateCodeFragment(ValidatorUnbindTask task) '''
		«FOR validator : task.validators»
			«FOR field : task.referencedFields»
				«val validatorVar = getUnifiedName("validator")»
				«generateValidatorCodeFragment(validator, validatorVar)»
				«val widgetVar = getUnifiedName("widget")»
				«generateWidgetCodeFragment(resolveViewGUIElement(field), widgetVar)»
				«widgetVar».removeValidator(«validatorVar»);
			«ENDFOR»
		«ENDFOR»
	'''
	
	def private static dispatch generateCodeFragment(CallTask task) '''
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(task.action, actionVar)»
		«actionVar».execute();
	'''
	
	def private static dispatch generateCodeFragment(MappingTask task) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(task.pathDefinition, contentProviderVar)»
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewGUIElement(task.referencedViewField), widgetVar)»
		this.$.dataMapper.map(«widgetVar», «contentProviderVar», "«task.pathDefinition.resolveContentProviderPathAttribute»");
	'''
	
	def private static dispatch generateCodeFragment(UnmappingTask task) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(task.pathDefinition, contentProviderVar)»
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewGUIElement(task.referencedViewField), widgetVar)»
		this.$.dataMapper.unmap(«widgetVar», «contentProviderVar», "«task.pathDefinition.resolveContentProviderPathAttribute»");
	'''
	
	def private static dispatch generateCodeFragment(ConditionalCodeFragment task) '''
		if (
			«generateCondition(task.^if.condition)»
		) {
			«generateCodeBlock(task.^if.codeFragments)»
		}
		«FOR elseif : task.elseifs»
			else if (
				«generateCondition(elseif.condition)»
			) {
				«generateCodeBlock(elseif.codeFragments)»
			}
		«ENDFOR»
		«IF task.^else != null»
			else {
				«generateCodeBlock(task.^else.codeFragments)»
			}
		«ENDIF»
	'''
	
	def private static dispatch generateCodeFragment(ViewElementSetTask task) '''
		// TODO
	'''
	
	def private static dispatch generateCodeFragment(AttributeSetTask task) '''
		«val targetContentProviderVar = getUnifiedName("targetContentProvider")»
		«generateContentProviderCodeFragment(task.pathDefinition.contentProviderRef, targetContentProviderVar)»
		«val setVar = getUnifiedName("set")»
		«IF task.newValue != null»
			var «setVar» = «generateSimpleExpression(task.newValue)»;
		«ELSEIF task.sourceContentProvider != null»
			«val sourceContentProviderVar = getUnifiedName("sourceContentProvider")»
			«generateContentProviderCodeFragment(task.sourceContentProvider.contentProvider, sourceContentProviderVar)»
			var «setVar» = «sourceContentProviderVar».getContent();
		«ENDIF»
		«targetContentProviderVar».setValue("«task.pathDefinition.resolveContentProviderPathAttribute»", «setVar»);
	'''
	
	def private static dispatch generateCodeFragment(ContentProviderSetTask task) '''
		// TODO
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Action
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch String generateActionCodeFragment(ActionDef actionDefinition, String varName) {
		switch (actionDefinition) {
			ActionReference: {
				generateActionCodeFragment(actionDefinition.actionRef, varName)
			}
			SimpleActionRef: {
				generateActionCodeFragment(actionDefinition.action, varName)
			}
		}
	}
	
	def private static dispatch String generateActionCodeFragment(CustomAction action, String varName) '''
		var «varName» = this.$.actionFactory.getCustomAction("«action.name»");
	'''
	
	def private static dispatch String generateActionCodeFragment(GotoViewAction action, String varName) '''
		var «varName» = this.$.actionFactory.getGotoViewAction("«getName(resolveViewGUIElement(action.view))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(DisableAction action, String varName) '''
		var «varName» = this.$.actionFactory.getDisableAction("«getName(resolveViewGUIElement(action.inputField))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(EnableAction action, String varName) '''
		var «varName» = this.$.actionFactory.getEnableAction("«getName(resolveViewGUIElement(action.inputField))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(DisplayMessageAction action, String varName) '''
		var «varName» = this.$.actionFactory.getDisplayMessageAction("«action.message»");
	'''
	
	def private static dispatch String generateActionCodeFragment(ContentProviderOperationAction action, String varName) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(action.contentProvider.contentProvider, contentProviderVar)»
		var «varName» = this.$.actionFactory.getContentProviderOperationAction(«contentProviderVar», "«action.operation.toString»");
	'''
	
	def private static dispatch String generateActionCodeFragment(ContentProviderResetAction action, String varName) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(action.contentProvider.contentProvider, contentProviderVar)»
		var «varName» = this.$.actionFactory.getContentProviderResetAction(«contentProviderVar»);
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Event
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch generateEventBindingCodeFragment(ViewElementEventRef event, ActionDef actionDefinition, boolean isBinding) '''
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewGUIElement(event.referencedField), widgetVar)»
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar)»
		this.$.eventRegistry.get("widget/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«widgetVar», «actionVar»);
	'''
	
	def private static dispatch generateEventBindingCodeFragment(ContentProviderEventRef event, ActionDef actionDefinition, boolean isBinding) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(event.pathDefinition, contentProviderVar)»
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar)»
		this.$.eventRegistry.get("widget/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«contentProviderVar», "«event.pathDefinition.resolveContentProviderPathAttribute»", «actionVar»);
	'''
	
	def private static dispatch generateEventBindingCodeFragment(GlobalEventRef event, ActionDef actionDefinition, boolean isBinding) '''
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar)»
		this.$.eventRegistry.get("global/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«actionVar»);
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Content Provider
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch generateContentProviderCodeFragment(ContentProvider contentProvider, String varName) '''
		var «varName» = this.$.contentProviderRegistry.getContentProvider("«contentProvider.name»");
	'''
	
	def private static dispatch generateContentProviderCodeFragment(AbstractContentProviderPath contentProviderPath, String varName) '''
		var «varName» = this.$.contentProviderRegistry.getContentProvider("«contentProviderPath.resolveContentProviderName»");
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Widget
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static generateWidgetCodeFragment(ViewGUIElement guiElement, String varName) '''
		var «varName» = this.$.widgetRegistry.getWidget("«getName(guiElement)»");
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Validator
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch String generateValidatorCodeFragment(ValidatorType validator, String varName) {
		switch (validator) {
			StandardValidatorType: {
				generateValidatorCodeFragment(validator.validator, varName)
			}
			CustomizedValidatorType: {
				generateValidatorCodeFragment(validator.validator, varName)
			}
		}
	}
	
	def private static dispatch String generateValidatorCodeFragment(StandardRegExValidator validator, String varName) {
		val regEx = validator.resolveValidatorParam(typeof(ValidatorRegExParam))?.regEx ?: ".*"
		val message = validator.resolveValidatorParam(typeof(ValidatorMessageParam))?.message
		'''
			var «varName» = this.$.validatorFactory.getRegExValidator("«regEx»"«IF message != null», "«message»"«ENDIF»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(StandardNotNullValidator validator, String varName) {
		val message = validator.resolveValidatorParam(typeof(ValidatorMessageParam))?.message
		'''
			var «varName» = this.$.validatorFactory.getNotNullValidator(«IF message != null»"«message»"«ENDIF»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(StandardNumberRangeValidator validator, String varName) {
		val minVarName = getUnifiedName("min")
		val maxVarName = getUnifiedName("max")
		val min = validator.resolveValidatorParam(typeof(ValidatorMinParam))?.min.toString
		val max = validator.resolveValidatorParam(typeof(ValidatorMaxParam))?.max.toString
		val message = validator.resolveValidatorParam(typeof(ValidatorMessageParam))?.message.quotify
		'''
			var «minVarName» = «IF min != null»this.$.create("float", «min»)«ELSE»null«ENDIF»;
			var «maxVarName» = «IF max != null»this.$.create("float", «max»)«ELSE»null«ENDIF»;
			var «varName» = this.$.validatorFactory.getNumberRangeValidator(«minVarName», «maxVarName»«IF message != null», "«message»"«ENDIF»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(StandardStringRangeValidator validator, String varName) {
		val min = validator.resolveValidatorParam(typeof(ValidatorMinLengthParam))?.minLength.toString ?: "null"
		val max = validator.resolveValidatorParam(typeof(ValidatorMaxLengthParam))?.maxLength.toString ?: "null"
		val message = validator.resolveValidatorParam(typeof(ValidatorMessageParam))?.message.quotify
		'''
			var «varName» = this.$.validatorFactory.getStringRangeValidator(«min», «max»«IF message != null», "«message»"«ENDIF»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(StandardDateRangeValidator validator, String varName) {
		val minVarName = getUnifiedName("min")
		val maxVarName = getUnifiedName("max")
		val min = validator.resolveValidatorParam(typeof(ValidatorMinDateParam))?.min.toISODate.quotify
		val max = validator.resolveValidatorParam(typeof(ValidatorMaxDateParam))?.max.toISODate.quotify
		val message = validator.resolveValidatorParam(typeof(ValidatorMessageParam))?.message.quotify
		'''
			var «minVarName» = «IF min != null»this.$.create("date", stamp.fromISOString("«min»"))«ELSE»null«ENDIF»;
			var «maxVarName» = «IF max != null»this.$.create("date", stamp.fromISOString("«max»"))«ELSE»null«ENDIF»;
			var «varName» = this.$.validatorFactory.getDateRangeValidator(«minVarName», «maxVarName»«IF message != null», "«message»"«ENDIF»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(StandardTimeRangeValidator validator, String varName) {
		val minVarName = getUnifiedName("min")
		val maxVarName = getUnifiedName("max")
		val min = validator.resolveValidatorParam(typeof(ValidatorMinTimeParam))?.min.toISOTime.quotify
		val max = validator.resolveValidatorParam(typeof(ValidatorMaxTimeParam))?.max.toISOTime.quotify
		val message = validator.resolveValidatorParam(typeof(ValidatorMessageParam))?.message.quotify
		'''
			var «minVarName» = «IF min != null»this.$.create("time", stamp.fromISOString("«min»"))«ELSE»null«ENDIF»;
			var «maxVarName» = «IF max != null»this.$.create("time", stamp.fromISOString("«max»"))«ELSE»null«ENDIF»;
			var «varName» = this.$.validatorFactory.getTimeRangeValidator(«minVarName», «maxVarName»«IF message != null», "«message»"«ENDIF»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(StandardDateTimeRangeValidator validator, String varName) {
		val minVarName = getUnifiedName("min")
		val maxVarName = getUnifiedName("max")
		val min = validator.resolveValidatorParam(typeof(ValidatorMinDateTimeParam))?.min.toISODateTime.quotify
		val max = validator.resolveValidatorParam(typeof(ValidatorMaxDateTimeParam))?.max.toISODateTime.quotify
		val message = validator.resolveValidatorParam(typeof(ValidatorMessageParam))?.message.quotify
		'''
			var «minVarName» = «IF min != null»this.$.create("datetime", stamp.fromISOString("«min»"))«ELSE»null«ENDIF»;
			var «maxVarName» = «IF max != null»this.$.create("datetime", stamp.fromISOString("«max»"))«ELSE»null«ENDIF»;
			var «varName» = this.$.validatorFactory.getDateTimeRangeValidator(«minVarName», «maxVarName»«IF message != null», "«message»"«ENDIF»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(RemoteValidator validator, String varName) '''
		// TODO
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Conditional Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static String generateCondition(ConditionalExpression expression) {
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
	// Simple Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch String generateSimpleExpression(Value expression) {
		switch (expression) {
			StringVal: '''this.$.create("string", "«expression.value»")'''
			IntVal: '''this.$.create("integer", «expression.value»)'''
			FloatVal: '''this.$.create("float", «expression.value»)'''
			BooleanVal: '''this.$.create("boolean", «expression.value.toString»)'''
			DateVal: '''this.$.create("date", stamp.fromISOString("«expression.value.toISODate»"))'''
			TimeVal: '''this.$.create("time", stamp.fromISOString("«expression.value.toISOTime»"))'''
			DateTimeVal: '''this.$.create("datetime", stamp.fromISOString("«expression.value.toISODateTime»"))'''
		}
	}
	
	def private static dispatch String generateSimpleExpression(AbstractViewGUIElementRef expression) {
		'''this.$.widgetRegistry.getWidget("«getName(resolveViewGUIElement(expression))»").getValue()'''
	}
	
	def private static dispatch String generateSimpleExpression(AbstractContentProviderPath expression) {
		'''this.$.contentProviderRegistry.getContentProvider("«expression.resolveContentProviderName»").getValue("«expression.resolveContentProviderPathAttribute»")'''
	}
	
	def private static dispatch String generateSimpleExpression(ConcatenatedString expression) {
		'''this.$.create("string", «FOR literal : expression.literals SEPARATOR(" + ")»«generateStringLiteral(literal)»«ENDFOR»)'''
	}
	
	def private static dispatch String generateSimpleExpression(MathSubExpression expression) {
		'''this.$.create("float", «generateMathExpression(expression)»)'''
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
	// Concatenated Strings
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch generateStringLiteral(Value literal) {
		'''«generateSimpleExpression(literal)».toString()'''
	}
	
	def private static dispatch generateStringLiteral(AbstractViewGUIElementRef literal) {
		'''«generateSimpleExpression(literal)».toString()'''
	}
	
	def private static dispatch generateStringLiteral(AbstractContentProviderPath literal) {
		'''«generateSimpleExpression(literal)».toString()'''
	}
	
	def private static dispatch generateStringLiteral(MathSubExpression literal) {
		'''(«generateMathExpression(literal)»).toString()'''
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Math Expressions
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static String generateMathExpression(MathSubExpression expression) {
		switch (expression) {
			Plus: '''(«generateMathExpression(expression.leftOperand)» + «generateMathExpression(expression.rightOperand)»)'''
			Minus: '''(«generateMathExpression(expression.leftOperand)» - «generateMathExpression(expression.rightOperand)»)'''
			Mult: '''«generateMathExpression(expression.leftOperand)» * «generateMathExpression(expression.rightOperand)»'''
			Div: '''«generateMathExpression(expression.leftOperand)» / «generateMathExpression(expression.rightOperand)»'''
			MathLiteral: '''«generateMathLiteral(expression)»'''
		}
	}
	
	def private static String generateMathLiteral(MathLiteral literal) {
		switch (literal) {
			IntVal: '''«literal.value»'''
			FloatVal: '''«literal.value»'''
			AbstractViewGUIElementRef: '''this.$.widgetRegistry.getWidget("«getName(resolveViewGUIElement(literal))»").getValue().getPlatformValue()'''
			AbstractContentProviderPath: '''this.$.contentProviderRegistry.getContentProvider("«literal.resolveContentProviderName»").getValue("«literal.resolveContentProviderPathAttribute»").getPlatformValue()'''
		}
	}
	
}
