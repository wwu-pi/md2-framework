package de.wwu.md2.framework.generator;

import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.generator.IGenerator;

/**
 * Platform generator interface.
 */
public interface IPlatformGenerator extends IGenerator {
	
	/**
	 * Enable code generation for multiple input models (resources).
	 * 
	 * @param input - A set of model resources for which to generate the code.
	 * @param fsa - File system access to be used to generate files.
	 */
	public void doGenerate(ResourceSet input, IExtendedFileSystemAccess fsa);
	
	/**
	 * This method provides a platform prefix to distinguish generators for different
	 * target platforms.
	 * 
	 * @return Platform prefix string.
	 */
	public String getPlatformPrefix();
	
}
