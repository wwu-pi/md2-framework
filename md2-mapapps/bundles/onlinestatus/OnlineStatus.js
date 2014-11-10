define([
    "dojo/_base/declare", "dojo/_base/lang", "ct/_when", "ct/request", "ct/_url"
],
function(declare, lang, ct_when, ct_request, ct_url) {
    
    return declare([], {
        
        _xhrStatus: true,
        
        _navigationOnlineStatus: true,
        
        _previousOnlineStatus: true,
        
        _i18nMessages: {},
        
        activate: function() {
            var prop = this._properties;
            var url = prop.xhrRemoteUrl;
            
            if(url) {
                var host = window.location.origin;
                var path = url.replace(/^\/?/, "");
                url = ct_url.isAbsoluteURL(url) ? url : host + "/" + path;
            } else {
                url = ct_url.resourceURL("onlinestatus:./ping.txt");
            }
            
            this._i18nMessages = this._i18n.get().ui.messages;
            
            if(prop.navigatorOnLineCheck) {
                this._pollNavigatorOnline();
            }
            
            if(prop.xhrCheck) {
                this._pollXhr(url);
            }
        },
        
        isOnline: function() {
            return this._xhrStatus && this._navigationOnlineStatus;
        },
        
        _pollXhr: function(url) {
            var prop = this._properties;
            
            window.setInterval(lang.hitch(this, function() {
                if(!this._navigationOnlineStatus) {
                    return;
                }
                ct_when(ct_request({
                    url: url,
                    handleAs: "text",
                    timeout: prop.xhrTimeout
                }, {
                    usePost: prop.method === "post"
                }), this._onXhrSuccess, this._onXhrError, this);
            }), prop.xhrFrequency);
        },
        
        _pollNavigatorOnline: function() {
            var prop = this._properties;
            
            if(!("onLine" in navigator)) {
                return;
            }
            
            window.setInterval(lang.hitch(this, function() {
                this._navigationOnlineStatus = navigator.onLine;
                this._postOnlineStatusChange();
            }), prop.pollingFrequency);
        },
        
        _onXhrSuccess: function() {
            this._xhrStatus = true;
            this._postOnlineStatusChange();
        },
        
        _onXhrError: function() {
            this._xhrStatus = false;
            this._postOnlineStatusChange();
        },
        
        _postOnlineStatusChange: function() {
            var prop = this._properties;
            if(this._previousOnlineStatus !== this.isOnline()) {
                if(this.isOnline()) {
                    this._eventService.postEvent("md2/onlinestatus/REGAINED_CONNECTION", {prop: "online"});
                    prop.postNotifications && this._notificationService.info({
                        message: this._i18nMessages.regainedConnection
                    });
                } else {
                    this._eventService.postEvent("md2/onlinestatus/LOST_CONNECTION", {prop: "online"});
                    prop.postNotifications && this._notificationService.error({
                        message: this._i18nMessages.lostConnection
                    });
                }
            }
            this._previousOnlineStatus = this.isOnline();
        }
        
    });
});
