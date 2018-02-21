package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import java.util.Map

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class ModelsInterfaceClass {
	
	def static String generateModelsInterface(DataContainer dataContainer) '''
		«val imports = newLinkedHashMap("declare" -> "dojo/_base/declare")»
		«val body = generateModelsInterfaceBody(dataContainer, imports)»
		define([
			«FOR key : imports.keySet SEPARATOR ","»
				"«imports.get(key)»"
			«ENDFOR»
		],
		function(«FOR key : imports.keySet SEPARATOR ", "»«key»«ENDFOR») {
			
			«body»
		});
	'''
	
	def static String generateModelsInterfaceBody(DataContainer dataContainer, Map<String, String> imports) '''
		return declare([], {
			
			/**
			 * Provide an array with instances of all model elements (entities and enums).
			 */
			createInstance: function() {
				return [
					«val snippets = newArrayList(
						generateEntityExportSnippet(dataContainer, imports),
						generateEnumExportSnippet(dataContainer, imports)
					)»
					«FOR snippet : snippets.filter(s | !s.toString.trim.empty) SEPARATOR ","»
						«snippet»
					«ENDFOR»
				];
			}
			
		});
	'''
	
	def static String generateEntityExportSnippet(DataContainer dataContainer, Map<String, String> imports) '''
		«FOR entity : dataContainer.entities SEPARATOR ","»
			«imports.put(entity.name, "./models/" + entity.name.toFirstUpper).returnVoid»
			new «entity.name»()
		«ENDFOR»
	'''
	
	def static String generateEnumExportSnippet(DataContainer dataContainer, Map<String, String> imports) '''
		«FOR md2enum : dataContainer.enums SEPARATOR ","»
			«imports.put(md2enum.name, "./models/" + md2enum.name.toFirstUpper).returnVoid»
			new «md2enum.name»()
		«ENDFOR»
	'''
}