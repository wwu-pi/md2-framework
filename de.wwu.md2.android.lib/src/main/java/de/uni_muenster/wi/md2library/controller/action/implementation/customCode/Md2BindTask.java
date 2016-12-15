package de.uni_muenster.wi.md2library.controller.action.implementation.customCode;

import de.uni_muenster.wi.md2library.controller.action.implementation.customCode.interfaces.Md2CustomCodeTask;
import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnAttributeChangedHandler;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2WidgetEventType;
import de.uni_muenster.wi.md2library.exception.Md2WidgetNotCreatedException;
import de.uni_muenster.wi.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;
import de.uni_muenster.wi.md2library.view.management.implementation.Md2ViewManager;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Widget;

/**
 * Binds an action to an event.
 * Represents EventBindingTask element in MD2-DSL.
 * <p/>
 * Created on 24/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2BindTask implements Md2CustomCodeTask {

    /**
     * The Action.
     */
    Md2Action action;

    /**
     * The Content provider.
     */
    String contentProvider;

    /**
     * The Attribute.
     */
    String attribute;

    /**
     * The Widget id.
     */
    int widgetId;

    /**
     * The Event type.
     */
    Md2WidgetEventType eventType;

    /**
     * Instantiates a new Md2 bind task.
     *
     * @param action          the action
     * @param contentProvider the key of the content provider
     * @param attribute       the attribute
     */
    public Md2BindTask(Md2Action action, String contentProvider, String attribute) {
        this.action = action;
        this.attribute = attribute;
        this.contentProvider = contentProvider;
    }

    /**
     * Instantiates a new Md2 bind task.
     *
     * @param action    the action
     * @param widgetId  the widget id
     * @param eventType the event type
     */
    public Md2BindTask(Md2Action action, int widgetId, Md2WidgetEventType eventType) {
        this.action = action;
        this.widgetId = widgetId;
        this.eventType = eventType;
    }

    @Override
    public void execute() throws Md2WidgetNotCreatedException {

        if (contentProvider == null || contentProvider.isEmpty()) {
            Md2Widget widget = Md2ViewManager.getInstance().getWidget(widgetId);

            if (widget == null) {
                throw new Md2WidgetNotCreatedException();
            }

            switch (eventType) {
                case ON_CHANGE:
                    widget.getOnChangedHandler().registerAction(action);
                    break;
                case ON_CLICK:
                    widget.getOnClickHandler().registerAction(action);
                    break;
                // TODO: implement other event types
                default:
                    return; // TODO: possible improvement: add general task execution exception
            }
        } else {
            Md2ContentProvider cp = Md2ContentProviderRegistry.getInstance().getContentProvider(contentProvider);
            Md2OnAttributeChangedHandler oaceh = cp.getOnAttributeChangedHandler(attribute);
            if (oaceh == null) {
                oaceh = new Md2OnAttributeChangedHandler(attribute);
            }
            oaceh.registerAction(action);
            cp.registerAttributeOnChangeHandler(attribute, oaceh);
        }
    }
}
