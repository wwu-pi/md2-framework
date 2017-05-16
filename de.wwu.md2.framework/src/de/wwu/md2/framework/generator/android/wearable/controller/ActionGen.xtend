package de.wwu.md2.framework.generator.android.wearable.controller

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.AbstractProviderReference
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.Action
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.And
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.ConditionalCodeFragment
import de.wwu.md2.framework.mD2.ConditionalExpression
import de.wwu.md2.framework.mD2.ContentProviderAddAction
import de.wwu.md2.framework.mD2.ContentProviderGetAction
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.ContentProviderRemoveAction
import de.wwu.md2.framework.mD2.ContentProviderResetAction
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.DisableAction
import de.wwu.md2.framework.mD2.DisplayMessageAction
import de.wwu.md2.framework.mD2.EnableAction
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.FireEventAction
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.MappingTask
import de.wwu.md2.framework.mD2.Not
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.Or
import de.wwu.md2.framework.mD2.SimpleAction
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.UnmappingTask
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.ViewElementSetTask
import de.wwu.md2.framework.mD2.WorkflowElement
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import de.wwu.md2.framework.mD2.WebServiceCallAction
import de.wwu.md2.framework.mD2.LocationAction
import de.wwu.md2.framework.mD2.ValidatorBindingTask

class ActionGen {
	def static generateActions(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		App app, Iterable<WorkflowElement> workflowElements) {

		// generate actions that belong to each workflow element
		workflowElements.forEach [ wfe |
			wfe.actions.forEach [ a |
				val qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(a, "_")
				fsa.generateFile(
					rootFolder + Settings.JAVA_PATH + mainPath + "md2/controller/action/" + qualifiedName.toFirstUpper +
						"_Action.java", generateAction(mainPackage, app, wfe, a, qualifiedName))

			]
		]
	}

	protected def static generateAction(String mainPackage, App app, WorkflowElement wfe, Action action,
		String qualifiedActionName) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Actions.generateAction()
		package «mainPackage».md2.controller.action;
		
		import «mainPackage».«app.name.toFirstUpper»;
		import «mainPackage».R;
		
		import «mainPackage»«Settings.MD2_APP_FILES_CONTROLLER_PACKAGE_NAME»;
		«MD2AndroidLollipopUtil.generateImportAllActions»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllExceptions»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
		«MD2AndroidLollipopUtil.generateImportAllCustomCodeTasks»
		import «Settings.MD2LIBRARY_CONTENTPROVIDERREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;

		public class «qualifiedActionName.toFirstUpper»_Action extends AbstractMd2Action {
		
		    public «qualifiedActionName.toFirstUpper»_Action() {
				super("«qualifiedActionName.toFirstUpper»_Action");
			}
		
		    @Override
		    public void execute() {
		    	«/*actions should actually always be a custom action */»
				«IF action instanceof CustomAction»
					«val customAction = action as CustomAction»
					«var counter = 1»
					«FOR ccf : customAction.codeFragments»
						«generateCodeForCodeFragment(ccf, app, wfe, counter++)»
					«ENDFOR»
				«ENDIF»
			}
		}
	'''

	protected def static String generateCodeForCodeFragment(CustomCodeFragment ccf, App app, WorkflowElement wfe,
		int counter) {
		if (ccf == null)
			return ""

		var intCounter = counter

		val qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider
		var dataType = ""
		var instantiation = ""
		var result = ""

		// check type of custom code fragment
		switch ccf {
			EventBindingTask: {
				dataType = "Md2BindTask"

				var qualifiedNameAction = ""
				val action = ccf.actions.head
				switch action {
					ActionReference:
						qualifiedNameAction = qualifiedNameProvider.getFullyQualifiedName(action.actionRef).
							toString("_") + "_Action()"
					SimpleActionRef:
						qualifiedNameAction = generateSimpleAction(app, action.action)
				}

				val event = ccf.events.head as ViewElementEventRef
				val viewElementType = event.referencedField.ref
				val eventType = event.event
				var eventString = ""
				switch eventType {
					case eventType == ON_CHANGE: eventString = "Md2WidgetEventType.ON_CHANGE"
					case eventType == ON_CLICK: eventString = "Md2WidgetEventType.ON_CLICK"
					//add swipe support
					case eventType == ON_LEFT_SWIPE: eventString = "Md2WidgetEventType.ON_LEFT_SWIPE"
					case eventType == ON_RIGHT_SWIPE: eventString = "Md2WidgetEventType.ON_RIGHT_SWIPE"
				}

				val qualifiedNameView = qualifiedNameProvider.getFullyQualifiedName(viewElementType).toString("_")

				instantiation = '''
					new «qualifiedNameAction», R.id.«qualifiedNameView», «eventString»
				'''

				// get working code if sth went wrong
				if (qualifiedNameAction.empty || qualifiedNameView.empty || eventString.empty)
					instantiation = ""
			}
			
//			TODO: implement EventUnbindTask
//			EventUnbindTask:
//				return ""

			CallTask: {
				dataType = "Md2CallTask"
				var actionString = ""
				val haction = ccf.action
				switch haction {
					ActionReference: {
						if (haction.actionRef.eContainer == null) {
							actionString = wfe.name + "_" +
								qualifiedNameProvider.getFullyQualifiedName(haction.actionRef).toString("_") +
								"_Action()"	
						} else {
							actionString = qualifiedNameProvider.getFullyQualifiedName(haction.actionRef).
								toString("_") + "_Action()"
						}
					}
					SimpleActionRef: {
						actionString = generateSimpleAction(app, haction.action)
					}
				}
				if(!actionString.empty)
					instantiation = '''new «actionString.toFirstUpper»'''
			}
			MappingTask: {
				dataType = "Md2MapTask"

				var attribute = ""
				var contentProvider = ""

				var pathDefinition = ccf.pathDefinition
				switch pathDefinition {
					ContentProviderPath: {
						attribute = pathDefinition.tail.attributeRef.name
						contentProvider = pathDefinition.contentProviderRef.name
					}
				}

				instantiation = '''"«contentProvider»", R.id.«MD2AndroidLollipopUtil.getQualifiedName(ccf.referencedViewField.ref).toString("_")», "«attribute»"'''
			}
			
//			TODO: implement UnmappingTask
			UnmappingTask:
				return ""

			AttributeSetTask: {
				dataType = "Md2AttributeSetTask"
				instantiation = '''"«ccf.pathDefinition.contentProviderRef.name»", "«ccf.pathDefinition.tail.attributeRef.name»", «generateSimpleExpression(ccf.source)»'''

			}
			
//			TODO: implement ContentProviderSetTask
			ContentProviderSetTask:
				return ""	

//			TODO: implement ViewElementSetTask
			ViewElementSetTask:
				return ""
				
			//TODO implement ValidatorBindingTask
			ValidatorBindingTask:
				return ""

			ConditionalCodeFragment: {
				result = '''
					if(«generateCondition(ccf.^if.condition)»){
						«FOR containedCcf : ccf.^if.codeFragments»
							«containedCcf.generateCodeForCodeFragment(app, wfe, intCounter++)»
						«ENDFOR»
					}
					«FOR ei : ccf.elseifs»
						else if («generateCondition(ei.condition)»){
							«FOR containedCcf : ei.codeFragments»
								«containedCcf.generateCodeForCodeFragment(app, wfe, intCounter++)»
							«ENDFOR»
						}				
					«ENDFOR»
					«IF ccf.^else != null»				
						else{
							«FOR containedCcf : ccf.^else.codeFragments»
								«containedCcf.generateCodeForCodeFragment(app, wfe, intCounter++)»
							«ENDFOR»
						}
					«ENDIF»
				'''
				return result;
			}
			default:
				throw new UnsupportedOperationException("generateCustomCodeFragment()")
		}

		result = '''
			«dataType» var«intCounter» = null;
			try {
				var«intCounter» = new «dataType»(«instantiation»);
				var«intCounter».execute();
			}catch (Md2WidgetNotCreatedException e){
				Md2TaskQueue.getInstance().addPendingTask(var«intCounter»);
			}
		'''

		if (instantiation.empty || dataType.empty)
			return ""

		return result
	}

	protected static def String generateSimpleAction(App app, SimpleAction sa) {
		var result = ""
		switch sa {
			GotoViewAction:
				result = '''Md2GoToViewAction(«app.name.toFirstUpper».getAppContext().getString(R.string.«sa.view.ref.name»Activity))'''
			DisableAction:
				result = ''''''
			EnableAction:
				result = ''''''
			DisplayMessageAction:
				result = '''Md2DisplayMessageAction(«generateSimpleExpression(sa.message)».toString())'''
			FireEventAction:{
					result = '''Md2FireEventAction("«sa.workflowEvent.name»")'''
				}
			ContentProviderOperationAction: {
				val contentProvider = sa.contentProvider
				var contentProviderName = ""
				var operation = ""
				switch sa.operation {
					case CREATE_OR_UPDATE: operation = "Md2ContentProviderOperations.CREATE_OR_UPDATE"
					case READ: operation = "Md2ContentProviderOperations.READ"
					case DELETE: operation = "Md2ContentProviderOperations.DELETE"
				}

				switch contentProvider {
					ContentProviderReference: contentProviderName = contentProvider.contentProvider.name
//					LocationProviderReference: ...
				}

				result = '''Md2ContentProviderOperationAction("«contentProviderName»", «operation»)'''
			}
			ContentProviderResetAction:
				result = '''Md2ContentProviderResetAction("«sa.contentProvider.contentProvider.name»")'''
//			TODO: implement ContentProviderAddAction
			ContentProviderAddAction: 
			 	result = '''''' 
//			TODO: implement ContentProviderRemoveAction
			ContentProviderRemoveAction:
			  	result = ''''''
//			TODO: implement ContentProviderGetAction
			ContentProviderGetAction:
			 result = ''''''
//			TODO: implement WebServiceCallAction
			WebServiceCallAction:
				result = ''''''
//			TODO: implement LocationAction
			LocationAction:
				result = ''''''
			default:
				throw new UnsupportedOperationException("generateSimpleAction()")
		}

		return result
	}

	protected static def String generateCondition(ConditionalExpression condition) {
		var result = '''true'''

		switch condition {
			CompareExpression: {
				result = '''(«generateSimpleExpression(condition.eqLeft)».«generateOperator(condition.op)»(«generateSimpleExpression(condition.eqRight)»))'''
			}
			Or: {
				result = '''(«generateCondition(condition.leftExpression)» || «generateCondition(condition.rightExpression)»)'''
			}
			And: {
				result = '''(«generateCondition(condition.leftExpression)» && «generateCondition(condition.rightExpression)»)'''
			}
			Not: {
				result = '''(!(«generateCondition(condition.expression)»))'''
			}
			default:
				throw new UnsupportedOperationException("generateCondition()")
		}

		return result
	}

	protected static def String generateOperator(Operator op) {
		switch op {
			// EQUALS = 'equals' | GREATER = '>' | SMALLER = '<' | GREATER_OR_EQUAL = '>=' | SMALLER_OR_EQUAL = '<='
			case EQUALS: return "equals"
			case GREATER: return "gt"
			case GREATER_OR_EQUAL: return "gte"
			case SMALLER: return "lt"
			case SMALLER_OR_EQUAL: return "lte"
			default: throw new UnsupportedOperationException("generateOperator()")
		}
	}

	protected static def String generateSimpleExpression(SimpleExpression expression) {
		switch expression {
			StringVal:
				return '''new Md2String("«expression.value»")'''
			BooleanVal:
				return '''new Md2Boolean(«expression.value»)'''
			DateVal:
				return '''new Md2Date(«expression.value»)'''
			TimeVal:
				return '''new Md2Time(«expression.value»)'''
			DateTimeVal:
				return '''new Md2DateTime(«expression.value»)'''
			IntVal:
				return '''new Md2Integer(«expression.value»)'''
			FloatVal:
				return '''new Md2Float(«expression.value»)'''
			AbstractContentProviderPath: {
				switch expression {
					ContentProviderPath: return '''Md2ContentProviderRegistry.getInstance().getContentProvider("«expression.contentProviderRef.name»").getValue("«expression.tail.attributeRef.name»")'''
//					LocationProvider: ...
				}
			}
			AbstractProviderReference: {
				switch expression {
					ContentProviderReference: return '''Md2ContentProviderRegistry.getInstance().getContentProvider("«expression.contentProvider.name»").getContent()'''
//					LocationProvider: ...
				}
			}
			AbstractViewGUIElementRef:
				return '''Md2ViewManager.getInstance().getWidgetValue(R.id.«MD2AndroidLollipopUtil.getQualifiedNameAsString(expression.ref, "_")»)'''
			default:
				throw new UnsupportedOperationException("generateSimpleExpression()")
		}
	}
}