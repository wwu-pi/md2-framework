package de.wwu.md2.framework.generator.ios;

import java.util.Collection;
import java.util.Map;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

/**
 * This class stores the virtual file structure of the XCode project. These information are used
 * to generate project file. To facilitate the generation of this file, all non-generated files
 * in the iOS mock up have been annotated as static in the first line of code of each file and the
 * virtual folder has been annotated. The FileLister project (see other git repository) can be used
 * to extract the relevant information and generate code snippets for this file. 
 */
public class FileStructure
{
	// Lists for static files and folder structure
	/**
	 * Folder structure, key = folder, value = children
	 */
	public final Map<String, Collection<String>> FolderStructure = Maps.newLinkedHashMap();
	public final Map<String, String> StaticFiles = Maps.newLinkedHashMap();
	public final Collection<String> Images = Lists.newArrayList(	"arrow.png",
																	"first.png",
																	"second.png",
																	"add.png",
																	"bullet_arrow_bottom.png",
																	"bullet_arrow_down.png",
																	"bullet_go.png",
																	"calculator.png",
																	"exclamation.png",
																	"bullet_error.png",
																	"information.png",
																	"tick.png",
																	"arrow2.png");
	public final Map<String, String> Frameworks;
	public final Collection<String> LocalizableStrings = Lists.newArrayList("Localizable_de.strings");
	public final String PrefixHeader = "Prefix.pch";
	public final String InfoFile = "Info.plist";
	public final String DataModelFileFolder = "DTOs";
	
	// Lists for generated files
	public Collection<String> ModelFiles = Lists.newArrayList();
	public Collection<String> ViewFiles = Lists.newArrayList();
	public Collection<String> ControllerFiles = Lists.newArrayList();
	
	public final String RootGroupName = "[root]";
	public final String ProductsGroupName = "Products";
	
	public FileStructure(String appName)
	{
		// Initialize frameworks with paths
		Frameworks = Maps.newLinkedHashMap();
		Frameworks.put("UIKit.framework", "System/Library/Frameworks/UIKit.framework");
		Frameworks.put("Foundation.framework", "System/Library/Frameworks/Foundation.framework");
		Frameworks.put("CoreGraphics.framework", "System/Library/Frameworks/CoreGraphics.framework");
		Frameworks.put("CoreData.framework", "System/Library/Frameworks/CoreData.framework");
		Frameworks.put("CoreLocation.framework", "System/Library/Frameworks/CoreLocation.framework");
		
		// Initialize static files
		StaticFiles.put("Action.h", "Actions");
		StaticFiles.put("Action.m", "Actions");
		StaticFiles.put("AlphabeticValidator.h", "Validators");
		StaticFiles.put("AlphabeticValidator.m", "Validators");
		StaticFiles.put("AppDelegate.h", "ActionHandling");
		StaticFiles.put("AppDelegate.m", "ActionHandling");
		StaticFiles.put("AppDelegateProtocols.h", "ActionHandling");
		StaticFiles.put("AssignObjectAtContentProviderAction.h", "Actions");
		StaticFiles.put("AssignObjectAtContentProviderAction.m", "Actions");
		StaticFiles.put("AssignObjectAtContentProviderEvent.h", "Events");
		StaticFiles.put("AssignObjectAtContentProviderEvent.m", "Events");
		StaticFiles.put("ButtonWidget.h", "Widgets");
		StaticFiles.put("ButtonWidget.m", "Widgets");
		StaticFiles.put("CheckboxWidget.h", "Widgets");
		StaticFiles.put("CheckboxWidget.m", "Widgets");
		StaticFiles.put("ComboboxSelectionChangedEvent.h", "Events");
		StaticFiles.put("ComboboxSelectionChangedEvent.m", "Events");
		StaticFiles.put("ComboboxWidget.h", "Widgets");
		StaticFiles.put("ComboboxWidget.m", "Widgets");
		StaticFiles.put("Condition.h", "Conditions");
		StaticFiles.put("Condition.m", "Conditions");
		StaticFiles.put("ContentProvider.h", "ContentProviders");
		StaticFiles.put("ContentProvider.m", "ContentProviders");
		StaticFiles.put("Controller.h", "Controllers");
		StaticFiles.put("Controller.m", "Controllers");
		StaticFiles.put("CreateAction.h", "Actions");
		StaticFiles.put("CreateAction.m", "Actions");
		StaticFiles.put("CreateEvent.h", "Events");
		StaticFiles.put("CreateEvent.m", "Events");
		StaticFiles.put("CustomPickerButtonClickedEvent.h", "Events");
		StaticFiles.put("CustomPickerButtonClickedEvent.m", "Events");
		StaticFiles.put("DatabaseAccess.h", "Utility");
		StaticFiles.put("DatabaseAccess.m", "Utility");
		StaticFiles.put("DataConverter.h", "Converters");
		StaticFiles.put("DataConverter.m", "Converters");
		StaticFiles.put("DataMapper.h", "DataMappers");
		StaticFiles.put("DataMapper.m", "DataMappers");
		StaticFiles.put("DataTransferObject.h", "DTOs");
		StaticFiles.put("DataTransferObject.m", "DTOs");
		StaticFiles.put("DatePickerButtonClickedEvent.h", "Events");
		StaticFiles.put("DatePickerButtonClickedEvent.m", "Events");
		StaticFiles.put("Dimensions.h", "\"Supporting Files\"");
		StaticFiles.put("DismissPopoverControllerAction.h", "Actions");
		StaticFiles.put("DismissPopoverControllerAction.m", "Actions");
		StaticFiles.put("DismissPopoverControllerEvent.h", "Events");
		StaticFiles.put("DismissPopoverControllerEvent.m", "Events");
		StaticFiles.put("EntitySelectorPickerButtonClickedEvent.h", "Events");
		StaticFiles.put("EntitySelectorPickerButtonClickedEvent.m", "Events");
		StaticFiles.put("EntitySelectorSelectionChangedEvent.h", "Events");
		StaticFiles.put("EntitySelectorSelectionChangedEvent.m", "Events");
		StaticFiles.put("EntitySelectorWidget.h", "Widgets");
		StaticFiles.put("EntitySelectorWidget.m", "Widgets");
		StaticFiles.put("Event.h", "Events");
		StaticFiles.put("Event.m", "Events");
		StaticFiles.put("EventBindingAction.h", "Actions");
		StaticFiles.put("EventBindingAction.m", "Actions");
		StaticFiles.put("EventBindingEvent.h", "Events");
		StaticFiles.put("EventBindingEvent.m", "Events");
		StaticFiles.put("EventHandler.h", "EventHandling");
		StaticFiles.put("EventHandler.m", "EventHandling");
		StaticFiles.put("EventHandlerProtocols.h", "EventHandling");
		StaticFiles.put("EventTrigger.h", "Views");
		StaticFiles.put("EventTrigger.m", "Views");
		StaticFiles.put("EventUnbindingAction.h", "Actions");
		StaticFiles.put("EventUnbindingAction.m", "Actions");
		StaticFiles.put("EventUnbindingEvent.h", "Events");
		StaticFiles.put("EventUnbindingEvent.m", "Events");
		StaticFiles.put("ExitApplicationAction.h", "Actions");
		StaticFiles.put("ExitApplicationAction.m", "Actions");
		StaticFiles.put("ExitApplicationEvent.h", "Events");
		StaticFiles.put("ExitApplicationEvent.m", "Events");
		StaticFiles.put("Filter.h", "Filters");
		StaticFiles.put("Filter.m", "Filters");
		StaticFiles.put("FloatValidator.h", "Validators");
		StaticFiles.put("FloatValidator.m", "Validators");
		StaticFiles.put("FlowLayout.h", "Layouts");
		StaticFiles.put("FlowLayout.m", "Layouts");
		StaticFiles.put("GotoControllerAction.h", "Actions");
		StaticFiles.put("GotoControllerAction.m", "Actions");
		StaticFiles.put("GotoControllerEvent.h", "Events");
		StaticFiles.put("GotoControllerEvent.m", "Events");
		StaticFiles.put("GotoNextWorkflowStepAction.h", "Actions");
		StaticFiles.put("GotoNextWorkflowStepAction.m", "Actions");
		StaticFiles.put("GotoNextWorkflowStepEvent.h", "Events");
		StaticFiles.put("GotoNextWorkflowStepEvent.m", "Events");
		StaticFiles.put("GotoPreviousWorkflowStepAction.h", "Actions");
		StaticFiles.put("GotoPreviousWorkflowStepAction.m", "Actions");
		StaticFiles.put("GotoPreviousWorkflowStepEvent.h", "Events");
		StaticFiles.put("GotoPreviousWorkflowStepEvent.m", "Events");
		StaticFiles.put("GotoWorkflowAction.h", "Actions");
		StaticFiles.put("GotoWorkflowAction.m", "Actions");
		StaticFiles.put("GotoWorkflowEvent.h", "Events");
		StaticFiles.put("GotoWorkflowEvent.m", "Events");
		StaticFiles.put("GotoWorkflowStepAction.h", "Actions");
		StaticFiles.put("GotoWorkflowStepAction.m", "Actions");
		StaticFiles.put("GotoWorkflowStepEvent.h", "Events");
		StaticFiles.put("GotoWorkflowStepEvent.m", "Events");
		StaticFiles.put("GPSActionBinding.h", "Bindings");
		StaticFiles.put("GPSActionBinding.m", "Bindings");
		StaticFiles.put("GPSContentProvider.h", "ContentProviders");
		StaticFiles.put("GPSContentProvider.m", "ContentProviders");
		StaticFiles.put("GPSUpdateAction.h", "Actions");
		StaticFiles.put("GPSUpdateAction.m", "Actions");
		StaticFiles.put("GPSUpdateEvent.h", "Events");
		StaticFiles.put("GPSUpdateEvent.m", "Events");
		StaticFiles.put("GridLayout.h", "Layouts");
		StaticFiles.put("GridLayout.m", "Layouts");
		StaticFiles.put("HelpController.h", "Controllers");
		StaticFiles.put("HelpController.m", "Controllers");
		StaticFiles.put("HelpView.h", "Views");
		StaticFiles.put("HelpView.m", "Views");
		StaticFiles.put("ImageWidget.h", "Widgets");
		StaticFiles.put("ImageWidget.m", "Widgets");
		StaticFiles.put("InfoButtonClickedEvent.h", "Events");
		StaticFiles.put("InfoButtonClickedEvent.m", "Events");
		StaticFiles.put("InfoWidget.h", "Widgets");
		StaticFiles.put("InfoWidget.m", "Widgets");
		StaticFiles.put("InitializeApplicationEvent.h", "Events");
		StaticFiles.put("InitializeApplicationEvent.m", "Events");
		StaticFiles.put("IntegerValidator.h", "Validators");
		StaticFiles.put("IntegerValidator.m", "Validators");
		StaticFiles.put("LabelWidget.h", "Widgets");
		StaticFiles.put("LabelWidget.m", "Widgets");
		StaticFiles.put("Layout.h", "Layouts");
		StaticFiles.put("Layout.m", "Layouts");
		StaticFiles.put("LoadAction.h", "Actions");
		StaticFiles.put("LoadAction.m", "Actions");
		StaticFiles.put("LoadEvent.h", "Events");
		StaticFiles.put("LoadEvent.m", "Events");
		StaticFiles.put("LocalCreateRequest.h", "Requests");
		StaticFiles.put("LocalCreateRequest.m", "Requests");
		StaticFiles.put("LocalDeleteRequest.h", "Requests");
		StaticFiles.put("LocalDeleteRequest.m", "Requests");
		StaticFiles.put("LocalizedStringAccess.h", "Strings");
		StaticFiles.put("LocalizedStringAccess.m", "Strings");
		StaticFiles.put("LocalReadRequest.h", "Requests");
		StaticFiles.put("LocalReadRequest.m", "Requests");
		StaticFiles.put("LocalUpdateRequest.h", "Requests");
		StaticFiles.put("LocalUpdateRequest.m", "Requests");
		StaticFiles.put("main.m", "ActionHandling");
		StaticFiles.put("NotEmptyValidator.h", "Validators");
		StaticFiles.put("NotEmptyValidator.m", "Validators");
		StaticFiles.put("NumberRangeValidator.h", "Validators");
		StaticFiles.put("NumberRangeValidator.m", "Validators");
		StaticFiles.put("OnConditionEvent.h", "Events");
		StaticFiles.put("OnConditionEvent.m", "Events");
		StaticFiles.put("PersistAction.h", "Actions");
		StaticFiles.put("PersistAction.m", "Actions");
		StaticFiles.put("PersistEvent.h", "Events");
		StaticFiles.put("PersistEvent.m", "Events");
		StaticFiles.put("PickerController.h", "Controllers");
		StaticFiles.put("PickerController.m", "Controllers");
		StaticFiles.put("PickerView.h", "Views");
		StaticFiles.put("PickerView.m", "Views");
		StaticFiles.put("RegExValidator.h", "Validators");
		StaticFiles.put("RegExValidator.m", "Validators");
		StaticFiles.put("RegisterMappingAction.h", "Actions");
		StaticFiles.put("RegisterMappingAction.m", "Actions");
		StaticFiles.put("RegisterMappingEvent.h", "Events");
		StaticFiles.put("RegisterMappingEvent.m", "Events");
		StaticFiles.put("ReloadControllerAction.h", "Actions");
		StaticFiles.put("ReloadControllerAction.m", "Actions");
		StaticFiles.put("ReloadControllerEvent.h", "Events");
		StaticFiles.put("ReloadControllerEvent.m", "Events");
		StaticFiles.put("RemoteCreateRequest.h", "Requests");
		StaticFiles.put("RemoteCreateRequest.m", "Requests");
		StaticFiles.put("RemoteDeleteRequest.h", "Requests");
		StaticFiles.put("RemoteDeleteRequest.m", "Requests");
		StaticFiles.put("RemoteReadRequest.h", "Requests");
		StaticFiles.put("RemoteReadRequest.m", "Requests");
		StaticFiles.put("RemoteUpdateRequest.h", "Requests");
		StaticFiles.put("RemoteUpdateRequest.m", "Requests");
		StaticFiles.put("RemoteValidator.h", "Validators");
		StaticFiles.put("RemoteValidator.m", "Validators");
		StaticFiles.put("RemoveAction.h", "Actions");
		StaticFiles.put("RemoveAction.m", "Actions");
		StaticFiles.put("RemoveEvent.h", "Events");
		StaticFiles.put("RemoveEvent.m", "Events");
		StaticFiles.put("Request.h", "Requests");
		StaticFiles.put("Request.m", "Requests");
		StaticFiles.put("ShowCustomPickerControllerAction.h", "Actions");
		StaticFiles.put("ShowCustomPickerControllerAction.m", "Actions");
		StaticFiles.put("ShowCustomPickerControllerEvent.h", "Events");
		StaticFiles.put("ShowCustomPickerControllerEvent.m", "Events");
		StaticFiles.put("ShowDatePickerControllerAction.h", "Actions");
		StaticFiles.put("ShowDatePickerControllerAction.m", "Actions");
		StaticFiles.put("ShowDatePickerControllerEvent.h", "Events");
		StaticFiles.put("ShowDatePickerControllerEvent.m", "Events");
		StaticFiles.put("ShowHelpControllerAction.h", "Actions");
		StaticFiles.put("ShowHelpControllerAction.m", "Actions");
		StaticFiles.put("ShowHelpControllerEvent.h", "Events");
		StaticFiles.put("ShowHelpControllerEvent.m", "Events");
		StaticFiles.put("SpacerWidget.h", "Widgets");
		StaticFiles.put("SpacerWidget.m", "Widgets");
		StaticFiles.put("StringRangeValidator.h", "Validators");
		StaticFiles.put("StringRangeValidator.m", "Validators");
		StaticFiles.put("StylesheetCategory.h", "Style");
		StaticFiles.put("StylesheetCategory.m", "Style");
		StaticFiles.put("SwitchValueChangedEvent.h", "Events");
		StaticFiles.put("SwitchValueChangedEvent.m", "Events");
		StaticFiles.put("TableLayout.h", "Layouts");
		StaticFiles.put("TableLayout.m", "Layouts");
		StaticFiles.put("TextFieldEditingChangedEvent.h", "Events");
		StaticFiles.put("TextFieldEditingChangedEvent.m", "Events");
		StaticFiles.put("TextFieldWidget.h", "Widgets");
		StaticFiles.put("TextFieldWidget.m", "Widgets");
		StaticFiles.put("UnregisterMappingAction.h", "Actions");
		StaticFiles.put("UnregisterMappingAction.m", "Actions");
		StaticFiles.put("UnregisterMappingEvent.h", "Events");
		StaticFiles.put("UnregisterMappingEvent.m", "Events");
		StaticFiles.put("Utilities.h", "Utility");
		StaticFiles.put("Utilities.m", "Utility");
		StaticFiles.put("Validator.h", "Validators");
		StaticFiles.put("Validator.m", "Validators");
		StaticFiles.put("ValidatorBindingAction.h", "Actions");
		StaticFiles.put("ValidatorBindingAction.m", "Actions");
		StaticFiles.put("ValidatorBindingEvent.h", "Events");
		StaticFiles.put("ValidatorBindingEvent.m", "Events");
		StaticFiles.put("ValidatorUnbindingAction.h", "Actions");
		StaticFiles.put("ValidatorUnbindingAction.m", "Actions");
		StaticFiles.put("ValidatorUnbindingEvent.h", "Events");
		StaticFiles.put("ValidatorUnbindingEvent.m", "Events");
		StaticFiles.put("View.h", "Views");
		StaticFiles.put("View.m", "Views");
		StaticFiles.put("ViewEvent.h", "Events");
		StaticFiles.put("ViewEvent.m", "Events");
		StaticFiles.put("Widget.h", "Widgets");
		StaticFiles.put("Widget.m", "Widgets");
		StaticFiles.put("WidgetFactory.h", "Widgets");
		StaticFiles.put("WidgetFactory.m", "Widgets");
		StaticFiles.put("WidgetValidation.h", "Validation");
		StaticFiles.put("WidgetValidation.m", "Validation");
		StaticFiles.put("Workflow.h", "Workflows");
		StaticFiles.put("Workflow.m", "Workflows");
		StaticFiles.put("WorkflowManagement.h", "Workflows");
		StaticFiles.put("WorkflowManagement.m", "Workflows");
		StaticFiles.put("WorkflowStep.h", "Workflows");
		StaticFiles.put("WorkflowStep.m", "Workflows");
		StaticFiles.put("WriteCheckboxValueAction.h", "Actions");
		StaticFiles.put("WriteCheckboxValueAction.m", "Actions");
		StaticFiles.put("WriteCheckboxValueEvent.h", "Events");
		StaticFiles.put("WriteCheckboxValueEvent.m", "Events");
		StaticFiles.put("WriteComboBoxSelectionAction.h", "Actions");
		StaticFiles.put("WriteComboBoxSelectionAction.m", "Actions");
		StaticFiles.put("WriteComboBoxSelectionEvent.h", "Events");
		StaticFiles.put("WriteComboBoxSelectionEvent.m", "Events");
		StaticFiles.put("WriteEntitySelectorSelectionAction.h", "Actions");
		StaticFiles.put("WriteEntitySelectorSelectionAction.m", "Actions");
		StaticFiles.put("WriteEntitySelectorSelectionEvent.h", "Events");
		StaticFiles.put("WriteEntitySelectorSelectionEvent.m", "Events");
		StaticFiles.put("WriteTextFieldTextAction.h", "Actions");
		StaticFiles.put("WriteTextFieldTextAction.m", "Actions");
		StaticFiles.put("WriteTextFieldTextEvent.h", "Events");
		StaticFiles.put("WriteTextFieldTextEvent.m", "Events");
		
		// Initialize folder structure, key = folder, value = children
		// Initializes children collections for folders and folder structure (sub folders)
		FolderStructure.put("Events", Lists.<String>newArrayList());
		FolderStructure.put("Style", Lists.<String>newArrayList());
		FolderStructure.put("Strings", Lists.<String>newArrayList());
		FolderStructure.put("Images", Lists.<String>newArrayList());
		FolderStructure.put(RootGroupName, Lists.newArrayList(appName, "Frameworks", "Products"));
		FolderStructure.put(ProductsGroupName, Lists.newArrayList(appName + ".app"));
		FolderStructure.put("Frameworks", Lists.<String>newArrayList());
		FolderStructure.put(appName, Lists.newArrayList("Model", "Controllers", "Views", "\"Supporting Files\""));
		FolderStructure.put("\"Supporting Files\"", Lists.newArrayList("Bindings", "Converters", "Resources"));
		FolderStructure.put("ActionHandling", Lists.newArrayList("Actions"));
		FolderStructure.put("Workflows", Lists.newArrayList("Conditions"));
		FolderStructure.put("Conditions", Lists.<String>newArrayList());
		FolderStructure.put("Resources", Lists.newArrayList("Images", "Strings", "Style"));
		FolderStructure.put("Widgets", Lists.<String>newArrayList());
		FolderStructure.put("DTOs", Lists.<String>newArrayList());
		FolderStructure.put("Filters", Lists.<String>newArrayList());
		FolderStructure.put("Requests", Lists.<String>newArrayList());
		FolderStructure.put("Utility", Lists.<String>newArrayList());
		FolderStructure.put("Views", Lists.newArrayList("Layouts", "Widgets"));
		FolderStructure.put("DataMappers", Lists.<String>newArrayList());
		FolderStructure.put("Layouts", Lists.<String>newArrayList());
		FolderStructure.put("EventHandling", Lists.newArrayList("Events"));
		FolderStructure.put("Model", Lists.newArrayList("DTOs"));
		FolderStructure.put("Validation", Lists.newArrayList("Validators"));
		FolderStructure.put("Validators", Lists.<String>newArrayList());
		FolderStructure.put("Controllers", Lists.newArrayList("ActionHandling", "ContentProviders", "DataMappers", "EventHandling", "Validation", "Workflows"));
		FolderStructure.put("Bindings", Lists.<String>newArrayList());
		FolderStructure.put("Converters", Lists.<String>newArrayList());
		FolderStructure.put("ContentProviders", Lists.<String>newArrayList("Filters", "Requests", "Utility"));
		FolderStructure.put("Actions", Lists.<String>newArrayList());
		
		// Add the static lists
		for (Map.Entry<String, String> currentFile : StaticFiles.entrySet())
			FolderStructure.get(currentFile.getValue()).add(currentFile.getKey());
		
		FolderStructure.get("Images").addAll(Images);
		FolderStructure.get("Frameworks").addAll(Frameworks.keySet());
		FolderStructure.get("Strings").addAll(LocalizableStrings);
		
		FolderStructure.get("\"Supporting Files\"").add(PrefixHeader);
	}
	
	public void addEntityFile(String file)
	{
		ModelFiles.add(file);
		FolderStructure.get("DTOs").add(file);
	}
	public void addFilterFile(String file)
	{
		ModelFiles.add(file);
		FolderStructure.get("Filters").add(file);
	}
	
	public void addContentProviderFile(String file)
	{
		ModelFiles.add(file);
		FolderStructure.get("ContentProviders").add(file);
	}
	
	public void addControllerFile(String file)
	{
		ControllerFiles.add(file);
		FolderStructure.get("Controllers").add(file);
	}
	
	public void addDelegateFile(String file)
	{
		ControllerFiles.add(file);
		FolderStructure.get("ActionHandling").add(file);
	}
	
	public void addActionFile(String file)
	{
		ControllerFiles.add(file);
		FolderStructure.get("Actions").add(file);
	}
	
	public void addConditionFile(String file)
	{
		ControllerFiles.add(file);
		FolderStructure.get("Conditions").add(file);
	}
	
	public void addEventFile(String file)
	{
		ControllerFiles.add(file);
		FolderStructure.get("Events").add(file);
	}
	
	public void addViewFile(String file)
	{
		ViewFiles.add(file);
		FolderStructure.get("Views").add(file);
	}
	
	public void addStylesheetFile(String file)
	{
		ViewFiles.add(file);
		FolderStructure.get("Style").add(file);
	}
	
	public void addImageFile(String file)
	{
		Images.add(file);
		FolderStructure.get("Images").add(file);
	}
	
	public Iterable<String> getFilesToCopy()
	{
		Collection<String> filesToCopy = Lists.newArrayList();
		filesToCopy.addAll(StaticFiles.keySet());
		filesToCopy.addAll(Images);
		filesToCopy.add(PrefixHeader);
		filesToCopy.add(InfoFile);
		
		return filesToCopy;
	}
	
	public Iterable<String> getSourceFilesToBuild(boolean justCode)
	{
		Collection<String> sourceFilesToBuild = Lists.newArrayList();
		insertFilesWithSuffix(StaticFiles.keySet(), sourceFilesToBuild, ".m");
		insertFilesWithSuffix(ModelFiles, sourceFilesToBuild, ".m");
		insertFilesWithSuffix(ViewFiles, sourceFilesToBuild, ".m");
		insertFilesWithSuffix(ControllerFiles, sourceFilesToBuild, ".m");
		if(!justCode)
		{
			sourceFilesToBuild.addAll(Frameworks.keySet());
			sourceFilesToBuild.addAll(LocalizableStrings);
			sourceFilesToBuild.addAll(Images);
		}
		
		return sourceFilesToBuild;
	}
	
	public Iterable<String> getProjectCodeFiles()
	{
		Collection<String> projectFiles = Lists.newArrayList();
		projectFiles.addAll(StaticFiles.keySet());
		projectFiles.addAll(ModelFiles);
		projectFiles.addAll(ViewFiles);
		projectFiles.addAll(ControllerFiles);
		
		return projectFiles;
	}
	
	private void insertFilesWithSuffix(Iterable<String> sourceIterable, Collection<String> targetCollection, String fileSuffix)
	{
		for (String currentFile : sourceIterable)
		{
			if(currentFile.endsWith(fileSuffix))
			{
				targetCollection.add(currentFile);
			}
		}
	}
}
