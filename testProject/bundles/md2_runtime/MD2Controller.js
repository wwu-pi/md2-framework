define([
    "dojo/_base/declare",
    "./MD2MainWidget"
],
function(declare, MD2MainWidget) {
    
    return declare([], {
        
        _mainWidget: null,
        
        activate: function() {
            
        },
        
        deactivate: function() {
            this._mainWidget.destroyRecursive();
            this._mainWidget = null;
        },
        
        createInstance: function() {
            
            this._mainWidget = new MD2MainWidget({
                _windowManager: this._windowManager,
                _dataFormService: this._dataFormService,
                _dataFormBean: this._dataFormBean,
                _storeFactory: this._storeFactory,
                _notificationService: this._notificationService,
                _customActions: this._customActions,
                _entities: this._entities
            });
            
            return this._mainWidget;
        }
        
    });
});
