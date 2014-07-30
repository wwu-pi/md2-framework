define([
    "dojo/_base/declare",
    "ct/_lang",
    "./MD2MainWidget",
    "dojo/dom",
    "dijit/form/Button",
    "dojo/_base/array",
    "./MD2ContentProviderRegistry",
    "./datamapper/DataMapper",
    "./MD2ActionExecutor",
    "./MD2DataEventHandler",
    "./MD2CustomEventHandler"
],
function(declare, ct_lang, MD2MainWidget, dom, Button, array, MD2ContentProviderRegistry, DataMapper, MD2ActionExecutor, MD2DataEventHandler, MD2CustomEventHandler) {
    return declare([], {
        
        // attributes
        
        _mainWidget: null,
        
        _contentProviderRegistry: null,
        
        _dataMapper: null,
        
        _eventHandler: null,
        
        
        // public methods
        
        activate: function() {
            
            var window = this._window = this._createWindow();
            window.show();
            
            this._contentProviderRegistry = this._createContentProviderRegistry();
            this._createContentProviders();
            this._dataMapper = new DataMapper();
            
            
            var dataFormWidget = this._createDataForm();
            this._attachElementsToWindow(dataFormWidget);
            
            this._eventHandler = new MD2DataEventHandler(this._getReferences());
            this._customEventHandler = new MD2CustomEventHandler(this._customEventsDefinition, this._getReferences());
            
            // now everything is loaded => execute actions
            var exec = new MD2ActionExecutor(this._customActionsDefinition, this._getReferences(!0));
            exec.run(this._dataFormBean.onInitialized);
            
            
            // TODO remove
            {
                console.log(dataFormWidget.bodyControl.children);
                var fc = this._dataMapper.getMapping("startView$outerPanel$customerId").formControl;
                fc.widget.constraints.min = "750";
                fc.widget.regExp = "[0-9]{3}$";
                fc.widget.regex = "[0-9]{3}$";
                fc.widget.pattern = "[0-9]{3}$";
                var fc = this._dataMapper.getMapping("startView$outerPanel$dateOfBirth").formControl;
                //alert(fc.widget._defaultValidator);
            }
            
        },
        
        deactivate: function() {
            this._mainWidget.destroyRecursive();
            this._mainWidget = null;
        },
        
        createInstance: function() {
            return this._mainWidget;
        },
        
        
        // private methods
        
        _createContentProviderRegistry: function() {
            // configure store factory
            var storeFactory = this._storeFactory;
            var entities = this._dataFormBean.entities;
            storeFactory.setDefaultServiceUri(this._dataFormBean.serviceUri);
            
            return new MD2ContentProviderRegistry(storeFactory, entities);
        },
        
        _createContentProviders: function() {
            
            var contentProviders = this._dataFormBean.contentProviders;
            var dataMapper = this._dataMapper;
            
            array.forEach(contentProviders, function(contentProvider) {
                if(contentProvider.configuration.filter) {
                    contentProvider.configuration.filter.dataMapper = dataMapper;
                }
                this._contentProviderRegistry.registerContentProvider(contentProvider.name, contentProvider.configuration);
            }, this);
        },
        
        _createDataForm: function() {
            
            // DataFormService and dataFormBean injected by the component runtime
            var dataFormService = this._dataFormService;
            var currentView = this._dataFormBean.views[1];
            
            // create dataFormObject that describes what the data form looks like
            //var dataFormObject = json.parse(dataformJson);
            var dataFormObject = currentView.dataForm;
            var dataFormWidget = dataFormService.createDataForm(dataFormObject);
            
            // bind view
            this._dataMapper.bindDataForm(currentView.name, dataFormWidget);
            
            // load view
            this._dataMapper.setCurrentView(currentView.name).updateDataForm();
            
            return dataFormWidget;
        },
        
        _createWindow: function() {
            
            this._mainWidget = new MD2MainWidget({});
            
            var windowSize = {
                w: this._dataFormBean.views[1].dataForm["size"]["w"] + 20,
                h: this._dataFormBean.views[1].dataForm["size"]["h"] + 100
            };
            
            var windowProperites = {
                content: this._mainWidget,
                title: this._dataFormBean.windowTitle,
                marginBox: windowSize,
                windowName: "md2_window_root"
            };
            
            var window = this._windowManager.createWindow(windowProperites);
            
            return window;
        },
        
        _attachElementsToWindow: function(dataFormWidget) {
            // attach data form to DOM
            var domNodeDataForm = dom.byId("md2_testwidget_dataform");
            dataFormWidget.placeAt(domNodeDataForm).startup();
            
            // generate and attach save button
            new Button({
                label: "Save",
                eventScope: {
                    dataFormWidget: dataFormWidget,
                    contentProvider: this._contentProviderRegistry.getContentProvider("customerProvider")
                },
                onClick: this._onSaveClick
            }, "md2_testwidget_savebutton");
        },
        
        _onSaveClick: function() {
            var binding = this.eventScope.dataFormWidget.get("dataBinding");
            
            if (this.eventScope.dataFormWidget.isValid() && binding.get("startView$outerPanel$acceptConditions")) {
                this.eventScope.contentProvider.save();
                alert("Saved!");
                /*.then(function(response) {
                    alert("Saved!\n" + "ID: " + response[0].__internalId);
                });*/
            }
            else {
                alert("Please fill out all fields!");
            }
        },
        
        _getReferences: function(isEnforceAll) {
            
            isEnforceAll = isEnforceAll || false;
            
            var references = {
                contentProviderRegistry: this._contentProviderRegistry,
                dataMapper: this._dataMapper,
                eventHandler: this._eventHandler,
                notificationService: this._notificationService
            };
            
            if(isEnforceAll) {
                var nullRefs = ct_lang.getOwnPropNamesWithValue(references, null);
                nullRefs.length && window.console && window.console.warn("MD2MainController: _" + nullRefs.join(", ") + " has/have not been initialized, yet!");
            } else {
                ct_lang.removeUndefinedProps(references);
            }
            
            return references;
        }
        
    });
});
