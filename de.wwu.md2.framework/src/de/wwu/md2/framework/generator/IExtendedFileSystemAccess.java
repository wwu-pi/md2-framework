package de.wwu.md2.framework.generator;

import java.io.InputStream;

import org.eclipse.xtext.generator.IFileSystemAccess;

public interface IExtendedFileSystemAccess extends IFileSystemAccess {
	
	/**
	 * Generates a file from an input stream.
	 * 
	 * @param inputStream Any input stream that should be written to the given file.
	 * @param targetFileName File name and path of the new resource.
	 */
	void generateFileFromInputStream(InputStream inputStream, String targetFileName);
	
	/**
	 * Deletes the specified directory.
	 * 
	 * @param directoryName Directory to delete.
	 */
	void deleteDirectory(String directoryName);
	
	/**
	 * Allows to copy a file or folder from within the current project to the default output environment.
	 * 
	 * @param fileName File or folder to be copied recursively
	 * @param targetFolderName Target folder relative to the default output
	 * 
	 * @return A list of all copied file names.
	 */
	Iterable<String> copyFileFromProject(String fileName, String targetFolderName);
}
