define([
    "dojo/_base/declare",
    "dojo/_base/lang"
], function(declare, lang) {
    
    return declare([], {
        
        _currentMapPoint: null,
        
        _onClickHandler: null,
        
        activate: function() {
            this._observeMapClicks();
        },
        
        deactivate: function() {
            this._onClickHandler.remove();
        },
        
        getLatitude: function() {
           return  this._currentMapPoint.getLatitude();
        },
        
        getLongitude: function() {
            return this._currentMapPoint.getLongitude();
        },
        
        _observeMapClicks: function() {
            var map = this._esriMap;
            var handler = map.on("click", lang.hitch(this, function(event) {
                this._currentMapPoint = event.mapPoint;
                this._broadcastOnLocationUpdateEvent();
            }));
            this._onClickHandler = handler;
        },
        
        _broadcastOnLocationUpdateEvent: function() {
            this._eventService.postEvent("md2/location/LOCATION_UPDATE", {
                latitude: this.getLatitude(),
                longitude: this.getLongitude()
            });
        }
        
    });
    
});
