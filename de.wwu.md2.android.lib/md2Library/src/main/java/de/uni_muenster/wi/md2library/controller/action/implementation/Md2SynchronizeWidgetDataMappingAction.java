package de.uni_muenster.wi.md2library.controller.action.implementation;

import de.uni_muenster.wi.md2library.controller.action.implementation.customCode.Md2SyncDirection;
import de.uni_muenster.wi.md2library.controller.action.implementation.customCode.Md2SyncTask;
import de.uni_muenster.wi.md2library.controller.action.implementation.customCode.Md2TaskQueue;
import de.uni_muenster.wi.md2library.exception.Md2WidgetNotCreatedException;
import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Content;

/**
 * Used by the Md2DataMapper to synchronize a content provider and a widget.
 * Sync: Content provider --> widget
 * <p/>
 * Created on 12/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2SynchronizeWidgetDataMappingAction extends AbstractMd2Action {
    /**
     * The Widget.
     */
    Md2Content widget;
    /**
     * The Content provider.
     */
    Md2ContentProvider contentProvider;
    /**
     * The Attribute.
     */
    String attribute;

    /**
     * Instantiates a new Md 2 synchronize widget data mapping action.
     *
     * @param widget          the widget
     * @param contentProvider the content provider
     * @param attribute       the attribute
     */
    public Md2SynchronizeWidgetDataMappingAction(Md2Content widget, Md2ContentProvider contentProvider, String attribute) {
        super("Md2SynchronizeWidgetDataMappingAction" + String.valueOf(widget.getWidgetId()) + contentProvider.getKey() + attribute);
        this.widget = widget;
        this.contentProvider = contentProvider;
        this.attribute = attribute;
    }

    @Override
    public void execute() {
        Md2SyncTask var1 = null;
        try {
            var1 = new Md2SyncTask(widget.getWidgetId(), contentProvider.getKey(), attribute, Md2SyncDirection.CONTENTPROVIDER_TO_WIDGET);
            var1.execute();
        } catch (Md2WidgetNotCreatedException e) {
            Md2TaskQueue.getInstance().addPendingTask(var1);
        }
    }
}
