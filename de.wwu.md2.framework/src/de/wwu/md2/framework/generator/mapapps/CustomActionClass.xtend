package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.AbstractProviderReference
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.ConditionalCodeFragment
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderEventRef
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.ContentProviderPathEventRef
import de.wwu.md2.framework.mD2.ContentProviderResetAction
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.CustomizedValidatorType
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.DisableAction
import de.wwu.md2.framework.mD2.DisplayMessageAction
import de.wwu.md2.framework.mD2.EnableAction
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.GlobalEventRef
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.MappingTask
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
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.ViewElementSetTask
import de.wwu.md2.framework.mD2.ViewElementType
import org.eclipse.emf.common.util.EList
import org.eclipse.xtend2.lib.StringConcatenation

import static de.wwu.md2.framework.generator.mapapps.Expressions.*

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.DateISOFormatter.*
import static extension de.wwu.md2.framework.util.StringExtensions.*

class CustomActionClass {
	
	def static String generateCustomAction(CustomAction customAction, DataContainer dataContainer) '''
		«val hasDateValue = !customAction.eAllContents.filter[ e |
			e instanceof DateVal || e instanceof TimeVal || e instanceof DateTimeVal ||
			e instanceof ValidatorMinDateParam || e instanceof ValidatorMaxDateParam ||
			e instanceof ValidatorMinTimeParam || e instanceof ValidatorMaxTimeParam ||
			e instanceof ValidatorMinDateTimeParam || e instanceof ValidatorMaxDateTimeParam
		].empty»
		define([
			"dojo/_base/declare",
			«IF hasDateValue»"dojo/date/stamp",«ENDIF»
			"md2_runtime/actions/_Action"
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
				«generateWidgetCodeFragment(resolveViewElement(field), widgetVar)»
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
				«generateWidgetCodeFragment(resolveViewElement(field), widgetVar)»
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
		«generateWidgetCodeFragment(resolveViewElement(task.referencedViewField), widgetVar)»
		this.$.dataMapper.map(«widgetVar», «contentProviderVar», "«task.pathDefinition.resolveContentProviderPathAttribute»");
	'''
	
	def private static dispatch generateCodeFragment(UnmappingTask task) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(task.pathDefinition, contentProviderVar)»
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewElement(task.referencedViewField), widgetVar)»
		this.$.dataMapper.unmap(«widgetVar», «contentProviderVar», "«task.pathDefinition.resolveContentProviderPathAttribute»");
	'''
	
	def private static dispatch generateCodeFragment(ConditionalCodeFragment task) '''
		«val ifBoolVar = getUnifiedName("bool")»
		var «ifBoolVar» = «generateCondition(task.^if.condition)»;
		«val precomputedElseifs = newArrayList»
		«FOR elseif : task.elseifs»
			«val elseifBoolVar = getUnifiedName("bool")»
			var «elseifBoolVar» = «generateCondition(elseif.condition)»;
			«precomputedElseifs.add(elseifBoolVar -> elseif.codeFragments).returnVoid»
		«ENDFOR»
		if («ifBoolVar») {
			«generateCodeBlock(task.^if.codeFragments)»
		}
		«FOR elseif : precomputedElseifs»
			else if («elseif.key») {
				«generateCodeBlock(elseif.value)»
			}
		«ENDFOR»
		«IF task.^else != null»
			else {
				«generateCodeBlock(task.^else.codeFragments)»
			}
		«ENDIF»
	'''
	
	def private static dispatch generateCodeFragment(ViewElementSetTask task) '''
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewElement(task.referencedViewField), widgetVar)»
		«val setVar = getUnifiedName("set")»
		var «setVar» = «generateSimpleExpression(task.source)»;
		«widgetVar».setValue(«setVar»);
	'''
	
	def private static dispatch generateCodeFragment(AttributeSetTask task) '''
		«val targetContentProviderVar = getUnifiedName("targetContentProvider")»
		«generateContentProviderCodeFragment(task.pathDefinition.contentProviderRef, targetContentProviderVar)»
		«val setVar = getUnifiedName("set")»
		var «setVar» = «generateSimpleExpression(task.source)»;
		«targetContentProviderVar».setValue("«task.pathDefinition.resolveContentProviderPathAttribute»", «setVar»);
	'''
	
	def private static dispatch generateCodeFragment(ContentProviderSetTask task) '''
		«val targetContentProviderVar = getUnifiedName("targetContentProvider")»
		«generateContentProviderCodeFragment(task.contentProvider.contentProvider, targetContentProviderVar)»
		«val setVar = getUnifiedName("set")»
		var «setVar» = «generateSimpleExpression(task.source)»;
		«targetContentProviderVar».setContent(«setVar»);
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
		var «varName» = this.$.actionFactory.getGotoViewAction("«getName(resolveViewElement(action.view))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(DisableAction action, String varName) '''
		var «varName» = this.$.actionFactory.getDisableAction("«getName(resolveViewElement(action.inputField))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(EnableAction action, String varName) '''
		var «varName» = this.$.actionFactory.getEnableAction("«getName(resolveViewElement(action.inputField))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(DisplayMessageAction action, String varName) '''
		«val messageExpressionVar = getUnifiedName("messageExpression")»
		var «messageExpressionVar» = function() {
			return «generateSimpleExpression(action.message)».toString();
		};
		var «varName» = this.$.actionFactory.getDisplayMessageAction("«action.parameterSignature»", «messageExpressionVar»);
	'''
	
	def private static dispatch String generateActionCodeFragment(ContentProviderOperationAction action, String varName) '''
		var «varName» = this.$.actionFactory.getContentProviderOperationAction("«action.contentProvider.resolveContentProviderName»", "«action.operation.toString»");
	'''
	
	def private static dispatch String generateActionCodeFragment(ContentProviderResetAction action, String varName) '''
		var «varName» = this.$.actionFactory.getContentProviderResetAction("«action.contentProvider.contentProvider.name»");
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Event
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch generateEventBindingCodeFragment(ViewElementEventRef event, ActionDef actionDefinition, boolean isBinding) '''
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewElement(event.referencedField), widgetVar)»
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar)»
		this.$.eventRegistry.get("widget/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«widgetVar», «actionVar»);
	'''
	
	def private static dispatch generateEventBindingCodeFragment(ContentProviderPathEventRef event, ActionDef actionDefinition, boolean isBinding) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(event.pathDefinition, contentProviderVar)»
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar)»
		this.$.eventRegistry.get("contentProvider/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«contentProviderVar», "«event.pathDefinition.resolveContentProviderPathAttribute»", «actionVar»);
	'''
	
	def private static dispatch generateEventBindingCodeFragment(ContentProviderEventRef event, ActionDef actionDefinition, boolean isBinding) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(event.contentProvider, contentProviderVar)»
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar)»
		this.$.eventRegistry.get("contentProvider/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«contentProviderVar», "*", «actionVar»);
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
	
	def private static dispatch generateContentProviderCodeFragment(AbstractProviderReference contentProvider, String varName) '''
		var «varName» = this.$.contentProviderRegistry.getContentProvider("«contentProvider.resolveContentProviderName»");
	'''
	
	def private static dispatch generateContentProviderCodeFragment(AbstractContentProviderPath contentProviderPath, String varName) '''
		var «varName» = this.$.contentProviderRegistry.getContentProvider("«contentProviderPath.resolveContentProviderName»");
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Widget
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static generateWidgetCodeFragment(ViewElementType guiElement, String varName) '''
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
	
	
	
	
}
