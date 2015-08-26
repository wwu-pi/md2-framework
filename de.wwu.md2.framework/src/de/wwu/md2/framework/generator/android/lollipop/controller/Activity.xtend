package de.wwu.md2.framework.generator.android.lollipop.controller

import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.WorkflowElementReference
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.TextInput
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import de.wwu.md2.framework.mD2.GridLayoutPane

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
		import de.uni_muenster.wi.fabian.md2library.view.management.implementation.Md2ViewManager;
		«MD2AndroidLollipopUtil.generateImportAllWidgets»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
		
		
		public class StartActivity extends Activity {
		
		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_start);
		        Md2ViewManager.getInstance().registerActivity(this);
		        «FOR wer : wers»
		        	Md2Button «wer.workflowElementReference.name»Button = (Md2Button) findViewById(R.id.startActivity_«wer.workflowElementReference.name»Button);
		        	if(«wer.workflowElementReference.name»Button.getOnClickHandler() == null){
		        		«wer.workflowElementReference.name»Button.setOnClickHandler(new Md2OnClickHandler());
		        	}
		        	//«wer.workflowElementReference.name»Button.getOnClickHandler().registerAction(new Md2GoToViewAction(getString(R.string.«wer.workflowElementReference»Activity)));
		        	
		        	if(«wer.workflowElementReference.name»Button.getOnChangedHandler() == null){
		        		«wer.workflowElementReference.name»Button.setOnChangedHandler(new Md2OnClickHandler());
		        	}
		        «ENDFOR»
				Controller.getInstance().tryExecutePendingActions();
		    }
		
		    @Override
		    protected void onStart(){
				super.onStart();
		        Md2ViewManager.getInstance().registerActivity(this);
		        Md2ViewManager.getInstance().setActiveView(this);
		        Controller.getInstance().tryExecutePendingActions();
		    }
		    
			@Override
		    protected void onPause(){
		        super.onPause();
		        Md2ViewManager.getInstance().unregisterActivity(this);
		    }
		    
			@Override
		    protected void onDestroy(){
		        super.onDestroy();
		        Md2ViewManager.getInstance().unregisterActivity(this);
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
		import de.uni_muenster.wi.fabian.md2library.view.management.implementation.Md2ViewManager;
		«MD2AndroidLollipopUtil.generateImportAllWidgets»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
		
		
		public class «rv.name»Activity extends Activity {
		
		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_«rv.name.toLowerCase»);
		        Md2ViewManager.getInstance().registerActivity(this);
		        
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«generateInitViewElement(viewElement)»
		        «ENDFOR»
		        
		        Controller.getInstance().tryExecutePendingActions();
		    }
		
		    @Override
		    protected void onStart(){
				super.onStart();
		        Md2ViewManager.getInstance().registerActivity(this);
		        Md2ViewManager.getInstance().setActiveView(this);
		        Controller.getInstance().tryExecutePendingActions();
		    }
		    
			@Override
		    protected void onPause(){
		        super.onPause();
		        Md2ViewManager.getInstance().unregisterActivity(this);
		    }
		    
			@Override
		    protected void onDestroy(){
		        super.onDestroy();
		        Md2ViewManager.getInstance().unregisterActivity(this);
		    }
		}
	'''
	
	private static def String generateInitViewElement(ViewElementType vet){
		var String result = ""
		var String type = ""
		
		val qnp = new DefaultDeclarativeQualifiedNameProvider
		var qualifiedName = qnp.getFullyQualifiedName(vet).toString("_")		
		
		switch vet{
			ViewGUIElementReference: return generateInitViewElement(vet.value)
			GridLayoutPane:
				type = "Md2GridLayoutPane"
			Button:
				type = "Md2Button"
			Label:
				type = "Md2Label"
			TextInput:
				type = "Md2TextInput"
		}
		
		result = '''
		«type» «qualifiedName» = («type») findViewById(R.id.«qualifiedName»);
		if(«qualifiedName».getOnClickHandler() == null)
			«qualifiedName».setOnClickHandler(new Md2OnClickHandler());
		if(«qualifiedName».getOnChangedHandler() == null)
			«qualifiedName».setOnChangedHandler(new Md2OnChangedHandler());
        '''
        
		return result
	}
}