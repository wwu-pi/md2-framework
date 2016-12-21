package de.uni_muenster.wi.md2library.controller.action.implementation;

import de.uni_muenster.wi.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;

/**
 * Action that triggers a operation in a content provider.
 * Represents ContentProviderOperationAction element in MD2-DSL.
 * <p/>
 * Created on 24/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2ContentProviderOperationAction extends AbstractMd2Action {

    /**
     * The Content provider.
     */
    protected String contentProvider;

    /**
     * The Operation.
     */
    protected Md2ContentProviderOperations operation;

    /**
     * Instantiates a new Md2 content provider operation action.
     *
     * @param contentProvider the content provider
     * @param operation       the operation
     */
    public Md2ContentProviderOperationAction(String contentProvider, Md2ContentProviderOperations operation) {
        super("Md2ContentProviderOperationAction" + contentProvider + operation.toString());
        this.contentProvider = contentProvider;
        this.operation = operation;
    }

    @Override
    public void execute() {
        Md2ContentProvider cp = Md2ContentProviderRegistry.getInstance().getContentProvider(contentProvider);
        switch (operation) {
            case CREATE_OR_UPDATE:
                cp.save();
                break;
            case READ:
                cp.load();
                break;
            case DELETE:
                cp.remove();
                break;
        }
    }
}
