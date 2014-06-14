package de.wwu.md2.framework.generator;

import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.generator.IFileSystemAccess;

import de.wwu.md2.framework.generator.util.DataContainer;
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil;
import de.wwu.md2.framework.generator.util.preprocessor.PreprocessModel;
import de.wwu.md2.framework.mD2.MD2Factory;
import de.wwu.md2.framework.mD2.impl.MD2FactoryImpl;

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

	protected String basePackageName;
	protected MD2Factory factory;
	
	@Override
	public String getPlatformPrefix() {
		return this.getClass().getCanonicalName();
	}
	
	@Override
	public void doGenerate(Resource input, IFileSystemAccess fsa) {
		throw new UnsupportedOperationException("Use the following method instead: " +
				"doGenerate(ResourceSet input, IExtendedFileSystemAccess fsa)");
	}
	
	@Override
	public void doGenerate(ResourceSet input, IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Setup
		/////////////////////////////////////////
		
		// Set factory
		factory = new MD2FactoryImpl();
		
		// Pre process model (M2M transformation)
		// Note: input is not being passed back to concrete Xtend generator classes (parameters are final by default)
		processedInput = PreprocessModel.preprocessModel(factory, input);
		
		// Initialize DataContainer
		dataContainer = new DataContainer(processedInput);
		
		// Extract base package name
		basePackageName = MD2GeneratorUtil.getBasePackageName(processedInput) + '.' + getPlatformPrefix();
		
		// trigger actual generation process
		doGenerate(fsa);
	}
	
	public abstract void doGenerate(IExtendedFileSystemAccess fsa);
	
}
