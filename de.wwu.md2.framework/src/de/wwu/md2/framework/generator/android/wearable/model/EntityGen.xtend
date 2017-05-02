package de.wwu.md2.framework.generator.android.wearable.model

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.generator.android.wearable.util.MD2AndroidWearableUtil
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
			entities.forEach [ e |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/" + e.name.toFirstUpper + ".java",
				generateEntity(mainPackage, e))
		]
		
	}

	private def static generateEntity(String mainPackage, Entity entity){ '''
		// generated in de.wwu.md2.framework.generator.android.wearable.model.Md2Entity.generateEntity()
		package «mainPackage + ".md2.model"»;
		
		import java.util.HashMap;
		
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		public class «entity.name.toFirstUpper» extends AbstractMd2Entity {
		
		    public «entity.name.toFirstUpper»() {
		        super("«entity.name.toFirstUpper»");
		    }
		
		    public «entity.name.toFirstUpper»(HashMap attributes) {
		        super("«entity.name.toFirstUpper»", attributes);
		    }
		    
			@Override
		    public void set(String attribute, Md2Type value){
		        if(checkAttribute(attribute, value))
		            super.set(attribute, value);
		    }
		
		    private boolean checkAttribute(String attribute, Md2Type value){
		    	if(value == null)
		    		return true;
		    		
		        switch (attribute){
		        	«FOR attribute : entity.attributes»
		        		case "«attribute.name»": return (value instanceof «getMd2TypeStringForAttributeType(attribute.type)»);
		            «ENDFOR»
		            default: return false;
		        }
		    }
		    
		    @Override
		    public Md2Type clone() {
		        «entity.name.toFirstUpper» newEntity = new «entity.name.toFirstUpper»(this.getAttributes());
		   		        return newEntity;
		    }
		}
	'''}
		
	
private def static generateEntityPOJO(String mainPackage, Entity entity){ '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2Entity.generateEntity()
		package «mainPackage + ".md2.model"»;
		
		import java.util.HashMap;
		import java.util.List;
		import java.util.ArrayList;
		
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		«MD2AndroidLollipopUtil.generateImportAllTypes»

		public class «entity.name» extends AbstractMd2Entity {
		
		    private long _id;
		      protected String typeName;
		«FOR element : entity.attributes»
		«IF element.type.many»
		private List<«getMd2TypeStringForAttributeType(element.type)»>	«element.name»= new ArrayList<«getMd2TypeStringForAttributeType(element.type)»>();
			«ELSE»
		
		private «getMd2TypeStringForAttributeType(element.type)»	«element.name»;
		«ENDIF»
		«ENDFOR»
		
		
		
		    public «entity.name» {
		        super();
		    }
		    
		    		
		    @Override
		    public Md2Type clone() {
		   
		    }
		}
		
		
		 public long getId() {
		        return this._id;
		    }
		
		    public void setId(long id) {
		        this._id = id;
		    }
		
		 public String getTypeName() {
		        return this.typeName;
		    }
		
		«FOR element : entity.attributes»
		«IF element.type.many»
		public List<«getMd2TypeStringForAttributeType(element.type)»> get«element.name.toFirstUpper»(){
		return this.«element.name»	
		}	
		
		public void set«element.name.toFirstUpper»(«getMd2TypeStringForAttributeType(element.type)» «element.name» ){
		this.«element.name»=»element.name»; 	
		}
			«ELSE»		
		public <«getMd2TypeStringForAttributeType(element.type)» get«element.name.toFirstUpper»(){
				return this.«element.name»	
				}
		«ENDIF»
		«ENDFOR»
		
		
		    public String toString() {
		        StringBuffer result = new StringBuffer();
		        result.append(this.getTypeName() + ": (");
		        «FOR element : entity.attributes»
		        result.append(this.«element.name»);
		«ENDFOR» 
		
		        return result.append(")").toString();
		    }
		
		    public boolean equals(Md2Type value) {
		        if(value == null) {
		            return false;
		        } else if(!(value instanceof «entity.name»)) {
		            return false;
		        } else {
		            Md2Entity md2EntityValue = («entity.name»)value;
		            boolean b= true
		           «FOR element : entity.attributes»
		           b ?= this.«element.name».equals(value.get«entity.name.toFirstUpper») ;
		           
		           «ENDFOR» 
		
		            return b;
		        }
		    }
		
		
	'''}
	
	def static generateEnums(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<Enum> enums) {
		enums.forEach [ e |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/" + e.name.toFirstUpper + ".java",
				generateEnum(mainPackage, e))
		]
	}
	
	private def static generateEnum(String mainPackage, Enum entity) '''
		// generated in de.wwu.md2.framework.generator.android.wearable.model.Md2Entity.generateEnum()
		package «mainPackage + ".md2.model"»;
		
		import java.util.ArrayList;
		import java.util.Arrays;
		
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Enum;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2String;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		
		public class «entity.name.toFirstUpper» extends AbstractMd2Enum {
		
			ArrayList<Md2String> values = new ArrayList<Md2String>(Arrays.asList(
			«FOR elem: entity.enumBody.elements SEPARATOR ", "»
				new Md2String("«elem»")
			«ENDFOR»));
			
			public «entity.name.toFirstUpper»(String enumName) {
				super(enumName);
			}
			
			public «entity.name.toFirstUpper»(String enumName, ArrayList<Md2String> values) {
				super(enumName, values);
			}
			
			@Override
		    public Md2Type clone() {
		        return new «entity.name.toFirstUpper»(this.enumName, this.getAll());
		    }
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