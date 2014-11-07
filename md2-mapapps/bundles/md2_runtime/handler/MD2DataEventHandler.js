define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/string", "dojo/topic", "dojo/dom-style"
],

/**
 * 
 */
function(declare, lang, string, topic, domStyle) {
    return declare([], {
        
        spinnerMinDisplayTime: 1000,
        
        contentProviderTopic: "md2/contentProvider/dataAction/${appId}",
        
        _date: null,
        
        _dataMapper: null,
        
        _notificationService: null,
        
        _activeDataEventsQueue: null,
        
        _isActive: false,
        
        _activeDataEventsStartTime: 0,
        
        _currentTimeout: null,
        
        _spinnerOverlay: null,
        
        constructor: function(dataMapper, notificationService, mainWidget, appId, options) {
            declare.safeMixin(this, options);
            this._dataMapper = dataMapper;
            this._notificationService = notificationService;
            this._date = new Date();
            this._activeDataEventsQueue = [];
            this.contentProviderTopic = string.substitute(this.contentProviderTopic, {appId: appId});
            
            this._spinnerOverlay = {
                show: function() {
                    domStyle.set(mainWidget.spinnerOverlay, "display", "block");
                },
                hide: function() {
                    domStyle.set(mainWidget.spinnerOverlay, "display", "none");
                }
            };
            this._subscribeContentProviderTopic();
        },
        
        /**
         * DataActions register all load/save/remove requests.
         * When actions are fired, the requests are released. If after a certain amout of time no answer has been fired, release
         * the lock and display error message.
         */
        registerDataEvent: function(dataTask) {
            this._activeDataEventsQueue.push(dataTask);
            if(!this._isActive) {
                this._isActive = true;
                var currentTimeout = this._currentTimeout;
                currentTimeout && window.clearTimeout(currentTimeout);
                this._activeDataEventsStartTime = this._date.getTime();
                this._spinnerOverlay.show();
                this._executeNextTask();
            }
        },
        
        _executeNextTask: function() {
            if (this._activeDataEventsQueue.length) {
                var next = this._activeDataEventsQueue.shift();
                next();
            } else {
                // hide spinner after a minimum timespan of 1000 milliseconds
                var displayTime = this._date.getTime() - this._activeDataEventsStartTime;
                var minDisplayTime = this.spinnerMinDisplayTime;
                this._currentTimeout = window.setTimeout(lang.hitch(this, function() {
                    this._spinnerOverlay.hide();
                    this._isActive = false;
                }), displayTime < minDisplayTime ? minDisplayTime - displayTime : 0);
            }
        },
        
        _subscribeContentProviderTopic: function() {
            topic.subscribe(this.contentProviderTopic, lang.hitch(this, function(status, contentProvider, action, errMsg) {
                
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
                
                this._executeNextTask();
                
            }));
        }
        
    });
});
