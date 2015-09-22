package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.generator.ios.Settings
import java.lang.invoke.MethodHandles
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil

class IOSContentProvider {
	
	static var className = ""
	static var managedEntityClassName = ""
	static var remoteEntityClassName = ""
	
	def static generateClass(ContentProvider cpInstance) {
		className = Settings.PREFIX_CONTENT_PROVIDER + cpInstance.name.toFirstUpper
		managedEntityClassName = Settings.PREFIX_ENTITY + (cpInstance.type as ReferencedModelType).entity.name.toFirstUpper
		remoteEntityClassName = (cpInstance.type as ReferencedModelType).entity.name.toFirstUpper
			
		generateClassContent(cpInstance)
	} 
	
	def static generateClassContent(ContentProvider cpInstance) '''
«IOSGeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

class «className»: MD2ContentProvider {
    
    typealias contentType = «managedEntityClassName»
    
    var content: MD2Entity? // managed entity instance
    
    var store: MD2DataStore
    
    var observedAttributes: Dictionary<String, MD2Type> = [:]
    
    var attributeContentProviders: Dictionary<String, MD2ContentProvider> = [:]
    
    var filter: MD2Filter?
    
«IF cpInstance.local || cpInstance.^default»
    var entityPath: String = ""
«ELSE»
	var entityPath: String = "«cpInstance.connection.uri + remoteEntityClassName.toFirstLower»/"
«ENDIF»
    
    init() {
    	self.store = MD2DataSToreFactory<contentType>().createSTore(entityPath)
    }
    
    convenience init(content: MD2Entity) {
        self.init()
        self.content = content
    }
    
    func getContent() -> MD2Entity? {
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
    
    func setContent(content: MD2Entity) {
        // Update full entity by cloning
        self.content = (content.clone() as! MD2Entity)
        
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
    	// Check for value change
    	if content == nil || content?.get(attribute) == nil || value.equals(content?.get(attribute)) {
    		return
    	}
    	
        // Update content
        let newValue = value.clone()
        println("[«className»] Update id=\(content!.internalId.toString()) set \(attribute) to '\(newValue.toString())'")
        
        content?.set(attribute, value: newValue)
        
        // Check if attribute is observed and fire event accordingly
        checkForObserver(attribute, newValue: value)
        
        // Update value in map
        observedAttributes[attribute] = newValue
    }
    
    func checkForObserver(attribute: String, newValue: MD2Type) {
        // Check if attribute is observed
        if observedAttributes[attribute] != nil && !observedAttributes[attribute]!.equals(newValue) {
            MD2OnContentChangeHandler.instance.fire(MD2ContentProviderAttributeIdentity(self, attribute))
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
            let query = MD2Query()
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
    
    func registerAttributeContentProvider(attribute: String, contentProvider: MD2ContentProvider) {
        attributeContentProviders[attribute] = contentProvider
    }
    
}
	'''	
}