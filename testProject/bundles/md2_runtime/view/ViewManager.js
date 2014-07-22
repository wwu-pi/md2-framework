define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "dojo/dom-construct",
    "dojo/dom-geometry",
    "ct/Hash",
    "./WidgetWrapper"
],
function(declare, array, domConstruct, domGeometry, Hash, WidgetWrapper) {
    
    return declare([], {
        
        _widgetRegistry: null,
        
        _dataFormService: null,
        
        _dataMapper: null,
        
        _typeFactory: null,
        
        _mainWidget: null,
        
        _appId: null,
        
        _dataFormDescriptions: null,
        
        _currentView: null,
        
        _lastDisplayedViewName: null,
        
        constructor: function(widgetRegistry, dataFormService, dataMapper, typeFactory, mainWidget, appId) {
            this._widgetRegistry = widgetRegistry;
            this._dataFormService = dataFormService;
            this._dataMapper = dataMapper;
            this._typeFactory = typeFactory;
            this._mainWidget = mainWidget;
            this._appId = appId;
            this._dataFormDescriptions = new Hash();
        },
        
        goto: function(viewName) {
            
            this.destroyCurrentView();
            
            // attach data form to DOM
            var domNodeDataForm = this._mainWidget.displayViewNode;
            var dataFormWidget = this._buildView(viewName);
            dataFormWidget.placeAt(domNodeDataForm).startup();
            this._lastDisplayedViewName = viewName;
            
            this.resizeView();
        },
        
        destroyCurrentView: function() {
            var domNodeDataForm = this._mainWidget.displayViewNode;
            
            // destroy current view
            var previousView = this._currentView;
            if (previousView) {
                this._unsetAllFormControls(previousView.bodyControl);
                domConstruct.empty(domNodeDataForm);
                previousView.destroyRecursive();
                this._currentView = null;
            }
        },
        
        restoreLastView: function() {
            this.goto(this._lastDisplayedViewName);
        },
        
        resizeView: function() {
            var displayViewNode = this._mainWidget.displayViewNode;
            var marginBox = domGeometry.getMarginBox(displayViewNode);
            var currentView = this._currentView;
            if (currentView) {
                currentView.resize({
                    w: marginBox.w,
                    h: marginBox.h + 60
                });
            }
        },
        
        /**
         * After this method is called, all widgets for the particular view should be
         * available in the WidgetRegistry (view is ready to be mapped to contentProviders,
         * events, validators etc.).
         * 
         * @param {string} viewName
         * @param {DatFormDescription} dataFormDescription
         */
        setupView: function(viewName, dataFormDescription) {
            this._dataFormDescriptions.set(viewName, dataFormDescription);
            this._registerAllFormControls(dataFormDescription);
        },
        
        _buildView: function(viewName) {
            // create new view
            var dataFormDescription = this._dataFormDescriptions.get(viewName);
            var dataFormService = this._dataFormService;
            var dataMapper = this._dataMapper;
            var typeFactory = this._typeFactory;
            
            // create data form for current view
            var dataFormWidget = dataFormService.createDataForm(dataFormDescription);
            this._setAllFormControls(dataFormWidget.bodyControl);
            this._currentView = dataFormWidget;
            
            // bind dataMapper to data form
            var binding = dataFormService.createBinding("contentProvider", {
                dataMapper: dataMapper,
                typeFactory: typeFactory,
                appId: this._appId
            });
            dataFormWidget.set("dataBinding", binding);
            
            return dataFormWidget;
        },
        
        /**
         * Recursively extract all data form controls from data form description and
         * create WidgetWrappers in WigetRegistry for them.
         * 
         * @param {FormControl} dataFormDescription
         */
        _registerAllFormControls: function(dataFormDescription) {
            // register all formControls in widgetRegistry
            array.forEach(dataFormDescription.children, function(child) {
                var id = child.field;
                var datatype = child.datatype;
                var defaultValue = child.defaultValue;
                var typeFactory = this._typeFactory;
                var appId = this._appId;
                var widgetWrapper = new WidgetWrapper(id, datatype, defaultValue, typeFactory, appId);
                this._widgetRegistry.add(widgetWrapper);
                
                if (child.children) {
                    this._registerAllFormControls(child);
                }
            }, this);
        },
        
        /**
         * Unset the actual instances of FormControl in the WidgetWrappers.
         * Required on destroying the current view.
         * 
         * @param {DijitWidget} dataFormWidget
         */
        _unsetAllFormControls: function(dataFormWidget) {
            array.forEach(dataFormWidget.children, function(child) {
                var id = child.field;
                var widgetWrapper = this._widgetRegistry.getWidget(id);
                widgetWrapper && widgetWrapper.unsetWidget();
                
                if (child.children) {
                    this._unsetAllFormControls(child);
                }
            }, this);
        },
        
        /**
         * Set the actual instances of FormControl in the WidgetWrappers.
         * Required on creation of the new view.
         * 
         * @param {DijitWidget} dataFormWidget
         */
        _setAllFormControls: function(dataFormWidget) {
            array.forEach(dataFormWidget.children, function(child) {
                var id = child.field;
                var widgetWrapper = this._widgetRegistry.getWidget(id);
                widgetWrapper && widgetWrapper.setWidget(child);
                
                if (child.children) {
                    this._setAllFormControls(child);
                }
            }, this);
        }
    });
});
