package de.wwu.md2.framework.generator

import com.google.inject.Key
import de.wwu.md2.framework.MD2StandaloneSetup
import de.wwu.md2.framework.util.MD2Util
import java.io.File
import org.apache.log4j.LogManager
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
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
		new MD2TransformationRunner().transformInput(args.get(0))
	}
	
	def transformInput(String inputPath){
		new StandaloneSetup().setPlatformUri("../");
		
		val injector = new MD2StandaloneSetup().createInjectorAndDoEMFRegistration
		val XtextResourceSet source = injector.getInstance(XtextResourceSet)
		source.addLoadOption(XtextResource.OPTION_RESOLVE_ALL, Boolean.TRUE);
		
		val rootFolder = new File("src-gen/input/" + inputPath)
		
		val files = MD2Util.getFilesRecursive(rootFolder)
		
		logger.info("Start transformation")
		
		files.forEach[
			// Load resource
			val res = source.getResource(URI.createURI(it.toURI.toString), true)
			//md2Model.modelLayer res.contents.get(0)
			
			// Validation
			val validator = (res as XtextResource).getResourceServiceProvider().getResourceValidator()
			val issues = validator.validate(res, CheckMode.ALL, CancelIndicator.NullImpl)
			for (issue : issues) {
				logger.error(issue.getMessage())
			}
		]
		
		// Code Generation
		val generators = injector.getInstance(Key.get(MD2Util.setOf(IPlatformGenerator)))
		val fsa = injector.getInstance(ExtendedJavaIoFileSystemAccess)
		fsa.setOutputPath("src-gen/")
		
		logger.info("Start generation.")
		
		for(generator : generators){
			generator.doGenerate(source, fsa)
		}
		
		logger.info("Transformation done.")
	}
}