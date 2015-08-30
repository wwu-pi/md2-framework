package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.generator.ios.Settings
import java.util.Date
import java.text.SimpleDateFormat
import java.util.HashMap
import org.eclipse.xtext.naming.IQualifiedNameProvider
import de.wwu.md2.framework.mD2.Action

class IOSGeneratorUtil {
	
	private static IQualifiedNameProvider qualifiedNameProvider
	private static HashMap<String, String> qualifiedNameToNameMapping
	
	def static generateClassHeaderComment(String generatedClassName, Class generatorClass) '''
//
//  «generatedClassName».swift
//
//  Generated code by class '«generatorClass.simpleName»' on «new SimpleDateFormat(Settings.GENERATION_DATE_FORMAT).format(new Date())»
//
// 	iOS generator for MD2 (version «Settings.GENERATOR_VERSION») written by «Settings.GENERATOR_AUTHOR» on «Settings.GENERATOR_DATE» 
//
	'''
	
	// Output information during generation process
	def static printDebug(String message, Boolean withSeparator) {
		if(Settings.PRINT_DEBUG_INFO) {
			if (withSeparator)  println("\n/**************************************************")
			
			println(message)
			
			if (withSeparator) println("**************************************************/")
		}
	}
	
	def static printDebug(String message) {
		printDebug(message, false)
	}
	
	def static printDebug(String message, String path) {
		printDebug(message + " (" + path.replace(Settings.ROOT_FOLDER, "").replace("\\","/") + ")", false)
	}
	
	def static printWarning(String message) {
		System.err.println("WARNING: " + message)
	}
	
	def static printError(String message) {
		System.err.println("ERROR: " + message)
	}
	
	def static String randomId() {
		return ((Math.random() * 1000000) as int).toString
	}
	
	/**
	 * Returns the name of the given Action. In case that there is a second Action with the
	 * same name in another scope (the element has another fully qualified name), the name is extended
	 * by a number.
	 * 
	 * @return A name that identifies the view element uniquely or null if the parameter was null.
	 */
	def static getName(Action obj) {
		
		return obj.name.toFirstUpper
		
		/* This does not yet work because actions are sometimes copied during preprocessing and are 
		 * then treated as separate actions!!
		 * /
		if (obj == null) {
			return null
		}
		
		if(qualifiedNameProvider == null) {
			qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider
		}
		if(qualifiedNameToNameMapping == null) {
			qualifiedNameToNameMapping = newHashMap
		}
		
		var name = obj.name
		val qualifiedName = qualifiedNameProvider.getFullyQualifiedName(obj).toString
		
		if(!qualifiedNameToNameMapping.containsKey(qualifiedName)) {
			var int i = 0
			while(qualifiedNameToNameMapping.containsValue(name + if(i != 0) i else "")) {
				i = i + 1
			}
			qualifiedNameToNameMapping.put(qualifiedName, name + if(i != 0) i else "")
		}
		
		qualifiedNameToNameMapping.get(qualifiedName)*/
	}
	
}