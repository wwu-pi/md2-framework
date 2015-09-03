package de.wwu.md2.framework.generator.android.lollipop.model

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.Entity

class Md2Entity {
	
	def static generateEntities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<Entity> entities) {
		entities.forEach [ e |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/" + e.name + ".java",
				generateEntity(mainPackage, e))
		]
	}

	private def static generateEntity(String mainPackage, Entity entity) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2Entity.generateEntity()
		package «mainPackage + ".md2.model"»;
		
		import java.util.HashMap;
		
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.AbstractMd2Entity;
		import de.uni_muenster.wi.fabian.md2library.model.type.interfaces.Md2Type;

		public class «entity.name.toFirstUpper» extends AbstractMd2Entity {
		
		    public «entity.name.toFirstUpper»() {
		        super("«entity.name.toLowerCase»");
		    }
		
		    public «entity.name.toFirstUpper»(HashMap attributes) {
		        super("«entity.name.toLowerCase»", attributes);
		    }
		
		    @Override
		    public Md2Type clone() {
		        «entity.name.toFirstUpper» newEntity = new «entity.name.toFirstUpper»(this.getAttributes());
		        return newEntity;
		    }
		
		}
	'''
}