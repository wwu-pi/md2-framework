package de.wwu.md2.framework.generator.ios

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.StyleAssignment
import de.wwu.md2.framework.util.UuidProvider

import static de.wwu.md2.framework.generator.ios.ActionEventClass.*
import static de.wwu.md2.framework.generator.ios.ContentProviderClass.*
import static de.wwu.md2.framework.generator.ios.ControllerClass.*
import static de.wwu.md2.framework.generator.ios.DataModelXML.*
import static de.wwu.md2.framework.generator.ios.FilterClass.*
import static de.wwu.md2.framework.generator.ios.InitializeApplicationAction.*
import static de.wwu.md2.framework.generator.ios.LocalizableStrings.*
import static de.wwu.md2.framework.generator.ios.ModelClass.*
import static de.wwu.md2.framework.generator.ios.StylesheetClass.*
import static de.wwu.md2.framework.generator.ios.ViewClass.*
import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static de.wwu.md2.framework.util.MD2Util.*

/**
 * iOS platform generator
 */
class IOSGenerator extends AbstractPlatformGenerator
{
	public static String md2LibraryName = "Md2Library"
	public static String md2LibraryImport = md2LibraryName
	
	String appName
	String projectFolder
	
	override doGenerate(IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Initialize
		/////////////////////////////////////////
		
		appName = createAppName(dataContainer).toString
		projectFolder = rootFolder + "/" + appName
		val FileStructure fileStructure = new FileStructure(appName)
		
		/////////////////////////////////////////
		// Generation work flow
		/////////////////////////////////////////
		
		// Copy resources
		val fileNames = fsa.copyFileFromProject("resources/images", projectFolder)
		
		// Extract library archive
		extractArchive(getSystemResource("/ios/Md2Library.zip"), projectFolder + "/../Md2Library/", fsa);
		
		// Copy static files
		for(file : fileStructure.filesToCopy)
			fsa.generateFileFromInputStream(getSystemResource("/ios/" + file), projectFolder + "/" + file)
		
		if (fileNames != null) {
			for(name : fileNames) {
				fileStructure.addImageFile(name)
			}
		}
		
		// Generate entities and enumerations
		val entities = <Entity>newHashSet
		dataContainer.models.forEach [model |
			model.modelElements.filter(typeof(Entity)).forEach[entity |
				createModel(fsa, entity, fileStructure)
				entities.add(entity)
			]
		]
		fsa.generateFile(projectFolder + "/DataModel.xcdatamodeld/DataModel.xcdatamodel/contents", createDataModelXML(entities))
		fsa.generateFile(projectFolder + "/DataModel.xcdatamodeld/.xccurrentversion", createXcCurrentVersionXML)
		
		// Iterate over all content providers and trigger their generation
		// Add to list of generated files
		for (contentProvider : dataContainer.contentProviders)
		{
			fsa.generateFile(projectFolder + "/" + contentProvider.name.toFirstUpper + "ContentProvider.h" , createContentProviderH(contentProvider))
			fsa.generateFile(projectFolder + "/" + contentProvider.name.toFirstUpper + "ContentProvider.m" , createContentProviderM(contentProvider, dataContainer))
			fileStructure.addContentProviderFile(contentProvider.name.toFirstUpper + "ContentProvider.h")
			fileStructure.addContentProviderFile(contentProvider.name.toFirstUpper + "ContentProvider.m")
			
			if (contentProvider.whereClause != null)
			{
				fsa.generateFile(projectFolder + "/" + contentProvider.name.toFirstUpper + "Filter.h" , createFilterH(contentProvider))
				fsa.generateFile(projectFolder + "/" + contentProvider.name.toFirstUpper + "Filter.m" , createFilterM(contentProvider, dataContainer))
				fileStructure.addFilterFile(contentProvider.name.toFirstUpper + "Filter.h")
				fileStructure.addFilterFile(contentProvider.name.toFirstUpper + "Filter.m")
			}
		}
		
		// Generate views and controllers
		createViewsAndControllers(fsa, fileStructure)
		
		val workflowStepActionGenerator = new ActionClass(dataContainer)
		val workflowSteps = dataContainer.workflows.map(w | w.workflowSteps).flatten
		val conditionGenerator = new ConditionClass(dataContainer)
		for(workflowStep : workflowSteps)
		{
			if (!workflowStep.backwardEvents.empty)
			{
				fsa.generateFile(projectFolder + "/" + workflowStep.name.toFirstUpper + "BackwardWorkflowStepAction.h" , workflowStepActionGenerator.createWorkflowStepActionH(workflowStep, "Backward"))
				fsa.generateFile(projectFolder + "/" + workflowStep.name.toFirstUpper + "BackwardWorkflowStepAction.m" , workflowStepActionGenerator.createWorkflowStepActionM(workflowStep, "Backward"))
				fileStructure.addActionFile(workflowStep.name.toFirstUpper + "BackwardWorkflowStepAction.h")
				fileStructure.addActionFile(workflowStep.name.toFirstUpper + "BackwardWorkflowStepAction.m")
			}
			if (!workflowStep.forwardEvents.empty)
			{
				fsa.generateFile(projectFolder + "/" + workflowStep.name.toFirstUpper + "ForwardWorkflowStepAction.h" , workflowStepActionGenerator.createWorkflowStepActionH(workflowStep, "Forward"))
				fsa.generateFile(projectFolder + "/" + workflowStep.name.toFirstUpper + "ForwardWorkflowStepAction.m" , workflowStepActionGenerator.createWorkflowStepActionM(workflowStep, "Forward"))
				fileStructure.addActionFile(workflowStep.name.toFirstUpper + "ForwardWorkflowStepAction.h")
				fileStructure.addActionFile(workflowStep.name.toFirstUpper + "ForwardWorkflowStepAction.m")
			}
			if (workflowStep.forwardCondition != null)
			{
				fsa.generateFile(projectFolder + "/" + workflowStep.name.toFirstUpper + "ForwardCondition.h", conditionGenerator.createConditionH(workflowStep.forwardCondition, workflowStep.name + "ForwardCondition"))
				fsa.generateFile(projectFolder + "/" + workflowStep.name.toFirstUpper + "ForwardCondition.m", conditionGenerator.createConditionM(workflowStep.forwardCondition, workflowStep.name + "ForwardCondition"))
				fileStructure.addConditionFile(workflowStep.name.toFirstUpper + "ForwardCondition.h")
				fileStructure.addConditionFile(workflowStep.name.toFirstUpper + "ForwardCondition.m")
			}
			if (workflowStep.backwardCondition != null)
			{
				fsa.generateFile(projectFolder + "/" + workflowStep.name.toFirstUpper + "BackwardCondition.h", conditionGenerator.createConditionH(workflowStep.backwardCondition, workflowStep.name + "BackwardCondition"))
				fsa.generateFile(projectFolder + "/" + workflowStep.name.toFirstUpper + "BackwardCondition.m", conditionGenerator.createConditionM(workflowStep.backwardCondition, workflowStep.name + "BackwardCondition"))
				fileStructure.addConditionFile(workflowStep.name.toFirstUpper + "BackwardCondition.h")
				fileStructure.addConditionFile(workflowStep.name.toFirstUpper + "BackwardCondition.m")
			}
		}
		
		// Generate actions
		val actionGenerator = new ActionClass(dataContainer)
		for(customAction : dataContainer.customActions)
		{
			fsa.generateFile(projectFolder + "/" + customAction.name.toFirstUpper + "Action.h" , actionGenerator.createCustomActionH(customAction))
			fsa.generateFile(projectFolder + "/" + customAction.name.toFirstUpper + "Action.m" , actionGenerator.createCustomActionM(customAction))
			fileStructure.addActionFile(customAction.name.toFirstUpper + "Action.h")
			fileStructure.addActionFile(customAction.name.toFirstUpper + "Action.m")
		}
		
		// Generate initialize application action
		fsa.generateFile(projectFolder + "/InitializeApplicationAction.m", createInitializeApplicationActionM(dataContainer))
		fileStructure.addActionFile("InitializeApplicationAction.m")
		
		// Generate custom action event class
		fsa.generateFile(projectFolder + "/SpecificAppData.h", createSpecificAppDataH(dataContainer))
		fsa.generateFile(projectFolder + "/SpecificAppData.m", createSpecificAppDataM(dataContainer))
		fileStructure.addDelegateFile("SpecificAppData.h")
		fileStructure.addDelegateFile("SpecificAppData.m")
		
		// Generate stylesheet class
		val styles = dataContainer.views.map(v | v.eAllContents.toIterable.filter(typeof(StyleAssignment))).flatten
		fsa.generateFile(projectFolder + "/DefaultStyle.h", createStyleM(styles))
		fsa.generateFile(projectFolder + "/Stylesheet.m", createStylesheetM(styles))
		fileStructure.addStylesheetFile("DefaultStyle.h")
		fileStructure.addStylesheetFile("Stylesheet.m")
		
		//Generate on condition events
		val onConditionEventGenerator = new OnConditionEventClass(dataContainer)
		val conditionGenerator2 = new ConditionClass(dataContainer)
		for(onConditionEvent : dataContainer.onConditionEvents)
		{
			fsa.generateFile(projectFolder + "/" + onConditionEvent.name.toFirstUpper + "OnConditionEvent.h", onConditionEventGenerator.createOnConditionEventH(onConditionEvent))
			fsa.generateFile(projectFolder + "/" + onConditionEvent.name.toFirstUpper + "OnConditionEvent.m", onConditionEventGenerator.createOnConditionEventM(onConditionEvent))
			fileStructure.addEventFile(onConditionEvent.name.toFirstUpper + "OnConditionEvent.h")
			fileStructure.addEventFile(onConditionEvent.name.toFirstUpper + "OnConditionEvent.m")
			
			fsa.generateFile(projectFolder + "/" + onConditionEvent.name.toFirstUpper + "Condition.h", conditionGenerator2.createConditionH(onConditionEvent.condition, onConditionEvent.name + "Condition"))
			fsa.generateFile(projectFolder + "/" + onConditionEvent.name.toFirstUpper + "Condition.m", conditionGenerator2.createConditionM(onConditionEvent.condition, onConditionEvent.name + "Condition"))
			fileStructure.addConditionFile(onConditionEvent.name.toFirstUpper + "Condition.h")
			fileStructure.addConditionFile(onConditionEvent.name.toFirstUpper + "Condition.m")
		}
		
		// Generate project file and string resources
		fsa.generateFile(projectFolder + "/Localizable_de.strings", createLocalizableStrings(dataContainer))
		fsa.generateFile(projectFolder + ".xcodeproj/project.pbxproj", new ProjectFile().generateProjectFile(new UuidProvider(24, appName), fileStructure, appName))
	}
	
	
	///////////////////////////////////////////////////////////
	// Outsourced functionality from generation workflow
	///////////////////////////////////////////////////////////
	
	def private createModel(IExtendedFileSystemAccess fsa, Entity elem, FileStructure fileStructure)
	{
		try
		{
			fsa.generateFile(projectFolder + "/" + elem.name.toFirstUpper + "Entity.h" , createModelH(elem))
			fsa.generateFile(projectFolder + "/" + elem.name.toFirstUpper + "Entity.m" , createModelM(elem))
			fileStructure.addEntityFile(elem.name.toFirstUpper + "Entity.h")
			fileStructure.addEntityFile(elem.name.toFirstUpper + "Entity.m")
		}
		catch (Exception e)
		{
			System::out.println("Error generating model class " + elem.name.toFirstUpper + "Entity. Type: " + elem.eClass.name + " (" + e.getClass().name + ": " + e.message + ")")
		}
	}
	
	def private createViewsAndControllers(IExtendedFileSystemAccess fsa, FileStructure fileStructure)
	{
		for (container : dataContainer.viewContainers)
		{
			try
			{
				fsa.generateFile(projectFolder + "/" + getName(container).toFirstUpper + "View.h" , createViewH(container))
				fsa.generateFile(projectFolder + "/" + getName(container).toFirstUpper + "View.m" , createViewM(container))
				fsa.generateFile(projectFolder + "/" + getName(container).toFirstUpper + "Controller.h" , createControllerH(container))
				fsa.generateFile(projectFolder + "/" + getName(container).toFirstUpper + "Controller.m" , createControllerM(container, dataContainer))
				
				fileStructure.addViewFile(getName(container).toFirstUpper + "View.h")
				fileStructure.addViewFile(getName(container).toFirstUpper + "View.m")
				fileStructure.addControllerFile(getName(container).toFirstUpper + "Controller.h")
				fileStructure.addControllerFile(getName(container).toFirstUpper + "Controller.m")
			}
			catch (Exception e)
			{
				System::out.println("Error generating view class " + getName(container).toFirstUpper + "View. Type: " + container.eClass.name +" (" + e.getClass().name + ": " + e.message + ")")
			}
		}
	}
	
	override getPlatformPrefix()
	{
		"ios"
	}	
}
