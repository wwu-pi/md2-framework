define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "dijit/_Widget",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetsInTemplateMixin",
    "dojo/text!./templates/MainWidget.html",
    "./contentprovider/ContentProviderRegistry",
    "./datamapper/DataMapper",
    "./handler/MD2DataEventHandler",
    "./view/WidgetRegistry",
    "./view/ViewManager",
    "./events/EventRegistry",
    "./actions/ActionFactory",
    "./validators/ValidatorFactory",
    "./datatypes/TypeFactory"
], function(
    declare,
    array,
    _Widget,
    _TemplatedMixin,
    _WidgetsInTemplateMixin,
    templateStringContent,
    ContentProviderRegistry,
    DataMapper,
    MD2DataEventHandler,
    WidgetRegistry,
    ViewManager,
    EventRegistry,
    ActionFactory,
    ValidatorFactory,
    TypeFactory
) {
    
    return declare([_Widget, _TemplatedMixin, _WidgetsInTemplateMixin], {
        
        templateString: templateStringContent,
        
        _isFirstExecution: true,
        
        constructor: function(injectedServices) {
            declare.safeMixin(this, injectedServices);
        },
        
        openWindow: function() {
            var window = this._window;
            var actionFactory = this._actionFactory;
            if (window) {
                window.show();
                
                // execute onInitialized action
                if (this._isFirstExecution) {
                    this._isFirstExecution = false;
                    actionFactory.getCustomAction(this._dataFormBean.onInitialized).execute();
                }
            }
        },
        
        closeWindow: function() {
            var window = this._window;
            if (window) {
                window.hide();
            }
        },
        
        build: function() {
            
            // injected notification service
            var notificationService = this._notificationService;
            
            // injected custom actions
            var customActions = this._customActions;
            
            // injected entities
            TypeFactory.entityFactories = this._entities;
            
            var contentProviderRegistry = this._createContentProviderRegistry();
            var dataMapper = new DataMapper();
            this._createContentProviders(contentProviderRegistry, dataMapper);
            
            var widgetRegistry = new WidgetRegistry();
            var viewManager = this._createDataForms(widgetRegistry, dataMapper);
            
            var eventRegistry = new EventRegistry();
            var dataEventHandler = new MD2DataEventHandler(dataMapper, notificationService);
            
            var validatorFactory = new ValidatorFactory();
            
            var references = {
                dataMapper: dataMapper,
                eventRegistry: eventRegistry,
                contentProviderRegistry: contentProviderRegistry,
                actionFactory: undefined,
                viewManager: viewManager,
                widgetRegistry: widgetRegistry,
                dataEventHandler: dataEventHandler,
                notificationService: notificationService,
                validatorFactory: validatorFactory
            };
            
            this._actionFactory = new ActionFactory(customActions, references);
            
            this._window = this._createWindow();
            
        },
        
        _createContentProviderRegistry: function() {
            // configure store factory
            var storeFactory = this._storeFactory;
            storeFactory.setDefaultServiceUri(this._dataFormBean.serviceUri);
            
            return new ContentProviderRegistry(storeFactory);
        },
        
        _createContentProviders: function(contentProviderRegistry, dataMapper) {
            
            var contentProviders = this._dataFormBean.contentProviders;
            
            array.forEach(contentProviders, function(contentProvider) {
                if(contentProvider.configuration.filter) {
                    contentProvider.configuration.filter.dataMapper = dataMapper;
                }
                contentProviderRegistry.registerContentProvider(contentProvider.name, contentProvider.configuration);
            });
        },
        
        _createDataForms: function(widgetRegistry, dataMapper) {
            
            // DataFormService and dataFormBean injected by the component runtime
            var dataFormService = this._dataFormService;
            var views = this._dataFormBean.views;
            
            var viewManager = new ViewManager(widgetRegistry, dataFormService, dataMapper);
            
            array.forEach(views, function(view) {
                viewManager.setupView(view.name, view.dataForm);
            });
            
            return viewManager;
        },
        
        _createWindow: function() {
            
            var windowSize = {
                w: "60%",
                h: "60%"
            };
            
            var windowProperites = {
                content: this,
                title: this._dataFormBean.windowTitle,
                marginBox: windowSize,
                minimizeOnClose: true,
                windowName: "md2_window_root"
            };
            
            var window = this._windowManager.createWindow(windowProperites);
            
            return window;
        }
        
    });
});
