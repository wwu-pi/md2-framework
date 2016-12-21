package de.uni_muenster.wi.md2library.controller.action.implementation.customCode;

/**
 * Used to define the direction of a synchronization in the Md2SyncTask.
 * <p/>
 * Created on 11/09/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public enum Md2SyncDirection {
    /**
     * Contentprovider --> widget md 2 sync direction.
     */
    CONTENTPROVIDER_TO_WIDGET,

    /**
     * Widget --> contentprovider
     */
    WIDGET_TO_CONTENTPROVIDER
}
