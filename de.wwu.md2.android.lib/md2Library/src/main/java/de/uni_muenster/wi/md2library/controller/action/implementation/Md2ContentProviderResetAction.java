package de.uni_muenster.wi.md2library.controller.action.implementation;

import de.uni_muenster.wi.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;

/**
 * Used to trigger the reset method of a content provider
 * Represents ContentProviderResetAction element in MD2-DSL
 * <p/>
 * Created on 24/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2ContentProviderResetAction extends AbstractMd2Action {
    /**
     * The Content provider.
     */
    protected String contentProvider;

    /**
     * Instantiates a new Md 2 content provider reset action.
     *
     * @param contentProvider the content provider
     */
    public Md2ContentProviderResetAction(String contentProvider) {
        super("Md2ContentProviderResetAction" + contentProvider);
        this.contentProvider = contentProvider;
    }

    @Override
    public void execute() {
        Md2ContentProvider cp = Md2ContentProviderRegistry.getInstance().getContentProvider(contentProvider);
        cp.reset();
    }
}
