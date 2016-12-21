package de.uni_muenster.wi.md2library.controller.action.implementation;

import de.uni_muenster.wi.md2library.view.management.implementation.Md2ViewManager;

/**
 * Used to navigate to another view. It uses the view manager
 * to start the new activity.
 * Represents GotoViewAction in MD2-DSL
 * <p/>
 * Created on 10/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2GoToViewAction extends AbstractMd2Action {

    /**
     * The view manager instance.
     */
    Md2ViewManager vm = Md2ViewManager.getInstance();

    /**
     * The Target view.
     */
    String targetView;

    /**
     * Instantiates a new Md 2 go to view action.
     *
     * @param targetView the target view
     */
    public Md2GoToViewAction(String targetView) {
        super("Md2GoToViewAction" + targetView);
        this.targetView = targetView;
    }

    @Override
    public void execute() {
        vm.goTo(targetView);
        Md2ViewManager.getInstance().goTo(targetView);
    }

    @Override
    public String toString() {
        return "Md2GoToViewAction: " + targetView;
    }
}
