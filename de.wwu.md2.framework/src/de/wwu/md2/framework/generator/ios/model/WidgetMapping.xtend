package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.impl.ViewImpl

class WidgetMapping {
	
	static def generateClass(View view) '''
	TODO
	«view.viewElements.length»
	'''
	
	// Lookup real widget name for 
	def static lookup(AbstractViewGUIElementRef ref) {
		return buildRecursive(ref.ref)
	}
	
	def static String buildRecursive(ViewElementType ref) {
		if(ref.eContainer instanceof ViewImpl) {
			// Stop
			return ref.name
		} else {
			return buildRecursive(ref.eContainer as ViewElementType) + "_" + ref.name 
		}
	}
	
}