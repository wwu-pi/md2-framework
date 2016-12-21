package de.uni_muenster.wi.md2library.controller.action.implementation;

import de.uni_muenster.wi.md2library.workflow.Md2WorkflowAction;
import de.uni_muenster.wi.md2library.workflow.Md2WorkflowElement;
import de.uni_muenster.wi.md2library.workflow.Md2WorkflowEventRegistry;
import de.uni_muenster.wi.md2library.workflow.Md2WorkflowManager;

/**
 * Used to throw a workflow event.
 * Represents FireEventAction in MD2-DSL
 * <p/>
 * Created on 23/08/2016
 *
 * @author Christoph Rieger
 * @version 1.0
 * @since 1.0
 */
public class Md2FireEventAction extends AbstractMd2Action {

    /**
     * Instantiates a new Md 2 fire event action.
     */
    public Md2FireEventAction(String name) {
        super("Md2FireEventAction" + name);
    }

    @Override
    public void execute() {
        Md2WorkflowElement workflowElement = Md2WorkflowEventRegistry.getInstance().getWorkflowEventTarget(this.actionSignature);
        Md2WorkflowAction workflowAction = Md2WorkflowEventRegistry.getInstance().getWorkflowEventAction(this.actionSignature);

        if (workflowAction.equals(Md2WorkflowAction.START)) {
            Md2WorkflowManager.getInstance().goToWorkflow(workflowElement);
        } else if (workflowAction.equals(Md2WorkflowAction.END)) {
            Md2WorkflowManager.getInstance().endWorkflow(workflowElement);
        }
    }
}
