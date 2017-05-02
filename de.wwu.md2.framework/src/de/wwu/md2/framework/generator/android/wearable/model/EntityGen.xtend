package de.wwu.md2.framework.generator.android.wearable.model

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.FileType
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.generator.android.wearable.Settings

class EntityGen {
	
	def static generateEntities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<Entity> entities) {
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/" + "TestEntity".toFirstUpper + ".java",
				generateEntity(mainPackage, null))
		
	}

	private def static generateEntity(String mainPackage, Entity entity) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2Entity.generateEntity()
		package «mainPackage + ".md2.model"»;
		
		import java.util.HashMap;
		
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		«MD2AndroidLollipopUtil.generateImportAllTypes»

		public class TestEntity extends AbstractMd2Entity {
		
		    public TestEntity {
		        super("TestEntity.toFirstUpper»");
		    }		
		    @Override
		    public Md2Type clone() {
		   
		    }
		}
	'''
	
	def static generateEnums(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<Enum> enums) {		
		fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/" + "TestEnum".toFirstUpper + ".java",
				generateEnum(mainPackage, null))
	}
	
	private def static generateEnum(String mainPackage, Enum entity) '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2Entity.generateEnum()
		package «mainPackage + ".md2.model"»;
		
		import java.util.ArrayList;
		import java.util.Arrays;
		
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Enum;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2String;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		
		public class TestEnum extends AbstractMd2Enum {
		

		}
	'''
	
	private def static String getMd2TypeStringForAttributeType(AttributeType attributeType){
		switch attributeType{
			ReferencedType: attributeType.element.name.toFirstUpper
			IntegerType: "Md2Integer"
			FloatType: "Md2Float"
			StringType: "Md2String"
			BooleanType: "Md2Boolean"
			DateType: "Md2Date"
			TimeType: "Md2Time"
			DateTimeType: "Md2DateTime"			
			FileType: "Object" // TODO not implemented
		}		
	}
}