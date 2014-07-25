define([
	"dojo/_base/declare",
	"../../md2_runtime/contentprovider/ContentProvider"
],
function(declare, ContentProvider) {
	
	/**
	 * ContentProvider Factory
	 */
	return declare([], {
		
		create: function(typeFactory, $) {
			
			if (!this._remoteFactory) {
				throw new Error("[CopyTest2] No store factory of type 'remote' found! "
						+ "Check whether bundle is missing.");
			}
			
			var properties = this._properties;
			var entityFactory = typeFactory.getEntityFactory("CopyTest");
			var store = this._remoteFactory.create(properties.uri, entityFactory);
			var appId = "md2_mapAppsTest";
			
			
			return new ContentProvider("copyTest2", appId, store, false);
		}
		
	});
});
