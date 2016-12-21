package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;

/**
 * Created by c_rieg01 on 23.08.2016.
 */
public class Md2WorkflowEventHandler extends AbstractMd2EventHandler {

    @Override
    public void registerAction(Md2Action action) {
        super.addAction(action);
    }

    @Override
    public void unregisterAction(Md2Action action) {
        super.removeAction(action);
    }

    public void onFireEvent(){
        this.execute();
    }
}
