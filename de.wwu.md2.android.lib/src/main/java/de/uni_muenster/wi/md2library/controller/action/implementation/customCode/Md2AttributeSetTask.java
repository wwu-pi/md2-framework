package de.uni_muenster.wi.md2library.controller.action.implementation.customCode;

import de.uni_muenster.wi.md2library.controller.action.implementation.customCode.interfaces.Md2CustomCodeTask;
import de.uni_muenster.wi.md2library.exception.Md2WidgetNotCreatedException;
import de.uni_muenster.wi.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * Implementation of a Md2AttributeSetTask.
 * Represents AttributeSetTask element in MD2-DSL.
 * <p/>
 * Created on 26/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2AttributeSetTask implements Md2CustomCodeTask {
    /**
     * The Content provider.
     */
    String contentProvider;
    /**
     * The Attribute.
     */
    String attribute;
    /**
     * The Value.
     */
    Md2Type value;

    /**
     * Instantiates a new Md 2 attribute set task.
     *
     * @param contentProvider the content provider
     * @param attribute       the attribute
     * @param value           the value
     */
    public Md2AttributeSetTask(String contentProvider, String attribute, Md2Type value) {
        this.contentProvider = contentProvider;
        this.attribute = attribute;
        this.value = value;
    }

    @Override
    public void execute() throws Md2WidgetNotCreatedException {
        Md2ContentProviderRegistry.getInstance().getContentProvider(contentProvider).setValue(attribute, value);
    }
}
