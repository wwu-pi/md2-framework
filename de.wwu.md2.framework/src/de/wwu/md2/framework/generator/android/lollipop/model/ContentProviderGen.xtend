package de.wwu.md2.framework.generator.android.lollipop.model

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType

class ContentProviderGen {
	
	def static generateContentProviders(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContentProvider> contentProviders) {
		contentProviders.forEach [ cp |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + cp.name.toFirstUpper + ".java",
				generateContentProvider(mainPackage, cp))
		]
	}

	private def static generateContentProvider(String mainPackage, ContentProvider contentProvider) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2ContentProvider.generateContentProvider()
		package «mainPackage».md2.model.contentProvider;
		«var content =  contentProvider.type as ReferencedModelType»
		
		import «mainPackage».md2.model.«content.entity.name.toFirstUpper»;
		import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.implementation.AbstractMd2ContentProvider;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2LocalStore;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2DataStore;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Entity;
		
		public class «contentProvider.name.toFirstUpper» extends AbstractMd2ContentProvider {
		    public «contentProvider.name.toFirstUpper»(«content.entity.name.toFirstUpper» content, Md2LocalStore md2DataStore) {
		        super("«contentProvider.name»", content, md2DataStore);
		    }
		}
	'''
}