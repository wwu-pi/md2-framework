package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.generator.ios.Settings
import java.text.SimpleDateFormat
import java.util.Date
import java.util.HashMap

/**
 * Utility functions for the iOS generator.
 */
class IOSGeneratorUtil {
	
	/**
	 * A map of references (e.g. objects, files, etc.) and the generated Apple-UUID value. 
	 */
	private static HashMap<String, String> uuidMapping
	
	/**
	 * Output a common class header for all generated files.
	 * 
	 * @param The Swift class name to generate a header for.
	 * @param generatorClass The Xtend class in which the file is generated (to lookup its origin).
	 * @return The Swift header comment content.
	 */
	def static generateClassHeaderComment(String generatedClassName, Class<?> generatorClass) '''
//
//  «generatedClassName».swift
//
//  Generated code by class '«generatorClass.simpleName»' on «new SimpleDateFormat(Settings.GENERATION_DATE_FORMAT).format(new Date())»
//
// 	iOS generator for MD2 (version «Settings.GENERATOR_VERSION») written by «Settings.GENERATOR_AUTHOR» on «Settings.GENERATOR_DATE» 
//
	'''
	
	/**
	 * Output debugging information in the Java console during the generation process.
	 * 
	 * @param message The message to generate.
	 * @param withSeparator Whether the message should be visually separated from the previous messages. 
	 */
	def static printDebug(String message, Boolean withSeparator) {
		if(Settings.PRINT_DEBUG_INFO) {
			if (withSeparator)  println("\n/**************************************************")
			
			println(message)
			
			if (withSeparator) println("**************************************************/")
		}
	}
	
	/**
	 * Output debugging information in the Java console during the generation process.
	 * 
	 * @param message The message to generate. 
	 */
	def static printDebug(String message) {
		printDebug(message, false)
	}
	
	/**
	 * Output debugging information in the Java console during the generation process.
	 * 
	 * @param message The message to generate.
	 * @param path A path that relates to message. 
	 */
	def static printDebug(String message, String path) {
		printDebug(message + " (" + path.replace(Settings.ROOT_FOLDER, "").replace("\\","/") + ")", false)
	}
	
	/**
	 * Output debugging information in the Java console during the generation process.
	 * 
	 * @param message The warning to generate. 
	 */
	def static printWarning(String message) {
		System.err.println("WARNING: " + message)
	}
	
	/**
	 * Output debugging information in the Java console during the generation process.
	 * 
	 * @param message The error to generate.
	 */
	def static printError(String message) {
		System.err.println("ERROR: " + message)
	}
	
	/**
	 * Generate a random 7-digit numeric identifier.
	 * 
	 * @return The Id.
	 */
	def static String randomId() {
		return ((Math.random() * 1000000) as int).toString
	}
	
	/**
	 * Get an Apple hex identifier for the element (e.g. objects, files, etc.) 
	 * that is unique across the project.
	 * 
	 * @param elementName The element name for which the UUID is generated.
	 * @return The UUID.
	 */
	def static getUuid(String elementName) {
		if (elementName === null) return null
		
		if(uuidMapping === null) {
			uuidMapping = newHashMap
		}
		
		// Element is already known
		if(uuidMapping.containsKey(elementName)) {
			return uuidMapping.get(elementName)
		}

		// Generate unique Id
		var String newId = randomUuid()
		while(newId.startsWith('59') || uuidMapping.containsValue(newId)) { // Check prefix to avoid collisions with library IDs
			newId = randomUuid()
		}
		uuidMapping.put(elementName, newId)
		return newId
	}
	
	/**
	 * Generate a new, not yet used 96-bit UUID in 24-character hex representation. 
	 * This is Apple's default identifier style in project files.
	 * 
	 * @return The UUID.
	 */
	def static randomUuid() {
		val length = 24
		
		var result = ""
		val char[] digits = #['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F']
		while(result.length < length) {
			result += digits.get(Math.round(Math.random() * (digits.length - 1)) as int)
		}
		return result
	}
}
