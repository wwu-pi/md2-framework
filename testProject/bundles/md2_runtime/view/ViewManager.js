define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "dojo/dom",
    "dojo/dom-construct",
    "ct/Hash",
    "./WidgetWrapper"
],
function(declare, array, dom, domConstruct, Hash, WidgetWrapper) {
    
    return declare([], {
        
        _widgetRegistry: undefined,
        
        _dataFormService: undefined,
        
        _dataMapper: undefined,
        
        _dataFormDescriptions: undefined,
        
        _currentView: undefined,
        
        constructor: function(widgetRegistry, dataFormService, dataMapper) {
            this._widgetRegistry = widgetRegistry;
            this._dataFormService = dataFormService;
            this._dataMapper = dataMapper;
            this._dataFormDescriptions = new Hash();
        },
        
        goto: function(viewName) {
            
            var domNodeDataForm = dom.byId("md2_view");
            
            if (domNodeDataForm) {
                // destroy current view
                var previousView = this._currentView;
                if (previousView) {
                    this._unsetAllFormControls(previousView.bodyControl);
                    domConstruct.empty(domNodeDataForm);
                    previousView.destroyRecursive();
                }

                // attach data form to DOM
                var dataFormWidget = this._buildView(viewName);
                dataFormWidget.placeAt(domNodeDataForm).startup();
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
            
            // create data form for current view
            var dataFormWidget = dataFormService.createDataForm(dataFormDescription);
            this._setAllFormControls(dataFormWidget.bodyControl);
            this._currentView = dataFormWidget;
            
            // bind dataMapper to data form
            var binding = dataFormService.createBinding("contentProvider", {
                dataMapper: dataMapper
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
                var widgetWrapper = new WidgetWrapper(id, datatype, defaultValue);
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
