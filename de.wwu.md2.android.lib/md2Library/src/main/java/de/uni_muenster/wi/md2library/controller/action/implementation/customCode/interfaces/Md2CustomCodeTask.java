package de.uni_muenster.wi.md2library.controller.action.implementation.customCode.interfaces;

import de.uni_muenster.wi.md2library.exception.Md2WidgetNotCreatedException;

/**
 * Interface definition of a custom code task.
 * Custom code tasks are used in custom code actions.
 * Represents task in CustomCodeFragment element in MD2-DSL.
 * <p/>
 * Created on 24/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2CustomCodeTask {
    /**
     * Execute the tasks.
     *
     * @throws Md2WidgetNotCreatedException the widget not created exception
     */
    void execute() throws Md2WidgetNotCreatedException;
}
