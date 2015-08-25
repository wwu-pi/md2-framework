package de.wwu.md2.framework.generator.android.lollipop.util

import com.google.common.base.Joiner
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.SimpleType

class MD2AndroidLollipopUtil {
	
	/**
	 * Returns the package name that is being derived from the String path
	 */
	def static String getPackageNameFromPath(String path) {
		val joiner = Joiner.on(".")
		val pathSegments = path.split("/").map([s | s.toFirstLower])
		return joiner.join(pathSegments)
	}
	
	def static String getTypeNameForContentProvider(ContentProvider cp){
		val type = cp.type
		
		switch type{
			ReferencedModelType: return type.entity.name.toFirstUpper
			SimpleType: return "Md2" + type.type.getName.toFirstUpper
		}
	}
	
	def static String generateImportAllWidgets()'''
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2GridLayout;
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2FlowLayout;
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2Label;
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2Button;
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2TextInput;
	'''
	
	def static String generateImportAllTypes()'''
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Boolean;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Date;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2DateTime;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Float;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Integer;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2String;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Time;
	'''
	
}