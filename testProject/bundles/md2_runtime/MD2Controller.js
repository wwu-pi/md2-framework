define([
    "dojo/_base/declare",
    "./MD2MainWidget",
    "dojo/_base/array",
    "./contentprovider/ContentProviderRegistry",
    "./datamapper/DataMapper",
    "./handler/MD2DataEventHandler",
    "./view/WidgetRegistry",
    "./view/ViewManager",
    "./events/EventRegistry",
    "./actions/ActionFactory",
    "./validators/ValidatorFactory",
    "./datatypes/TypeFactory"
],
function(
    declare,
    MD2MainWidget,
    array,
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
    return declare([], {
        
        _mainWidget: undefined,
        
        activate: function() {
            
            var window = this._createWindow();
            window.show();
            
            // injected notification service
            var notificationService = this._notificationService;
            
            // injected custom actions
            var customActions = this._customActions;
            
            // injected entities
            TypeFactory.entities = this._entities;
            
            var contentProviderRegistry = this._createContentProviderRegistry();
            var dataMapper = new DataMapper();
            this._createContentProviders(contentProviderRegistry, dataMapper);
            
            var widgetRegistry = new WidgetRegistry();
            var viewManager = this._createDataForms(widgetRegistry, dataMapper, window);
            
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
            
            var actionFactory = new ActionFactory(customActions, references);
            
            // execute onInitialized action
            actionFactory.getCustomAction(this._dataFormBean.onInitialized).execute();
            
        },
        
        deactivate: function() {
            this._mainWidget.destroyRecursive();
            this._mainWidget = null;
        },
        
        createInstance: function() {
            return this._mainWidget;
        },
        
        
        _createContentProviderRegistry: function() {
            // configure store factory
            var storeFactory = this._storeFactory;
            var entities = this._dataFormBean.entities;
            storeFactory.setDefaultServiceUri(this._dataFormBean.serviceUri);
            
            return new ContentProviderRegistry(storeFactory, entities);
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
        
        _createDataForms: function(widgetRegistry, dataMapper, window) {
            
            // DataFormService and dataFormBean injected by the component runtime
            var dataFormService = this._dataFormService;
            var views = this._dataFormBean.views;
            
            var viewManager = new ViewManager(widgetRegistry, window, dataFormService, dataMapper);
            
            array.forEach(views, function(view) {
                viewManager.setupView(view.name, view.dataForm);
            });
            
            return viewManager;
        },
        
        _createWindow: function() {
            
            this._mainWidget = new MD2MainWidget({});
            
            var windowSize = {
                w: "60%",
                h: "60%"
            };
            
            var windowProperites = {
                content: this._mainWidget,
                title: this._dataFormBean.windowTitle,
                marginBox: windowSize,
                windowName: "md2_window_root"
            };
            
            var window = this._windowManager.createWindow(windowProperites);
            
            return window;
        }
        
    });
});
