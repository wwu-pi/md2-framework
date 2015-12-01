package de.wwu.md2.framework.generator.preprocessor

import com.google.common.collect.Sets
import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.AttrDateMax
import de.wwu.md2.framework.mD2.AttrDateMin
import de.wwu.md2.framework.mD2.AttrDateTimeMax
import de.wwu.md2.framework.mD2.AttrDateTimeMin
import de.wwu.md2.framework.mD2.AttrFloatMax
import de.wwu.md2.framework.mD2.AttrFloatMin
import de.wwu.md2.framework.mD2.AttrIntMax
import de.wwu.md2.framework.mD2.AttrIntMin
import de.wwu.md2.framework.mD2.AttrIsOptional
import de.wwu.md2.framework.mD2.AttrStringMax
import de.wwu.md2.framework.mD2.AttrStringMin
import de.wwu.md2.framework.mD2.AttrTimeMax
import de.wwu.md2.framework.mD2.AttrTimeMin
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.Main
import de.wwu.md2.framework.mD2.MappingTask
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TimeType

import static de.wwu.md2.framework.generator.preprocessor.util.Util.*

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*import de.wwu.md2.framework.mD2.WorkflowElement

class ProcessModel extends AbstractPreprocessor {
	
	/**
	 * Replace implicit Enum definitions with Enum model elements.
	 * Change AttributeType from EnumType to ReferencedType.
	 */
	def transformImplicitEnums() {
		val Iterable<Attribute> enumAttributes = model.eAllContents.toIterable.filter(typeof(Attribute)).filter(attr | attr.type instanceof EnumType).toList
		enumAttributes.forEach [ enumAttr |
			// Assume structure: Model -> Entity -> Attribute
			val parentEntity = enumAttr.eContainer as Entity
			val parentModel = parentEntity.eContainer as Model
			val curEnum = factory.createEnum()
			curEnum.name = parentEntity.name + "_" + enumAttr.name.toFirstUpper
			curEnum.enumBody = factory.createEnumBody()
			curEnum.enumBody.elements.addAll(Sets::newHashSet((enumAttr.type as EnumType).enumBody.elements))
			parentModel.modelElements.add(curEnum)
			
			// Replace EnumType with ReferencedType
			val refType = factory.createReferencedType()
			refType.element = curEnum
			refType.many = enumAttr.type.many
			refType.params.addAll(Sets::newHashSet((enumAttr.type as EnumType).params.filter(typeof(AttrIsOptional))))
			enumAttr.type = refType
		]
	}
	
	/**
	 * Create validators according to model constraints for mapped GUI elements.
	 * Restricted to StartupActions.
	 * 
	 * TODO change => each time an entity is mapped, the according validator is mapped as well!!
	 */
	def createValidatorsForModelConstraints(String autoGenerationActionName, WorkflowElement wfe) {
		val mappingTasks = wfe.eAllContents.toIterable.filter(MappingTask).filter([isCalledAtStartup(it, autoGenerationActionName)]).toList
		
		val autogenAction = wfe.eAllContents.toIterable.filter(CustomAction).filter(action | action.name == autoGenerationActionName).last
		
		mappingTasks.filter([it.pathDefinition instanceof ContentProviderPath 
			  			 && (it.pathDefinition as ContentProviderPath).contentProviderRef.type instanceof ReferencedModelType
			]).forEach [ mappingTask |
				val validatorBindingTask = modelConstraintToValidator(mappingTask, autogenAction)
				
				if (validatorBindingTask != null && validatorBindingTask.validators.size > 0) {
					autogenAction?.codeFragments.add(validatorBindingTask)
				}
			]
	}
	
	private def modelConstraintToValidator(MappingTask mappingTask, CustomAction autogenAction) {
		
		if (!(mappingTask.pathDefinition instanceof ContentProviderPath)) {
			System::err.println("[ProcessModel] MappingTask is not instance of ContentProviderPathDefinition!")
			return null
		}
		
		if (autogenAction == null) return null
		val validatorBindingTask = factory.createValidatorBindingTask()
		validatorBindingTask.referencedFields.add(copyElement(mappingTask.referencedViewField) as AbstractViewGUIElementRef)
		val attr = (mappingTask.pathDefinition as ContentProviderPath).getReferencedAttribute
		
		// Add IsNotNullValidator
		if (!attr.type.eAllContents.toIterable.filter(typeof(AttrIsOptional)).exists(attrIsOptional | attrIsOptional.optional)) {
			val isNotNullValidator = factory.createStandardValidatorType
			isNotNullValidator.validator = factory.createStandardNotNullValidator
			validatorBindingTask.validators.add(isNotNullValidator)			
		}
		
		// Add attribute type specific standard validators
		val type = attr.type
		switch type {
			ReferencedType case type.element instanceof Enum: { 
				// No further standard validators exist for this case
			}
			IntegerType: {
				// set NumberRangeValidator
				if(type.params.exists(p | p instanceof AttrIntMax || p instanceof AttrIntMin)) {
					val numberRangeValidator = factory.createStandardValidatorType
					numberRangeValidator.validator = factory.createStandardNumberRangeValidator
					
					val max = type.params.filter(typeof(AttrIntMax)).last
					val min = type.params.filter(typeof(AttrIntMin)).last
					
					if(max != null) {
						val validatorMaxParam = factory.createValidatorMaxParam
						validatorMaxParam.setMax(max.max)
						numberRangeValidator.validator.params.add(validatorMaxParam)
					}
					if(min != null) {
						val validatorMinParam = factory.createValidatorMinParam
						validatorMinParam.setMin(min.min)
						numberRangeValidator.validator.params.add(validatorMinParam)
					}
					
					validatorBindingTask.validators.add(numberRangeValidator)
				}
			}
			FloatType: {
				// set NumberRangeValidator
				if(type.params.exists(p | p instanceof AttrFloatMax || p instanceof AttrFloatMin)) {
					val numberRangeValidator = factory.createStandardValidatorType
					numberRangeValidator.validator = factory.createStandardNumberRangeValidator
					
					val max = type.params.filter(typeof(AttrFloatMax)).last
					val min = type.params.filter(typeof(AttrFloatMin)).last
					
					if(max != null) {
						val validatorMaxParam = factory.createValidatorMaxParam
						validatorMaxParam.setMax(max.max)
						numberRangeValidator.validator.params.add(validatorMaxParam)
					}
					if(min != null) {
						val validatorMinParam = factory.createValidatorMinParam
						validatorMinParam.setMin(min.min)
						numberRangeValidator.validator.params.add(validatorMinParam)
					}
					
					validatorBindingTask.validators.add(numberRangeValidator)
				}
			}
			StringType: {
				// set StringRangeValidator
				if(type.params.exists(p | p instanceof AttrStringMax || p instanceof AttrStringMin)) {
					val stringRangeValidator = factory.createStandardValidatorType
					stringRangeValidator.validator = factory.createStandardStringRangeValidator
					
					val maxLength = type.params.filter(typeof(AttrStringMax)).last
					val minLength = type.params.filter(typeof(AttrStringMin)).last
					
					if(maxLength != null) {
						val validatorMaxLengthParam = factory.createValidatorMaxLengthParam
						validatorMaxLengthParam.setMaxLength(maxLength.max)
						stringRangeValidator.validator.params.add(validatorMaxLengthParam)
					}
					if(minLength != null) {
						val validatorMinLengthParam = factory.createValidatorMinLengthParam
						validatorMinLengthParam.setMinLength(minLength.min)
						stringRangeValidator.validator.params.add(validatorMinLengthParam)
					}
					
					validatorBindingTask.validators.add(stringRangeValidator)
				}
			}
			BooleanType: {
				// No further standard validators exist for this case
			}
			DateType: {
				// set DateRangeValidator
				if(type.params.exists(p | p instanceof AttrDateMax || p instanceof AttrDateMin)) {
					val dateRangeValidator = factory.createStandardValidatorType
					dateRangeValidator.validator = factory.createStandardDateRangeValidator
					
					val max = type.params.filter(typeof(AttrDateMax)).last
					val min = type.params.filter(typeof(AttrDateMin)).last
					
					if(max != null) {
						val validatorMaxDateParam = factory.createValidatorMaxDateParam
						validatorMaxDateParam.setMax(max.max)
						dateRangeValidator.validator.params.add(validatorMaxDateParam)
					}
					if(min != null) {
						val validatorMinDateParam = factory.createValidatorMinDateParam
						validatorMinDateParam.setMin(min.min)
						dateRangeValidator.validator.params.add(validatorMinDateParam)
					}
					
					validatorBindingTask.validators.add(dateRangeValidator)
				}
			}
			TimeType: {
				// set TimeRangeValidator
				if(type.params.exists(p | p instanceof AttrTimeMax || p instanceof AttrTimeMin)) {
					val timeRangeValidator = factory.createStandardValidatorType
					timeRangeValidator.validator = factory.createStandardDateRangeValidator
					
					val max = type.params.filter(typeof(AttrTimeMax)).last
					val min = type.params.filter(typeof(AttrTimeMin)).last
					
					if(max != null) {
						val validatorMaxTimeParam = factory.createValidatorMaxTimeParam
						validatorMaxTimeParam.setMax(max.max)
						timeRangeValidator.validator.params.add(validatorMaxTimeParam)
					}
					if(min != null) {
						val validatorMinTimeParam = factory.createValidatorMinTimeParam
						validatorMinTimeParam.setMin(min.min)
						timeRangeValidator.validator.params.add(validatorMinTimeParam)
					}
					
					validatorBindingTask.validators.add(timeRangeValidator)
				}
			}
			DateTimeType: {
				// set DateTimeRangeValidator
				if(type.params.exists(p | p instanceof AttrDateTimeMax || p instanceof AttrDateTimeMin)) {
					val dateTimeRangeValidator = factory.createStandardValidatorType
					dateTimeRangeValidator.validator = factory.createStandardDateTimeRangeValidator
					
					val max = type.params.filter(typeof(AttrDateTimeMax)).last
					val min = type.params.filter(typeof(AttrDateTimeMin)).last
					
					if(max != null) {
						val validatorMaxDateTimeParam = factory.createValidatorMaxDateTimeParam
						validatorMaxDateTimeParam.setMax(max.max)
						dateTimeRangeValidator.validator.params.add(validatorMaxDateTimeParam)
					}
					if(min != null) {
						val validatorMinDateTimeParam = factory.createValidatorMinDateTimeParam
						validatorMinDateTimeParam.setMin(min.min)
						dateTimeRangeValidator.validator.params.add(validatorMinDateTimeParam)
					}
					
					validatorBindingTask.validators.add(dateTimeRangeValidator)
				}
			}
		}
		validatorBindingTask
	}
	
	private def isCalledAtStartup(CustomCodeFragment codeFragment, String autoGenerationActionName) {
		if (codeFragment.eContainer instanceof CustomAction &&
			(codeFragment.eContainer as CustomAction).name == autoGenerationActionName
		) {
			return true
		}
		val startupAction = codeFragment.eResource.allContents.filter(WorkflowElement).last?.initActions.head
		if (startupAction == null) {
			return false
		}
		return traverseAction(startupAction).filter(CustomAction).exists(customAction | customAction.codeFragments.contains(codeFragment))
	}
	
}
