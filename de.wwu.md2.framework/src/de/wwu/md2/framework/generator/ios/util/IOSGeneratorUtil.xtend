package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.generator.ios.Settings
import java.text.SimpleDateFormat
import java.util.Date
import java.util.HashMap

class IOSGeneratorUtil {
	
	private static HashMap<String, String> uuidMapping
	
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
	 * Get an Apple hex identifier for the element that is unique across the project
	 */
	def static getUuid(String elementName) {
		if (elementName == null) return null
		
		if(uuidMapping == null) {
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
	 * Generate a 96-bit UUID in 24-character hex representation. 
	 * This is Apple's default identifier style in project files.
	 */
	def static randomUuid() {
		val length = 24
		
		var result = ""
		val char[] digits = #['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F']
		while(result.length < length) {
			result += digits.get(Math.round(Math.random() * digits.length) as int)
		}
		return result
	}
}
