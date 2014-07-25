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
				throw new Error("[PersonProvider] No store factory of type 'remote' found! "
						+ "Check whether bundle is missing.");
			}
			
			var properties = this._properties;
			var entityFactory = typeFactory.getEntityFactory("Person");
			var store = this._remoteFactory.create(properties.uri, entityFactory);
			var appId = "md2_mapAppsTest";
			
			var filter = function() {
				this.$ = $;
				
				var expr073 = this.$.create("string", "john.doe@example.com");
				var expr074 = this.$.create("string", this.$.create("string", this.$.create("string", "John").toString()
				.concat(this.$.create("string", " "))
				).toString()
				.concat(this.$.create("string", "Doe"))
				);
				var expr075 = this.$.create("string", "Johnny");
				return {
					query: {
						email: expr073,
						$or: [
							{ firstName: expr074 },
							{ firstName: expr075 }
						]
					},
					"count": "first"
				};
			};
			
			return new ContentProvider("personProvider", appId, store, false, filter);
		}
		
	});
});
