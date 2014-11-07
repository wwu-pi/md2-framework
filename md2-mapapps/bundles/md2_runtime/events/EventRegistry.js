define([
    "dojo/_base/declare",
    "ct/Hash",
    "./global/OnConnectionLost",
    "./global/OnConnectionRegained",
    "./global/OnLocationUpdate",
    "./contentprovider/OnChange",
    "./widget/OnChange",
    "./widget/OnClick",
    "./widget/OnLeftSwipe",
    "./widget/OnRightSwipe",
    "./widget/OnWrongValidation"
],
function(
    declare,
    Hash,
    GlobalOnConnectionLost,
    GlobalOnConnectionRegained,
    GlobalOnLocationUpdate,
    ContentProviderOnChange,
    WidgetOnChange,
    WidgetOnClick,
    WidgetOnLeftSwipe,
    WidgetOnRightSwipe,
    WidgetOnWrongValidation
) {
    /**
     * Provide a single point of access for all event registry instances.
     */
    return declare([], {
        
        _registry: null,
        
        _appId: null,
        
        constructor: function(appId) {
            this._registry = new Hash();
            this._appId = appId;
        },
        
        get: function(eventName) {
            if (!this._registry.contains(eventName)) {
                var appId = this._appId;
                switch(eventName) {
                    case "global/onConnectionLost":
                        this._registry.set(eventName, new GlobalOnConnectionLost());
                        break;
                    case "global/onConnectionRegained":
                        this._registry.set(eventName, new GlobalOnConnectionRegained());
                        break;
                    case "global/onLocationUpdate":
                        this._registry.set(eventName, new GlobalOnLocationUpdate());
                        break;
                    case "contentProvider/onChange":
                        this._registry.set(eventName, new ContentProviderOnChange(appId));
                        break;
                    case "widget/onChange":
                        this._registry.set(eventName, new WidgetOnChange(appId));
                        break;
                    case "widget/onClick":
                        this._registry.set(eventName, new WidgetOnClick(appId));
                        break;
                    case "widget/onLeftSwipe":
                        this._registry.set(eventName, new WidgetOnLeftSwipe(appId));
                        break;
                    case "widget/onRightSwipe":
                        this._registry.set(eventName, new WidgetOnRightSwipe(appId));
                        break;
                    case "widget/onWrongValidation":
                        this._registry.set(eventName, new WidgetOnWrongValidation(appId));
                        break;
                }
            }
            
            return this._registry.get(eventName);
        }
    });
});
