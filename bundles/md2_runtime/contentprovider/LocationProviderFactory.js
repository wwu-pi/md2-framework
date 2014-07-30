define([
    "dojo/_base/declare",
    "./ContentProvider"
],
function(declare, ContentProvider) {
    
    /**
     * ContentProvider Factory
     */
    return declare([], {
        
        create: function(appId, locationFactory, typeFactory) {
            
            if (!locationFactory) {
                    throw new Error("[LocationProvider] No store factory of type 'location' found! "
                            + "Check whether bundle is missing.");
            }
            
            var entityFactory = typeFactory.getEntityFactory("Location");
            var store = locationFactory.create({
                entityFactory: entityFactory
            });
            
            return new ContentProvider("location", appId, store, false);
        }
        
    });
});
