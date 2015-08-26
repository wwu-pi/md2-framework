package de.wwu.md2.framework.generator.android.lollipop.model

import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.mD2.ContentProvider
import javax.xml.stream.events.EntityReference
import de.wwu.md2.framework.mD2.ReferencedModelType

class Md2ContentProvider {
	
	def static generateContentProviders(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContentProvider> contentProviders) {
		contentProviders.forEach [ cp |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + cp.name + ".java",
				generateContentProvider(mainPackage, cp))
		]
	}

	private def static generateContentProvider(String mainPackage, ContentProvider contentProvider) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2ContentProvider.generateContentProvider()
		package «mainPackage».md2.model.contentProvider;
		«var content =  contentProvider.type as ReferencedModelType»
		
		import «mainPackage».md2.model.«content.entity.name.toFirstUpper»;
		import de.uni_muenster.wi.fabian.md2library.model.contentProvider.implementation.AbstractMd2ContentProvider;
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.interfaces.Md2LocalStore;
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.interfaces.Md2DataStore;
		import de.uni_muenster.wi.fabian.md2library.model.type.interfaces.Md2Entity;
		
		public class «contentProvider.name.toFirstUpper» extends AbstractMd2ContentProvider {
		    public «contentProvider.name.toFirstUpper»(«content.entity.name.toFirstUpper» content, Md2LocalStore md2DataStore) {
		        super(content, md2DataStore);
		    }
		}
	'''
}