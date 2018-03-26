package de.wwu.md2.framework.generator.android.lollipop.model

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.generator.android.common.util.MD2AndroidUtil
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
import de.wwu.md2.framework.mD2.SensorType
import de.wwu.md2.framework.generator.android.common.model.ForeignObject
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
	
	private def static generateEntityPOJO(String mainPackage, Entity entity, Iterable<Entity> entities){ '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2Entity.generateEntity()
		package «mainPackage + ".md2.model"»;
		
		«FOR element : entities»
			import «mainPackage + ".md2.model"».«element.name.toFirstUpper»;	
		«ENDFOR»

		import java.sql.Timestamp;
		import java.util.Calendar;
		import java.util.Date;
		import java.util.HashMap;
		import java.util.List;
		import java.util.ArrayList;
		import java.io.Serializable;
		import com.j256.ormlite.field.DataType;
		import com.j256.ormlite.field.DatabaseField;
		import com.j256.ormlite.dao.ForeignCollection;
		import com.j256.ormlite.field.ForeignCollectionField;
		import com.j256.ormlite.table.DatabaseTable;
		import com.google.gson.annotations.SerializedName;
		import com.google.gson.annotations.Expose;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		«MD2AndroidUtil.generateImportAllTypes»
		
		@DatabaseTable(tableName = "«entity.name.toFirstLower»")
		public class «entity.name.toFirstUpper» implements Serializable, Md2Entity{
		
			@SerializedName("__internalId")
			@Expose
			@DatabaseField(generatedId = true, columnName = "id")
			private long id;
			
			@Expose(serialize = false)
			private Timestamp modifiedDate;

			public Timestamp getModifiedDate(){
		  		return this.modifiedDate;
		  	}

		  	public void setModifiedDate(Timestamp modified){
		  		this.modifiedDate=modified;	
		  	}

			protected final String typeName = "«entity.name.toFirstUpper»";

		«FOR element : entity.attributes»
			«IF element.type instanceof ReferencedType && element.type.many»
				@ForeignCollectionField
				private ForeignCollection<«getMd2TypeStringForAttributeType(element.type)»>	«element.name»;
				«var boolean b = foreinReferences.add(new ForeignObject(entity.name, element.name, getMd2TypeStringForAttributeType(element.type)))»
			«ELSE»
				«IF element.type instanceof ReferencedType»
					@DatabaseField(canBeNull = false, foreign = true, foreignAutoRefresh = true)
				«ELSEIF element.type instanceof DateType»
					@Expose
					@DatabaseField(columnName = "«element.name.toFirstLower»", dataType = DataType.DATE_STRING, format = "yyyy-MM-dd")
				«ELSEIF element.type instanceof DateTimeType»
					@Expose
					@DatabaseField(columnName = "«element.name.toFirstLower»", dataType = DataType.DATE_STRING, format = "yyyy-MM-dd HH:mm:ss")
				«ELSEIF element.type instanceof TimeType»
					@Expose
					@DatabaseField(columnName = "«element.name.toFirstLower»", dataType = DataType.DATE_STRING, format = "HH:mm:ss")
				«ELSE»
					@Expose
					@DatabaseField(columnName = "«element.name.toFirstLower»")
				«ENDIF»	
				private «getJavaTypeStringForAttributeType(element.type, true)» «element.name»;
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
				this.setModifiedDate(new Timestamp(System.currentTimeMillis()));
			}
			

			@Override
			public Md2Type clone() {
				«entity.name.toFirstUpper» result = new «entity.name.toFirstUpper»();
			
				«FOR element : entity.attributes»
					result.set«element.name.toFirstUpper»(this.get«element.name.toFirstUpper»());
				«ENDFOR»
				return result;
			}
		
			@Override
			public Md2String getString() {
				return new Md2String((toString()));
			}
		
			@Override
			public Md2Type get(String s) {
				switch(s) {
					// TODO Collections
				«FOR element : entity.attributes»
					case "«element.name»": 
					«IF element.type instanceof ReferencedType»
						return get«element.name.toFirstUpper»();
					«ELSE»
						return new «getMd2TypeStringForAttributeType(element.type)»(get«element.name.toFirstUpper»());
					«ENDIF»
				«ENDFOR»
				}
				return null;
			}
			
			@Override
			public void set(String s, Md2Type md2Type) {
				switch(s) {
					// TODO Collections, TemporalTypes
				«FOR element : entity.attributes»
					case "«element.name»": 
					«IF element.type instanceof ReferencedType»
						set«element.name.toFirstUpper»((«getMd2TypeStringForAttributeType(element.type)») md2Type);
					«ELSEIF element.type instanceof DateType»
						set«element.name.toFirstUpper»(((«getMd2TypeStringForAttributeType(element.type)») md2Type).getPlatformValue());
					«ELSE»
						set«element.name.toFirstUpper»(((«getMd2TypeStringForAttributeType(element.type)») md2Type).getPlatformValue());
					«ENDIF»
				«ENDFOR»
				}
			}
		
			@Override
			public HashMap<String, Md2Type> getAttributes() {
				return null; //TODO
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
					«IF element.type instanceof DateType || element.type instanceof DateTimeType || element.type instanceof TimeType»
						if(this.«element.name» != null){
							Calendar calendar = Calendar.getInstance();
							calendar.setTime(this.«element.name»);
							return calendar;
						} 
						return null;
					«ELSE»
					return this.«element.name»;
					«ENDIF»	
				}

				public void set«element.name.toFirstUpper»(«getJavaTypeStringForAttributeType(element.type)» «element.name» ){
					if(«element.name» != null){
						«IF element.type instanceof DateType || element.type instanceof DateTimeType || element.type instanceof TimeType»
							this.«element.name»=«element.name».getTime();
						«ELSE»
							this.«element.name»=«element.name»;
						«ENDIF»
						this.setModifiedDate(new Timestamp(System.currentTimeMillis()));
					}
				}
			«ENDIF»
		«ENDFOR»
		
			@Override
			public String toString() {
				StringBuffer result = new StringBuffer();
				result.append(this.getTypeName() + ": (");
			«FOR element : entity.attributes»
				result.append(this.«element.name» + " ");
			«ENDFOR» 
		
				return result.append(")").toString();
			}
		
			@Override
			public boolean equals(Md2Type t){
				return this.equals((Object)t);
			}
		
			@Override
			public boolean equals(Object value) {
				if(value == null) {
					return false;
				} else if(!(value instanceof «entity.name»)) {
					return false;
				} else {
					«entity.name» md2EntityValue = («entity.name»)value;
					boolean b = true;
					«FOR element : entity.attributes»
					if(this.«element.name»== null) {
						b &= ((«entity.name») md2EntityValue).get«element.name.toFirstUpper»() == null;	
					} else {
						b &= this.«element.name».equals(((«entity.name») md2EntityValue).get«element.name.toFirstUpper»()) ;
					}
					«ENDFOR» 
		
					return b;
				}
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
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2Entity.generateEnum()
		package «mainPackage + ".md2.model"»;
		
		import com.google.gson.annotations.Expose;
		import com.google.gson.annotations.SerializedName;
		import com.j256.ormlite.field.DatabaseField;
		
		import java.sql.Timestamp;
		import java.util.ArrayList;
		import java.util.Arrays;
		
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.AbstractMd2Enum;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2String;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		
		public class «entity.name.toFirstUpper» extends AbstractMd2Enum {
			
			@SerializedName("__internalId")
			@Expose
			@DatabaseField(generatedId = true, columnName = "id")
			private long id;
		
			@Expose
			@DatabaseField
			private String value;
		
			@Expose(serialize = false)
			private Timestamp modifiedDate;
		
			public «entity.name.toFirstUpper»() {
				this.setModifiedDate(new Timestamp(System.currentTimeMillis()));
			}
		
			ArrayList<Md2String> values = new ArrayList<Md2String>(Arrays.asList(
			«FOR elem: entity.enumBody.elements SEPARATOR ", "»
				new Md2String("«elem»")
			«ENDFOR»));
			
			public «entity.name.toFirstUpper»(String enumName) {
				super(enumName);
				setModifiedDate(new Timestamp(System.currentTimeMillis()));
			}
			
			public «entity.name.toFirstUpper»(String enumName, ArrayList<Md2String> values) {
				super(enumName, values);
				setModifiedDate(new Timestamp(System.currentTimeMillis()));
			}
			
			public String getValue() {
				return value;
			}
		
			public void setValue(String value) {
				if(values.contains(value)){
					this.value = value;
					setModifiedDate(new Timestamp(System.currentTimeMillis()));
				}
			}
		
			public long getId() {
				return id;
			}
		
			public void setId(long id) {
				this.id = id;
			}
		
			public Timestamp getModifiedDate() {
				return modifiedDate;
			}
		
			public void setModifiedDate(Timestamp modifiedDate) {
				this.modifiedDate = modifiedDate;
			}
			
			@Override
			public Md2Type clone() {
				return new «entity.name.toFirstUpper»(this.enumName, this.getAll());
			}
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
			SensorType: "Md2Float"	
			FileType: "Object" // TODO not implemented
		}		
	}
	
	private def static String getJavaTypeStringForAttributeType(AttributeType attributeType){
		return attributeType.getJavaTypeStringForAttributeType(false)
	}
	
	private def static String getJavaTypeStringForAttributeType(AttributeType attributeType, boolean forDatabase){
		switch attributeType{
			ReferencedType: attributeType.element.name.toFirstUpper
			IntegerType: "Integer"
			FloatType: "Float"
			StringType: "String"
			BooleanType: "Boolean"
			DateType: if(forDatabase) "Date" else "Calendar"
			TimeType: "Md2Time"
			DateTimeType: "Md2DateTime"		
			
			SensorType: "Float"		
			FileType: "Object" // TODO not implemented
		}
	}
}