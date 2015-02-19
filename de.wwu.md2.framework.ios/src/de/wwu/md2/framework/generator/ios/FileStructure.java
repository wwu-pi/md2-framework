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
	public final Collection<String> Images = Lists.newArrayList();
	public final Collection<String> ImagesFromLibrary = Lists.newArrayList(	"arrow.png",
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
		StaticFiles.put("main.m", "ActionHandling");
		
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
		FolderStructure.get("Images").addAll(ImagesFromLibrary);
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
			sourceFilesToBuild.addAll(ImagesFromLibrary);
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
