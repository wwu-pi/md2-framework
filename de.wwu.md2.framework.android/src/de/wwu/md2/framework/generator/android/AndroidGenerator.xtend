package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.templates.StringsXmlTemplate
import de.wwu.md2.framework.generator.android.util.JavaClassDef
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import java.util.List
import java.util.Queue
import java.util.Set

import static com.google.common.collect.Lists.*
import static de.wwu.md2.framework.generator.android.ArraysXml.*
import static de.wwu.md2.framework.generator.android.ModelClass.*
import static de.wwu.md2.framework.generator.android.StyleXml.*
import static de.wwu.md2.framework.generator.android.common.DotClassPath.*
import static de.wwu.md2.framework.generator.android.common.DotProject.*
import static de.wwu.md2.framework.generator.android.common.Manifest.*
import static de.wwu.md2.framework.generator.android.common.Preferences.*
import static de.wwu.md2.framework.generator.android.common.ProjectProperties.*
import static de.wwu.md2.framework.generator.android.util.MD2AndroidUtil.*
import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static de.wwu.md2.framework.util.MD2Util.*

/**
 * Android platform generator
 */
class AndroidGenerator extends AbstractPlatformGenerator {
	
	int minAppVersion = 11
	
	override doGenerate(IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Generation work flow
		/////////////////////////////////////////
		
		// Copy resources
		fsa.copyFileFromProject("resources/images", rootFolder + "/res/drawable-xhdpi")
		
		// Copy static library files
		fsa.generateFileFromInputStream(getSystemResource("/android/guava-10.0.1.jar"), rootFolder + "/lib/guava-10.0.1.jar")
		fsa.generateFileFromInputStream(getSystemResource("/android/md2-android-lib.jar"), rootFolder + "/lib/md2-android-lib.jar")
		fsa.generateFileFromInputStream(getSystemResource("/android/jackson-all-1.9.9.jar"), rootFolder + "/lib/jackson-all-1.9.9.jar")
		
		// Copy Icons and logos
		fsa.generateFileFromInputStream(getSystemResource("/android/drawable-ldpi/ic_launcher.png"), rootFolder + "/res/drawable-ldpi/ic_launcher.png")
		fsa.generateFileFromInputStream(getSystemResource("/android/drawable-mdpi/ic_launcher.png"), rootFolder + "/res/drawable-mdpi/ic_launcher.png")
		fsa.generateFileFromInputStream(getSystemResource("/android/drawable-hdpi/ic_launcher.png"), rootFolder + "/res/drawable-hdpi/ic_launcher.png")
		fsa.generateFileFromInputStream(getSystemResource("/android/drawable-xhdpi/ic_launcher.png"), rootFolder + "/res/drawable-xhdpi/ic_launcher.png")
		fsa.generateFileFromInputStream(getSystemResource("/android/drawable-ldpi/information.png"), rootFolder + "/res/drawable-hdpi/information.png")
		fsa.generateFileFromInputStream(getSystemResource("/android/drawable-mdpi/information_24px.png"), rootFolder + "/res/drawable-ldpi/information.png")
		fsa.generateFileFromInputStream(getSystemResource("/android/drawable-hdpi/information_32px.png"), rootFolder + "/res/drawable-mdpi/information.png")
		fsa.generateFileFromInputStream(getSystemResource("/android/drawable-xhdpi/information_32px.png"), rootFolder + "/res/drawable-xhdpi/information.png")
		
		// Generate common base elements
		fsa.generateFile(rootFolder + "/.project", dotProject(basePackageName))
		fsa.generateFile(rootFolder + "/.classpath", dotClassPath)
		fsa.generateFile(rootFolder + "/project.properties", projectProperties(minAppVersion))
		fsa.generateFile(rootFolder + "/src/" + basePackageName.replace('.', '/') + "/" + createAppClassName(dataContainer) + ".java", ProjectApplication::generateApplication(basePackageName, createAppClassName(dataContainer), dataContainer))
		fsa.generateFile(rootFolder + "/.settings/org.eclipse.core.resources.prefs", preferences)
		
		
		/////////////////////////////////////////
		// Generate models
		/////////////////////////////////////////
		
		// Generate models and create list of all enumerations
		val Iterable<Enum> enums = dataContainer.models.map(model | model.modelElements.filter(typeof(Enum))).flatten
		dataContainer.models.forEach[model | model.modelElements.forEach[elem | createModel(fsa, elem)]]
		
		// Generate Arrays.xml
		fsa.generateFile(rootFolder + "/res/values/arrays.xml" , generateArraysXml(enums))
		val stringsTemplate = new StringsXmlTemplate();
		stringsTemplate.addString("app_name", dataContainer.main.appName)
		
		
		/////////////////////////////////////////
		// Generate views
		/////////////////////////////////////////
		
		// Generate Style.xml
		fsa.generateFile(rootFolder + "/res/values/style.xml" , generateStyleXml())
		
		// List of all root views that will be created
		val Set<ContainerElement> activities = newHashSet
		// Insert all view containers not contained in an (tabbed) alternatives pane
		activities.addAll(dataContainer.viewContainersNotInAnyAlternativesPane)
		
		// List of all sub views (contained in a tabbed pane or an alternatives pane)
		val Set<ContainerElement> fragments = newHashSet
		// Insert all view containers contained in an alternatives pane
		fragments.addAll(dataContainer.viewContainersInAnyAlternativesPane)
		
		// Initialize queue to generate all already know view containers
		// and so far unknow view containers that might be contained in sub alternatives pane
		val Queue<ContainerElement> viewContainerQueue = newLinkedList
		viewContainerQueue.addAll(dataContainer.viewContainers)
		
		// Check if the tabbed alternatives pane is already in the list of activities and add it otherwise
		if(dataContainer.tabbedAlternativesPane != null) {
			activities.add(dataContainer.tabbedAlternativesPane)
		}
		
		while(!viewContainerQueue.isEmpty()) {
			val curViewContainer = viewContainerQueue.remove
			// Generate view
			if(!(curViewContainer instanceof TabbedAlternativesPane)) {
				val viewGenerator = new LayoutXml(stringsTemplate)
				fsa.generateFile(rootFolder + "/res/layout/" + getName(curViewContainer).toLowerCase + ".xml" , viewGenerator.generateLayoutXml(curViewContainer))
				// Add all new detected fragments to the queue and the list of fragments
				viewContainerQueue.addAll(viewGenerator.newFragmentsToGenerate)
				fragments.addAll(viewGenerator.newFragmentsToGenerate)
			}
		}
		
		
		/////////////////////////////////////////
		// Generate controllers
		/////////////////////////////////////////
		
		val Set<ContainerElement> topLevelViewContainers = newHashSet
		topLevelViewContainers.addAll(activities)
		topLevelViewContainers.addAll(fragments)
		
		// Determine main activity
		val ContainerElement mainActivity = if(activities.contains(resolveContainerElement(dataContainer.main.startView))) {
			resolveContainerElement(dataContainer.main.startView)
		}
		else if(dataContainer.tabbedViewContent.contains(resolveContainerElement(dataContainer.main.startView))) {
			dataContainer.tabbedAlternativesPane
		}
		else {
			throw new Exception("Android: Cannot determine main activity")
		}
		
		// Generate actions
		dataContainer.customActions.forEach [
			fsa.generateFile(rootFolder + "/src/" + basePackageName.replace('.', '/') + "/actions/" + getName(it).toFirstUpper + ".java", 
				new CustomActionTemplate(basePackageName, it, dataContainer, topLevelViewContainers, activities, fragments).generateCustomAction
			)
		]
		
		// Generate conditions
		dataContainer.conditions.forEach[conditionName, condition |
			val conditionGenerator = new ConditionClass(dataContainer, topLevelViewContainers)
			writeJavaFile(fsa, createJavaClassDef("condition", [it.simpleName = conditionName
																conditionGenerator.generateCondition(it, condition)
			]))
		]
		
		// Generate workflows and workflow steps
		dataContainer.workflows.forEach[workflow |
			val workflowGenerator = new WorkflowClass(dataContainer)
			writeJavaFile(fsa, createJavaClassDef("workflow", [it.simpleName = workflow.name.toFirstUpper
																workflowGenerator.generateWorkflow(it, workflow)
			]))
			workflow.workflowSteps.forEach[workflowStep |
				writeJavaFile(fsa, createJavaClassDef("workflow", [it.simpleName = workflowStep.name.toFirstUpper
																	workflowGenerator.generateWorkflowStep(it, workflowStep, activities, fragments)
				]))
			]
		]
		
		// Generate activities
		val activityGenerator = new Activity(dataContainer)
		activities.forEach [
			if(it instanceof TabbedAlternativesPane) {
				fsa.generateFile(rootFolder + "/src/" + basePackageName.replace('.', '/') + "/controller/" + getName(it).toFirstUpper + "Activity.java" , activityGenerator.generateTabbedActivity(basePackageName, stringsTemplate, it as TabbedAlternativesPane))
			}
			else {
				fsa.generateFile(rootFolder + "/src/" + basePackageName.replace('.', '/') + "/controller/" + getName(it).toFirstUpper + "Activity.java" , activityGenerator.generateActivity(basePackageName, it))
			}
		]
		
		// Generate fragments
		fragments.forEach [ fragment |
			writeJavaFile(fsa, createJavaClassDef("controller", [activityGenerator.generateFragment(it, fragment)]))
		]
		
		// Generate content providers
		dataContainer.contentProviders.forEach [
			val template = new ContentProviderClass(dataContainer, mainActivity, it)
//			if (it.local) {
				writeJavaFile(fsa, createJavaClassDef("contentprovider", [template.generateContentProvider(it)]))
//			} else {
			// TODO Generate remote ContentProvider class
//			}
		]
		
		
		/////////////////////////////////////////
		// Generate general files
		/////////////////////////////////////////
		
		val List<ContainerElement> activitiesListForFragment = newLinkedList
		activitiesListForFragment.addAll(activities)
		activitiesListForFragment.remove(mainActivity)
		activitiesListForFragment.add(0, mainActivity)
		
		// Generate Manifest
		fsa.generateFile(rootFolder + "/AndroidManifest.xml", manifest(basePackageName, minAppVersion, dataContainer, activitiesListForFragment))
		
		// Generate from template objects
		fsa.generateFile(rootFolder + "/res/values/strings.xml" , stringsTemplate.render())
	}
	
	def private createModel(IExtendedFileSystemAccess fsa, ModelElement elem) {
		try {
			fsa.generateFile(rootFolder + "/src/" + basePackageName.replace('.', '/') + '/models/' + elem.name + '.java' , createClass(elem, basePackageName))
		} catch (Exception e) {
			System::out.println("Error generating model class " + elem.name + ". Type: " + elem.toString() + " (" + e.getClass().name + ": " + e.message+")");
		}
	}
	
	override getPlatformPrefix() {
		"android"
	}
	
	/**
	 * Helper to create a java file descriptor.
	 * 
	 * @param initializer Function to initialize the file descriptor. It's return value will be used as the file content.
	 * 
	 * Example:
	 * writeJavaFile(fsa, [it.baseName = "de.test"; it.simpleName = "HelloWorld"; generateHelloWorld(it)])
	 */
	def private JavaClassDef createJavaClassDef(String subPackage, (JavaClassDef)=>CharSequence initializer) {
		val classDef = new JavaClassDef()
		classDef.basePackage = basePackageName
		classDef.subPackage = subPackage
		classDef.contents = initializer.apply(classDef)
		return classDef
	}
	
}
