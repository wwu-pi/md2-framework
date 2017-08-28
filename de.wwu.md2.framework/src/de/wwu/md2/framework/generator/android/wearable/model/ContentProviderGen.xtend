package de.wwu.md2.framework.generator.android.wearable.model

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess

import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.generator.android.wearable.Settings
import java.util.Set
import java.util.HashSet
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.FileType
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.generator.android.wearable.util.MD2AndroidWearableUtil
import de.wwu.md2.framework.mD2.SensorType

class ContentProviderGen {
	
	
	
	def static generateContentProviders(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContentProvider> contentProviders) {
		var Set<String> providers= new HashSet<String>;	
		contentProviders.forEach [ cp |
			if(cp.type.many){
				fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + cp.name.toFirstUpper + ".java",
				generateMultiContentProvider(mainPackage, cp));}
				else{
					fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + cp.name.toFirstUpper + ".java",
				generateContentProviderPOJO(mainPackage, cp))
				}
		]
	}

	private def static generateContentProvider(String mainPackage, ContentProvider contentProvider) { '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2ContentProvider.generateContentProvider()
				package «mainPackage».md2.model.contentProvider;
				«var content =  contentProvider.type as ReferencedModelType»
				
				import «mainPackage».md2.model.«content.entity.name.toFirstUpper»;
				import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.implementation.AbstractMd2ContentProvider;
				import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2LocalStore;
				import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2DataStore;
				import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Entity;
				
				import java.util.List; //TODO nur BugFix für dev_filter_design_pol
				
				public class «contentProvider.name.toFirstUpper» extends AbstractMd2ContentProvider {
				    public «contentProvider.name.toFirstUpper»(«content.entity.name.toFirstUpper» content, Md2LocalStore md2DataStore) {
				        super("«contentProvider.name»", content, md2DataStore);
				    }
				}
		'''}
		
		
		
		private def static generateContentProviderPOJO(String mainPackage, ContentProvider contentProvider){ '''
			// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2ContentProvider.generateContentProvider()
			package «mainPackage».md2.model.contentProvider;
			
				«var content =  contentProvider.type as ReferencedModelType»

«FOR element : (content.entity as Entity).attributes»
«IF element.type instanceof ReferencedType»
			import «mainPackage + ".md2.model"».«(element.type as ReferencedType).element.name.toFirstUpper»;		
«ENDIF»
	
		«ENDFOR»

import «Settings.MD2LIBRARY_PACKAGE»controller.eventhandler.implementation.Md2OnAttributeChangedHandler;
			import java.util.HashMap;
			import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
			import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.implementation.AbstractMd2ContentProvider;
			import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2LocalStore;
			import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2DataStore;
			import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Entity;
			import de.uni_muenster.wi.md2library.model.type.implementation.Md2List;
			
			import java.util.List; //TODO nur BugFix für dev_filter_design_pol
			
			import «mainPackage».md2.model.«(content.entity as Entity).name»;
			
			«MD2AndroidWearableUtil.generateImportAllTypes»
			
			public class «contentProvider.name.toFirstUpper»    extends AbstractMd2ContentProvider {
			
			    			
			    public «contentProvider.name.toFirstUpper»(String key, Md2Entity content, Md2DataStore md2DataStore) {
			       super(key, content, md2DataStore);
			       «IF contentProvider.filter»
			       this.filter = new Filter(«FilterGen.generateFilter(contentProvider)»);
			       «ENDIF»
			    }
			@Override
			    public String getKey() {
			        return this.key;
			    }
			@Override
			    protected long getInternalId() {
			        return this.internalId;
			    }
			@Override
			    protected void setInternalId(long internalId) {
			        this.internalId = internalId;
			    }
			@Override
			    public Md2Entity getContent() {
			        return this.content;
			    }
			@Override
			    public void setContent(Md2Entity content) {
			        if(content != null) {
			            this.content = content;
			            this.backup = (Md2Entity)content.clone();
			            this.internalId = -1L;
			            this.load();
			        }
			
			    }
			@Override
			    public void registerAttributeOnChangeHandler(String attribute, Md2OnAttributeChangedHandler onAttributeChangedHandler) {
			        this.attributeChangedEventHandlers.put(attribute, onAttributeChangedHandler);
			    }
			@Override
			    public void unregisterAttributeOnChangeHandler(String attribute) {
			        this.attributeChangedEventHandlers.remove(attribute);
			    }
			@Override
			    public Md2OnAttributeChangedHandler getOnAttributeChangedHandler(String attribute) {
			        return (Md2OnAttributeChangedHandler)this.attributeChangedEventHandlers.get(attribute);
			    }
			
«««						if(((Artikel)content).getSensorTest() != null){
«««						return new
«««						Md2Sensor(((Artikel)content).getSensorTest());	
			
			
			@Override
			    public Md2Type getValue(String attribute) {			
			switch (attribute){
			«FOR attribute: (content.entity as Entity).attributes»			
				case "«attribute.name»":
				if(((«(content.entity as Entity).name»)content).get«attribute.name.toFirstUpper»() != null){
				return  
				«IF attribute.type instanceof ReferencedType && !attribute.type.many»
					((«(content.entity as Entity).name»)content).get«attribute.name.toFirstUpper»();	
				«ELSE»
					new 
					«IF attribute.type.many»
						Md2List<«EntityGen.getMd2TypeStringForAttributeType(attribute.type)»>	
					«ELSE»
						«EntityGen.getMd2TypeStringForAttributeType(attribute.type)»
					«ENDIF»
					«IF (EntityGen.getMd2TypeStringForAttributeType(attribute.type) == "Md2Sensor")»
						(((«(content.entity as Entity).name»)content).get«attribute.name.toFirstUpper»().getPlatformValue());
					«ELSE»		
						(((«(content.entity as Entity).name»)content).get«attribute.name.toFirstUpper»());
					«ENDIF»
				«ENDIF»
				} else { return null;}
			«ENDFOR»
			default:return null;		
			}
			}
			
			@Override
			public void setValue(String name, Md2Type value){
			     if (content == null) {
			            return;
			        }
			
			        // set only if value is different to current value
			        if ((this.getValue(name) == null && value != null) || value != null && !this.getValue(name).toString().equals(value.toString())) {
			        switch (name){
			        			«FOR attribute: (content.entity as Entity).attributes»			
			        			case "«attribute.name»":
			        			   «IF !(attribute.type instanceof StringType)»
			        			   
			        			   		// Umgang mit anderen Datentypen hier einfügen - derzeit kein Support für Listen innerhalb v. Entities
			        			   		// angenommen wird entweder Md2String oder passender Md2Type als value
			        			   		
			        			   		«IF (attribute.type instanceof IntegerType)»
				        			   		if(!(value instanceof «getMd2TypeStringForAttributeType(attribute.type)»)){
				        			   			if(!(value.getString().toString().isEmpty())) {
				        			   		 	((«(content.entity as Entity).name»)content).set«attribute.name.toFirstUpper»(Integer.parseInt(value.getString().toString()));	
				        			   			notifyChangeHandler(name);
				        			   			}
				        			   		} else {
				        			   				((«(content.entity as Entity).name»)content).set«attribute.name.toFirstUpper»(((«getMd2TypeStringForAttributeType(attribute.type)»)value).getPlatformValue());
				        			   		}
				        			   		break;
			        			   		«ENDIF»
			        			   «ELSE»
				        			   ((«(content.entity as Entity).name»)content).set«attribute.name.toFirstUpper»(((«IF attribute.type.many»
				        			   Md2List
				        			   «ELSE»«getMd2TypeStringForAttributeType(attribute.type)»
			        			   «ENDIF») value)
			        			   «IF attribute.type instanceof ReferencedType && !attribute.type.many»
			        			   );

			        				«ELSEIF attribute.type.many»
			        			   .getContents());
			        				«ELSE».getPlatformValue());«ENDIF»	
				        					notifyChangeHandler(name);
					        				break;
			        				«ENDIF»
			        			«ENDFOR»		
			        			}
			        }	
			}
			
			    public void reset(){ 
			       
			    }
			
			
			
			@Override
			    public void load() {
			        if(!(this.content == null | this.md2DataStore == null)) {
			            if(this.content.getId() > 0L) {
			                this.existsInDataStore = true;
			                this.internalId = this.content.getId();
			            } else {
			                long id = -1;
			                this.md2DataStore.getInternalId(this.content);
			                if(id == -1L) {
			                    this.existsInDataStore = false;
			                    this.internalId = -1L;
			                } else {
			                    this.existsInDataStore = true;
			                    this.internalId = id;
			                    this.content.setId(id);
			                }
			
			            }
			        }
			    }
			@Override
			    public void save() {
			        if(this.content != null && this.md2DataStore != null) {
			            if(this.existsInDataStore) {
			                this.md2DataStore.put(this.internalId, this.content);
			            } else {
			                long newId = 0;
			                this.md2DataStore.put(this.content);
			                if(newId > 0L) {
			                    this.existsInDataStore = true;
			                    this.internalId = newId;
			                }
			            }
			
			            this.backup = (Md2Entity)this.content.clone();
			        }
			    }
			@Override
			    public void remove() {
			        if(this.content != null && this.md2DataStore != null) {
			            this.md2DataStore.remove(this.internalId, this.content.getClass());
			            this.internalId = -1L;
			        }
			    }
			
			@Override
				public void newEntity(){
					content = new «(content.entity as Entity).name»();
				}
						public void update() {
				System.out.println("single wurde geupdated");			
						}
			}
			
		'''}
		
		
		
		private def static generateMultiContentProvider(String mainPackage, ContentProvider contentProvider){ '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2ContentProvider.generateContentProvider()
		package «mainPackage».md2.model.contentProvider;
		«var content =  contentProvider.type as ReferencedModelType»
		
		import «mainPackage».md2.model.«content.entity.name.toFirstUpper»;
import de.uni_muenster.wi.md2library.model.contentProvider.implementation.AbstractMd2MultiContentProvider;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2LocalStore;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2DataStore;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Entity;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Type;
		
		import java.util.List; //TODO nur BugFix für dev_filter_design_pol
		
		«MD2AndroidWearableUtil.generateImportAllTypes»
		
		public class «contentProvider.name.toFirstUpper» extends AbstractMd2MultiContentProvider {
		  
		  				    public «contentProvider.name.toFirstUpper»(String key , Md2DataStore dataStore) {
		  				        super(key, dataStore);
		  				    }
		  				    
		  				    
		  			  @Override
		  			    			    public Md2Type getValue(int entityIndex,String attribute) {
		  			    			  if(this.getContentsList()!=null && this.getContentsList().get(entityIndex)!=null){  				
		  			    			switch (attribute){
		  			    			«FOR attribute: (content.entity as Entity).attributes»			
		  			    			case "«attribute.name»": return  
		  			    			«IF attribute.type instanceof ReferencedType && !attribute.type.many»
		  			    			((«(content.entity as Entity).name»)this.getContentsList().get(entityIndex)).get«attribute.name.toFirstUpper»();	
		  			    			«ELSE»
		  			    			new «IF attribute.type.many»
		  			    			Md2List<«EntityGen.getMd2TypeStringForAttributeType(attribute.type)»>	«ELSE»
		  			    			«EntityGen.getMd2TypeStringForAttributeType(attribute.type)»«ENDIF»(((«(content.entity as Entity).name»)this.getContentsList().get(entityIndex)).get«attribute.name.toFirstUpper»());	
		  			    			«ENDIF»
		  			    			«ENDFOR»
		  			    			default:return null;		
		  			    			}
		  			    			}
		  			    			return null;
		  			    			}
		  			    			
		  			    			 @Override
		  			    			public void setValue(int entityIndex, String name, Md2Type value){
		  			    			    if(this.getContentsList()==null && this.getContentsList().get(entityIndex)!=null) {
		  			    			            return;
		  			    			        }
		  			    			
		  			    			        // set only if value is different to current value
		  			    			        if ((this.getValue(entityIndex,name) == null && value != null) || !this.getValue(entityIndex,name).equals(value)) {
		  			    			        switch (name){
		  			    			        			«FOR attribute: (content.entity as Entity).attributes»			
		  			    			        			case "«attribute.name»":   ((«(content.entity as Entity).name»)this.getContentsList().get(entityIndex)).set«attribute.name.toFirstUpper»(((«IF attribute.type.many»
		  			    			        				Md2List«ELSE»«getMd2TypeStringForAttributeType(attribute.type)»«ENDIF») value)«IF attribute.type instanceof ReferencedType && !attribute.type.many»
		  			    			        				);
		  			    			        				«ELSEIF attribute.type.many»
		  			    			        				.getContents());
		  			    			        				«ELSE».getPlatformValue());«ENDIF»	
		  			    			        				notifyAllAdapters();
		  			    			        				break;
		  			    			        			«ENDFOR»		
		  			    			        			}
		  				    
		  				    
		  				}	
		  				}
		  				
	  					@Override
	  					public void overwriteContent(List<Md2Entity> list) {
	  						
	  					}
		  					
		  				public void update() {
		  					System.out.println("multi wurde geupdated");
		  				}	
		  		}		  	

	'''
	}	
	
	
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
			SensorType: "Md2Sensor"	
			FileType: "Object" // TODO not implemented
		}		
	}
		
}
	