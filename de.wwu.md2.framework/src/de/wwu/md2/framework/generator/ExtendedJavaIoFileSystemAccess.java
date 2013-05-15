package de.wwu.md2.framework.generator;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collection;

import org.eclipse.xtext.generator.JavaIoFileSystemAccess;

import com.google.common.collect.Sets;

public class ExtendedJavaIoFileSystemAccess extends JavaIoFileSystemAccess implements IExtendedFileSystemAccess {
	
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
		
		// copy file
		File file = getFile(targetFileName, outputConfiguration);
		try {
			createFolder(file.getParentFile());
			
			OutputStream out = new FileOutputStream(file);
			
			int read = 0;
			byte[] bytes = new byte[1024];
		 
			while ((read = inputStream.read(bytes)) != -1) {
				out.write(bytes, 0, read);
			}
		 
			inputStream.close();
			out.flush();
			out.close();
			
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
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
		File file = getFile(directoryName, outputConfiguration);
		try {
			deleteDirectory(file);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public Collection<String> copyFileFromProject(String fileName, String targetFolderName) {
		File source = getFile(fileName.replaceAll("^/", ""), DEFAULT_OUTPUT);
		File target = getFile(fileName.replaceAll("^/", ""), DEFAULT_OUTPUT);
		
		try {
			return copyDirectory(source, target);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	/**
	 * Recursively copy a file or directory.
	 * 
	 * @param sourceLocation
	 * @param targetLocation
	 * @throws IOException
	 */
	private Collection<String> copyDirectory(File sourceLocation , File targetLocation) throws IOException {
		
		Collection<String> copiedFiles = Sets.newHashSet();
		
		if (sourceLocation.isDirectory()) {
	    	if (!targetLocation.exists()) {
	    		targetLocation.mkdir();
	    	}
	    	
	    	String[] children = sourceLocation.list();
	    	for (int i = 0; i < children.length; i++) {
	    		copiedFiles.addAll(copyDirectory(new File(sourceLocation, children[i]), new File(targetLocation, children[i])));
	    	}
	    }
	    else {
	    	InputStream in = new FileInputStream(sourceLocation);
	    	OutputStream out = new FileOutputStream(targetLocation);
	    	
	    	// Copy the bits from instream to outstream
	    	byte[] buf = new byte[1024];
	    	int len;
	    	while ((len = in.read(buf)) > 0) {
	    		out.write(buf, 0, len);
	    	}
	    	in.close();
	    	out.close();
	    	
	    	copiedFiles.add(targetLocation.getName());
	    }
		
		return copiedFiles;
	}
	
	/**
	 * If the directory is not empty, it is necessary to first recursively
	 * delete all files and subdirectories in the directory.
	 * 
	 * @param file File to be deleted.
	 */
	private void deleteDirectory(File file) throws IOException {
		if(file.isDirectory()) {
			for(File f : file.listFiles()) {
	            deleteDirectory(f);
	        }
	    }
		
		if(!file.delete()) {
			throw new IOException("Could not delete " + file);
		}
	}
}
