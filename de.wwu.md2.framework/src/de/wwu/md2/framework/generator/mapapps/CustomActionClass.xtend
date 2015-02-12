package de.wwu.md2.framework.generator.mapapps

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
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.StandardDateRangeValidator
import de.wwu.md2.framework.mD2.StandardDateTimeRangeValidator
import de.wwu.md2.framework.mD2.StandardNotNullValidator
import de.wwu.md2.framework.mD2.StandardNumberRangeValidator
import de.wwu.md2.framework.mD2.StandardRegExValidator
import de.wwu.md2.framework.mD2.StandardStringRangeValidator
import de.wwu.md2.framework.mD2.StandardTimeRangeValidator
import de.wwu.md2.framework.mD2.StandardValidatorType
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
import java.util.List
import java.util.Map
import org.eclipse.xtend2.lib.StringConcatenation

import static de.wwu.md2.framework.generator.mapapps.Expressions.*

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.DateISOFormatter.*
import static extension de.wwu.md2.framework.util.StringExtensions.*
import de.wwu.md2.framework.mD2.FireEventAction
import de.wwu.md2.framework.mD2.WorkflowEvent
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.Action
import org.eclipse.emf.ecore.EObject
import de.wwu.md2.framework.mD2.LocationAction

class CustomActionClass {
	
	def static String generateCustomAction(CustomAction customAction) '''
		«val imports = newLinkedHashMap("declare" -> "dojo/_base/declare", "_Action" -> "md2_runtime/actions/_Action")»
		«val body = generateCustomActionBody(customAction, imports)»
		define([
			«FOR key : imports.keySet SEPARATOR ","»
				"«imports.get(key)»"
			«ENDFOR»
		],
		function(«FOR key : imports.keySet SEPARATOR ", "»«key»«ENDFOR») {
			
			«body»
		});
	'''
	
	def static String generateCustomActionBody(CustomAction customAction, Map<String, String> imports) '''
		return declare([_Action], {
			
			_actionSignature: "«customAction.name»",
			
			execute: function() {
				
				«generateCodeBlock(customAction.codeFragments, imports)»
				
			}
			
		});
	'''
	
	def private static String generateCodeBlock(List<CustomCodeFragment> codeFragments, Map<String, String> imports) '''
		«FOR codeFragment : codeFragments SEPARATOR StringConcatenation::DEFAULT_LINE_DELIMITER»
			«generateCodeFragment(codeFragment, imports)»
		«ENDFOR»
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Custom Code Fragments
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch generateCodeFragment(EventBindingTask task, Map<String, String> imports) '''
		«FOR event : task.events»
			«FOR action : task.actions»
				«generateEventBindingCodeFragment(event, action, true, imports)»
			«ENDFOR»
		«ENDFOR»
	'''
	
	def private static dispatch generateCodeFragment(EventUnbindTask task, Map<String, String> imports) '''
		«FOR event : task.events»
			«FOR action : task.actions»
				«generateEventBindingCodeFragment(event, action, false, imports)»
			«ENDFOR»
		«ENDFOR»
	'''
	
	def private static dispatch generateCodeFragment(ValidatorBindingTask task, Map<String, String> imports) '''
		«FOR validator : task.validators»
			«FOR field : task.referencedFields»
				«val validatorVar = getUnifiedName("validator")»
				«generateValidatorCodeFragment(validator, validatorVar, imports)»
				«val widgetVar = getUnifiedName("widget")»
				«generateWidgetCodeFragment(resolveViewElement(field), widgetVar)»
				«widgetVar».addValidator(«validatorVar»);
			«ENDFOR»
		«ENDFOR»
	'''
	
	def private static dispatch generateCodeFragment(ValidatorUnbindTask task, Map<String, String> imports) '''
		«FOR validator : task.validators»
			«FOR field : task.referencedFields»
				«val validatorVar = getUnifiedName("validator")»
				«generateValidatorCodeFragment(validator, validatorVar, imports)»
				«val widgetVar = getUnifiedName("widget")»
				«generateWidgetCodeFragment(resolveViewElement(field), widgetVar)»
				«widgetVar».removeValidator(«validatorVar»);
			«ENDFOR»
		«ENDFOR»
	'''
	
	def private static dispatch generateCodeFragment(CallTask task, Map<String, String> imports) '''
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(task.action, actionVar, imports)»
		«actionVar».execute();
	'''
	
	def private static dispatch generateCodeFragment(MappingTask task, Map<String, String> imports) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(task.pathDefinition, contentProviderVar)»
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewElement(task.referencedViewField), widgetVar)»
		this.$.dataMapper.map(«widgetVar», «contentProviderVar», "«task.pathDefinition.resolveContentProviderPathAttribute»");
	'''
	
	def private static dispatch generateCodeFragment(UnmappingTask task, Map<String, String> imports) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(task.pathDefinition, contentProviderVar)»
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewElement(task.referencedViewField), widgetVar)»
		this.$.dataMapper.unmap(«widgetVar», «contentProviderVar», "«task.pathDefinition.resolveContentProviderPathAttribute»");
	'''
	
	def private static dispatch generateCodeFragment(ConditionalCodeFragment task, Map<String, String> imports) '''
		«val ifBoolVar = getUnifiedName("bool")»
		«generateCondition(task.^if.condition, ifBoolVar, imports)»
		«val precomputedElseifs = newArrayList»
		«FOR elseif : task.elseifs»
			«val elseifBoolVar = getUnifiedName("bool")»
			«generateCondition(elseif.condition, elseifBoolVar, imports)»
			«precomputedElseifs.add(elseifBoolVar -> elseif.codeFragments).returnVoid»
		«ENDFOR»
		if («ifBoolVar») {
			«generateCodeBlock(task.^if.codeFragments, imports)»
		}
		«FOR elseif : precomputedElseifs»
			else if («elseif.key») {
				«generateCodeBlock(elseif.value, imports)»
			}
		«ENDFOR»
		«IF task.^else != null»
			else {
				«generateCodeBlock(task.^else.codeFragments, imports)»
			}
		«ENDIF»
	'''
	
	def private static dispatch generateCodeFragment(ViewElementSetTask task, Map<String, String> imports) '''
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewElement(task.referencedViewField), widgetVar)»
		«val setVar = getUnifiedName("expr")»
		«generateSimpleExpression(task.source, setVar, imports)»
		«widgetVar».setValue(«setVar»);
	'''
	
	def private static dispatch generateCodeFragment(AttributeSetTask task, Map<String, String> imports) '''
		«val targetContentProviderVar = getUnifiedName("targetContentProvider")»
		«generateContentProviderCodeFragment(task.pathDefinition.contentProviderRef, targetContentProviderVar)»
		«val setVar = getUnifiedName("expr")»
		«generateSimpleExpression(task.source, setVar, imports)»
		«targetContentProviderVar».setValue("«task.pathDefinition.resolveContentProviderPathAttribute»", «setVar»);
	'''
	
	def private static dispatch generateCodeFragment(ContentProviderSetTask task, Map<String, String> imports) '''
		«val targetContentProviderVar = getUnifiedName("targetContentProvider")»
		«generateContentProviderCodeFragment(task.contentProvider.contentProvider, targetContentProviderVar)»
		«val setVar = getUnifiedName("expr")»
		«generateSimpleExpression(task.source, setVar, imports)»
		«targetContentProviderVar».setContent(«setVar»);
	'''
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Action
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch String generateActionCodeFragment(ActionDef actionDefinition, String varName, Map<String, String> imports) {
		switch (actionDefinition) {
			ActionReference: {
				generateActionCodeFragment(actionDefinition.actionRef, varName, imports)
			}
			SimpleActionRef: {
				generateActionCodeFragment(actionDefinition.action, varName, imports)
			}
		}
	}
	
	def private static dispatch String generateActionCodeFragment(CustomAction action, String varName, Map<String, String> imports) '''
		var «varName» = this.$.actionFactory.getCustomAction("«action.name»");
	'''
	
	def private static dispatch String generateActionCodeFragment(GotoViewAction action, String varName, Map<String, String> imports) '''
		var «varName» = this.$.actionFactory.getGotoViewAction("«getName(resolveViewElement(action.view))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(DisableAction action, String varName, Map<String, String> imports) '''
		var «varName» = this.$.actionFactory.getDisableAction("«getName(resolveViewElement(action.inputField))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(EnableAction action, String varName, Map<String, String> imports) '''
		var «varName» = this.$.actionFactory.getEnableAction("«getName(resolveViewElement(action.inputField))»");
	'''
	
	def private static dispatch String generateActionCodeFragment(DisplayMessageAction action, String varName, Map<String, String> imports) '''
		«val messageExpressionVar = getUnifiedName("message")»
		«generateMessage(action.message, messageExpressionVar, imports)»
		var «varName» = this.$.actionFactory.getDisplayMessageAction("«action.parameterSignature»", «messageExpressionVar»);
	'''
	
	def private static dispatch String generateActionCodeFragment(ContentProviderOperationAction action, String varName, Map<String, String> imports) '''
		var «varName» = this.$.actionFactory.getContentProviderOperationAction("«action.contentProvider.resolveContentProviderName»", "«action.operation.toString»");
	'''
	
	def private static dispatch String generateActionCodeFragment(ContentProviderResetAction action, String varName, Map<String, String> imports) '''
		var «varName» = this.$.actionFactory.getContentProviderResetAction("«action.contentProvider.contentProvider.name»");
	'''
	
	def private static dispatch String generateActionCodeFragment(LocationAction action, String varName, Map<String, String> imports) '''
		var «varName» = this.$.actionFactory.getLocationAction("«action.cityInput.resolveContentProviderPathAttribute»","«action.cityInput.resolveContentProviderName»","«action.streetInput.resolveContentProviderPathAttribute»",
		"«action.streetInput.resolveContentProviderName»","«action.streetNumberInput.resolveContentProviderPathAttribute»","«action.streetNumberInput.resolveContentProviderName»","«action.postalInput.resolveContentProviderPathAttribute»",
		"«action.postalInput.resolveContentProviderName»","«action.countryInput.resolveContentProviderPathAttribute»","«action.countryInput.resolveContentProviderName»",
		"«action.getLatitude.resolveContentProviderPathAttribute»","«action.getLongitude.resolveContentProviderPathAttribute»","«action.getLatitude.resolveContentProviderName»","«action.getLongitude.resolveContentProviderName»"); 
	'''
	
	def private static dispatch String generateActionCodeFragment(FireEventAction action, String varName, Map<String, String> imports) 
	//TODO: Preprocessing porbably needs to be changed; 
	//also: getFiredEventAction does not exists in code -> RefImpl.
	'''
		var «varName» = this.$.actionFactory.getFireEventAction("«(action.containingWorkflowElement).name»","«action.workflowEvent.name»");
	'''
	
	def public static WorkflowElement getContainingWorkflowElement(FireEventAction context)
	{
		var EObject current = context;
		while(!(current.eContainer() instanceof WorkflowElement))
		{
			current = current.eContainer();
		}
		
		return (current.eContainer() as WorkflowElement);
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Event
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch generateEventBindingCodeFragment(ViewElementEventRef event, ActionDef actionDefinition, boolean isBinding, Map<String, String> imports) '''
		«val widgetVar = getUnifiedName("widget")»
		«generateWidgetCodeFragment(resolveViewElement(event.referencedField), widgetVar)»
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar, imports)»
		this.$.eventRegistry.get("widget/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«widgetVar», «actionVar»);
	'''
	
	def private static dispatch generateEventBindingCodeFragment(ContentProviderPathEventRef event, ActionDef actionDefinition, boolean isBinding, Map<String, String> imports) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(event.pathDefinition, contentProviderVar)»
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar, imports)»
		this.$.eventRegistry.get("contentProvider/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«contentProviderVar», "«event.pathDefinition.resolveContentProviderPathAttribute»", «actionVar»);
	'''
	
	def private static dispatch generateEventBindingCodeFragment(ContentProviderEventRef event, ActionDef actionDefinition, boolean isBinding, Map<String, String> imports) '''
		«val contentProviderVar = getUnifiedName("contentProvider")»
		«generateContentProviderCodeFragment(event.contentProvider, contentProviderVar)»
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar, imports)»
		this.$.eventRegistry.get("contentProvider/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«contentProviderVar», "*", «actionVar»);
	'''
	
	def private static dispatch generateEventBindingCodeFragment(GlobalEventRef event, ActionDef actionDefinition, boolean isBinding, Map<String, String> imports) '''
		«val actionVar = getUnifiedName("action")»
		«generateActionCodeFragment(actionDefinition, actionVar, imports)»
		this.$.eventRegistry.get("global/«event.event.toString»").«IF !isBinding»un«ENDIF»registerAction(«actionVar»);
	'''
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Content Provider
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static dispatch generateContentProviderCodeFragment(ContentProvider contentProvider, String varName) '''
		var «varName» = this.$.contentProviderRegistry.getContentProvider("«contentProvider.name.toFirstLower»");
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
	
	def private static dispatch String generateValidatorCodeFragment(ValidatorType validator, String varName, Map<String, String> imports) {
		switch (validator) {
			StandardValidatorType: {
				generateValidatorCodeFragment(validator.validator, varName, imports)
			}
			CustomizedValidatorType: {
				generateValidatorCodeFragment(validator.validator, varName, imports)
			}
		}
	}
	
	def private static dispatch String generateValidatorCodeFragment(
		StandardRegExValidator validator, String varName, Map<String, String> imports
	) {
		val msgVarName = getUnifiedName("message")
		val regEx = validator.resolveValidatorParam(ValidatorRegExParam)?.regEx ?: ".*"
		'''
			«generateMessage(validator.resolveValidatorParam(ValidatorMessageParam)?.message, msgVarName, imports)»
			var «varName» = this.$.validatorFactory.getRegExValidator("«regEx»", «msgVarName»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(
		StandardNotNullValidator validator, String varName, Map<String, String> imports
	) {
		val msgVarName = getUnifiedName("message")
		'''
			«generateMessage(validator.resolveValidatorParam(ValidatorMessageParam)?.message, msgVarName, imports)»
			var «varName» = this.$.validatorFactory.getNotNullValidator(«msgVarName»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(
		StandardNumberRangeValidator validator, String varName, Map<String, String> imports
	) {
		val minVarName = getUnifiedName("min")
		val maxVarName = getUnifiedName("max")
		val msgVarName = getUnifiedName("message")
		val minParam = validator.resolveValidatorParam(ValidatorMinParam)
		val maxParam = validator.resolveValidatorParam(ValidatorMaxParam)
		'''
			var «minVarName» = «IF minParam != null»this.$.create("float", «minParam.min»)«ELSE»null«ENDIF»;
			var «maxVarName» = «IF maxParam != null»this.$.create("float", «maxParam.max»)«ELSE»null«ENDIF»;
			«generateMessage(validator.resolveValidatorParam(ValidatorMessageParam)?.message, msgVarName, imports)»
			var «varName» = this.$.validatorFactory.getNumberRangeValidator(«minVarName», «maxVarName», «msgVarName»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(
		StandardStringRangeValidator validator, String varName, Map<String, String> imports
	) {
		val msgVarName = getUnifiedName("message")
		val minParam = validator.resolveValidatorParam(ValidatorMinLengthParam)
		val maxParam = validator.resolveValidatorParam(ValidatorMaxLengthParam)
		val min = if (minParam != null) minParam.minLength else "null"
		val max = if (maxParam != null) maxParam.maxLength else "null"
		'''
			«generateMessage(validator.resolveValidatorParam(ValidatorMessageParam)?.message, msgVarName, imports)»
			var «varName» = this.$.validatorFactory.getStringRangeValidator(«min», «max», «msgVarName»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(
		StandardDateRangeValidator validator, String varName, Map<String, String> imports
	) {
		val minVarName = getUnifiedName("min")
		val maxVarName = getUnifiedName("max")
		val msgVarName = getUnifiedName("message")
		val min = validator.resolveValidatorParam(ValidatorMinDateParam)?.min.toISODate.quotify
		val max = validator.resolveValidatorParam(ValidatorMaxDateParam)?.max.toISODate.quotify
		if (min != null || max != null) {
			imports.put("stamp", "dojo/date/stamp")
		}
		'''
			var «minVarName» = «IF min != null»this.$.create("date", stamp.fromISOString("«min»"))«ELSE»null«ENDIF»;
			var «maxVarName» = «IF max != null»this.$.create("date", stamp.fromISOString("«max»"))«ELSE»null«ENDIF»;
			«generateMessage(validator.resolveValidatorParam(ValidatorMessageParam)?.message, msgVarName, imports)»
			var «varName» = this.$.validatorFactory.getDateRangeValidator(«minVarName», «maxVarName», «msgVarName»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(
		StandardTimeRangeValidator validator, String varName, Map<String, String> imports
	) {
		val minVarName = getUnifiedName("min")
		val maxVarName = getUnifiedName("max")
		val msgVarName = getUnifiedName("message")
		val min = validator.resolveValidatorParam(ValidatorMinTimeParam)?.min.toISOTime.quotify
		val max = validator.resolveValidatorParam(ValidatorMaxTimeParam)?.max.toISOTime.quotify
		if (min != null || max != null) {
			imports.put("stamp", "dojo/date/stamp")
		}
		'''
			var «minVarName» = «IF min != null»this.$.create("time", stamp.fromISOString("«min»"))«ELSE»null«ENDIF»;
			var «maxVarName» = «IF max != null»this.$.create("time", stamp.fromISOString("«max»"))«ELSE»null«ENDIF»;
			«generateMessage(validator.resolveValidatorParam(ValidatorMessageParam)?.message, msgVarName, imports)»
			var «varName» = this.$.validatorFactory.getTimeRangeValidator(«minVarName», «maxVarName», «msgVarName»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(
		StandardDateTimeRangeValidator validator, String varName, Map<String, String> imports
	) {
		val minVarName = getUnifiedName("min")
		val maxVarName = getUnifiedName("max")
		val msgVarName = getUnifiedName("message")
		val min = validator.resolveValidatorParam(ValidatorMinDateTimeParam)?.min.toISODateTime.quotify
		val max = validator.resolveValidatorParam(ValidatorMaxDateTimeParam)?.max.toISODateTime.quotify
		if (min != null || max != null) {
			imports.put("stamp", "dojo/date/stamp")
		}
		'''
			var «minVarName» = «IF min != null»this.$.create("datetime", stamp.fromISOString("«min»"))«ELSE»null«ENDIF»;
			var «maxVarName» = «IF max != null»this.$.create("datetime", stamp.fromISOString("«max»"))«ELSE»null«ENDIF»;
			«generateMessage(validator.resolveValidatorParam(ValidatorMessageParam)?.message, msgVarName, imports)»
			var «varName» = this.$.validatorFactory.getDateTimeRangeValidator(«minVarName», «maxVarName», «msgVarName»);
		'''
	}
	
	def private static dispatch String generateValidatorCodeFragment(
		RemoteValidator validator, String varName, Map<String, String> imports
	) '''
		// TODO
	'''
	
	def private static generateMessage(SimpleExpression msg, String varName, Map<String, String> imports) '''
		«IF msg != null»
			«imports.put("lang", "dojo/_base/lang").returnVoid»
			«val exprVar = getUnifiedName("expr")»
			var «varName» = lang.hitch(this, function() {
				«generateSimpleExpression(msg, exprVar, imports)»
				return «exprVar».toString();
			});
		«ELSE»
			var «varName» = null;
		«ENDIF»
	'''
	
}
