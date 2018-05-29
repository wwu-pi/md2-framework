package de.wwu.md2.framework.generator

import com.google.inject.Key
import de.wwu.md2.framework.MD2StandaloneSetup
import de.wwu.md2.framework.util.MD2Util
import java.io.File
import org.apache.log4j.LogManager
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.mwe.utils.StandaloneSetup
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.validation.CheckMode

class MD2TransformationRunner {
	
	private static final Logger logger = LogManager.getLogger(MD2TransformationRunner)
	/**
	 * Main program
	 */	
	def static void main(String[] args){
		if(args === null || args.size == 0) {
			println("No input models given")
			return
		}
		
		new MD2TransformationRunner().transformInput(args.get(0))
	}
	
	def transformInput(String inputPath){
		new StandaloneSetup().setPlatformUri("../");
		
		val injector = new MD2StandaloneSetup().createInjectorAndDoEMFRegistration
		val XtextResourceSet source = injector.getInstance(XtextResourceSet)
		source.addLoadOption(XtextResource.OPTION_RESOLVE_ALL, Boolean.TRUE);
		
		val rootFolder = "src-gen/input/" + inputPath
		val layers = #["/models", "/views", "/controllers", "/workflows"] // Order is important to resolve cross-references
		
		layers.forEach[
			val files = MD2Util.getFilesRecursive(new File(rootFolder + "/models"))
			
			files.forEach[
				// Load resource
				source.getResource(URI.createURI(it.toURI.toString), true)
			]
		]
		
		// Validation
		logger.info("Start validation")
		
		EcoreUtil.resolveAll(source)
		
		val validator = (source.resources.get(0) as XtextResource).getResourceServiceProvider().getResourceValidator()
		val issues = validator.validate(source.resources.get(0), CheckMode.ALL, CancelIndicator.NullImpl)
		for (issue : issues) {
			logger.error(issue.getMessage())
		}
		
		// Code Generation
		logger.info("Start generation.")
		
		val generators = injector.getInstance(Key.get(MD2Util.setOf(IPlatformGenerator)))
		val fsa = injector.getInstance(ExtendedJavaIoFileSystemAccess)
		fsa.setOutputPath("src-gen/")
		
		for(generator : generators){
			generator.doGenerate(source, fsa)
		}
		
		logger.info("Transformation done.")
	}
}