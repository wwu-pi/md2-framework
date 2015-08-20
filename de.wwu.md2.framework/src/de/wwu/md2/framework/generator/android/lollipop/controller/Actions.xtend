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

class Actions {
	def static generateActions(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<WorkflowElement> workflowElements) {
		val qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider
		
		workflowElements.forEach [ wfe |
			wfe.actions.forEach [ a |
				val qualifiedName = qualifiedNameProvider.getFullyQualifiedName(a).toString("_")
				fsa.generateFile(
					rootFolder + Settings.JAVA_PATH + mainPath + "md2/controller/action/" + qualifiedName + "_Action.java", generateAction(mainPackage, wfe, a))

			]
		]
	}

	def static generateAction(String mainPackage, WorkflowElement wfe, Action action) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Actions.generateAction()
		package «mainPackage».md2.controller.action;
		
		import de.uni_muenster.wi.fabian.md2library.controller.action.Interfaces.Md2Action;
		import de.uni_muenster.wi.fabian.md2library.controller.action.Implementation.AbstractMd2Action;
		
		public class «wfe.name.toFirstUpper»«action.name.toFirstUpper»Action extends AbstractMd2Action {
		
		    public «wfe.name.toFirstUpper»«action.name.toFirstUpper»Action() {

		    }
		
		    @Override
		    public void execute() {
				«IF action instanceof CustomAction»
					«val customAction = action as CustomAction»
					«FOR ccf : customAction.codeFragments»
						«generateCodeForCodeFragment(ccf)»
					«ENDFOR»
				«ENDIF»
		    }
		
		    @Override
		    public boolean equals(Md2Action otherMd2Action) {
		        if (otherMd2Action == null || !(otherMd2Action instanceof «wfe.name.toFirstUpper»«action.name.toFirstUpper»Action))
		            return false;
		
		        // // TODO: 10.08.2015 use parameter
		        return otherMd2Action.hashCode() == this.hashCode();
		    }
	  '''

	def static String generateCodeForCodeFragment(CustomCodeFragment ccf){
		var result = ""
		switch ccf{
			EventBindingTask : result = ""
			EventUnbindTask : result = ""
			CallTask : result = ""
			MappingTask : result = ""
			UnmappingTask : result = ""
		}
		return result
	}

}