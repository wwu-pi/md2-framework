package de.wwu.md2.framework.validation

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.AllowedOperation
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.mD2.AutoGeneratedContentElement
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderAddAction
import de.wwu.md2.framework.mD2.ContentProviderGetActiveAction
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.ContentProviderRemoveAction
import de.wwu.md2.framework.mD2.ContentProviderRemoveActiveAction
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.EnumBody
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FileType
import de.wwu.md2.framework.mD2.FileUpload
import de.wwu.md2.framework.mD2.FilterType
import de.wwu.md2.framework.mD2.FireEventAction
import de.wwu.md2.framework.mD2.InvokeDefaultValue
import de.wwu.md2.framework.mD2.InvokeDefinition
import de.wwu.md2.framework.mD2.InvokeParam
import de.wwu.md2.framework.mD2.InvokeStringValue
import de.wwu.md2.framework.mD2.InvokeValue
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.LocationProviderReference
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.Main
import de.wwu.md2.framework.mD2.MappingTask
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.ProcessChain
import de.wwu.md2.framework.mD2.ProcessChainGoToNext
import de.wwu.md2.framework.mD2.ProcessChainGoToPrevious
import de.wwu.md2.framework.mD2.ProcessChainStep
import de.wwu.md2.framework.mD2.RESTMethod
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.SimpleType
import de.wwu.md2.framework.mD2.StandardValidator
import de.wwu.md2.framework.mD2.UnmappingTask
import de.wwu.md2.framework.mD2.UploadedImageOutput
import de.wwu.md2.framework.mD2.Validator
import de.wwu.md2.framework.mD2.ViewElementSetTask
import de.wwu.md2.framework.mD2.WebServiceCall
import de.wwu.md2.framework.mD2.WhereClauseCompareExpression
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.impl.BooleanTypeImpl
import de.wwu.md2.framework.mD2.impl.DateTimeTypeImpl
import de.wwu.md2.framework.mD2.impl.DateTypeImpl
import de.wwu.md2.framework.mD2.impl.EnumTypeImpl
import de.wwu.md2.framework.mD2.impl.FloatTypeImpl
import de.wwu.md2.framework.mD2.impl.IntegerTypeImpl
import de.wwu.md2.framework.mD2.impl.InvokeBooleanValueImpl
import de.wwu.md2.framework.mD2.impl.InvokeDateTimeValueImpl
import de.wwu.md2.framework.mD2.impl.InvokeDateValueImpl
import de.wwu.md2.framework.mD2.impl.InvokeFloatValueImpl
import de.wwu.md2.framework.mD2.impl.InvokeIntValueImpl
import de.wwu.md2.framework.mD2.impl.InvokeStringValueImpl
import de.wwu.md2.framework.mD2.impl.InvokeTimeValueImpl
import de.wwu.md2.framework.mD2.impl.StringTypeImpl
import de.wwu.md2.framework.mD2.impl.TimeTypeImpl
import de.wwu.md2.framework.util.GetFiredEventsHelper
import de.wwu.md2.framework.util.MD2Type
import de.wwu.md2.framework.util.MD2Util
import java.util.HashMap
import java.util.HashSet
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check

import static extension de.wwu.md2.framework.util.TypeResolver.*

/**
 * Validators for all controller elements of MD2.
 */
class ControllerValidator extends AbstractMD2Validator {

	public static final String EMPTYPROCESSCHAIN = "emptyProcessChain";
	public static final String NESTEDENTITYWITHOUTCONTENTPROVIDER = "nestedEntityWithoutContentProvider";
	public static final String SAVINGCHECKOFNESTEDENTITY = "savingCheckOfNestedEntity";

	public static final String INVOKEDEFAULTVALUETYPEMISSMATCH = "invokeDefaultValueTypeMissmatch";
	public static final String INVOKEDEFAULTVALUETYPENOTSUPPORTED = "invokeDefaultValueTypeNotSupported";
	public static final String INVOKEMISSINGREQUIREDATTRIBUTE = "invokeMissingRequiredAttribute";
	public static final String INVOKEPATHCOLLISION = "invokePathCollision";
	public static final String ENUMENTRYNOTKNOWN = "enumEntryNotKnown";
	public static final String ACTIONINVALID = "actionInvalid";
	public static final String FILTERMULTIPLIYITY = "filtermultipliyity";

	@Inject
	MD2Util util;

	@Inject
	ValidatorHelpers helper;

	@Inject
	GetFiredEventsHelper eventHelper;

	// ///////////////////////////////////////////////////////
	// / Action Validators
	// ///////////////////////////////////////////////////////
	public static final String EVENTININIT = "EventInInitBlock"

	/**
	 * Ensures correct use of single- and multicontentproviders in ContentProviderGetActiveAction
	 */
	@Check
	def checkCorrectUseOfContentProvidersInGetActiveAction(ContentProviderGetActiveAction action) {

		val cpt = action.contentProviderTarget.contentProvider;
		if (cpt.getType.isMany()) {
			error("Tried to use multicontentprovider as target, only singlecontentprovider allowed.",
				MD2Package.eINSTANCE.contentProviderGetActiveAction_ContentProviderTarget, ACTIONINVALID);
		}

		val cps = action.contentProviderSource.contentProvider;
		if (!cps.getType.isMany()) {
			error("Tried to use singlecontentprovider as source, only multicontentprovider allowed.",
				MD2Package.eINSTANCE.contentProviderGetActiveAction_ContentProviderSource, ACTIONINVALID);
		}
	}

	/**
	 * Ensures correct use of amulticontentprovider in ContentProviderRemoveActiveAction
	 */
	@Check
	def checkCorrectUseOfContentProviderInRemoveActiveAction(ContentProviderRemoveActiveAction action) {
		if (!action.contentProvider.contentProvider.getType.isMany()) {
			error("Tried to use singlecontentprovider in removeActiveAction, only multicontentprovider allowed.",
				MD2Package.eINSTANCE.contentProviderRemoveActiveAction_ContentProvider, ACTIONINVALID);
		}
	}

	/**
	 * Throws errors if a WorkflowEvent is fired in the init Block of a WorkflowElement.
	 */
	@Check
	def checkNoFireEventActionInInitBlock(WorkflowElement wfe) {
		val initActions = wfe.initActions.filter(CustomAction).map[it.codeFragments].flatten

		val callActions = initActions.filter(CallTask).map[it.action]

		val fireEventActions = callActions.filter(SimpleActionRef).map[it.action].filter(FireEventAction)

		fireEventActions.forEach [
			acceptError(it.workflowEvent.name + ": Workflow events must not be fired inside the onInit block!", it,
				MD2Package.eINSTANCE.fireEventAction_WorkflowEvent, -1, EVENTININIT)
		]

	}

	/**
	 * Ensures that the operations 'save' and 'remove' can only be used for none-read-only content providers
	 * in the ContentProviderOperationAction.
	 */
	@Check
	def checkOnlyReadParameterForReadOnlyContentProviderOperations(ContentProviderOperationAction action) {

		val abstractProviderReference = action.contentProvider
		val isReadOnly = switch (abstractProviderReference) {
			ContentProviderReference: abstractProviderReference.contentProvider.readonly
			LocationProviderReference: true
		}

		if (isReadOnly && !action.operation.equals(AllowedOperation::READ)) {
			val error = "You tried to apply a '«action.operation»'-operation on a read-only content provider. Only 'load' is allowed in this location."
			error(error, MD2Package.eINSTANCE.contentProviderOperationAction_Operation, ACTIONINVALID);
		}
	}

	public static final String EVENTSINCONTROLLER = "EventsInController";

	/**
	 * For each Workflow Element Entry of a workflow model, this
	 * method checks whether all Workflow Events fired by the corresponding
	 * Workflow Element are handled.
	 */
	@Check
	def checkAllEventsOfWorkflowElementHandled(WorkflowElementEntry workflowElementEntry) {
		// get names of all events expected in *Workflow.md2
		val expectedEvents = workflowElementEntry.firedEvents.map[it.event.name]

		// get names of all events fired in *Controller.md2
		val actuallyFiredEvents = eventHelper.getFiredEvents(workflowElementEntry.workflowElement).map [
			it.name
		].toSet

		// Calculate difference
		val eventsInControllerButNotInWorkflow = actuallyFiredEvents.filter[!expectedEvents.contains(it)]

		// Show error
		eventsInControllerButNotInWorkflow.forEach [ eventName |
			error(
				"The event " + eventName + " specified in WorkflowElement is not caught",
				MD2Package.eINSTANCE.workflowElementEntry_WorkflowElement,
				-1,
				EVENTSINCONTROLLER
			)
		]
	}

	public static final String IMAGEUPLOAD = "Image Upload requires Connection"
	public static final String UPLOAD_SPECIFYPATH = "Remote Connection for Upload Requires Storage Path"

	/**
	 * Checks whether a fileUploadConnection exists when file uploads or uploaded image outputs are used in the model
	 */
	@Check
	def checkFileUploadConnectionExistsIfNecessary(Main main) {

		if (main.fileUploadConnection === null) {

			val controller = (main.eContainer as Controller)

			val elems = controller.eAllContents.toSet

			// get all viewelements that are used in the controller (unused elements are not relevant)
			val viewrefs = elems.filter(AbstractViewGUIElementRef).map[it.viewElement.ref]

			// search the view elements for uploaded image outputs and file uploads
			val outputViews = viewrefs.filter(UploadedImageOutput)
			val inputViews = viewrefs.filter(FileUpload)

			val allViews = outputViews + inputViews

			if (allViews.size > 0) {
				error(
					"If FileUploads or UploadedImageOutput view elements are used, a fileUploadConnection needs to be specified in the main block.",
					main, null, IMAGEUPLOAD)
			}

		} else if (main.fileUploadConnection.storagePath === null) {
			error("The remote connection of the file upload connection needs to specify a storage path.",
				MD2Package.eINSTANCE.main_FileUploadConnection, -1, UPLOAD_SPECIFYPATH);
		}
	}

	public static final String FILEUPLOADMAPPING = "FileUpload must be mapped to a file type"
	public static final String UPLOADEDIMAGEOUTPUTMAPPING = "UploadedImageOutput must be mapped to a file type"

	/**
	 * Check that mappings of FileUploads or UploadedImageOutputs only reference FileTypes.
	 */
	@Check
	def checkMappingOfFileUploadAndUploadedImageOutputToFileType(MappingTask task) {
		val viewElementType = task.referencedViewField.ref
		var tail = (task.pathDefinition as ContentProviderPath).tail
		while (tail.tail !== null) {
			tail = tail.tail
		}
		val type = tail.attributeRef.type

		if (viewElementType instanceof FileUpload) {
			if (!(type instanceof FileType)) {
				error("A FileUpload must be mapped to a file type.", task, null, FILEUPLOADMAPPING)
			}
		}
		if (viewElementType instanceof UploadedImageOutput) {
			if (!(type instanceof FileType)) {
				error("An UploadedImageOutput must be mapped to a file type.", task, null, UPLOADEDIMAGEOUTPUTMAPPING)
			}
		}
	}

	// ///////////////////////////////////////////////////////
	// / Type Validators
	// ///////////////////////////////////////////////////////
	def static AbstractViewGUIElementRef getViewElement(AbstractViewGUIElementRef ref) {
		if (ref.tail !== null) {
			return ref.tail.getViewElement;
		}
		return ref;
	}

	/**
	 * Ensures that attributes can only be mapped to a view element if both are of the same data type.
	 */
	@Check
	def checkDataTypesOfMappingTask(MappingTask task) {
		val viewField = task.referencedViewField.getViewElement.ref

		val viewFieldType = task.referencedViewField?.calculateType
		val attributeType = task.pathDefinition?.calculateType

		if (viewField instanceof Label) {
			// Mapping to a Label is always ok.
			return;
		}

		if (!viewFieldType.equals(attributeType)) {
			val error = '''Cannot map an attribute with value of type '«attributeType»' to a view element that handles values of type '«viewFieldType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.mappingTask_PathDefinition, -1, null);
		}
	}

	/**
	 * Ensures that attributes can only be unmapped from a view element if both are of the same data type.
	 */
	@Check
	def checkDataTypesOfUnmappingTask(UnmappingTask task) {
		val viewFieldType = task.referencedViewField?.calculateType
		val attributeType = task.pathDefinition?.calculateType

		if (!viewFieldType.equals(attributeType)) {
			val error = '''Cannot (un)map an attribute with value of type '«attributeType»' to a view element that handles values of type '«viewFieldType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.unmappingTask_PathDefinition, -1, null);
		}
	}

	/**
	 * Ensures that values can only be set to an attribute if both have the same data type.
	 */
	@Check
	def checkDataTypesOfAttributeSetTask(AttributeSetTask task) {
		val targetType = task.pathDefinition?.calculateType
		val sourceType = task.source?.calculateType
		val isValidEnum = (task.source !== null && task.source.isValidEnumType(task.pathDefinition)) || false

		if (!targetType.equals(sourceType) && !targetType.equals("string") && !isValidEnum) {
			val errorText = '''Cannot set value of type '«sourceType»' to attribute with value of type '«targetType»'.'''
			error(errorText, MD2Package.eINSTANCE.attributeSetTask_Source);
		} else if (!targetType.equals(sourceType) && targetType.equals("string") && !isValidEnum) {
			val warningText = '''You are assigning a value of type '«sourceType»' to an attribute of type string. The string representation of '«sourceType»' will be assigned instead.'''
			warning(warningText, MD2Package.eINSTANCE.attributeSetTask_Source);
		}
	}

	/**
	 * Ensures that values can only be set to a content provider if both have the same data type.
	 */
	@Check
	def checkDataTypesOfContentProviderSetTask(ContentProviderSetTask task) {
		val targetType = task.contentProvider?.calculateType
		val sourceType = task.source?.calculateType

		if (!targetType.equals(sourceType)) {
			val error = '''Cannot set value of type '«sourceType»' to content provider of type '«targetType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.contentProviderSetTask_Source, -1, null);
		}
	}

	/**
	 * Ensures that values can only be set to a view element if both have the same data type.
	 */
	@Check
	def checkDataTypesOfViewElementSetTask(ViewElementSetTask task) {
		val targetType = task.referencedViewField?.calculateType
		val sourceType = task.source?.calculateType
		val isValidEnum = task.source.isValidEnumType(task.referencedViewField)

		if (!targetType.equals(sourceType) && !targetType.equals(MD2Type.STRING) && !isValidEnum) {
			val error = '''Cannot set value of type '«sourceType»' to a view element that handles values of type '«targetType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.viewElementSetTask_Source, -1, null);
		} else if (!targetType.equals(sourceType) && targetType.equals(MD2Type.STRING) && !isValidEnum) {
			val warning = '''You are assigning a value of type '«sourceType»' to view element of type string. The string representation of '«sourceType»' will be assigned instead.'''
			acceptWarning(warning, task, MD2Package.eINSTANCE.viewElementSetTask_Source, -1, null);
		}
	}

	/**
	 * Ensures that the left-hand side and the right-hand side of a comparison expression have the same data type.
	 */
	@Check
	def checkBothExpressionsInComparisonOfSameType(CompareExpression expr) {
		val left = expr.eqLeft?.calculateType
		val right = expr.eqRight?.calculateType
		val isValidEnum = expr.eqLeft.isValidEnumType(expr.eqRight)

		if (!left.equals(right) && !isValidEnum) {
			val error = '''Cannot compare a value of type '«right»' with a value of type '«left»'. Both values in a comparison have to be of the same type.'''
			acceptError(error, expr, MD2Package.eINSTANCE.compareExpression_EqRight, -1, null);
		}
	}

	/**
	 * Ensures that <=, >=, < and > can only be applied to values with numerical values.
	 */
	@Check
	def checkCorrectUsageOfOperators(CompareExpression expr) {
		val left = expr.eqLeft?.calculateType
		val isNumericOperator = switch expr.op {
			case Operator::GREATER: true
			case Operator::GREATER_OR_EQUAL: true
			case Operator::SMALLER: true
			case Operator::SMALLER_OR_EQUAL: true
			default: false
		}

		if (isNumericOperator && !left.numeric) {
			val error = '''Cannot use operator '«expr.op.toString»' on a value of type '«left»'.'''
			error(error, MD2Package.eINSTANCE.compareExpression_Op, null);
		}
	}

	/**
	 * Ensures that the left-hand side (attribute value) and the right-hand side of a where filter comparison expression
	 * have the same data type.
	 */
	@Check
	def checkBothExpressionsInWhereClauseComparisonOfSameType(WhereClauseCompareExpression expr) {
		val attrType = expr.eqLeft.tail?.calculateType
		val valueType = expr.eqRight?.calculateType

		if (!attrType.equals(valueType)) {
			val error = '''Cannot compare a value of type '«valueType»' with an attribute that has a value of type '«attrType»'.'''
			error(error, MD2Package.eINSTANCE.whereClauseCompareExpression_EqRight, null);
		}
	}

	/**
	 * Ensures that <=, >=, < and > can only be applied to values with numerical values.
	 */
	@Check
	def checkCorrectUsageOfOperatorsInWhereClauseComparison(WhereClauseCompareExpression expr) {
		val left = expr.eqLeft.tail?.calculateType
		val isNumericOperator = switch expr.op {
			case Operator::GREATER: true
			case Operator::GREATER_OR_EQUAL: true
			case Operator::SMALLER: true
			case Operator::SMALLER_OR_EQUAL: true
			default: false
		}

		if (isNumericOperator && !left.numeric) {
			val error = '''Cannot use operator '«expr.op.toString»' on a value of type '«left»'.'''
			error(error, MD2Package.eINSTANCE.whereClauseCompareExpression_Op, null);
		}
	}

	// ///////////////////////////////////////////////////////
	// / ProcessChain Validators
	// ///////////////////////////////////////////////////////
	/**
	 * Avoids that reverse operations can be assigned to the first step of a ProcessChain.
	 */
	@Check
	def checkThatNoReverseDeclarationsOnFirstProcessChainStep(ProcessChainGoToPrevious reverse) {

		val processChainStep = reverse.eContainer.eContainer as ProcessChainStep
		val processChain = processChainStep.eContainer as ProcessChain

		val stepIndex = processChain.processChainSteps.indexOf(processChainStep)

		if (stepIndex == 0) {
			val error = '''No preceeding step! Cannot define 'reverse' operation on first processChain step.'''
			acceptError(error, reverse, null, -1, null);
		}
	}

	/**
	 * Avoids that proceed operations can be assigned to the last step of a ProcessChain.
	 */
	@Check
	def checkThatNoProceedDeclarationsOnLastProcessChainStep(ProcessChainGoToNext next) {

		val processChainStep = next.eContainer.eContainer as ProcessChainStep
		val processChain = processChainStep.eContainer as ProcessChain

		val stepIndex = processChain.processChainSteps.indexOf(processChainStep)

		if (stepIndex == processChain.processChainSteps.size - 1) {
			val error = '''No subsequent step! Cannot define 'proceed' operation on last processChain step.'''
			acceptError(error, next, null, -1, null);
		}
	}
	/**
	 * Avoid empty processChains.
	 * @param processChain
	 */
	@Check
	def checkForEmptyProcessChains(ProcessChain processChain) {
		if (processChain.processChainSteps.empty) {
			acceptWarning(
				"No processChain steps are defined for this processChain. A processChain should have at least one step showing a view.",
				processChain, null, -1, EMPTYPROCESSCHAIN);
		}
	}

	/**
	 * Validator for nested entities -> throws a warning, if no content provider and initialization for nested entities exist.
	 * "A ContentProvider for a nested entity is missing."
	 *  
	 *  @param ContentProvider
	 */
	@Check
	def checkContentProvidersOfNestedEntities(ContentProvider cprov) {
		// List of ContentProviders
		val cpList = (cprov.eContainer() as Controller).controllerElements.filter(typeof(ContentProvider))

		// Attributes of the contentProviderEntity
		if(!(cprov.type instanceof ReferencedModelType) ||
			!((cprov.type as ReferencedModelType).entity instanceof Entity)) return
		val refModelType = cprov.type as ReferencedModelType
		val cpEntity = refModelType.entity as Entity
		val cpEntityAttributes = cpEntity.attributes

		// Find referenced attributes within the entity
		val referencedAttributes = cpEntityAttributes.filter[it.type instanceof ReferencedType].filter [
			(it.type as ReferencedType).element instanceof Entity
		].toList

		// Check if ContentProviders exist for the nested Entities
		for (refAt : referencedAttributes) {
			var found = false
			val referencedEntityName = (refAt.type as ReferencedType).element.name
			for (cp : cpList) {
				if (referencedEntityName == ((cp.type as ReferencedModelType).entity as Entity).name) {
					found = true
				}
			}
			// Show warning, in case of missing ContentProvider for a nested entity
			if (!found) {
				warning("A ContentProvider for the nested entity " + referencedEntityName + " is missing.", cprov, null,
					-1, NESTEDENTITYWITHOUTCONTENTPROVIDER);
			}
		}
	}

	/**
	 * Validator for saving of nested entities. 
	 * Show warning, if not set directly before saving.
	 * "Please be sure to check, if the provider is correctly set before using the saving operation."
	 * 
	 * @param CustomAction
	 */
	@Check
	def checkSavingOfNestedEntities(CustomAction caction) {
		val wfelements = caction.eContainer() as WorkflowElement
		val container = wfelements.eContainer() as Controller
		val cpList = container.controllerElements.filter(typeof(ContentProvider)).toList

		// HashMap of Entities with their nested Entities
		var hm = <String, HashMap<String, String>>newHashMap

		// Search for Entities with nested Entities and put them into hm
		for (cp : cpList) {
			if ((cp.type as ReferencedModelType).entity instanceof Entity) {
				val entity = (cp.type as ReferencedModelType).entity as Entity
				val refEntities = entity.attributes.filter[it.type instanceof ReferencedType].filter [
					(it.type as ReferencedType).element instanceof Entity
				].toList
				for (rE : refEntities) {
					var temphashmap = hm.get(entity.name)
					if (temphashmap === null) {
						temphashmap = <String, String>newHashMap
						hm.put(entity.name, temphashmap)
					}
					temphashmap.put(rE.name, (rE.type as ReferencedType).element.name)
				}
			} // else skip enums
		}
		// Only do for CustomActions, that include a call to save a ContentProvider  
		val callTasks = caction.codeFragments.filter(CallTask)
		val savecalls = callTasks.map [
			it.eAllContents.filter(ContentProviderOperationAction).filter[it.operation.literal == "save"].toSet
		].flatten.toList

		// Check for the remaining CustomActions, if the saved entity is nested
		for (sc : savecalls) {
			// Save information about savecall
			val savedEntity = ((sc.contentProvider as ContentProviderReference).contentProvider.
				type as ReferencedModelType).entity as Entity
			val savedEntityName = savedEntity.name
			val indexOfSaveCall = caction.codeFragments.indexOf(
				(sc.eContainer as SimpleActionRef).eContainer as CallTask)

			// Check, if saved-Entity includes nested entities
			if (hm.containsKey(savedEntityName)) {
				var nestedEntities = hm.get(savedEntityName)

				// Check, if attribute of the entity is set onto the corresponding nested contentProvider BEFORE the save operation
				for (var i = 0; i < indexOfSaveCall; i++) {
					var codeFragment = caction.codeFragments.get(i)

					// Check, if the codeFragement is a set operation
					if (codeFragment instanceof AttributeSetTask) {
						val sourceEntity = (codeFragment.pathDefinition.contentProviderRef.type as ReferencedModelType).
							entity.name
						val sourceAttr = codeFragment.pathDefinition.tail.attributeRef.name
						val target = ((codeFragment.source as ContentProviderReference).contentProvider.
							type as ReferencedModelType).entity.name

						// Check, if savedEntity is saved within the set command 
						if (savedEntityName == sourceEntity) {
							// Check, if the target of the set statement corresponds to one of the nestedEntities
							if (target == nestedEntities.get(sourceAttr)) {
								// if correct, delete from list of unset nested entity attributes
								nestedEntities.remove(sourceAttr)
							}
						}
					}
				}
				if (!nestedEntities.empty) {
					// System.out.println("WARNING! Following nested Entities are not set: " + nestedEntities.toString) //for debugging
					warning(
						"Not all Attributes of nested Entities within the Provider are set to their corresponding providers before saving. Please make sure, this is wanted.",
						sc, null, -1, SAVINGCHECKOFNESTEDENTITY);
				}
			}
		}
	}

	/**
	 * Ensures that, when the REST method 'GET' is chosen, no body params are set.  
	 */
	public static final String NOBODYPARAMSWHENGET = "noBodyParamsWhenGET";

	@Check
	def checkNoBodyParamsWhenGETMethod(WebServiceCall wscall) {
		if (wscall.method.equals(RESTMethod.GET) && wscall.bodyparams.size > 0) {
			error(
				"When REST method 'GET' is chosen, no body params are allowed. Use the queryparams construct instead.",
				MD2Package.eINSTANCE.webServiceCall_Bodyparams, NOBODYPARAMSWHENGET);
		}
	}
    
	/////////////////////////////////////////////////////////
	/// Invoke Validators
	/////////////////////////////////////////////////////////

	public static final String UNSUPPORTEDRESTMETHOD = "unsupportedRESTMethod"

	/**
	 * Validate that the chosen REST method to invoke a workflowElement is either POST or PUT.
	 */
	@Check
	def checkRestMethod(InvokeDefinition invokeDefinition) {
		val method = invokeDefinition?.method
		if (method == RESTMethod.GET || method == RESTMethod.DELETE) {
			error("The method type " + method.toString + " is not supported. Please use POST or PUT.",
				MD2Package.eINSTANCE.invokeDefinition_Method, UNSUPPORTEDRESTMETHOD);
		}
	}

	/**
	 * These maps enable for a comparison between the two class types and to ensure, that no unsupported value is set.
	 */
	static final Map<Class<? extends InvokeValue>, String> invokeValueTypeMap = getInvokeValueTypeHashMap()

	static final Map<Class<? extends AttributeType>, String> supportedAttributeTypeMap = getSupportedAttributeTypeHashMap()

	private static def HashMap<Class<? extends InvokeValue>, String> getInvokeValueTypeHashMap() {
		val HashMap<Class<? extends InvokeValue>, String> map = newHashMap()
		map.put(InvokeIntValueImpl, "integer")
		map.put(InvokeFloatValueImpl, "float")
		map.put(InvokeStringValueImpl, "string")
		map.put(InvokeBooleanValueImpl, "boolean")
		map.put(InvokeDateValueImpl, "date")
		map.put(InvokeTimeValueImpl, "time")
		map.put(InvokeDateTimeValueImpl, "datetime")
		return map;
	}

	private static def HashMap<Class<? extends AttributeType>, String> getSupportedAttributeTypeHashMap() {
		val HashMap<Class<? extends AttributeType>, String> map = newHashMap()
		map.put(IntegerTypeImpl, "integer")
		map.put(FloatTypeImpl, "float")
		map.put(StringTypeImpl, "string")
		map.put(BooleanTypeImpl, "boolean")
		map.put(DateTypeImpl, "date")
		map.put(TimeTypeImpl, "time")
		map.put(DateTimeTypeImpl, "datetime")
		map.put(EnumTypeImpl, "enum")
		return map
	}

	/**
	 * Ensure, that InvokeDefaultValue has same type
	 * @param invokeDefaultValue
	 */
	@Check
	def checkForTypeOfInvokeDefaultValue(InvokeDefaultValue defaultValue) {
		var valueType = invokeValueTypeMap.get(defaultValue.invokeValue.class)
		val attributeType = defaultValue.field.tail?.calculateType
		var cpType = supportedAttributeTypeMap.get(attributeType.class)
		if (cpType === null && attributeType instanceof ReferencedType) {
			var referencedType = (attributeType as ReferencedType).getElement()
			if (referencedType instanceof Enum) {
				cpType = supportedAttributeTypeMap.get(EnumTypeImpl)
			}
		}

		if (cpType !== null && valueType !== null && !valueType.equals(cpType)) {
			error('''The types of the content provider and its default value have to match each other! Expected default value to be of type «cpType» but was «valueType»!''',
				MD2Package.eINSTANCE.invokeDefaultValue_InvokeValue, INVOKEDEFAULTVALUETYPEMISSMATCH)
		} else if (cpType === null) {
			error('''The type «defaultValue.field.tail?.calculateType» of the content provider reference is not supported to be set to a default value!''',
				MD2Package.eINSTANCE.invokeParam_Field, INVOKEDEFAULTVALUETYPENOTSUPPORTED)
		}
	}

	/**
	 * Ensure, that invoke paths are unique
	 * @param workflowElement
	 */
	@Check
	def checkForInvokePathsBeingUnique(WorkflowElement wfe) {
		if (wfe.invoke.size > 1) {
			val paths = wfe.invoke.map[it.path ?: ""]
			val allpaths = new HashSet<String>()
			val conflictedPaths = new HashSet<String>()
			// Look for all paths, that are at least twice in the list
			paths.forEach [
				if (allpaths.contains(it)) {
					conflictedPaths.add(it)
				} else {
					allpaths.add(it)
				}
			]
			for (InvokeDefinition invoke : wfe.invoke) {
				if (conflictedPaths.contains(invoke.path ?: "")) {
					var error = '''The paths of invoke definitions need to be unique!'''
					var EStructuralFeature structuralFeature = null
					if (invoke.path !== null) {
						structuralFeature = MD2Package.eINSTANCE.invokeDefinition_Path
					} else {
						error += ''' When the path is not set the default is "".'''
					}
					error(error, invoke, structuralFeature, -1, INVOKEPATHCOLLISION)
				}
			}
		}
	}

	/**
	 * Ensure, that all required attributes are set
	 * @param workflowElement
	 */
	@Check
	def checkForRequiredAttributesInInvoke(InvokeDefinition invokeDefinition) {
		// Get all entities, which are somehow present in a invokeParam of the definition
		val allEntities = new HashSet<Entity>()
		for (InvokeParam param : invokeDefinition.params) {
			var entity = (( param.field.contentProviderRef.type as ReferencedModelType).entity) as Entity
			allEntities.add(entity)
		}
		val allAttributes = allEntities.map[it.attributes].flatten
		// Set that contains all required attributes including nested
		var processedRequiredAttributes = new HashSet<Attribute>()
		// Serves as temporary set for required attributes (is needed for the extraction of nested required attributes)
		var requiredAttributes = helper.getRequiredAttributes(allAttributes.toSet)
		processedRequiredAttributes.addAll(requiredAttributes)
		// For requrired attributes of type ReferenceTypes look deeper if there are nested required attributes (recursive)
		var requiredReferenceTypes = requiredAttributes.filter[it.type instanceof ReferencedType]
		while (requiredReferenceTypes.size > 0) {
			requiredAttributes = helper.getRequiredAttributes(requiredReferenceTypes.map[(it.type as ReferencedType).element].filter(Entity).map [
				it.attributes
			].flatten)
			processedRequiredAttributes.addAll(requiredAttributes)
			requiredReferenceTypes = requiredAttributes.filter[it.type instanceof ReferencedType]
			processedRequiredAttributes.addAll(requiredAttributes)
		}

		// Retrieve all real covered attributes either set by a InvokeDefaultValue, InvokeSetContentProvider, or InvokeWSParam operation
		var allCoveredAttributes = invokeDefinition.params.map[it.field.tail.resolveAttribute]
		processedRequiredAttributes.removeAll(allCoveredAttributes)
		processedRequiredAttributes.forEach [
			var error = '''The required attribute «it.name» of the entity «(it.eContainer as Entity).name» is not set. Either set «it.name» to an default value, offer it to be set via the rest service, set «it.name» to be optional, or remove any other related attribute from the invoke definition.'''
			error(error, invokeDefinition, null, -1, INVOKEMISSINGREQUIREDATTRIBUTE)
		]
	}

	/**
	 * Ensure, that enum string is valid
	 * @param workflowElement
	 */
	@Check
	def checkForValidEnumString(InvokeDefaultValue defaultValue) {
		var attributeType = defaultValue.field.tail?.calculateType
		var EnumBody enumBody = null
		var String enumName = null
		switch (attributeType) {
			ReferencedType: {
				var element = attributeType.getElement()
				if (element instanceof Enum) {
					enumBody = element.enumBody
					enumName = element.name
				}
			}
			EnumType: {
				error(
					"An internal enum is not supported to be set as default value. Please create a enum object for it.",
					defaultValue, MD2Package.eINSTANCE.invokeDefaultValue_InvokeValue, null)
			}
		}
		if (enumBody !== null) {
			if (defaultValue.invokeValue instanceof InvokeStringValue) {

				var value = (defaultValue.invokeValue as InvokeStringValue).value
				if (!enumBody.elements.contains(value)) {
					error('''The enum value does not equal any entry of the enum «enumName»''',
						MD2Package.eINSTANCE.invokeDefaultValue_InvokeValue, ENUMENTRYNOTKNOWN)
				}
			}
		}
	}

	/**
	 * This validator enforces the declaration of exactly one Main block in all of the
	 * controller files.
	 * 
	 * @param controller
	 */
	@Check
	def ensureThatExactlyOneMainBlockExists(Controller controller) {
		// this list only stores the Main objects of the controller currently validated
		// this information is needed to mark all duplicate Main blocks
		var List<Main> mainObjects = null;

		// this counter stores the overall occurrences of main blocks throughout all controllers
		var occurencesOfMain = 0;

		// collect all Main Objects of this controller and count the overall main objects over all controllers
		val md2Models = util.getAllMD2Models(controller.eResource());
		for (MD2Model m : md2Models) {
			val ml = m.getModelLayer();
			if (ml instanceof Controller) {
				val lst = EcoreUtil2.getAllContentsOfType(ml, Main);
				occurencesOfMain += lst.size();

				if (ml.eResource().getURI().equals(controller.eResource().getURI())) {
					mainObjects = lst;
				}
			}
		}

		// throw error if not exactly one main block exists
		if (occurencesOfMain == 0 && !md2Models.isEmpty()) {
			error("The Main declaration block is missing", MD2Package.eINSTANCE.getController_ControllerElements());
		} else if (occurencesOfMain > 1 && mainObjects !== null) {
			// mark all Main blocks in this controller
			for (Main mainObj : mainObjects) {
				error("Only one Main block is allowed, but " + occurencesOfMain + " have been found", mainObj, null, -1,
					null);
			}
		}
	}

	/**
	 * Prevent from defining parameters multiple times in any of the validators.
	 * 
	 * @param validator
	 */
	@Check
	def checkRepeatedParams(Validator validator) {
		helper.repeatedParamsError(validator, MD2Package.eINSTANCE.validator_Name, this, validatorParams());
	}

	/**
	 * Prevent from defining parameters multiple times in any of the standard validators.
	 * 
	 * @param validator
	 * 
	 */
	@Check
	def checkRepeatedParams(StandardValidator validator) {
		helper.repeatedParamsError(validator, MD2Package.eINSTANCE.standardValidator_Params, this, validatorParams());
	}

	private def String[] validatorParams() {
		return #[
			"ValidatorMessageParam",
			"message",
			"ValidatorFormatParam",
			"format",
			"ValidatorRegExParam",
			"regEx",
			"ValidatorMaxParam",
			"max",
			"ValidatorMinParam",
			"min",
			"ValidatorMaxLengthParam",
			"maxLenght",
			"ValidatorMinLengthParam",
			"minLength"
		]
	}

	/**
	 * Make sure the the ContentProviderPathDefinition for a ReferencedModelType-ContentProvider provides at least one attribute
	 * Mainly used for MappingTasks.
	 * @param pathDef
	 */
	@Check
	def checkContentProviderPathDefinition(ContentProviderPath pathDef) {
		if (pathDef.getContentProviderRef() !== null) {
			if (pathDef.getContentProviderRef().getType() instanceof ReferencedModelType) {
				if (pathDef.getTail() === null) {
					error("No attribute specified", MD2Package.eINSTANCE.contentProviderPath_ContentProviderRef);
				}
			}
		}
	}

	/**
	 * Make sure the referenced auto-generated element from a Simple-Type-ContentProvider exists
	 * @param abstractRef
	 */
	@Check
	def checkAbstractViewGUIElementRef_SimpleDataType(AbstractViewGUIElementRef abstractRef) {
		if(abstractRef.getSimpleType() === null) return;
		val simpleTypes = newArrayList();
		if (abstractRef.getRef() instanceof AutoGeneratedContentElement) {
			for (ContentProviderReference ref : (abstractRef.getRef() as AutoGeneratedContentElement).
				getContentProvider()) {
				val cp = ref.getContentProvider();
				if (cp.getType() instanceof SimpleType) {
					val type = (cp.getType() as SimpleType).getType();
					if (type == abstractRef.getSimpleType().getType()) {
						return
					} else simpleTypes.add(type.toString());
				}
			}
		}
		var warning = "No such element exists.";
		if(simpleTypes.size() > 0) warning += " Choose from: " + simpleTypes;
		error(warning, MD2Package.eINSTANCE.abstractViewGUIElementRef_SimpleType);
	}

	/**
	 * Prevent user from referencing an AutoGeneratorContentElement
	 * @param abstractRef
	 */
	@Check
	def checkAbstractViewGUIElementRef_Path(AbstractViewGUIElementRef abstractRef) {
		if (abstractRef.getRef() instanceof AutoGeneratedContentElement && abstractRef.getPath() === null &&
			abstractRef.getSimpleType() === null) {
			warning("No attribute specified.", MD2Package.eINSTANCE.abstractViewGUIElementRef_Path);
		}
	}

	/**
	 * This validator avoids the assignment of none-toMany content providers (providing X[]) to ContentProviderAddActions.
	 * @param addAction
	 */
	@Check
	def checkContentProviderAddActionForInvalidMultiplicities(ContentProviderAddAction addAction) {
		val targetContentProviderType = addAction.contentProviderTarget.contentProvider.type;
		if (!targetContentProviderType.isMany()) {
			error(
				"Tried to add an element to a content provider of type '" +
					helper.getDataTypeName(targetContentProviderType) + "', but expected an is-many content provider " +
					helper.getDataTypeName(targetContentProviderType) + "[].",
				MD2Package.eINSTANCE.contentProviderAddAction_ContentProviderTarget);
		}

		if (addAction.contentProviderSource.contentProvider.type.isMany()) {
			error("Tried to use a MultiContentProvider as source for addAction, only single ContenProvider allowed",
				MD2Package.eINSTANCE.contentProviderAddAction_ContentProviderSource);
		}
	}

	/**
	 * This validator avoids the assignment of none-toMany content providers (providing X[]) to ContentProviderRemoveActions.
	 * @param removeAction
	 */
	@Check
	def checkContentProviderRemoveActionForInvalidMultiplicities(ContentProviderRemoveAction removeAction) {
		val targetContentProviderType = removeAction.contentProvider.contentProvider.type;
		if (!targetContentProviderType.isMany()) {
			error(
				"Tried to remove an element from a content provider of type '" +
					helper.getDataTypeName(targetContentProviderType) + "', but expected an is-many content provider " +
					helper.getDataTypeName(targetContentProviderType) + "[].",
				MD2Package.eINSTANCE.contentProviderRemoveAction_ContentProvider);
		}
	}

	/**
	 * Avoid the assignment of 'all' filters to single-instance content providers.
	 * @param contentProvider
	 */
	@Check
	def checkFilterMultiplicity(ContentProvider contentProvider) {
		if (!contentProvider.getType().isMany() && contentProvider.isFilter() &&
			contentProvider.getFilterType().equals(FilterType.ALL)) {
			error("The filter type 'all' cannot be assigned to content providers that only return a single " +
				"instance. Change parameter to 'first'.",
				MD2Package.eINSTANCE.contentProvider_FilterType,
				FILTERMULTIPLIYITY);
		}
	}
}
