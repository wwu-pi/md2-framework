define([
	"dojo/_base/declare"
],
function(declare) {
	
	return declare([], {
		
		/**
		 * Configure and build this MD2 app once on startup.
		 * Then always deliver the instance.
		 */
		activate: function() {
			var app = this._md2AppWidget;
			
			// configure app
			app._dataFormBean = this._configBean;
			app._customActions = this._customActions;
			app._models = this._models;
			app._workflowEventHandler = this._workflowEventHandler;
			app._workflowStateHandler = this._workflowStateHandler;
			
			// build app
			app.build();
		},
		
		/**
		 * Destroy app on deactivation.
		 */
		deactivate: function() {
			this._md2AppWidget.destroyRecursive();
			this._md2AppWidget = null;
		},
		
		/**
		 * Returns the configured MD2AppWidget instance.
		 * @returns {MD2AppWidget}
		 */
		createInstance: function() {
			return this._md2AppWidget;
		}
		
	});
});
