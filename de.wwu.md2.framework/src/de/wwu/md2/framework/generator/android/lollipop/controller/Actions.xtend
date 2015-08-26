package de.wwu.md2.framework.generator.android.lollipop.controller

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.Action
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.MappingTask
import de.wwu.md2.framework.mD2.UnmappingTask
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.SimpleAction
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.DisableAction
import de.wwu.md2.framework.mD2.EnableAction
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.DisplayMessageAction
import de.wwu.md2.framework.mD2.ContentProviderResetAction
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.ViewElementSetTask
import de.wwu.md2.framework.mD2.ConditionalCodeFragment
import java.util.concurrent.locks.Condition
import de.wwu.md2.framework.mD2.ConditionalExpression
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.ContentProviderAddAction
import de.wwu.md2.framework.mD2.ContentProviderRemoveAction
import de.wwu.md2.framework.mD2.ContentProviderGetAction
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.AbstractProviderReference
import de.wwu.md2.framework.mD2.Or
import de.wwu.md2.framework.mD2.And
import de.wwu.md2.framework.mD2.Not
import de.wwu.md2.framework.mD2.FireEventAction

class Actions {
	def static generateActions(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<WorkflowElement> workflowElements) {
		val qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider

		workflowElements.forEach [ wfe |
			wfe.actions.forEach [ a |
				val qualifiedName = qualifiedNameProvider.getFullyQualifiedName(a).toString("_")
				fsa.generateFile(
					rootFolder + Settings.JAVA_PATH + mainPath + "md2/controller/action/" + qualifiedName.toFirstUpper +
						"_Action.java", generateAction(mainPackage, wfe, a, qualifiedName))

			]
		]
	}

	def static generateAction(String mainPackage, WorkflowElement wfe, Action action, String qualifiedActionName) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Actions.generateAction()
		package «mainPackage».md2.controller.action;
		
		import de.uni_muenster.wi.fabian.md2library.controller.action.Interfaces.Md2Action;
		import de.uni_muenster.wi.fabian.md2library.controller.action.Implementation.AbstractMd2Action;
		
		public class «qualifiedActionName.toFirstUpper»_Action extends AbstractMd2Action {
		
		    public «qualifiedActionName.toFirstUpper»_Action() {
				super("«qualifiedActionName.toFirstUpper»_Action");
			}
		
		    @Override
		    public void execute() {
				«IF action instanceof CustomAction»
					«val customAction = action as CustomAction»
					«var counter = 1»
					«FOR ccf : customAction.codeFragments»
						«generateCodeForCodeFragment(ccf, counter++)»
					«ENDFOR»
				«ENDIF»
			}
		}
	'''

	def static String generateCodeForCodeFragment(CustomCodeFragment ccf, int counter) {
		if (ccf == null)
			return ""

		val qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider
		var dataType = ""
		var instantiation = ""
		var result = ""
		switch ccf {
			EventBindingTask: {
				dataType = "Md2BindAction"

				var qualifiedNameAction = ""
				val action = ccf.actions.head
				switch action {
					ActionReference:
						qualifiedNameAction = qualifiedNameProvider.getFullyQualifiedName(action.actionRef).
							toString("_") + "_Action()"
					SimpleActionRef:
						qualifiedNameAction = generateSimpleAction(action.action)
				}

				val event = ccf.events.head as ViewElementEventRef
				val viewElementType = event.referencedField.ref
				val eventType = event.event
				var eventString = ""
				switch eventType {
					case eventType == ON_CHANGE: eventString = "Md2WidgetEventType.ON_CHANGE"
					case eventType == ON_CLICK: eventString = "Md2WidgetEventType.ON_CLICK"
				}

				val qualifiedNameView = qualifiedNameProvider.getFullyQualifiedName(viewElementType).toString("_")

				instantiation = '''
					new «qualifiedNameAction», R.id.«qualifiedNameView», «eventString»
				'''

				// hack to get working code if sth went wrong
				if (qualifiedNameAction.empty || qualifiedNameView.empty || eventString.empty)
					instantiation = ""
			}
//			EventUnbindTask:
//				return "Some event unbinding task"
			CallTask: {
				dataType = "Md2CallAction"
				var qualifiedName = ""
				val haction = ccf.action
				switch haction {
					ActionReference:
						qualifiedName = qualifiedNameProvider.getFullyQualifiedName(haction.actionRef).toString("_") +
							"_Action()"
					SimpleActionRef:
						qualifiedName = generateSimpleAction(haction.action)
				}
				instantiation = '''new «qualifiedName.toFirstUpper»'''
			}
			MappingTask: {
				dataType = "Md2MapAction"

				var attribute = ""
				var contentProvider = ""

				var pathDefinition = ccf.pathDefinition
				switch pathDefinition {
					ContentProviderPath: {
						attribute = pathDefinition.tail.attributeRef.name
						contentProvider = pathDefinition.contentProviderRef.name
					}
				}

				instantiation = '''«contentProvider», R.id.«MD2AndroidLollipopUtil.getQualifiedName(ccf.referencedViewField.ref).toString("_")», «attribute»'''
			}
//			UnmappingTask:
//				return "Some unmapping task"
			AttributeSetTask: {
				dataType = "Md2AttributeSetAction"
				instantiation = '''«ccf.pathDefinition.contentProviderRef.name», «ccf.pathDefinition.tail.attributeRef.name», '''

			}
//			ContentProviderSetTask:
//				return "Some contentprovider set task"	
//			ViewElementSetTask:
//				return "Some viewElementSet task"
			ConditionalCodeFragment: {
				result = '''
					if(«generateCondition(ccf.^if.condition)»){
						«FOR containedCcf : ccf.^if.codeFragments»
							«containedCcf.generateCodeForCodeFragment(counter)»
						«ENDFOR»
					}
					«FOR ei : ccf.elseifs»
						else if («generateCondition(ei.condition)»){
							«FOR containedCcf : ei.codeFragments»
								«containedCcf.generateCodeForCodeFragment(counter)»
							«ENDFOR»
						}				
					«ENDFOR»
					«IF ccf.^else != null»				
						else{
							«FOR containedCcf : ccf.^else.codeFragments»
								«containedCcf.generateCodeForCodeFragment(counter)»
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
			«dataType» var«counter» = null;
			try {
				var«counter» = new «dataType»(«instantiation»);
				var«counter».execute();
			}catch (WidgetNotCreatedException e){
				Controller.getInstance().addPendingAction(var«counter»);
			}
		'''

		// hack to get working code if sth went wrong
		if (instantiation.empty || dataType.empty)
			return ""

		return result
	}

	protected static def String generateSimpleAction(SimpleAction sa) {
		var result = ""
		switch sa {
			GotoViewAction:
				result = '''Md2GoToViewAction("«sa.view.ref.name»Activity")'''
			DisableAction:
				result = '''some disable action'''
			EnableAction:
				result = '''some enable action'''
			DisplayMessageAction:
				result = '''Md2DisplayMessageAction(«generateSimpleExpression(sa.message)».toString())'''
			FireEventAction:
				result = ""
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

				result = '''Md2ContentProviderOperationAction("«contentProviderName», «operation»")'''
			}
			ContentProviderResetAction:
				result = '''Md2ContentProviderResetAction("«sa.contentProvider.contentProvider.name»")'''
			/*ContentProviderAddAction: 
			 * 	result = '''some ContentProviderAddAction action''' 
			 * ContentProviderRemoveAction:
			 * 	result = '''some ContentProviderRemoveAction action'''
			 * ContentProviderGetAction:
			 result = '''some ContentProviderGetAction action'''*/
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
				result = '''(!(«condition.expression»))'''
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
				// LocationProvider: ...
				}
			}
			// AbstractProviderReference: return ""
			// AbstractViewGUIElementRef: return ""
			default:
				throw new UnsupportedOperationException("generateSimpleExpression()")
		}
	}
}