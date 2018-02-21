package de.wwu.md2.framework.generator;

import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.generator.IFileSystemAccess;

import de.wwu.md2.framework.generator.preprocessor.MD2Preprocessor;
import de.wwu.md2.framework.generator.util.DataContainer;
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil;

/**
 * Abstract platform generator.
 * Implements methods that can be utilized by all platform generators.
 */
public abstract class AbstractPlatformGenerator implements IPlatformGenerator {
	
	/**
	 * DataContainer, which contains all collections of model elements
	 */
	protected DataContainer dataContainer;
	protected ResourceSet processedInput;

	protected String rootFolder;
	protected String basePackageName;
	
	@Override
	public void doGenerate(ResourceSet input, IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Setup
		/////////////////////////////////////////
		
		// Pre process model (M2M transformation)
		// Note: input is not being passed back to concrete Xtend generator classes (parameters are final by default)
		processedInput = MD2Preprocessor.getPreprocessedModel(input);
		
		// Initialize DataContainer
		dataContainer = new DataContainer(processedInput);
		
		// Extract base package name
		basePackageName = MD2GeneratorUtil.getBasePackageName(processedInput) + '.' + getPlatformPrefix();
		
		// Extend the root folder with a default sub-folder to which all files are generated
		rootFolder = (getDefaultSubfolder() != null) ? basePackageName + "/" + getDefaultSubfolder() : basePackageName;
		
		
		/////////////////////////////////////////
		// Feasibility check
		/////////////////////////////////////////
		
		// Check whether a main block has been defined. Otherwise do not run the generator.
		if (dataContainer.main == null) {
			System.out.println("No main block found. Quit gracefully.");
			return;
		}
		
		
		/////////////////////////////////////////
		// Clean current project folder
		/////////////////////////////////////////
		
		fsa.deleteDirectory(basePackageName);
		
		
		/////////////////////////////////////////
		// Trigger actual generation process
		/////////////////////////////////////////
		
		doGenerate(fsa);
	}
	
	@Override
	public String getPlatformPrefix() {
		return this.getClass().getCanonicalName();
	}
	
	@Override
	public void doGenerate(Resource input, IFileSystemAccess fsa) {
		throw new UnsupportedOperationException("Use the following method instead: " +
				"doGenerate(ResourceSet input, IExtendedFileSystemAccess fsa)");
	}
	
	/**
	 * Specify the name of a default sub-folder of the root folder to which all files are generated.
	 * Is supposed to be overwritten by the actual generator implementation if a sub-folder should be used.
	 * 
	 * @return File name of the sub folder or null if no sub folder should be used.
	 */
	public String getDefaultSubfolder() {
		return null;
	}
	
	/**
	 * Actual generator method that is supposed to be implemented by the concrete generators.
	 * @param fsa
	 */
	public abstract void doGenerate(IExtendedFileSystemAccess fsa);
	
}
