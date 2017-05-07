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

class ContentProviderGen {
	
	
	
	def static generateContentProviders(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContentProvider> contentProviders) {
		var Set<String> providers= new HashSet<String>;	
		contentProviders.forEach [ cp |
			/*if(cp.type.many){
				fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + cp.name.toFirstUpper + ".java",
				generateMultiContentProvider(mainPackage, cp));}
				else{*/
					fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + cp.name.toFirstUpper + ".java",
				generateContentProvider(mainPackage, cp))
				//}
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

			import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.implementation.AbstractMd2ContentProvider;
			import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2LocalStore;
			import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2DataStore;
			import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Entity;
			
			public class ContentProviderFor«content.entity.name»    extends AbstractMd2ContentProvider {
			
			  protected String key;
			    protected Md2Entity content;
			    protected Md2Entity backup;
			    protected Md2DataStore md2DataStore;
			    protected HashMap<String, Md2OnAttributeChangedHandler> attributeChangedEventHandlers;
			    protected long internalId;
			    protected boolean existsInDataStore;
			
			    public AbstractMd2ContentProvider(String key, Md2Entity content, Md2DataStore md2DataStore) {
			        this.content = content;
			        if(content != null) {
			            this.backup = (Md2Entity)content.clone();
			        }
			
			        this.attributeChangedEventHandlers = new HashMap();
			        this.md2DataStore = md2DataStore;
			        this.existsInDataStore = false;
			        this.internalId = -1L;
			        this.load();
			        this.key = key;
			    }
			
			    public String getKey() {
			        return this.key;
			    }
			
			    protected long getInternalId() {
			        return this.internalId;
			    }
			
			    protected void setInternalId(long internalId) {
			        this.internalId = internalId;
			    }
			
			    public Md2Entity getContent() {
			        return this.content;
			    }
			
			    public void setContent(Md2Entity content) {
			        if(content != null) {
			            this.content = content;
			            this.backup = (Md2Entity)content.clone();
			            this.internalId = -1L;
			            this.load();
			        }
			
			    }
			
			    public void registerAttributeOnChangeHandler(String attribute, Md2OnAttributeChangedHandler onAttributeChangedHandler) {
			        this.attributeChangedEventHandlers.put(attribute, onAttributeChangedHandler);
			    }
			
			    public void unregisterAttributeOnChangeHandler(String attribute) {
			        this.attributeChangedEventHandlers.remove(attribute);
			    }
			
			    public Md2OnAttributeChangedHandler getOnAttributeChangedHandler(String attribute) {
			        return (Md2OnAttributeChangedHandler)this.attributeChangedEventHandlers.get(attribute);
			    }
			
			
			
			
			
			    public Md2Type getValue(String attribute) {			
			switch attribute{
			«FOR attribute: (content.entity as Entity).attributes»			
			case "«attribute.name»": return  content.get«attribute.name.toFirstUpper»();	
			«ENDFOR»		
			}
			}
			
			
			public void setValue(String attribute, Md2Type attribute){
			     if (content == null) {
			            return;
			        }
			
			        // set only if value is different to current value
			        if ((this.getValue(attribute) == null && value != null) || !this.getValue(attribute).equals(value)) {
			        switch attribute{
			        			«FOR attribute: (content.entity as Entity).attributes»			
			        			case "«attribute.name»": return  content.set«attribute.name.toFirstUpper»((«getMd2TypeStringForAttributeType(attribute.type)») attribute);	
			        			«ENDFOR»		
			        			}
			        
			        
			            Md2OnAttributeChangedHandler handler = this.attributeChangedEventHandlers.get(attribute);
			            if (handler != null) {
			                handler.onChange(attribute);
			            }
			        }	
			}
			
			    public void reset(){ 
			       
			    }
			
			
			
			
			    public void load() {
			        if(!(this.content == null | this.md2DataStore == null)) {
			            if(this.content.getId() > 0L) {
			                this.existsInDataStore = true;
			                this.internalId = this.content.getId();
			            } else {
			                long id = this.md2DataStore.getInternalId(this.content);
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
			
			    public void save() {
			        if(this.content != null && this.md2DataStore != null) {
			            if(this.existsInDataStore) {
			                this.md2DataStore.put(this.internalId, this.content);
			            } else {
			                long newId = this.md2DataStore.put(this.content);
			                if(newId > 0L) {
			                    this.existsInDataStore = true;
			                    this.internalId = newId;
			                }
			            }
			
			            this.backup = (Md2Entity)this.content.clone();
			        }
			    }
			
			    public void remove() {
			        if(this.content != null && this.md2DataStore != null) {
			            this.md2DataStore.remove(this.internalId, this.content);
			            this.internalId = -1L;
			        }
			    }
			
			
			}
		'''}
		
		
		
		private def static generateMultiContentProvider(String mainPackage, ContentProvider contentProvider){ '''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.Md2ContentProvider.generateContentProvider()
		package «mainPackage».md2.model.contentProvider;
		«var content =  contentProvider.type as ReferencedModelType»
		
		import «mainPackage».md2.model.«content.entity.name.toFirstUpper»;
		import «Settings.MD2LIBRARY_PACKAGE»model.contentProvider.implementation.AbstractMd2ContentProvider;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2LocalStore;
		import «Settings.MD2LIBRARY_PACKAGE»model.dataStore.interfaces.Md2DataStore;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.interfaces.Md2Entity;
		
		public class «contentProvider.name.toFirstUpper» extends AbstractMd2MultiContentProvider {
		  
		  				    public «contentProvider.name.toFirstUpper»(«content.entity.name.toFirstUpper») {
		  				        super("«contentProvider.name»");
		  				    }
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
			FileType: "Object" // TODO not implemented
		}		
	}
		
}
	