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
        _registry: undefined,
        
        constructor: function() {
            this._registry = new Hash();
        },
        
        get: function(eventName) {
            if (!this._registry.contains(eventName)) {
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
                        this._registry.set(eventName, new ContentProviderOnChange());
                        break;
                    case "widget/onChange":
                        this._registry.set(eventName, new WidgetOnChange());
                        break;
                    case "widget/onClick":
                        this._registry.set(eventName, new WidgetOnClick());
                        break;
                    case "widget/onLeftSwipe":
                        this._registry.set(eventName, new WidgetOnLeftSwipe());
                        break;
                    case "widget/onRightSwipe":
                        this._registry.set(eventName, new WidgetOnRightSwipe());
                        break;
                    case "widget/onWrongValidation":
                        this._registry.set(eventName, new WidgetOnWrongValidation());
                        break;
                }
            }
            
            return this._registry.get(eventName);
        }
    });
});
