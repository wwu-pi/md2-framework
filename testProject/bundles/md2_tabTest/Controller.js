define([
    "dojo/_base/declare",
    "dojo/_base/array"
],
function(declare, array) {
    
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
         * Returns the configured MD2AppWidget instance and registers
         * a tool to start this app in the MD2 toolset.
         * @returns {MD2AppWidget}
         */
        createInstance: function() {
            return this._md2AppWidget;
        }
        
    });
});
