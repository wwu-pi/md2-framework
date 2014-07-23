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
			
			// TODO Local Content Provider
			var appId = "md2_generateTest";
			
			
			return new ContentProvider("__conditionalEventMappingsProvider", appId, store, false);
		}
		
	});
});
