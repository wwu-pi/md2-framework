package de.uni_muenster.wi.md2library.workflow;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;

/**
 * Created by c_rieg01 on 23.08.2016.
 */
public class Md2WorkflowElement {
    protected String name;
    protected ArrayList<Md2Action> onInit = new ArrayList<Md2Action>();

    public Md2WorkflowElement(String name, Md2Action onInit){
        this.name = name;
        this.onInit.add(onInit);
    }

    /**
     * Start the workflow element, i.e. its initial actions.
     */
    public void start(){
        for(Md2Action initAction : onInit){
            initAction.execute();
        }
    }

    /**
     * Eventually perform actions when the workflow element is left.
     */
    public void end(){
        // Currently nothing to do
        // There might have some unmapping etc. in future
    }
}
