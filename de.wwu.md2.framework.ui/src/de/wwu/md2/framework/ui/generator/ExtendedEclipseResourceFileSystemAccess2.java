package de.wwu.md2.framework.ui.generator;

import java.io.InputStream;
import java.util.Collection;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.OperationCanceledException;
import org.eclipse.core.runtime.Path;
import org.eclipse.xtext.builder.EclipseResourceFileSystemAccess2;
import org.eclipse.xtext.generator.OutputConfiguration;

import com.google.common.collect.Sets;

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess;

public class ExtendedEclipseResourceFileSystemAccess2
					extends EclipseResourceFileSystemAccess2 implements IExtendedFileSystemAccess {
	
	private IFileCallback callBack;
	private IProject project;
	
	@Override
	public void setPostProcessor(IFileCallback callBack) {
		this.callBack = callBack;
		super.setPostProcessor(callBack);
	}
	
	@Override
	public void setProject(IProject project) {
		this.project = project;
		super.setProject(project);
	}
	
	@Override
	public void generateFileFromInputStream(InputStream inputStream, String targetFileName) {
		generateFileFromInputStream(inputStream, targetFileName, DEFAULT_OUTPUT);
	}
	
	/**
	 * Generates a file from an input stream.
	 * 
	 * @param inputStream Any input stream that should be written to the given file.
	 * @param targetFileName File name and path of the new resource.
	 * @param outputConfiguration Output configuration.
	 */
	public void generateFileFromInputStream(InputStream inputStream, String targetFileName, String outputConfiguration) {
		if (getMonitor().isCanceled())
			throw new OperationCanceledException();
		OutputConfiguration outputConfig = getOutputConfig(outputConfiguration);
		
		// check output folder exists
		IFolder folder = getFolder(outputConfig);
		if (!folder.exists()) {
			if (outputConfig.isCreateOutputDirectory()) {
				try {
					createFolder(folder);
				} catch (CoreException e) {
					throw new RuntimeException(e);
				}
			} else {
				return;
			}
		}
		
		// copy file
		IFile file = getFile(targetFileName, outputConfiguration);
		if (file.exists()) {
			if (outputConfig.isOverrideExistingResources()) {
				try {					
					file.setContents(inputStream, true, true, getMonitor());
					if (file.isDerived() != outputConfig.isSetDerivedProperty()) {
						file.setDerived(outputConfig.isSetDerivedProperty(), getMonitor());
					}
				} catch (CoreException e) {
					throw new RuntimeException(e);
				}
				callBack.afterFileUpdate(file);
			}
		} else {
			try {
				ensureParentExists(file);
				file.create(inputStream, true, getMonitor());
				if (outputConfig.isSetDerivedProperty()) {
					file.setDerived(true, getMonitor());
				}
			} catch (CoreException e) {
				throw new RuntimeException(e);
			}
			callBack.afterFileCreation(file);
		}
	}
	
	@Override
	public Collection<String> copyFileFromProject(String fileName, String targetFolderName) {
		OutputConfiguration outputConfiguration = getOutputConfig(DEFAULT_OUTPUT);
		IResource sourceResource = project.findMember(new Path(fileName));
		IPath outputPath = new Path(outputConfiguration.getOutputDirectory() + "/"
				+ targetFolderName.replaceAll("^/", ""));
		
		// Check of sourceResource exists
		if (sourceResource == null) return null;
		
		// check output folder exists
		IFolder folder = getFolder(outputConfiguration);
		if (!folder.exists()) {
			if (outputConfiguration.isCreateOutputDirectory()) {
				try {
					createFolder(folder);
				} catch (CoreException e) {
					throw new RuntimeException(e);
				}
			} else {
				return null;
			}
		}
		
		// ensure target folder exists
		IFolder outputFolder = project.getFolder(outputPath.removeLastSegments(1));
		if (!outputFolder.exists()) {
			try {
				createFolder(outputFolder);
			} catch (CoreException e) {
				throw new RuntimeException(e);
			}
		}
		
		// copy
		try {
			sourceResource.copy(outputPath.makeRelativeTo(project.getFullPath()), true, getMonitor());
			return getAllFileNames(sourceResource);
		} catch (CoreException e) {
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * Collect all file names of the files in a folder (recursive).
	 * @return
	 */
	private Collection<String> getAllFileNames(IResource resource) {
		Collection<String> fileNames = Sets.newHashSet();
		if(resource.getType() == IResource.FILE) {
			fileNames.add(((IFile)resource).getName());
		} else if(resource.getType() == IResource.FOLDER) {
			try {
				for(IResource res : ((IFolder)resource).members()) {
					if(res.getType() == IResource.FILE) {
						fileNames.add(((IFile)res).getName());
					} else if(res.getType() == IResource.FOLDER) {
						fileNames.addAll(getAllFileNames(res));
					}
				}
			} catch (CoreException e) {
				e.printStackTrace();
			}
		}
		return fileNames;
	}
	
	@Override
	public void deleteDirectory(String directoryName) {
		deleteDirectory(directoryName, DEFAULT_OUTPUT);
	}
	
	/**
	 * Deletes the specified directory.
	 * 
	 * @param directoryName Directory to delete.
	 * @param outputConfiguration Output configuration.
	 */
	public void deleteDirectory(String directoryName, String outputConfiguration) {
		
		if (getMonitor().isCanceled())
			throw new OperationCanceledException();
		OutputConfiguration outputConfig = getOutputConfig(outputConfiguration);
		
		try {
			directoryName = directoryName.replaceAll("^/", "");
			IFolder folder = getFolder(outputConfig);
			if(!directoryName.isEmpty()) {
				folder = folder.getFolder(directoryName);
			}
			folder.delete(IResource.KEEP_HISTORY, getMonitor());
		} catch (CoreException e) {
			throw new RuntimeException(e);
		}
	}
}
