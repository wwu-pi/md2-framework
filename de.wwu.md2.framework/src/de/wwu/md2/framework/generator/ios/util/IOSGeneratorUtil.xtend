package de.wwu.md2.framework.generator.ios.util

import de.wwu.md2.framework.generator.ios.Settings
import java.util.Date
import java.text.SimpleDateFormat

class IOSGeneratorUtil {
	
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
	
}