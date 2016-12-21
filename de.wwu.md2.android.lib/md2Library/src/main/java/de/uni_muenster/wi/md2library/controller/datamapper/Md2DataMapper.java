package de.uni_muenster.wi.md2library.controller.datamapper;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.controller.action.implementation.Md2SynchronizeContentProviderDataMappingAction;
import de.uni_muenster.wi.md2library.controller.action.implementation.Md2SynchronizeWidgetDataMappingAction;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnAttributeChangedHandler;
import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Content;

/**
 * Data mapper is used to synchronize values of widgets and content providers.
 * It registers
 * Implemented as singleton.
 * <p/>
 * Created on 12/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2DataMapper {
    private static Md2DataMapper instance;
    /**
     * The Mappings.
     */
    protected ArrayList<Mapping> mappings;

    private Md2DataMapper() {
        this.mappings = new ArrayList<>();
    }

    /**
     * Gets instance of Md2DataMapper.
     *
     * @return the instance
     */
    public static synchronized Md2DataMapper getInstance() {
        if (Md2DataMapper.instance == null) {
            Md2DataMapper.instance = new Md2DataMapper();
        }
        return Md2DataMapper.instance;
    }

    /**
     * Maps a widget and a content provider.
     * The method registers a sync action in the widget's onChangedHandler and the
     * content provider's onAttributeChangedHandler.
     *
     * @param contentProvider the content provider
     * @param widget          the widget
     * @param attribute       the attribute
     */
// maps a widget and contentProvider
    public void map(Md2ContentProvider contentProvider, Md2Content widget, String attribute) {
        Mapping mapping = new Mapping(contentProvider, widget, attribute);
        if (this.mappings.contains(mapping)) {
            return;
        }

        this.mappings.add(mapping);
        // add sync action for contentProvider
        Md2OnAttributeChangedHandler oaceh = contentProvider.getOnAttributeChangedHandler(attribute);
        if (oaceh == null) {
            oaceh = new Md2OnAttributeChangedHandler(attribute);
        }
        oaceh.registerAction(new Md2SynchronizeWidgetDataMappingAction(widget, contentProvider, attribute));
        contentProvider.registerAttributeOnChangeHandler(attribute, oaceh);

        // add event for Widget
        widget.getOnChangedHandler().registerAction(new Md2SynchronizeContentProviderDataMappingAction(widget, contentProvider, attribute));

        // first sync
        Md2Type val = contentProvider.getValue(attribute);
        widget.setValue(val);
    }

    /**
     * Removes synchronization of widget and content provider.
     * I.e., the sync actions are removed from the event handlers.
     *
     * @param contentProvider the content provider
     * @param widget          the widget
     * @param attribute       the attribute
     */
// unmaps a widget and content provider
    public void unmap(Md2ContentProvider contentProvider, Md2Content widget, String attribute) {
        Mapping mapping = new Mapping(contentProvider, widget, attribute);
        if (!this.mappings.contains(mapping)) {
            return;
        }

        this.mappings.remove(mapping);

        // remove sync action for contentProvider
        contentProvider.getOnAttributeChangedHandler(attribute).unregisterAction(new Md2SynchronizeWidgetDataMappingAction(widget, contentProvider, attribute));

        // remove event for Widget
        widget.getOnChangedHandler().unregisterAction(new Md2SynchronizeContentProviderDataMappingAction(widget, contentProvider, attribute));
    }

    /**
     * Representation of a mapping between a widget and a content provider.
     */
    private static class Mapping {
        /**
         * The Content provider.
         */
        protected Md2ContentProvider contentProvider;
        /**
         * The Widget.
         */
        protected Md2Content widget;
        /**
         * The Attribute.
         */
        protected String attribute;

        /**
         * Instantiates a new Mapping.
         *
         * @param contentProvider the content provider
         * @param widget          the widget
         * @param attribute       the attribute
         */
        Mapping(Md2ContentProvider contentProvider, Md2Content widget, String attribute) {
            this.contentProvider = contentProvider;
            this.widget = widget;
            this.attribute = attribute;
        }

        /**
         * Gets content provider.
         *
         * @return the content provider
         */
        public Md2ContentProvider getContentProvider() {
            return contentProvider;
        }

        /**
         * Gets widget.
         *
         * @return the widget
         */
        public Md2Content getWidget() {
            return widget;
        }

        /**
         * Gets attribute.
         *
         * @return the attribute
         */
        public String getAttribute() {
            return attribute;
        }

        @Override
        public boolean equals(Object otherObject) {
            if (otherObject == null || !(otherObject instanceof Mapping))
                return false;

            Mapping otherMapping = (Mapping) otherObject;

            if (!this.getContentProvider().equals(otherMapping.getContentProvider()))
                return false;

            if (!this.getWidget().equals(otherMapping.getWidget()))
                return false;

            return this.getAttribute().equals(otherMapping.getAttribute());

        }
    }
}
