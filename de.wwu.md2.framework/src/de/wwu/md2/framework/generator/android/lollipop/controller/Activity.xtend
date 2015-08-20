package de.wwu.md2.framework.generator.android.lollipop.controller

import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.WorkflowElementReference

class Activity {
	
	
	def static generateActivities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContainerElement> rootViews, Iterable<WorkflowElementReference> wers) {
		
		fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "StartActivity.java",
				generateStartActivity(mainPackage, wers))	
		
		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "Activity.java",
				generateActivity(mainPackage, rv))
		]
	}
	
	def static generateStartActivity(String mainPackage, Iterable<WorkflowElementReference> wers)'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Activity.generateStartActivity()
		package «mainPackage»;
		
		import android.app.Activity;
		import android.content.Intent;
		import android.os.Bundle;
		import android.view.View;
		
		import «mainPackage».md2.controller.Controller;
		import «mainPackage».md2.view.ViewManager;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2String;
		
		
		public class StartActivity extends Activity {
		
		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_start);
		        «FOR wer : wers»
		        	Md2Button «wer.workflowElementReference.name»Button = (Md2Button) findViewById(R.id.startActivity_«wer.workflowElementReference.name»Button);
		        	«wer.workflowElementReference.name»Button.setOnClickHandler(new Md2OnClickHandler());
		        	«wer.workflowElementReference.name»Button.getOnClickHandler().registerAction(new Md2GoToViewAction(getString(R.string.«wer.workflowElementReference.defaultProcessChain.processChainSteps.head.view.ref.name»Activity)));
		        «ENDFOR»

		    }
		
		    @Override
		    protected void onStart(){
		        super.onStart();
		        Controller.getInstance().setActiveView(this);
		    }
		}
	'''

	private def static generateActivity(String mainPackage, ContainerElement rv) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.controller.Activity.generateActivity()
		package «mainPackage»;
		
		import android.app.Activity;
		import android.content.Intent;
		import android.os.Bundle;
		import android.view.View;
		
		import «mainPackage».md2.controller.Controller;
		import «mainPackage».md2.view.ViewManager;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2String;
		
		
		public class «rv.name»Activity extends Activity {
		
		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_«rv.name»);
		    }
		
		    @Override
		    protected void onStart(){
		        super.onStart();
		        Controller.getInstance().setActiveView(this);
		    }
		}
	'''
}