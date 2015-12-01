package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.generator.util.preprocessor.PreprocessModel

import static de.wwu.md2.framework.generator.android.util.MD2AndroidUtil.*
import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class ProjectApplication {
	def static generateApplication(String basePackage, String projectAppClassName, DataContainer dataContainer) '''
		package «basePackage»;
		
		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.controller.events.OnConditionEvent;
		«IF !dataContainer.contentProviders.empty»
			import «basePackage».contentprovider.*;
		«ENDIF»
		
		public class «projectAppClassName» extends MD2Application {
			
			@Override
			protected void bootStrap() {
				
				// Register all actions
				«FOR action : dataContainer.customActions»
					registerAction(new «basePackage».actions.«getName(action).toFirstUpper»(this));
				«ENDFOR»
				
				// Register all content providers
				«FOR contentProvider : dataContainer.contentProviders»
					registerContentProvider(new «contentProvider.name.toFirstUpper»(this));
				«ENDFOR»
				
				// Initialize all on condition events
				«FOR oncConditionEvent : dataContainer.onConditionEvents»
					new OnConditionEvent("«oncConditionEvent.name.toFirstUpper»", new «basePackage».condition.«getConditionName(dataContainer, oncConditionEvent.condition)»(this), this);
				«ENDFOR»
				
				// Initialize all workflows
				«FOR workflow : dataContainer.workflows»
					getWorkflowManager().addWorkflow("«workflow.name.toFirstUpper»", new «basePackage».workflow.«workflow.name.toFirstUpper»(this));
				«ENDFOR»
				
				// Set initial workflow (if specified)
				«IF dataContainer.main.defaultWorkflow != null»
					getWorkflowManager().setActiveWorkflow("«dataContainer.main.defaultWorkflow.name.toFirstUpper»");
				«ENDIF»
				
				// Execute default actions
				executeAction(«basePackage».actions.«PreprocessModel::autoGenerationActionName.toFirstUpper».class);
				executeAction(«basePackage».actions.«dataContainer.main.onInitializedEvent.name.toFirstUpper».class);
			}
			
		}
	'''
}