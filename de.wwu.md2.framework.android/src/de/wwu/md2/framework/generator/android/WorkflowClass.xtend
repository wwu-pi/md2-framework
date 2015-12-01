package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.generator.android.util.JavaClassDef
import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.WorkflowStep
import java.util.Set

import static de.wwu.md2.framework.generator.android.util.MD2AndroidUtil.*
import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class WorkflowClass {
	
	private DataContainer dataContainer
	
	new (DataContainer dataContainer) {
		this.dataContainer = dataContainer
	}
	
	def public generateWorkflow(JavaClassDef classDef, Workflow workflow) '''
		package «classDef.fullPackage»;
		
		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.controller.workflow.Workflow;
		
		public class «classDef.simpleName» extends Workflow {
			
			public «classDef.simpleName»(MD2Application application) {
				super(application);
			}
			
			@Override
			protected void initializeWorkflowSteps(MD2Application application) {
				«FOR workflowStep : workflow.workflowSteps»
					addWorkflowStep(new «workflowStep.name.toFirstUpper»(application));
				«ENDFOR»
			}
		}
		
	'''
	
	def public generateWorkflowStep(JavaClassDef classDef, WorkflowStep workflowStep, Set<ContainerElement> activities, Set<ContainerElement> fragments) '''
		package «classDef.fullPackage»;
		
		import android.content.Intent;
		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.controller.condition.Condition;
		import de.wwu.md2.android.lib.controller.workflow.WorkflowStep;
		import de.wwu.md2.android.lib.view.TabbedActivity;
		
		public class «classDef.simpleName» extends WorkflowStep {
			
			public «classDef.simpleName»(MD2Application application) {
				super("«workflowStep.name.toFirstUpper»", application);
			}
			
			@Override
			public String getViewName() {
				return "«getName(resolveViewGUIElement(workflowStep.view))»";
			}
			
			@Override
			public String getViewTitle() {
				return "«getTabName(resolveContainerElement(workflowStep.view))»";
			}
			
			@Override
			protected Condition getInitilizedForwardConditions() {
				return «IF workflowStep.forwardCondition != null»new «classDef.basePackage».condition.«getConditionName(dataContainer, workflowStep.forwardCondition)»(application)«ELSE»null«ENDIF»;
			}
			
			@Override
			public String getForwardMessage() {
				return «IF workflowStep.forwardMessage != null»"«workflowStep.forwardMessage»"«ELSE»null«ENDIF»;
			}
			
			@Override
			protected Condition getInitilizedBackwardConditions() {
				return «IF workflowStep.backwardCondition != null»new «classDef.basePackage».condition.«getConditionName(dataContainer, workflowStep.backwardCondition)»(application)«ELSE»null«ENDIF»;
			}
			
			@Override
			public String getBackwardMessage() {
				return «IF workflowStep.backwardMessage != null»"«workflowStep.backwardMessage»"«ELSE»null«ENDIF»;
			}
			
			@Override
			protected void registerEventhandler() {
				«FOR forwardEvent : workflowStep.forwardEvents»
					«val eventName = getEventName(forwardEvent)»
					application.getEventBus().subscribe("«eventName»", "«eventName»_«workflowStep.name»_GoToNextStepEventHandler", application.getWorkflowManager().getGoToNextStepEventHandler());
				«ENDFOR»
				«FOR backwardEvent : workflowStep.backwardEvents»
					«val eventName = getEventName(backwardEvent)»
					application.getEventBus().subscribe("«eventName»", "«eventName»_«workflowStep.name»_GoToPreviousStepEventHandler", application.getWorkflowManager().getGoToPreviousStepEventHandler());
				«ENDFOR»
			}
			
			@Override
			protected void unregisterEventhandler() {
				«FOR forwardEvent : workflowStep.forwardEvents»
					«val eventName = getEventName(forwardEvent)»
					application.getEventBus().unsubscribe("«eventName»", "«eventName»_«workflowStep.name»_GoToNextStepEventHandler");
				«ENDFOR»
				«FOR backwardEvent : workflowStep.backwardEvents»
					«val eventName = getEventName(backwardEvent)»
					application.getEventBus().unsubscribe("«eventName»", "«eventName»_«workflowStep.name»_GoToPreviousStepEventHandler");
				«ENDFOR»
			}
			
			@Override
			protected void showView() {
				// Check if the app is already initialized, otherwise the start view action defined in the main block shall be shown first
				if(application.getActiveActivity() != null) {
					«getGoToViewCode(resolveViewGUIElement(workflowStep.view), "application", classDef.basePackage, dataContainer, activities, fragments)»
				}
			}
		}
		
	'''
}