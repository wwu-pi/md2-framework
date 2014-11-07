define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/_base/array",
    "dojo/dom-construct",
    "dojo/dom-geometry",
    "ct/_lang",
    "ct/Hash",
    "./WidgetWrapper"
],
function(declare, lang, array, domConstruct, domGeometry, ct_lang, Hash, WidgetWrapper) {
    
    return declare([], {
        
        _widgetRegistry: null,
        
        _dataFormService: null,
        
        _dataMapper: null,
        
        _typeFactory: null,
        
        _mainWidget: null,
        
        _appId: null,
        
        _dataFormDescriptions: null,
        
        _currentView: null,
        
        _currentSubViews: null,
        
        _lastDisplayedViewName: null,
        
        /**
         * Hash that represents the view hierarchy. E.g., if a view in a tab is showed, the
         * parental view that shows the actual tab-pane has to be displayed as well.
         * Hash: view->parentView
         */
        _subviewHierarchy: null,
        
        constructor: function(widgetRegistry, dataFormService, dataMapper, typeFactory, mainWidget, appId) {
            this._widgetRegistry = widgetRegistry;
            this._dataFormService = dataFormService;
            this._dataMapper = dataMapper;
            this._typeFactory = typeFactory;
            this._mainWidget = mainWidget;
            this._appId = appId;
            this._dataFormDescriptions = new Hash();
            this._subviewHierarchy = new Hash();
        },
        
        /**
         * Recursively displays the view with the given name and all its parental views.
         * @param {string} viewName
         */
        goto: function(viewName) {
            var parentViewName = this._subviewHierarchy.get(viewName);
            if (parentViewName) {
                this.goto(parentViewName);
                var subViewContainer = this._currentSubViewContainers.get(viewName);
                var subView = this._currentSubViews.get(viewName).widget;
                subViewContainer.widget.selectChild(subView);
            } else {
                this._showMainView(viewName);
            }
            this._lastDisplayedViewName = viewName;
        },
        
        destroyCurrentView: function() {
            var domNodeDataForm = this._mainWidget.displayViewNode;
            
            // destroy current view
            var previousView = this._currentView;
            if (previousView) {
                this._unsetAllFormControls(previousView.bodyControl);
                domConstruct.empty(domNodeDataForm);
                previousView.get("dataBinding").destroy();
                previousView.destroyRecursive();
                this._currentView = null;
            }
        },
        
        restoreLastView: function() {
            this.goto(this._lastDisplayedViewName);
        },
        
        resizeView: function() {
            // samll time laps to ensure that the new size is already assigned to DOM tree
            setTimeout(lang.hitch(this, function() {
                var containerNode = this._mainWidget.domNode.parentNode;
                if (!containerNode) {
                    return;
                }
                var contentBox = domGeometry.getContentBox(containerNode);
                var currentView = this._currentView;
                if (currentView) {
                    currentView.resize({
                        w: contentBox.w,
                        h: contentBox.h
                    });
                }
            }), 250);
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
            this._registerAllFormControls(dataFormDescription, viewName);
        },
        
        _buildView: function(viewName) {
            // create new view
            var dataFormDescription = this._dataFormDescriptions.get(viewName);
            var dataFormService = this._dataFormService;
            var dataMapper = this._dataMapper;
            var typeFactory = this._typeFactory;
            
            // create data form for current view
            var dataFormWidget = dataFormService.createDataForm(dataFormDescription);
            this._currentSubViews = null;
            this._currentSubViewContainers = null;
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
        
        _showMainView: function(viewName) {
            // check whether view is already displayed
            if (this._currentView && this._lastDisplayedViewName === viewName) {
                return;
            }
            
            this.destroyCurrentView();
            
            // attach data form to DOM
            var domNodeDataForm = this._mainWidget.displayViewNode;
            var dataFormWidget = this._buildView(viewName);
            dataFormWidget.placeAt(domNodeDataForm).startup();
            
            this.resizeView();
        },
        
        /**
         * Recursively extract all data form controls from data form description and
         * create WidgetWrappers in WigetRegistry for them.
         * 
         * @param {FormControl} dataFormDescription
         */
        _registerAllFormControls: function(dataFormDescription, currentParentView) {
            
            // register all formControls in widgetRegistry
            array.forEach(dataFormDescription.children, function(child) {
                var id = child.field;
                var datatype = child.datatype;
                var defaultValue = child.defaultValue;
                var typeFactory = this._typeFactory;
                var appId = this._appId;
                var widgetWrapper = new WidgetWrapper(id, datatype, defaultValue, typeFactory, appId);
                this._widgetRegistry.add(widgetWrapper);
                
                this._addSubViewToHierarchyHash(child, currentParentView);
                
                if (child.children) {
                    var parentViewName = child.subViewName || currentParentView;
                    this._registerAllFormControls(child, parentViewName);
                }
            }, this);
        },
        
        /**
         * If the current dataFormDescription is a sub view (i.e., a tabbed or an alternatives pane),
         * add it to the hierarchy hash.
         * 
         * @param {type} widgetDescription
         */
        _addSubViewToHierarchyHash: function(widgetDescription, parentViewName) {
            var subViewName = widgetDescription.subViewName;
            if (!subViewName) {
                return;
            }
            this._subviewHierarchy.set(subViewName, parentViewName);
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
                
                this._populateSelectBox(child);
                
                this._currentSubViews = ct_lang.chk(this._currentSubViews, new Hash());
                if (child.subViewName) {
                    this._currentSubViews.set(child.subViewName, child);
                    this._currentSubViewContainers = ct_lang.chk(this._currentSubViewContainers, new Hash());
                    this._currentSubViewContainers.set(child.subViewName, dataFormWidget);
                }
                
                if (child.children) {
                    this._setAllFormControls(child);
                }
            }, this);
        },
        
        /**
         * Checks whether the given form control is a selectbox. If so, populate it with
         * the enum values specified in the view or the values currently mapped.
         * 
         * @param {FormControl} dataFormWidget
         */
        _populateSelectBox: function(dataFormWidget) {
            if (dataFormWidget.controlClass === "selectbox") {
                var datatype = dataFormWidget.datatype;
                var e = this._typeFactory.createEntity(datatype);
                dataFormWidget.searchAttribute = "name";
                dataFormWidget.values = e.getOptions();
            }
        }
    });
});
