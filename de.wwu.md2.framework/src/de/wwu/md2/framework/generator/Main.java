package de.wwu.md2.framework.generator;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.Constants;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.CheckMode;
import org.eclipse.xtext.validation.IResourceValidator;
import org.eclipse.xtext.validation.Issue;

import com.google.common.collect.Sets;
import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Provider;
import com.google.inject.name.Named;

/**
 * Standalone generator for the MD2 project.
 */
public class Main {
	
	@Inject 
	private Provider<ResourceSet> resourceSetProvider;
	
	@Inject
	private IResourceValidator validator;
	
	@Inject
	Set<IPlatformGenerator> generators;
	
	@Inject 
	private ExtendedJavaIoFileSystemAccess fileAccess;
	
	@Inject @Named(Constants.FILE_EXTENSIONS)
	private String fileExtension;
	
	
	/**
	 * Entry point for standalone generation.
	 * 
	 * @param args Expects the base path for the resource files as the only parameter.
	 */
	public static void main(String[] args) {
		
		checkArgs(args);
		
		Injector injector = new de.wwu.md2.framework.MD2StandaloneSetupGenerated().createInjectorAndDoEMFRegistration();
		Main main = injector.getInstance(Main.class);
		main.runGenerator(args[0]);
	}
	
	/**
	 * Load resources from given path, validate them and generate files. If the validation
	 * of the resources fails, exit with exit code 2.
	 * 
	 * @param baseFolder Folder in which to look for the resources.
	 */
	protected void runGenerator(String baseFolder) {
		// load the resources
		ResourceSet set = resourceSetProvider.get();
		Set<Resource> resources = Sets.newHashSet();
		try {
			for (String fileName : getSourceFiles(baseFolder)) {
				Resource resource = set.getResource(URI.createURI(fileName), true);
				resources.add(resource);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
				
		// validate the resources
		for(Resource resource : resources) {
			List<Issue> list = validator.validate(resource, CheckMode.ALL, CancelIndicator.NullImpl);
			if (!list.isEmpty()) {
				for (Issue issue : list) {
					System.err.println(issue);
				}
				//System.exit(2);
			}
		}
		
		// configure and run generator for each supported platform
		fileAccess.setOutputPath("src-gen/");
		for (IPlatformGenerator generator : generators) {
			generator.doGenerate(set, fileAccess);
		}
		
		System.out.println("Code generation finished.");
	}
	
	/**
	 * Check whether the parameters are correct. If not, exit the generator with exit code 1
	 * 
	 * @param args Expects the base path for the resource files as the only parameter.
	 */
	private static void checkArgs(String[] args) {
		if (args.length==0) {
			System.err.println("Aborting: no base path for EMF resources provided!");
			System.exit(1);
		} else {
			File folder = new File(args[0]);
			if(!(folder.exists() && folder.isDirectory())) {
				System.err.println("Source folder " + folder.getAbsolutePath() + " not found.");
				System.exit(1);
			}
		}
	}
	
	/**
	 * Recursively search for resource files in the given folder.
	 *  
	 * @param folderName Folder in which to search for the model files.
	 * @return Collection of all resource files.
	 * @throws IOException
	 */
	private Collection<String> getSourceFiles(String folderName) throws IOException {
		Set<String> resultSet = Sets.newHashSet();
		File folder = new File(folderName);
		
		for (String s : folder.list()) {
			File f = new File(folder.getAbsolutePath() + '/' + s);
			String relativePath = folderName + '/' + s;
			if (f.isFile() && f.getName().endsWith("." + fileExtension)) {
				// is model file
				resultSet.add(relativePath);
			}
			else if (f.isDirectory()) {
				// recursively search all sub-directories for model files
				resultSet.addAll(getSourceFiles(relativePath));
			}
		}
		
		return resultSet;
	}
}
