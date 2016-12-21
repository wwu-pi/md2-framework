package de.uni_muenster.wi.md2library.controller.action.interfaces;

/**
 * Interface definition for an Md2Action.
 * Represents CustomAction and SimpleAction elements in MD2-DSL.
 * <p/>
 * Created on
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2Action {
    /**
     * Execute the action.
     */
    void execute();

    /**
     * Equals method that uses the action signature to compare actions.
     *
     * @param otherMd2Action the other md 2 action
     * @return the boolean
     */
    boolean equals(Md2Action otherMd2Action);

    /**
     * Gets action signature.
     * The action signature contains the name of the action and the parameters.
     *
     * @return the action signature
     */
    String getActionSignature();
}
