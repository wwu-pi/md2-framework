package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.AllowedOperation
import de.wwu.md2.framework.mD2.AssignObjectAtContentProviderAction
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.CheckBox
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.DataAction
import de.wwu.md2.framework.mD2.DataType
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.GPSActionEntityBindingEntry
import de.wwu.md2.framework.mD2.GPSField
import de.wwu.md2.framework.mD2.GPSUpdateAction
import de.wwu.md2.framework.mD2.GotoNextWorkflowStepAction
import de.wwu.md2.framework.mD2.GotoPreviousWorkflowStepAction
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.GotoWorkflowStepAction
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.MappingTask
import de.wwu.md2.framework.mD2.NewObjectAtContentProviderAction
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.SetActiveWorkflowAction
import de.wwu.md2.framework.mD2.SimpleAction
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.SimpleDataType
import de.wwu.md2.framework.mD2.SimpleType
import de.wwu.md2.framework.mD2.StandardIsDateValidator
import de.wwu.md2.framework.mD2.StandardIsIntValidator
import de.wwu.md2.framework.mD2.StandardIsNumberValidator
import de.wwu.md2.framework.mD2.StandardNotNullValidator
import de.wwu.md2.framework.mD2.StandardNumberRangeValidator
import de.wwu.md2.framework.mD2.StandardRegExValidator
import de.wwu.md2.framework.mD2.StandardStringRangeValidator
import de.wwu.md2.framework.mD2.StandardValidatorType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.UnmappingTask
import de.wwu.md2.framework.mD2.ValidatorBindingTask
import de.wwu.md2.framework.mD2.ValidatorFormatParam
import de.wwu.md2.framework.mD2.ValidatorMaxLengthParam
import de.wwu.md2.framework.mD2.ValidatorMaxParam
import de.wwu.md2.framework.mD2.ValidatorMessageParam
import de.wwu.md2.framework.mD2.ValidatorMinLengthParam
import de.wwu.md2.framework.mD2.ValidatorMinParam
import de.wwu.md2.framework.mD2.ValidatorRegExParam
import de.wwu.md2.framework.mD2.ValidatorUnbindTask
import de.wwu.md2.framework.mD2.ViewGUIElement
import java.util.List
import java.util.Set

import static de.wwu.md2.framework.generator.android.util.MD2AndroidUtil.*
import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class CustomActionTemplate {
	
	private String basePackage
	private DataContainer dataContainer
	private CustomAction action
	private Set<ContainerElement> topLevelViewContainers
	private Set<ContainerElement> activities
	private Set<ContainerElement> fragments
	
	new (String basePackage, CustomAction action, DataContainer dataContainer, Set<ContainerElement> topLevelViewContainers, Set<ContainerElement> activities, Set<ContainerElement> fragments){
		this.basePackage = basePackage
		this.action = action
		this.dataContainer = dataContainer
		this.topLevelViewContainers = topLevelViewContainers
		this.activities = activities
		this.fragments = fragments
	}
	
	def generateCustomAction() '''
		package «basePackage».actions;
		
		import android.content.Intent;
		import android.location.Address;
		import android.location.Location;
		import android.widget.CheckBox;
		import android.widget.Spinner;
		import android.widget.TextView;
		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.controller.actions.*;
		import de.wwu.md2.android.lib.controller.binding.CheckBoxMapping;
		import de.wwu.md2.android.lib.controller.binding.DateTimeTextViewMapping;
		import de.wwu.md2.android.lib.controller.binding.EnumPathResolver;
		import de.wwu.md2.android.lib.controller.binding.FloatTextViewMapping;
		import de.wwu.md2.android.lib.controller.binding.IntegerTextViewMapping;
		import de.wwu.md2.android.lib.controller.binding.PathResolver;
		import de.wwu.md2.android.lib.controller.binding.SpinnerMapping;
		import de.wwu.md2.android.lib.controller.binding.StringTextViewMapping;
		import de.wwu.md2.android.lib.controller.contentprovider.GPSAddressProvider;
		import de.wwu.md2.android.lib.controller.contentprovider.GPSAddressProvider.GPSAddressReceiver;
		import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
		import de.wwu.md2.android.lib.controller.validators.NotNullValidator;
		import de.wwu.md2.android.lib.controller.validators.NumberRangeValidator;
		import de.wwu.md2.android.lib.controller.validators.StringRangeValidator;
		import de.wwu.md2.android.lib.controller.validators.RegExValidator;
		import de.wwu.md2.android.lib.controller.validators.IsDateValidator;
		import de.wwu.md2.android.lib.controller.validators.IsNumberValidator;
		import de.wwu.md2.android.lib.controller.validators.IsIntValidator;
		import de.wwu.md2.android.lib.model.MD2Enum;
		import de.wwu.md2.android.lib.view.TabbedActivity;
		«IF !dataContainer.contentProviders.empty»
			import «basePackage».contentprovider.*;
		«ENDIF»
		import «basePackage».R;
		
		@SuppressWarnings("all")
		public class «getName(action).toFirstUpper» extends CustomAction {
			
			public «getName(action).toFirstUpper»(MD2Application application) {
				super(application);
			}
		
			@Override
			protected void initializeCodeFragments() {
				
				«action.codeFragments.map[codeFragment | generateCodeFragment(codeFragment)].filter[it!=null && it.length > 0].join('\n')»
				
			}
		}
	'''
	
	def private dispatch generateCodeFragment(MappingTask task) {
		val topLevelView = getViewOfGUIElement(topLevelViewContainers, resolveViewGUIElement(task.referencedViewField))
		val activityName = if(topLevelView == null) null else getName(topLevelView).toFirstUpper
		/*
		 * Check if this code fragment is related to a view element contained in an activity or fragment that has not been generated (empty name),
		 * because it will never be used (usually view containers that are defined on the top level and are referenced inside other view containers)
		 */
		if(activityName != null && activityName.length != 0) '''
			addCodeFragment(new CodeFragment() {
				@Override
				public String getActivityName() {
					return "«activityName»";
				}
				
				@Override
				public void execute(MD2Application app) {
					«val widget = resolveViewGUIElement(task.referencedViewField)»
					«val attributePath = getPathTailAsList(task.pathDefinition.tail)»
					«val entityClass = getTypeName(task.pathDefinition.contentProviderRef.type)»
					«switch widget {
						TextInput: textViewMapTask(task.pathDefinition.contentProviderRef, entityClass, widget, attributePath)
						OptionInput: spinnerMapTask(task.pathDefinition.contentProviderRef, entityClass, widget, attributePath)
						CheckBox: checkBoxMapTask(task.pathDefinition.contentProviderRef, entityClass, widget, attributePath)
						default: "// TODO Mapper for " + widget.eClass.name
					}»
				}
			});
		'''
	}
	
	def private dispatch generateCodeFragment(UnmappingTask task) '''
		// TODO UnmappingTask
	'''
	
	def private dispatch generateCodeFragment(CallTask task) '''
		addCodeFragment(new CodeFragment() {
			@Override
			public String getActivityName() {
				return null;
			}
			
			@Override
			public void execute(MD2Application app) {
				«val action = task.action»
				«switch action {
					ActionReference: '''app.executeAction(«basePackage».actions.«getName(action.actionRef).toFirstUpper».class);'''
					SimpleActionRef: getSimpleActionCode(action.action)
				}»
			}
		});
	'''
	
	def private dispatch generateCodeFragment(EventBindingTask task) '''
		«FOR event : task.events»
			«val eventName = getEventName(event)»
			addCodeFragment(new CodeFragment() {
				@Override
				public String getActivityName() {
					return null;
				}
				
				@Override
				public void execute(final MD2Application app) {
					«FOR action : task.actions»
						«var actionName = ""»
						«var actionInitialization = ''''''»
						«switch action {
							ActionReference: {
								actionName = getName(action.actionRef).toFirstUpper
								actionInitialization = '''app.findActionByType(«actionName».class)'''
								null
							}
							SimpleActionRef: {
								actionName = action.action.eClass.name + getUniqueSimpleActionIdentifier(action.action)
								actionInitialization = getSimpleActionAsEventHandler(action.action).toString
								null
							}
						}»
						app.getEventBus().subscribe("«eventName»", "«eventName»_«actionName»", «actionInitialization»);
					«ENDFOR»
				}
			});
		«ENDFOR»
	'''
	
	def private dispatch generateCodeFragment(EventUnbindTask task) '''
		«FOR event : task.events»
			«val eventName = getEventName(event)»
			addCodeFragment(new CodeFragment() {
				@Override
				public String getActivityName() {
					return null;
				}
				
				@Override
				public void execute(MD2Application app) {
					«FOR action : task.actions»
						«val actionName = switch action {
							ActionReference: getName(action.actionRef).toFirstUpper
							SimpleActionRef: action.action.eClass.name + getUniqueSimpleActionIdentifier(action.action)
						}»
						app.getEventBus().unsubscribe("«eventName»", "«eventName»_«actionName»");
					«ENDFOR»
				}
			});
		«ENDFOR»
	'''
	
	def private dispatch generateCodeFragment(ValidatorBindingTask task) {
		task.referencedFields.map[abstractView | generateValidatorBindingFragment(task, abstractView)].filter[it!=null].join('\n')
	}
	
	def private generateValidatorBindingFragment(ValidatorBindingTask task, AbstractViewGUIElementRef abstractView) {
		val topLevelView = getViewOfGUIElement(topLevelViewContainers, resolveViewGUIElement(abstractView))
		val activityName = if(topLevelView == null) null else getName(topLevelView).toFirstUpper
		/*
		 * Check if this code fragment is related to a view element contained in an activity or fragment that has not been generated (empty name),
		 * because it will never be used (usually view containers that are defined on the top level and are referenced inside other view containers)
		 */
		if(activityName != null && activityName.length != 0) '''
			addCodeFragment(new CodeFragment() {
				@Override
				public String getActivityName() {
					return "«activityName»";
				}
				
				@Override
				public void execute(MD2Application app) {
					«val viewElem = resolveViewGUIElement(abstractView)»
					«FOR validatorType : task.validators»
						«IF validatorType instanceof StandardValidatorType»
							«val validator = (validatorType as StandardValidatorType).validator»
							«generateStandardValidator(validator, viewElem)»
						«ELSE»
							// TODO Generate custom validators
						«ENDIF»
					«ENDFOR»
				}
			});
		'''
	}
	
	def private dispatch generateCodeFragment(ValidatorUnbindTask task) '''
		// TODO ValidatorUnbindTask
	'''
	
	def private textViewMapTask(ContentProvider contentProviderRef, String entityClass, TextInput view, List<Attribute> attributePath) '''
		«val setPath = attributePath.join(".", [if(it.equals(attributePath.last)) '''set«it.name.toFirstUpper»''' else '''get«it.name.toFirstUpper»()''' ])»
		«val getPath = attributePath.join(".", [if(it.equals(attributePath.last)) '''get«it.name.toFirstUpper»''' else '''get«it.name.toFirstUpper»()''' ])»
		«val valueType = attributeTypeName(attributePath.last)»
		«val mappingType = getTextViewMappingType(attributePath.last)»
		«IF mappingType != null && mappingType.length > 0»
			app.getMappings().add(
				new «mappingType»<«entityClass»>(
					(TextView) app.getActiveActivity().findViewById(R.id.«getName(view)»),
					app.findContentProviderByType(«contentProviderRef.name.toFirstUpper».class),
					new PathResolver<«entityClass», «valueType»>() {
						public «valueType» retrieveValue(«entityClass» entity) {
							return entity.«getPath»();
						}
						
						public void adaptValue(«entityClass» entity, «valueType» value) {
							entity.«setPath»(value);
						}
					},
					app.getEventBus(),
					"«getName(view)»",
					getActivityName()
				)
			);
		«ELSE»
			// TODO Generate TextViewMapping for type: «valueType»
		«ENDIF»
	'''
	
	def private spinnerMapTask(ContentProvider contentProviderRef, String entityClass, OptionInput view, List<Attribute> attributePath) '''
		«val enumPath = attributePath.join(".", ['''get«it.name.toFirstUpper»()'''])»
		app.getMappings().add(
			new SpinnerMapping<«entityClass»>(
				(Spinner) app.getActiveActivity().findViewById(R.id.«getName(view)»),
				app.findContentProviderByType(«contentProviderRef.name.toFirstUpper».class),
				new EnumPathResolver<«entityClass»>() {
					public MD2Enum getEnum(«entityClass» entity) {
						return entity.«enumPath»;
					}
				},
				app.getEventBus(),
				"«getName(view)»",
				getActivityName()
			)
		);
	'''
	
	def private checkBoxMapTask(ContentProvider contentProviderRef, String entityClass, CheckBox view, List<Attribute> attributePath) '''
		«val setPath = attributePath.join(".", [if(it.equals(attributePath.last)) '''set«it.name.toFirstUpper»''' else '''get«it.name.toFirstUpper»()''' ])»
		«val getPath = attributePath.join(".", [if(it.equals(attributePath.last)) '''get«it.name.toFirstUpper»''' else '''get«it.name.toFirstUpper»()''' ])»
		«val valueType = attributeTypeName(attributePath.last)»
		app.getMappings().add(
			new CheckBoxMapping<«entityClass»>(
				(CheckBox) app.getActiveActivity().findViewById(R.id.«getName(view)»),
				app.findContentProviderByType(«contentProviderRef.name.toFirstUpper».class),
				new PathResolver<«entityClass», «valueType»>() {
					public «valueType» retrieveValue(«entityClass» entity) {
						return entity.«getPath»();
					}
					
					public void adaptValue(«entityClass» entity, «valueType» value) {
						entity.«setPath»(value);
					}
				},
				app.getEventBus(),
				"«getName(view)»",
				getActivityName()
			)
		);
	'''
	
	def private getTextViewMappingType(Attribute attribute) {
		switch attribute.type {
			IntegerType : "IntegerTextViewMapping"
			FloatType : "FloatTextViewMapping"
			StringType : "StringTextViewMapping"
			DateType : "DateTimeTextViewMapping"
			TimeType : "DateTimeTextViewMapping"
			DateTimeType : "DateTimeTextViewMapping"
			default: null
		}
	}
	
	def private getSimpleActionCode(SimpleAction simpleAction) {
		switch (simpleAction) {
			GotoNextWorkflowStepAction: '''
				app.getWorkflowManager().goToNextStep();
			'''
			GotoPreviousWorkflowStepAction: '''
				app.getWorkflowManager().goToPreviousStep();
			'''
			GotoWorkflowStepAction: '''
				app.getWorkflowManager().goToStep("«simpleAction.pcStep.name.toFirstUpper»", «IF simpleAction.silentFails»true«ELSE»false«ENDIF»);
			'''
			GotoViewAction: getGoToViewCode(resolveViewGUIElement(simpleAction.view), "app", basePackage, dataContainer, activities, fragments)
			DataAction: '''
				app.findContentProviderByType(«simpleAction.contentProvider.name.toFirstUpper».class).«switch (simpleAction.operation) {
						case AllowedOperation::CREATE_OR_UPDATE: "saveEntity()"
						case AllowedOperation::READ: "loadEntity()"
						case AllowedOperation::DELETE: "deleteEntity()"
				}»;
			'''
			NewObjectAtContentProviderAction: '''app.findContentProviderByType(«simpleAction.contentProvider.name.toFirstUpper».class).resetEntity();'''
			AssignObjectAtContentProviderAction: '''
				«FOR binding : simpleAction.bindings»
					«val attributePath =  getPathTailAsList(binding.path.tail)»
					«val setPath = attributePath.join(".", [if(it.equals(attributePath.last)) '''set«it.name.toFirstUpper»''' else '''get«it.name.toFirstUpper»()''' ])»
					app.findContentProviderByType(«binding.path.contentProviderRef.name.toFirstUpper».class).getEntity().«setPath»(app.findContentProviderByType(«binding.contentProvider.name.toFirstUpper».class).getEntity());
				«ENDFOR»
			'''
			GPSUpdateAction: getGPSUpdateCode(simpleAction)
			SetActiveWorkflowAction: '''
				app.getWorkflowManager().setActiveWorkflow("«simpleAction.workflow.name.toFirstUpper»");
			'''
		}
	}
	
	def private getGPSUpdateCode(GPSUpdateAction action) '''
		GPSAddressReceiver receiver = new GPSAddressReceiver() {
			@Override
			public void receiveGPSAddress(MD2Application app, Address address, Location location) {
				StringBuilder sb;
				«FOR binding : action.bindings»
					// Build value to set
					sb = new StringBuilder();
					«FOR entry : binding.entries»
						«resolveGPSActionEntityBindingEntry(entry)»
					«ENDFOR»
					
					// Set value
					«val attributePath =  getPathTailAsList(binding.path.tail)»
					«val setPath = attributePath.join(".", [if(it.equals(attributePath.last)) '''set«it.name.toFirstUpper»''' else '''get«it.name.toFirstUpper»()''' ])»
					app.findContentProviderByType(«binding.path.contentProviderRef.name.toFirstUpper».class).getEntity().«setPath»(«getStringConversion(attributePath.last, "sb.toString()")»);
					app.findContentProviderByType(«binding.path.contentProviderRef.name.toFirstUpper».class).throwRefreshEvent();
				«ENDFOR»
			}
		};
		GPSAddressProvider gpsAddressProvider = new GPSAddressProvider(app, receiver);
		gpsAddressProvider.provideGPSAddress();
	'''
	
	def private resolveGPSActionEntityBindingEntry(GPSActionEntityBindingEntry entry) {
		if(entry.string != null) {
			'''sb.append("«entry.string»");'''
		}
		else {
			val field = switch entry.gpsField {
				case GPSField::LATITUDE: "address.getLatitude()"
				case GPSField::LONGITUDE: "address.getLongitude()"
				case GPSField::ALTITUDE: "location.getAltitude()"
				case GPSField::CITY: "address.getLocality()"
				case GPSField::STREET: "address.getThoroughfare()"
				case GPSField::NUMBER: "address.getSubThoroughfare()"
				case GPSField::POSTAL_CODE: "address.getPostalCode()"
				case GPSField::COUNTRY: "address.getCountryName()"
				case GPSField::PROVINCE: "address.getAdminArea()"
			}
			'''
				«IF entry.gpsField != GPSField::LATITUDE && entry.gpsField != GPSField::LONGITUDE && entry.gpsField != GPSField::ALTITUDE»
					if(«field» != null) {
						sb.append(«field»);
					}
				«ELSE»
					sb.append(«field»);
				«ENDIF»
			'''
		}
	}
	
	def getStringConversion(Attribute attribute, String string) {
		switch (attribute.type) {
			StringType: string
			IntegerType: '''Integer.parseInt(«string»)'''
			FloatType: '''Float.parseFloat(«string»)'''
		}
	}
	
	def private getUniqueSimpleActionIdentifier(SimpleAction simpleAction) {
		switch (simpleAction) {
			GotoNextWorkflowStepAction: ""
			GotoPreviousWorkflowStepAction: ""
			GotoWorkflowStepAction: "_" + simpleAction.pcStep.name.toFirstUpper
			GotoViewAction: "_" + getName(resolveViewGUIElement(simpleAction.view))
			DataAction: "_" + simpleAction.contentProvider.name.toFirstUpper + "_" + 
				switch (simpleAction.operation) {
						case AllowedOperation::CREATE_OR_UPDATE: "CreateOrUpdate;"
						case AllowedOperation::READ: "Read;"
						case AllowedOperation::DELETE: "Delete"
				}
			NewObjectAtContentProviderAction: "_" + simpleAction.contentProvider.name.toFirstUpper
			GPSUpdateAction: '''«FOR binding : simpleAction.bindings»«getReferencedAttribute(binding.path).name»«ENDFOR»'''
			SetActiveWorkflowAction: "_" + simpleAction.workflow.name.toFirstUpper
			AssignObjectAtContentProviderAction: "_" + simpleAction.bindings.join("_", [it.contentProvider.name + "." + getPathTailAsString(it.path.tail)])
		}
	}
	
	def private CharSequence getSimpleActionAsEventHandler(SimpleAction simpleAction) '''
		new MD2EventHandler() {
			@Override
			public void eventOccured() {
				«getSimpleActionCode(simpleAction)»
			}
		}
	'''
	
	def private dispatch generateStandardValidator(StandardIsIntValidator validator, ViewGUIElement viewElem) '''
		«IF viewElem instanceof TextInput»
			new IsIntValidator("«validator.params.filter(typeof(ValidatorMessageParam)).last?.message»", (TextView)app.getActiveActivity().findViewById(R.id.«getName(viewElem)»), app, "«getName(viewElem)»");
		«ELSE»
			// TODO Handle IsIntValidators for type «viewElem.eClass.name» (ignore them?)
		«ENDIF»
	'''
	
	def private dispatch generateStandardValidator(StandardNotNullValidator validator, ViewGUIElement viewElem) '''
		«IF viewElem instanceof TextInput»
			new NotNullValidator("«validator.params.filter(typeof(ValidatorMessageParam)).last?.message»", (TextView)app.getActiveActivity().findViewById(R.id.«getName(viewElem)»), app, "«getName(viewElem)»");
		«ELSE»
			// TODO Handle NotNullValidators for type «viewElem.eClass.name» (ignore them?)
		«ENDIF»
	'''
	
	def private dispatch generateStandardValidator(StandardIsNumberValidator validator, ViewGUIElement viewElem) '''
		«IF viewElem instanceof TextInput»
			new IsNumberValidator("«validator.params.filter(typeof(ValidatorMessageParam)).last?.message»", (TextView)app.getActiveActivity().findViewById(R.id.«getName(viewElem)»), app, "«getName(viewElem)»");
		«ELSE»
			// TODO Handle IsNumberValidators for type «viewElem.eClass.name» (ignore them?)
		«ENDIF»
	'''
	
	def private dispatch generateStandardValidator(StandardIsDateValidator validator, ViewGUIElement viewElem) '''

		«IF viewElem instanceof TextInput»
			«val format = validator.params.filter(typeof(ValidatorFormatParam)).last»
			«val formatStr = if(format == null) "null" else '''"«format.format»"'''»
			new IsDateValidator("«validator.params.filter(typeof(ValidatorMessageParam)).last?.message»", (TextView)app.getActiveActivity().findViewById(R.id.«getName(viewElem)»), app, "«getName(viewElem)»", «formatStr»);
		«ELSE»
			// TODO Handle IsDateValidators for type «viewElem.eClass.name» (ignore them?)
		«ENDIF»
	'''
	
	def private dispatch generateStandardValidator(StandardRegExValidator validator, ViewGUIElement viewElem) '''
		«IF viewElem instanceof TextInput»
			«val regEx = validator.params.filter(typeof(ValidatorRegExParam)).last»
			«val regExStr = if(regEx == null) "null" else '''"«regEx.regEx.replaceAll("\\\\","\\\\\\\\").replaceAll("\"","\\\\\"")»"'''»
			new RegExValidator("«validator.params.filter(typeof(ValidatorMessageParam)).last?.message»", (TextView)app.getActiveActivity().findViewById(R.id.«getName(viewElem)»), app, "«getName(viewElem)»", «regExStr»);
		«ELSE»
			// TODO Handle RegExValidators for type «viewElem.eClass.name» (ignore them?)
		«ENDIF»

	'''

	def private dispatch generateStandardValidator(StandardNumberRangeValidator validator, ViewGUIElement viewElem) '''
		«IF viewElem instanceof TextInput»
			«val max = validator.params.filter(typeof(ValidatorMaxParam)).last»
			«val min = validator.params.filter(typeof(ValidatorMinParam)).last»
			«val maxStr = if(max == null) "Double.MAX_VALUE" else max.max»
			«val minStr = if(min == null) "Double.MIN_VALUE" else min.min»
			new NumberRangeValidator("«validator.params.filter(typeof(ValidatorMessageParam)).last?.message»", (TextView)app.getActiveActivity().findViewById(R.id.«getName(viewElem)»), app, "«getName(viewElem)»", «minStr», «maxStr»);
		«ELSE»
			// TODO Handle NumberRangeValidator for type «viewElem.eClass.name» (ignore them?)
		«ENDIF»
	'''
	
	def private dispatch generateStandardValidator(StandardStringRangeValidator validator, ViewGUIElement viewElem) '''
		«IF viewElem instanceof TextInput»
			«val maxLength = validator.params.filter(typeof(ValidatorMaxLengthParam)).last»
			«val minLength = validator.params.filter(typeof(ValidatorMinLengthParam)).last»
			«val maxLengthStr = if(maxLength == null) "null" else maxLength.maxLength»
			«val minLengthStr = if(minLength == null) "null" else minLength.minLength»
			new StringRangeValidator("«validator.params.filter(typeof(ValidatorMessageParam)).last?.message»", (TextView)app.getActiveActivity().findViewById(R.id.«getName(viewElem)»), app, "«getName(viewElem)»", «minLengthStr», «maxLengthStr»);
		«ELSE»
			// TODO Handle StringRangeValidators for type «viewElem.eClass.name» (ignore them?)
		«ENDIF»
	'''
	
	def private String getTypeName(DataType dataType) {
		switch dataType {
			SimpleType: switch (dataType as SimpleType).type {
				case SimpleDataType::BOOLEAN: "Boolean"
				case SimpleDataType::DATE: "java.util.Date"
				case SimpleDataType::DATE_TIME: "java.util.Date"
				case SimpleDataType::TIME: "java.util.Date"
				case SimpleDataType::FLOAT: "Float"
				case SimpleDataType::INTEGER: "Integer"
				case SimpleDataType::STRING: "String"
			}
			ReferencedModelType: basePackage + ".models." + getName((dataType as ReferencedModelType).entity).toFirstUpper
		}
	}
}