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
					ActionReference: qualifiedNameAction = qualifiedNameProvider.
						getFullyQualifiedName(action.actionRef).toString("_") + "_Action()"
					SimpleActionRef: qualifiedNameAction = generateSimpleAction(action.action)
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
				if(qualifiedNameAction.empty || qualifiedNameView.empty || eventString.empty)
					instantiation = ""
			}
			EventUnbindTask:
				return ""
			CallTask: {
				dataType = "Md2CallAction"
				var qualifiedName = ""
				val haction = ccf.action
				switch haction {
					ActionReference: qualifiedName = qualifiedNameProvider.getFullyQualifiedName(haction.actionRef).
						toString("_") + "_Action()"
					SimpleActionRef: qualifiedName = generateSimpleAction(haction.action)
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
			UnmappingTask:
				return ""
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
		if(instantiation.empty || dataType.empty)
			return ""

		return result
	}

	protected static def String generateSimpleAction(SimpleAction sa) {
		var result = ""
		switch sa {
			GotoViewAction:
				result = '''Md2GoToViewAction("«sa.view.ref.name»Activity")'''
//			DisableAction: result = '''''' 
//			EnableAction: result = '''''' 
			DisplayMessageAction:
				result = '''Md2DisplayMessageAction("«(sa.message as StringVal).value»")'''
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
		}

		return result
	}

}