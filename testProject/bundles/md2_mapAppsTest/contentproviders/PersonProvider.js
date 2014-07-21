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
			
			var filter = function() {
				this.$ = $;
				
				var expr04g = this.$.create("string", "john.doe@example.com");
				var expr04h = this.$.create("string", this.$.create("string", this.$.create("string", "John").toString()
				.concat(this.$.create("string", " "))
				).toString()
				.concat(this.$.create("string", "Doe"))
				);
				var expr04i = this.$.create("string", "Johnny");
				return {
					query: {
						email: expr04g,
						$or: [
							{ firstName: expr04h },
							{ firstName: expr04i }
						]
					},
					"count": "first"
				};
			};
			
			return new ContentProvider("personProvider", "md2_mapAppsTest", store, false, filter);
		}
		
	});
});
