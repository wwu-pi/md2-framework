package de.wwu.md2.framework.generator.android.lollipop.controller

import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.Settings

class Activity {
	def static generateActivities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContainerElement> rootViews) {
		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "Activity.java",
				generateActivity(mainPackage, rv))
		]
	}

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