package de.wwu.md2.framework.generator.mapapps

class ControllerClass {
	
	def static generateController() '''
		define([
		    "dojo/_base/declare"
		],
		function(declare) {
		    
		    return declare([], {
		        
		        /**
		         * Configure and build this MD2 app once on startup. Then
		         * always deliver the instance.
		         */
		        activate: function() {
		            var app = this._md2AppWidget;
		            
		            // configure app
		            app._dataFormBean = this._configBean;
		            app._customActions = this._customActions;
		            app._entities = this._entities;
		            app._contentProviders = this._contentProviders;
		            
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
	'''
	
}
