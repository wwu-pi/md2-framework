package de.wwu.md2.framework.validation

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.AllowedOperation
import de.wwu.md2.framework.mD2.AttrIsOptional
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FileType
import de.wwu.md2.framework.mD2.FileUpload
import de.wwu.md2.framework.mD2.FireEventAction
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.InvokeDefaultValue
import de.wwu.md2.framework.mD2.InvokeDefinition
import de.wwu.md2.framework.mD2.InvokeParam
import de.wwu.md2.framework.mD2.InvokeValue
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.LocationProviderReference
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
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.UnmappingTask
import de.wwu.md2.framework.mD2.UploadedImageOutput
import de.wwu.md2.framework.mD2.ViewElementSetTask
import de.wwu.md2.framework.mD2.WebServiceCall
import de.wwu.md2.framework.mD2.WhereClauseCompareExpression
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.impl.BooleanTypeImpl
import de.wwu.md2.framework.mD2.impl.DateTimeTypeImpl
import de.wwu.md2.framework.mD2.impl.DateTypeImpl
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
import java.util.HashMap
import java.util.HashSet
import java.util.Map
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

import static extension de.wwu.md2.framework.util.TypeResolver.*
import de.wwu.md2.framework.mD2.impl.EnumTypeImpl
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.EnumBody
import de.wwu.md2.framework.mD2.InvokeStringValue
import java.util.Set

/**
 * Validators for all controller elements of MD2.
 */
class ControllerValidator extends AbstractMD2JavaValidator {
	
	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    public static final String EMPTYPROCESSCHAIN = "emptyProcessChain";
    public static final String NESTEDENTITYWITHOUTCONTENTPROVIDER = "nestedEntityWithoutContentProvider";
    public static final String SAVINGCHECKOFNESTEDENTITY = "savingCheckOfNestedEntity";
    
    public static final String INVOKEDEFAULTVALUETYPEMISSMATCH = "invokeDefaultValueTypeMissmatch";
    public static final String INVOKEDEFAULTVALUETYPENOTSUPPORTED = "invokeDefaultValueTypeNotSupported";
    public static final String INVOKEMISSINGREQUIREDATTRIBUTE = "invokeMissingRequiredAttribute";
    public static final String INVOKEPATHCOLLISION = "invokePathCollision";
    public static final String ENUMENTRYNOTKNOWN = "enumEntryNotKnown";
    
    @Inject
    GetFiredEventsHelper helper;
    
    /////////////////////////////////////////////////////////
	/// Action Validators
	/////////////////////////////////////////////////////////
	
	public static final String EVENTININIT = "EventInInitBlock"
	
	/**
	 * Throws errors if a WorkflowEvent is fired in the init Block of a WorkflowElement.
	 */
	@Check
	def checkNoFireEventActionInInitBlock(WorkflowElement wfe){
		val initActions = wfe.initActions.filter(CustomAction).map[it.codeFragments].flatten
		
		val callActions = initActions.filter(CallTask).map[it.action]
		
		val fireEventActions = callActions.filter(SimpleActionRef).map[it.action].filter(FireEventAction)
		
		fireEventActions.forEach[
			acceptError(it.workflowEvent.name + ": Workflow events must not be fired inside the onInit block!", it, MD2Package.eINSTANCE.fireEventAction_WorkflowEvent , -1, EVENTININIT)
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
			val error = '''
				You tried to apply a '«action.operation»'-operation on a read-only content provider. Only 'load' is allowed in this location.
			'''
			acceptError(error, action, MD2Package.eINSTANCE.contentProviderOperationAction_Operation, -1, null);
		}
	}
	
	public static final String EVENTSINCONTROLLER = "EventsInController";
	
	/**
	 * For each Workflow Element Entry of a workflow model, this
	 * method checks whether all Workflow Events fired by the corresponding
	 * Workflow Element are handled.
	 */
	@Check
	def checkAllEventsOfWorkflowElementHandled(WorkflowElementEntry workflowElementEntry){
		// get names of all events expected in *Workflow.md2
		val expectedEvents = workflowElementEntry.firedEvents.map[it.event.name]
		
		// get names of all events fired in *Controller.md2
		val actuallyFiredEvents = helper.getFiredEvents(workflowElementEntry.workflowElement).map[
			it.name
		].toSet
		
		// Calculate difference
		val eventsInControllerButNotInWorkflow = actuallyFiredEvents.filter[!expectedEvents.contains(it)]
		
		// Show error
		eventsInControllerButNotInWorkflow.forEach[ eventName |
			error("The event " + eventName + " specified in WorkflowElement is not caught",
				MD2Package.eINSTANCE.workflowElementEntry_WorkflowElement, -1, EVENTSINCONTROLLER
			)
		]
	}
	
	public static final String IMAGEUPLOAD = "Image Upload requires Connection"
	public static final String UPLOAD_SPECIFYPATH = "Remote Connection for Upload Requires Storage Path"
	
	/**
	 * Checks whether a fileUploadConnection exists when file uploads or uploaded image outputs are used in the model
	 */
	@Check
	def checkFileUploadConnectionExistsIfNecessary (Main main){

		if (main.fileUploadConnection == null){
			
			val controller = (main.eContainer as Controller)
			
			val elems = controller.eAllContents.toSet
			
			// get all viewelements that are used in the controller (unused elements are not relevant)
			val viewrefs = elems.filter(AbstractViewGUIElementRef).map[it.viewElement.ref]
			
			// search the view elements for uploaded image outputs and file uploads
			val outputViews = viewrefs.filter(UploadedImageOutput)
			val inputViews = viewrefs.filter(FileUpload)
			
			val allViews = outputViews + inputViews
			
			if (allViews.size > 0){
				error("If FileUploads or UploadedImageOutput view elements are used, a fileUploadConnection needs to be specified in the main block.",
				main, null, IMAGEUPLOAD)
			}

		}
		else{
			if (main.fileUploadConnection.storagePath == null) {
				error("The remote connection of the file upload connection needs to specify a storage path.", MD2Package.eINSTANCE.main_FileUploadConnection, -1, UPLOAD_SPECIFYPATH);
			}
		}
	}
	
	
	public static final String FILEUPLOADMAPPING = "FileUpload must be mapped to a file type"
	public static final String UPLOADEDIMAGEOUTPUTMAPPING = "UploadedImageOutput must be mapped to a file type"
	/**
	 * Check that mappings of FileUploads or UploadedImageOutputs only reference FileTypes.
	 */
	@Check
	def checkMappingOfFileUploadAndUploadedImageOutputToFileType(MappingTask task){
	    val viewElementType = task.referencedViewField.ref
	    var tail = (task.pathDefinition as ContentProviderPath).tail
	    while(tail.tail != null){
	        tail = tail.tail
	    }
	    val type = tail.attributeRef.type
	    
	    if(viewElementType instanceof FileUpload){
            if(!(type instanceof FileType)){
               error("A FileUpload must be mapped to a file type.", task, null, FILEUPLOADMAPPING)    
            }
        }
        if(viewElementType instanceof UploadedImageOutput){
            if(!(type instanceof FileType)){
               error("An UploadedImageOutput must be mapped to a file type.", task, null, UPLOADEDIMAGEOUTPUTMAPPING)    
            }
        }  
	}
	
	
	/////////////////////////////////////////////////////////
	/// Type Validators
	/////////////////////////////////////////////////////////
	
	def static AbstractViewGUIElementRef getViewElement(AbstractViewGUIElementRef ref)
	{
		
		if (ref.tail != null)
		{
			return ref.tail.getViewElement;
		}
		else {
			return ref;
		}
	}
	
	/**
	 * Ensures that attributes can only be mapped to a view element if both are of the same data type.
	 */
	@Check
	def checkDataTypesOfMappingTask(MappingTask task) {
		
		val viewField = task.referencedViewField.getViewElement.ref
		
		val viewFieldType = task.referencedViewField.expressionType
		val attributeType = task.pathDefinition.expressionType
		
		if(viewField instanceof Label) {
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
		val viewFieldType = task.referencedViewField.expressionType
		val attributeType = task.pathDefinition.expressionType
		
		if (!viewFieldType.equals(attributeType)) {
			val error = '''Cannot map an attribute with value of type '«attributeType»' to a view element that handles values of type '«viewFieldType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.unmappingTask_PathDefinition, -1, null);
		}
	}
	
	/**
	 * Ensures that values can only be set to an attribute if both have the same data type.
	 */
	@Check
	def checkDataTypesOfAttributeSetTask(AttributeSetTask task) {
		val targetType = task.pathDefinition.expressionType
		val sourceType = task.source.expressionType
		val isValidEnum = task.source.isValidEnumType(task.pathDefinition)
		
		if (!targetType.equals(sourceType) && !targetType.equals("string") && !isValidEnum) {
			val error = '''Cannot set value of type '«sourceType»' to attribute with value of type '«targetType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.attributeSetTask_Source, -1, null);
		} else if (!targetType.equals(sourceType) && targetType.equals("string") && !isValidEnum) {
			val warning = '''You are assigning a value of type '«sourceType»' to an attribute of type string. The string representation of '«sourceType»' will be assigned instead.'''
			acceptWarning(warning, task, MD2Package.eINSTANCE.attributeSetTask_Source, -1, null);
		}
	}
	
	/**
	 * Ensures that values can only be set to a content provider if both have the same data type.
	 */
	@Check
	def checkDataTypesOfContentProviderSetTask(ContentProviderSetTask task) {
		val targetType = task.contentProvider.expressionType
		val sourceType = task.source.expressionType
		
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
		val targetType = task.referencedViewField.expressionType
		val sourceType = task.source.expressionType
		val isValidEnum = task.source.isValidEnumType(task.referencedViewField)
		
		if (!targetType.equals(sourceType) && !targetType.equals("string") && !isValidEnum) {
			val error = '''Cannot set value of type '«sourceType»' to a view element that handles values of type '«targetType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.viewElementSetTask_Source, -1, null);
		} else if (!targetType.equals(sourceType) && targetType.equals("string") && !isValidEnum) {
			val warning = '''You are assigning a value of type '«sourceType»' to view element of type string. The string representation of '«sourceType»' will be assigned instead.'''
			acceptWarning(warning, task, MD2Package.eINSTANCE.viewElementSetTask_Source, -1, null);
		}
	}
	
	/**
	 * Ensures that the left-hand side and the right-hand side of a comparison expression have the same data type.
	 */
	@Check
	def checkBothExpressionsInComparisonOfSameType(CompareExpression expr) {
		val left = expr.eqLeft.expressionType
		val right = expr.eqRight.expressionType
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
		val left = expr.eqLeft.expressionType
		val isNumericOperator = switch expr.op {
			case Operator::GREATER: true
			case Operator::GREATER_OR_EQUAL: true
			case Operator::SMALLER: true
			case Operator::SMALLER_OR_EQUAL: true
			default: false
		}
		val numericTypes = newHashSet("integer", "float", "date", "time", "datetime")
		
		if (isNumericOperator && !numericTypes.contains(left)) {
			val error = '''Cannot use operator '«expr.op.toString»' on a value of type '«left»'.'''
			acceptError(error, expr, MD2Package.eINSTANCE.compareExpression_Op, -1, null);
		}
	}
	
	/**
	 * Ensures that the left-hand side (attribute value) and the right-hand side of a where filter comparison expression
	 * have the same data type.
	 */
	@Check
	def checkBothExpressionsInWhereClauseComparisonOfSameType(WhereClauseCompareExpression expr) {
		val attrType = expr.eqLeft.tail.resolveAttributeType.attributeTypeName
		val valueType = expr.eqRight.expressionType
		
		if (!attrType.equals(valueType)) {
			val error = '''Cannot compare a value of type '«valueType»' with an attribute that has a value of type '«attrType»'.'''
			acceptError(error, expr, MD2Package.eINSTANCE.whereClauseCompareExpression_EqRight, -1, null);
		}
	}
	
	/**
	 * Ensures that <=, >=, < and > can only be applied to values with numerical values.
	 */
	@Check
	def checkCorrectUsageOfOperatorsInWhereClauseComparison(WhereClauseCompareExpression expr) {
		val left = expr.eqLeft.tail.resolveAttributeType.attributeTypeName
		val isNumericOperator = switch expr.op {
			case Operator::GREATER: true
			case Operator::GREATER_OR_EQUAL: true
			case Operator::SMALLER: true
			case Operator::SMALLER_OR_EQUAL: true
			default: false
		}
		val numericTypes = newHashSet("integer", "float", "date", "time", "datetime")
		
		if (isNumericOperator && !numericTypes.contains(left)) {
			val error = '''Cannot use operator '«expr.op.toString»' on a value of type '«left»'.'''
			acceptError(error, expr, MD2Package.eINSTANCE.whereClauseCompareExpression_Op, -1, null);
		}
	}
	
	
	/////////////////////////////////////////////////////////
	/// ProcessChain Validators
	/////////////////////////////////////////////////////////
	
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
        if(processChain.processChainSteps.empty) {
            acceptWarning("No processChain steps are defined for this processChain. A processChain should have at least one step showing a view.",
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
     def checkContentProvidersOfNestedEntities (ContentProvider cprov){
        // List of ContentProviders
        val cpList = (cprov.eContainer() as Controller).controllerElements.filter(typeof (ContentProvider))
        
        // Attributes of the contentProviderEntity
        if(!(cprov.type instanceof ReferencedModelType) || !((cprov.type as ReferencedModelType).entity instanceof Entity)) return
        val refModelType = cprov.type as ReferencedModelType
        val cpEntity = refModelType.entity as Entity
        val cpEntityAttributes = cpEntity.attributes
        
        // Find referenced attributes within the entity
        val referencedAttributes = cpEntityAttributes.filter[it.type instanceof ReferencedType].filter[(it.type as ReferencedType).element instanceof Entity].toList
        
        // Check if ContentProviders exist for the nested Entities
        for (refAt : referencedAttributes){
            var found = false
            val referencedEntityName = (refAt.type as ReferencedType).element.name
            for (cp : cpList){
                if (referencedEntityName == ((cp.type as ReferencedModelType).entity as Entity).name) { 
                    found = true
                }
            }
            // Show warning, in case of missing ContentProvider for a nested entity
            if (!found){
                warning("A ContentProvider for the nested entity "+ referencedEntityName + " is missing.", cprov, null, -1, NESTEDENTITYWITHOUTCONTENTPROVIDER);
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
     def checkSavingOfNestedEntities(CustomAction caction){
        val wfelements = caction.eContainer() as WorkflowElement 
        val container = wfelements.eContainer() as Controller
        val cpList = container.controllerElements.filter(typeof (ContentProvider)).toList
        
        // HashMap of Entities with their nested Entities
        var hm = <String, HashMap<String, String>>newHashMap
        
        // Search for Entities with nested Entities and put them into hm
        for (cp : cpList) {
        	if((cp.type as ReferencedModelType).entity instanceof Entity) {
	            val entity = (cp.type as ReferencedModelType).entity as Entity
	            val refEntities = entity.attributes.filter[it.type instanceof ReferencedType].filter[(it.type as ReferencedType).element instanceof Entity].toList
	            for (rE : refEntities){
	                var temphashmap = hm.get(entity.name)
	                if (temphashmap == null){
	                    temphashmap = <String, String>newHashMap
	                    hm.put(entity.name, temphashmap)
	                }
	                temphashmap.put(rE.name, (rE.type as ReferencedType).element.name)              
	            }
        	} // else skip enums
        }
        // Only do for CustomActions, that include a call to save a ContentProvider  
        val callTasks = caction.codeFragments.filter(CallTask)
        val savecalls = callTasks.map[it.eAllContents.filter(ContentProviderOperationAction).filter[it.operation.literal == "save"].toSet].flatten.toList

        // Check for the remaining CustomActions, if the saved entity is nested
        for (sc : savecalls){
            // Save information about savecall
            val savedEntity = (((sc.contentProvider as ContentProviderReference).contentProvider as ContentProvider).type as ReferencedModelType).entity as Entity
            val savedEntityName = savedEntity.name
            val indexOfSaveCall = caction.codeFragments.indexOf((sc.eContainer as SimpleActionRef).eContainer as CallTask)
            
            // Check, if saved-Entity includes nested entities
            if (hm.containsKey(savedEntityName)){
                var nestedEntities = hm.get(savedEntityName) 
                
                // Check, if attribute of the entity is set onto the corresponding nested contentProvider BEFORE the save operation
                for (var i=0; i<indexOfSaveCall; i++){
                    var codeFragment = caction.codeFragments.get(i)
                    
                    // Check, if the codeFragement is a set operation
                    if (codeFragment instanceof AttributeSetTask){
                        val sourceEntity = (codeFragment.pathDefinition.contentProviderRef.type as ReferencedModelType).entity.name
                        val sourceAttr =  codeFragment.pathDefinition.tail.attributeRef.name
                        val target = ((codeFragment.source as ContentProviderReference).contentProvider.type as ReferencedModelType).entity.name
                        
                        // Check, if savedEntity is saved within the set command 
                        if (savedEntityName == sourceEntity){
                            // Check, if the target of the set statement corresponds to one of the nestedEntities
                            if (target == nestedEntities.get(sourceAttr)) {
                                //if correct, delete from list of unset nested entity attributes
                                nestedEntities.remove(sourceAttr)                                   
                            }
                        }   
                    }   
                }                   
                if (!nestedEntities.empty){
                    //System.out.println("WARNING! Following nested Entities are not set: " + nestedEntities.toString) //for debugging
                    warning("Not all Attributes of nested Entities within the Provider are set to their corresponding providers before saving. Please make sure, this is wanted.", sc, null, -1, SAVINGCHECKOFNESTEDENTITY);
                }
            }
        }
    }
    
    /**
     * Ensures that, when the REST method 'GET' is chosen, no body params are set.  
     */
     
    public static final String NOBODYPARAMSWHENGET = "noBodyParamsWhenGET";
     
    @Check
    def checkNoBodyParamsWhenGETMethod(WebServiceCall wscall){
        if(wscall.method.equals(RESTMethod.GET) && wscall.bodyparams.size > 0) 
        {
            acceptError("When REST method 'GET' is chosen, no body params are allowed. Use the queryparams construct instead.", wscall, null, -1, NOBODYPARAMSWHENGET);
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
	def checkRestMethod(InvokeDefinition invokeDefinition){
	    val method = invokeDefinition?.method
	    if(method == RESTMethod.GET || method == RESTMethod.DELETE){
	        acceptError("The method type " + method.toString + " is not supported. Please use POST or PUT.", invokeDefinition, MD2Package.eINSTANCE.invokeDefinition_Method, -1, UNSUPPORTEDRESTMETHOD);
	    }
	}
	
	
	/**
	 * These maps enable for a comparison between the two class types and to ensure, that no unsupported value is set.
	 */
	static final Map<Class<? extends InvokeValue>, String> invokeValueTypeMap= getInvokeValueTypeHashMap()

	static final Map<Class<? extends AttributeType>, String> supportedAttributeTypeMap= getSupportedAttributeTypeHashMap()

	private static def getInvokeValueTypeHashMap(){
		val map = new HashMap<Class<? extends InvokeValue>,String>()
		map.put(InvokeIntValueImpl,"integer")
		map.put(InvokeFloatValueImpl, "float")
		map.put(InvokeStringValueImpl, "string")
		map.put(InvokeBooleanValueImpl, "boolean")
		map.put(InvokeDateValueImpl, "date")
		map.put(InvokeTimeValueImpl, "time")
		map.put(InvokeDateTimeValueImpl, "datetime")
		return map
	}
	
	private static def getSupportedAttributeTypeHashMap(){
		val map = new HashMap<Class<? extends AttributeType>,String>()
		map.put(IntegerTypeImpl, "integer")
		map.put(FloatTypeImpl, "float")
		map.put(StringTypeImpl, "string")
		map.put(BooleanTypeImpl, "boolean")
		map.put(DateTypeImpl, "date")
		map.put(TimeTypeImpl, "time")
		map.put(DateTimeTypeImpl, "datetime")
		map.put(EnumTypeImpl, "string")
		return map
	}

	/**
     * Ensure, that InvokeDefaultValue has same type
     * @param invokeDefaultValue
     */
    @Check
    def checkForTypeOfInvokeDefaultValue(InvokeDefaultValue defaultValue) {
		var valueType = invokeValueTypeMap.get(defaultValue.invokeValue.class)
		val attributeType = defaultValue.field.tail.resolveAttributeType
		var cpType = supportedAttributeTypeMap.get(attributeType.class)
		if (cpType ==null && attributeType instanceof ReferencedType){
			var referencedType = (attributeType as ReferencedType).getElement()
			if (referencedType instanceof Enum){
				cpType = supportedAttributeTypeMap.get(EnumTypeImpl)
			}
		}
		if (valueType != null && cpType!= null && !valueType.equals(cpType)){
			val error = '''The types of the content provider and its default value have to match each other! Expected default value to be of type «cpType» but was «valueType»!'''
			acceptError(error, defaultValue, MD2Package.eINSTANCE.invokeDefaultValue_InvokeValue, -1, INVOKEDEFAULTVALUETYPEMISSMATCH)
		}
		if (cpType == null){
			val error = '''The type «defaultValue.field.tail.resolveAttributeType.attributeTypeName» of the content provider reference is not supported to be set to a default value!'''
			acceptError(error, defaultValue, MD2Package.eINSTANCE.invokeParam_Field, -1, INVOKEDEFAULTVALUETYPENOTSUPPORTED)
		}	
    }
    
    /**
     * Ensure, that invoke paths are unique
     * @param workflowElement
     */
    @Check
    def checkForInvokePathsBeingUnique(WorkflowElement wfe) {
    	if (wfe.invoke.size>1){
			val paths = wfe.invoke.map[it.path?:""]
			val allpaths = new HashSet<String>()
			val conflictedPaths = new HashSet<String>()
			// Look for all paths, that are at least twice in the list
			paths.forEach[
				if (allpaths.contains(it)){
					conflictedPaths.add(it)
				}else{
					allpaths.add(it)
				}
			]
			for (InvokeDefinition invoke: wfe.invoke){
				if (conflictedPaths.contains(invoke.path?:"")){
					var error = '''The paths of invoke definitions need to be unique!'''
					var EStructuralFeature structuralFeature = null
					if (invoke.path != null){
						structuralFeature =  MD2Package.eINSTANCE.invokeDefinition_Path
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
    	//Get all entities, which are somehow present in a invokeParam of the definition
    	val allEntities = new HashSet<Entity>()
		for (InvokeParam param:invokeDefinition.params){
			var entity=(( param.field.contentProviderRef.type as ReferencedModelType).entity) as Entity
			allEntities.add(entity)
		}
		val allAttributes = allEntities.map[it.attributes].flatten
		// Set that contains all required attributes including nested
		var processedRequiredAttributes = new HashSet<Attribute>()
		// Serves as temporary set for required attributes (is needed for the extraction of nested required attributes)
		var requiredAttributes = allAttributes.toSet.getRequiredAttributes
		processedRequiredAttributes.addAll(requiredAttributes)
		// For requrired attributes of type ReferenceTypes look deeper if there are nested required attributes (recursive)
		var requiredReferenceTypes = requiredAttributes.filter[it.type instanceof ReferencedType]
		while (requiredReferenceTypes.size>0){
			requiredAttributes = requiredReferenceTypes.map[(it.type as ReferencedType).element].filter(Entity).map[it.attributes].flatten.getRequiredAttributes
			processedRequiredAttributes.addAll(requiredAttributes)
			requiredReferenceTypes = requiredAttributes.filter[it.type instanceof ReferencedType]
			processedRequiredAttributes.addAll(requiredAttributes)
		}
		
		// Retrieve all real covered attributes either set by a InvokeDefaultValue, InvokeSetContentProvider, or InvokeWSParam operation
		var allCoveredAttributes = invokeDefinition.params.map[it.field.tail.resolveAttribute]
		processedRequiredAttributes.removeAll(allCoveredAttributes)
		processedRequiredAttributes.forEach[
			var error = '''The required attribute «it.name» of the entity «(it.eContainer as Entity).name» is not set. Either set «it.name» to an default value, offer it to be set via the rest service, set «it.name» to be optional, or remove any other related attribute from the invoke definition.'''
			error(error , invokeDefinition, null, -1, INVOKEMISSINGREQUIREDATTRIBUTE)
		]
    }
    
     /**
     * Ensure, that enum string is valid
     * @param workflowElement
     */
    @Check
	def checkForValidEnumString(InvokeDefaultValue defaultValue) {
		var attributeType = defaultValue.field.tail.resolveAttributeType
		var EnumBody enumBody = null
		var String enumName = null
		switch (attributeType) {
			ReferencedType: {
				var element = (attributeType as ReferencedType).getElement()
				if (element instanceof Enum) {
					enumBody = (element as Enum).enumBody
					enumName = (element as Enum).name
				}
			}
			EnumType: {
				var error = '''An internal enum is not supported to be set as default value. Please create a enum object for it.'''
				error(error, defaultValue, MD2Package.eINSTANCE.invokeDefaultValue_InvokeValue, -1)
			}
		}
		if (enumBody != null) {
			if (defaultValue.invokeValue instanceof InvokeStringValue) {

				var value = (defaultValue.invokeValue as InvokeStringValue).value
				if (!enumBody.elements.contains(value)) {
					var error = '''The enum value does not equal any entry of the enum «enumName»'''
					error(error, defaultValue, MD2Package.eINSTANCE.invokeDefaultValue_InvokeValue, -1, ENUMENTRYNOTKNOWN)
				}
			}
		}
	}
	
	/**
	 * Retrieve all required attributes of a list of attributes
	 */
    private def Set<Attribute> getRequiredAttributes(Iterable<Attribute> attributes){
    	attributes.filter[
			var type = it.type
			var params = switch (type){
				ReferencedType: type.params
				IntegerType: type.params
				FloatType: type.params
				StringType: type.params
				BooleanType: type.params
				DateType: type.params
				TimeType: type.params
				DateTimeType: type.params
				EnumType: type.params
				FileType: type.params
				default: throw new RuntimeException("The attribute type is not registered in this method.")
			}
			params.filter(AttrIsOptional).size==0		
		].toSet
    }
}
