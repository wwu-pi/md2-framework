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
				throw new Error("[CustomerProvider] No store factory of type 'remote' found! "
						+ "Check whether bundle is missing.");
			}
			
			var properties = this._properties;
			var entityFactory = typeFactory.getEntityFactory("Customer");
			var store = this._remoteFactory.create(properties.uri, entityFactory);
			var appId = "md2_HelloWorld";
			
			var filter = function() {
				this.$ = $;
				
				var expr02c = this.$.widgetRegistry.getWidget("id").getValue();
				var expr02d = this.$.create("integer", 5);
				var expr02e = this.$.create("integer", 100);
				var expr02f = this.$.create("string", "Bill");
				var expr02g = this.$.create("string", "Marc");
				return {
					query: {
						id: expr02c,
						$or: [
							{ id: { $gt: expr02d } },
							{ id: { $lte: expr02e } }
						],
						$not: { $or: [
							{ firstName: expr02f },
							{ firstName: expr02g }
						] }
					},
					"count": "first"
				};
			};
			
			return new ContentProvider("customerProvider", appId, store, false, filter);
		}
		
	});
});
