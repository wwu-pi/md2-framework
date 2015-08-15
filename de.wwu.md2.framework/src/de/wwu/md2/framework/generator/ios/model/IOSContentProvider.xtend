package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.generator.ios.Settings
import java.lang.invoke.MethodHandles
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType

class IOSContentProvider {
	
	static var className = ""
	static var managedEntityClassName = ""
	
	def static generateClass(ContentProvider cpInstance) {
		className = Settings.PREFIX_CONTENT_PROVIDER + cpInstance.name
		managedEntityClassName = Settings.PREFIX_ENTITY + (cpInstance.type as ReferencedModelType).entity.name.toFirstUpper
		
		generateClassContent(cpInstance)
	} 
	
	def static generateClassContent(ContentProvider cpInstance) '''
«GeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

class «className»: ContentProviderType {
    
    let contentType = «managedEntityClassName».self
    
    var content: MD2EntityType? // managed entity instance
    
    var store: DataStoreType
    
    var observedAttributes: Dictionary<String, MD2Type> = [:]
    
    var attributeContentProviders: Dictionary<String, ContentProviderType> = [:]
    
    var filter: Filter?
    
    init() {
        self.store = LocalStoreFactory<«managedEntityClassName»>().createStore()
    }
    
    convenience init(content: MD2EntityType) {
        self.init()
        self.content = content
    }
    
    func getContent() -> MD2EntityType? {
        return content
    }
    
    func setContent() {
        // Create new object
        self.content = contentType()
        
        // Check all observed properties
        checkAllAttributesForObserver()
        
        // Update values in map
        for (attribute, _) in observedAttributes {
            observedAttributes[attribute] = self.content?.get(attribute)
        }
    }
    
    func setContent(content: MD2EntityType) {
        // Update full entity by cloning
        self.content = (content.clone() as! MD2EntityType)
        
        // Check all observed properties
        checkAllAttributesForObserver()
        
        // Update values in map
        for (attribute, _) in observedAttributes {
            observedAttributes[attribute] = self.content?.get(attribute)
        }
    }
    
    func registerObservedOnChange(attribute: String) {
        // Add observed attribute and remember current value
        observedAttributes[attribute] = self.content?.get(attribute)
    }
    
    func unregisterObservedOnChange(attribute: String) {
        observedAttributes[attribute] = nil
    }
    
    func getValue(attribute: String) -> MD2Type? {
        return content?.get(attribute)
    }
    
    func setValue(attribute: String, value: MD2Type) {
        // Update content
        let newValue = value.clone()
        if content != nil {
            println("[«className»] Update id=\(content!.internalId.toString()) set \(attribute) to '\(newValue.toString())'")
        }
        content?.set(attribute, value: newValue)
        
        // Check if attribute is observed and fire event accordingly
        checkForObserver(attribute, newValue: value)
        
        // Update value in map
        observedAttributes[attribute] = newValue
    }
    
    func checkForObserver(attribute: String, newValue: MD2Type) {
        // Check if attribute is observed
        if observedAttributes[attribute] != nil && !observedAttributes[attribute]!.equals(newValue) {
            OnContentChangeHandler.instance.fire(self, attribute: attribute)
        }
    }
    
    func checkAllAttributesForObserver() {
        if let _ = content {
            for (attribute, _) in observedAttributes {
                checkForObserver(attribute, newValue: content!.get(attribute)!)
            }
        }
    }
    
    func reset() {
        // Check all observed properties
        checkAllAttributesForObserver()
    }
    
    func load() {
        if let _ = content {
            println("LOAD entity \(content!.internalId.toString())")
            let query = Query()
            query.addPredicate("internalId", value: content!.internalId.toString())
            content = store.query(query)
        }
    }
    
    func save() {
        if let _ = content {
            println("SAVE entity \(content!.internalId.toString())")
            store.put(content!)
        }
    }
    
    func remove() {
        if let _ = content {
            println("REMOVE entity \(content!.internalId.toString())")
            store.remove(content!.internalId)
        }
    }
    
    func registerAttributeContentProvider(attribute: String, contentProvider: ContentProviderType) {
        attributeContentProviders[attribute] = contentProvider
    }
    
}
	'''	
}