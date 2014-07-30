package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer

class EntityInterfaceClass {
	
	def static String generateEntityInterface(DataContainer dataContainer) '''
		define([
			«val imports = newArrayList('''"dojo/_base/declare"''', generateEntityImports(dataContainer))»
			«FOR importStr : imports.filter(s | !s.toString.trim.empty) SEPARATOR ","»
				«importStr»
			«ENDFOR»
		],
		function(
			«val importParams = newArrayList("declare", generateEntityImportParams(dataContainer))»
			«FOR paramStr : importParams.filter(s | !s.toString.trim.empty) SEPARATOR ","»
				«paramStr»
			«ENDFOR»
		) {
			
			return declare([], {
				
				/**
				 * Provide an array with instances of all entities.
				 */
				createInstance: function() {
					return [
						«FOR entity : dataContainer.entities SEPARATOR ","»
							 new «entity.name»()
						«ENDFOR»
					];
				}
				
			});
		});
	'''
	
	private def static generateEntityImports(DataContainer dataContainer) '''
		«FOR entity : dataContainer.entities SEPARATOR ","»
			"./entities/«entity.name.toFirstUpper»"
		«ENDFOR»
	'''
	
	private def static generateEntityImportParams(DataContainer dataContainer) '''
		«FOR entity : dataContainer.entities SEPARATOR ","»
			«entity.name»
		«ENDFOR»
	'''
}