define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/topic", "dojo/query"
],

/**
 * 
 */
function(declare, lang, topic, query) {
    return declare([], {
        
        spinnerMinDisplayTime: 1000,
        
        contentProviderTopic: "md2/contentProvider/dataAction",
        
        spinnerOverlayId: "md2_spinner_overlay",
        
        _date: null,
        
        _dataMapper: null,
        
        _notificationService: null,
        
        _activeDataEventsCounter: 0,
        
        _activeDataEventsStartTime: 0,
        
        _currentTimeout: null,
        
        _spinnerOverlay: null,
        
        constructor: function(dataMapper, notificationService, options) {
            declare.safeMixin(this, options);
            this._dataMapper = dataMapper;
            this._notificationService = notificationService;
            this._date = new Date();
            
            var elem = query("#".concat(this.spinnerOverlayId));
            this._spinnerOverlay = {
                show: function() {
                    elem.style("display", "block");
                },
                hide: function() {
                    elem.style("display", "none");
                }
            };
            this._subscribeContentProviderTopic();
        },
        
        /**
         * DataActions register all load/save/remove requests.
         * When actions are fired, the requests are released. If after a certain amout of time no answer has been fired, release
         * the lock and display error message.
         */
        registerDataEvent: function() {
            if(!this._activeDataEventsCounter++) {
                var currentTimeout = this._currentTimeout;
                currentTimeout && window.clearTimeout(currentTimeout);
                this._activeDataEventsStartTime = this._date.getTime();
                this._spinnerOverlay.show();
            }
        },
        
        _subscribeContentProviderTopic: function() {
            topic.subscribe(this.contentProviderTopic, lang.hitch(this, function(status, contentProvider, action, errMsg) {
                
                // update dataForm with new contentProvider data
                if(action === "load" && status === "success") {
                    this._dataMapper.updateDataForm(contentProvider);
                }
                
                // post notification to map.apps log service
                var successMessage = {
                    load: "Data sucessfully loaded.",
                    save: "Data sucessfully saved.",
                    remove: "Data sucessfully removed."
                };
                
                var errorMessage = {
                    load: "Error on loading data.",
                    save: "Error on saving data.",
                    remove: "Error on removing data."
                };
                
                var logService = this._notificationService;
                if(status === "success") {
                    logService.info({
                        message: successMessage[action]
                    });
                } else if(status === "error") {
                    logService.error({
                        message: errorMessage[action].concat("\n", errMsg)
                    });
                }
                
                // hide spinner after a minimum timespan of 1000 milliseconds
                if(--this._activeDataEventsCounter === 0) {
                    var displayTime = this._date.getTime() - this._activeDataEventsStartTime;
                    var minDisplayTime = this.spinnerMinDisplayTime;
                    this._currentTimeout = window.setTimeout(lang.hitch(this, function() {
                        this._spinnerOverlay.hide();
                    }), displayTime < minDisplayTime ? minDisplayTime - displayTime : 0);
                }
            }));
        }
        
    });
});
