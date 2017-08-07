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
import de.wwu.md2.framework.mD2.SensorType
import de.wwu.md2.framework.generator.android.wearable.util.MD2AndroidWearableUtil
import java.util.ArrayList
import java.util.List

class EntityGen {
	
private static List<ForeignObject> foreinReferences= new ArrayList<ForeignObject>();	
	
	def static generateEntities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<Entity> entities) {
			entities.forEach [ e |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/" + e.name.toFirstUpper + ".java",
				generateEntityPOJO(mainPackage, e, entities))
		]
		
	}

	private def static generateEntity(String mainPackage, Entity entity){ '''
		// generated in de.wwu.md2.framework.generator.android.wearable.model.Md2Entity.generateEntity()
		package «mainPackage + ".md2.model"»;
		
		import java.util.HashMap;
		
	
		
		
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		«MD2AndroidWearableUtil.generateImportAllTypes»
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
	
	
	
	private def static generateEntityPOJO(String mainPackage, Entity entity, Iterable<Entity> entities){ '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2Entity.generateEntity()
		package «mainPackage + ".md2.model"»;
		
		«FOR element : entities»
				import «mainPackage + ".md2.model"».«element.name.toFirstUpper»;	
		«ENDFOR»

		import java.sql.Timestamp;
		import java.util.HashMap;
		import java.util.List;
		import java.util.ArrayList;
		import java.io.Serializable;
		import com.j256.ormlite.field.DatabaseField;
		import com.j256.ormlite.dao.ForeignCollection;
		import com.j256.ormlite.field.ForeignCollectionField;
		import com.j256.ormlite.table.DatabaseTable;
		import com.google.gson.annotations.SerializedName;
		import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		«MD2AndroidWearableUtil.generateImportAllTypes»
@DatabaseTable(tableName = "«entity.name.toFirstLower»")
		public class «entity.name.toFirstUpper»  implements Serializable,Md2Entity{
		
		@SerializedName("__internalId")
		@DatabaseField(generatedId = true, columnName = "id")
		    private long id;
		    
		    	@DatabaseField(columnName = "MODIFIED_DATE")
		  private Timestamp modifiedDate;
		   
		  public Timestamp getModifiedDate(){
		  	return this.modifiedDate;}
		  	
		  public void setModifiedDate(Timestamp modified){
		  this.modifiedDate=modified;	
		  }	  
		    
		      protected String typeName;
		«FOR element : entity.attributes»
		«IF  element.type instanceof ReferencedType && element.type.many»
		@ForeignCollectionField
		private ForeignCollection<«getMd2TypeStringForAttributeType(element.type)»>	«element.name»;
		«var boolean b= foreinReferences.add(new ForeignObject(entity.name, element.name, getMd2TypeStringForAttributeType(element.type)))»
			«ELSE»
		«IF element.type instanceof ReferencedType»
		@DatabaseField(canBeNull = false, foreign = true, foreignAutoRefresh = true)
		«ELSE»	
		@DatabaseField(columnName = "«entity.name.toFirstLower»_«element.name.toFirstLower»")
		«ENDIF»	
		private «getJavaTypeStringForAttributeType(element.type)»	«element.name»;		
		«ENDIF»
		«ENDFOR»
		«FOR element : foreinReferences»
		«IF element.targetClass.equals(entity.name)»
@DatabaseField(canBeNull = false, foreign = true, foreignAutoRefresh = true)		
private «element.className» «element.attributeName»;			
		«ENDIF»	
		«ENDFOR»
		
		
		
		    public «entity.name.toFirstUpper»() {
		        super();
		    }
		    
		    		
		    @Override
		    public Md2Type clone() {
		   return null; //TODO
		    }
		
		
		@Override
			public Md2String getString() {
				return null;
			}
		
			@Override
			public boolean equals(Md2Type md2Type) {
				return false;}
		
			@Override
			public Md2Type get(String s) {
				return null;
			}
		
			@Override
			public void set(String s, Md2Type md2Type) {
		
			}
		
	
		
			@Override
			public HashMap<String, Md2Type> getAttributes() {
				return null;
			}
		
		 public long getId() {
		        return this.id;
		    }
		
		    public void setId(long id) {
		        this.id = id;
		    }
		
		 public String getTypeName() {
		        return this.typeName;
		    }
		
		«FOR element : entity.attributes»
		«IF element.type.many»
		public List<«getJavaTypeStringForAttributeType(element.type)»> get«element.name.toFirstUpper»(){
		return new ArrayList<«getJavaTypeStringForAttributeType(element.type)»>(this.«element.name»);	
		}	
		
		public void set«element.name.toFirstUpper»(List<«getJavaTypeStringForAttributeType(element.type)»> «element.name» ){
		//this.«element.name»=«element.name»; 	
		}
			«ELSE»		
		public «getJavaTypeStringForAttributeType(element.type)» get«element.name.toFirstUpper»(){
				return this.«element.name»;	
				}
				
		public void set«element.name.toFirstUpper»(«getJavaTypeStringForAttributeType(element.type)» «element.name» ){
				this.«element.name»=«element.name»; 	
				}		
		«ENDIF»
		«ENDFOR»
		
		@Override
		    public String toString() {
		        StringBuffer result = new StringBuffer();
		        result.append(this.getTypeName() + ": (");
		        «FOR element : entity.attributes»
		        result.append(this.«element.name»);
		«ENDFOR» 
		
		        return result.append(")").toString();
		    }
		
		@Override
		    public boolean equals(Object value) {
		        if(value == null) {
		            return false;
		        } else if(!(value instanceof «entity.name»)) {
		            return false;
		        } else {
		            «entity.name» md2EntityValue = («entity.name»)value;
		            boolean b= true;
		           «FOR element : entity.attributes»
		           b &= this.«element.name».equals(((«entity.name»)md2EntityValue).get«element.name.toFirstUpper»()) ;
		           
		           «ENDFOR» 
		
		            return b;
		        }
		    }
		}
		
	'''}
	
	
	def static generateEnums(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<Enum> enums) {		
		//fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/" + "TestEnum".toFirstUpper + ".java",
		//		generateEnum(mainPackage, null))
	}
	
	private def static generateEnum(String mainPackage, Enum entity) '''
		// generated in de.wwu.md2.framework.generator.android.wearable.model.Md2Entity.generateEnum()
		package «mainPackage + ".md2.model"»;
		
		import java.util.ArrayList;
		import java.util.Arrays;
		
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Enum;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2String;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		
		public class TestEnum extends AbstractMd2Enum {
		

		}
	'''
	
	public def static String getMd2TypeStringForAttributeType(AttributeType attributeType){
		switch attributeType{
			ReferencedType: attributeType.element.name.toFirstUpper
			IntegerType: "Md2Integer"
			FloatType: "Md2Float"
			StringType: "Md2String"
			BooleanType: "Md2Boolean"
			DateType: "Md2Date"
			TimeType: "Md2Time"
			DateTimeType: "Md2DateTime"		
			
			SensorType: "Md2Sensor"	
			FileType: "Object" // TODO not implemented
		}		
	}
	
	
	private def static String getJavaTypeStringForAttributeType(AttributeType attributeType){
		switch attributeType{
			ReferencedType: attributeType.element.name.toFirstUpper
			IntegerType: "Integer"
			FloatType: "Float"
			StringType: "String"
			BooleanType: "Boolean"
			DateType: "Date"
			TimeType: "Md2Time"
			DateTimeType: "Md2DateTime"			
			FileType: "Object" // TODO not implemented
		}		
	}
	
	
	
}