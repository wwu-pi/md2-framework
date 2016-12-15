package de.uni_muenster.wi.md2library.controller.action.implementation;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;

/**
 * Created by Fabian on 10.08.2015.
 */
public abstract class AbstractMd2Action implements Md2Action {
    /**
     * The Action signature.
     */
    protected String actionSignature;

    /**
     * Instantiates a new Abstract md 2 action.
     *
     * @param actionSignature the action signature
     */
    public AbstractMd2Action(String actionSignature) {
        this.actionSignature = actionSignature;
    }

    @Override
    public boolean equals(Md2Action otherAction) {
        return this.actionSignature.equals(otherAction.getActionSignature());
    }

    @Override
    public String getActionSignature() {
        return this.actionSignature;
    }
}
