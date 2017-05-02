package de.wwu.md2.framework.generator.android.wearable.model

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType


class ContentProviderGen {
	
	def static generateContentProviders(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContentProvider> contentProviders) {
		
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + "TestContentProvider".toFirstUpper + ".java",
				generateContentProvider(mainPackage, null))
		
	}

	private def static generateContentProvider(String mainPackage, ContentProvider contentProvider) '''
			// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2ContentProvider.generateContentProvider()
			package «mainPackage».md2.model.contentProvider;
			

			import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.implementation.AbstractMd2ContentProvider;
			import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2LocalStore;
			import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2DataStore;
			import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Entity;
			
			public class TestContentProvider extends AbstractMd2ContentProvider {
			
			}
		'''
}
	