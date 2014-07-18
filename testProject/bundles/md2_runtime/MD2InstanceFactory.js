define([
    "dojo/_base/declare",
    "./MD2MainWidget"
],
function(declare, MD2MainWidget) {
    
    return declare([], {
        
        createInstance: function() {
            
            return new MD2MainWidget({
                _windowManager: this._windowManager,
                _dataFormService: this._dataFormService,
                _storeFactory: this._storeFactory,
                _notificationService: this._notificationService
            });
            
        }
        
    });
});
