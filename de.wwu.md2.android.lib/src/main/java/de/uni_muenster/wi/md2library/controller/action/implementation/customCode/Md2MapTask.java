package de.uni_muenster.wi.md2library.controller.action.implementation.customCode;

import de.uni_muenster.wi.md2library.controller.action.implementation.customCode.interfaces.Md2CustomCodeTask;
import de.uni_muenster.wi.md2library.controller.datamapper.Md2DataMapper;
import de.uni_muenster.wi.md2library.exception.Md2WidgetNotCreatedException;
import de.uni_muenster.wi.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;
import de.uni_muenster.wi.md2library.view.management.implementation.Md2ViewManager;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Content;

/**
 * Maps a widget and a content provider.
 * Represents MappingTask element in MD2-DSL.
 * <p/>
 * Created on 24/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2MapTask implements Md2CustomCodeTask {
    /**
     * The Attribute.
     */
    String attribute;

    /**
     * The Content provider.
     */
    String contentProvider;

    /**
     * The Widget id.
     */
    int widgetId;

    /**
     * Instantiates a new Md 2 map task.
     *
     * @param contentProvider the key of the content provider
     * @param widgetId        the widget id
     * @param attribute       the attribute
     */
    public Md2MapTask(String contentProvider, int widgetId, String attribute) {
        this.attribute = attribute;
        this.contentProvider = contentProvider;
        this.widgetId = widgetId;
    }

    @Override
    public void execute() throws Md2WidgetNotCreatedException {
        Md2Content widget = null;
        try {
            widget = (Md2Content) Md2ViewManager.getInstance().getWidget(widgetId);
        } catch (ClassCastException e) {
            return;
        }

        if (widget == null) {
            throw new Md2WidgetNotCreatedException();
        }

        Md2ContentProvider cp = Md2ContentProviderRegistry.getInstance().getContentProvider(contentProvider);
        Md2DataMapper.getInstance().map(cp, widget, attribute);
    }
}
