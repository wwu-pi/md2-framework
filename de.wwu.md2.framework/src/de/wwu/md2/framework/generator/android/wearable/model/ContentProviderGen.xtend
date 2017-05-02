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
		
		/*var Set<String> providers= new HashSet<String>;	
		contentProviders.forEach [ cp |
			if(cp.type.many){
				fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + cp.name.toFirstUpper + ".java",
				generateMultiContentProvider(mainPackage, cp));}
				else{
					fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "md2/model/contentProvider/" + cp.name.toFirstUpper + ".java",
				generateContentProvider(mainPackage, cp))}
		]*/
	}

	private def static generateContentProvider(String mainPackage, ContentProvider contentProvider) '''
			// generated in de.wwu.md2.framework.generator.android.wearable.model.Md2ContentProvider.generateContentProvider()
			package «mainPackage».md2.model.contentProvider;
			«var content =  contentProvider.type as ReferencedModelType»

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
}
	