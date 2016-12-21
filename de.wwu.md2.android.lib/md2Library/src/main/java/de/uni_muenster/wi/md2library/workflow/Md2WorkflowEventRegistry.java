package de.uni_muenster.wi.md2library.workflow;

import java.util.HashMap;
import java.util.Map;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Content;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Widget;

/**
 * Created by c_rieg01 on 23.08.2016.
 */
public class Md2WorkflowEventRegistry {

    private static Md2WorkflowEventRegistry instance;

    /**
     * The Widgets.
     */
    Map<String, Md2WorkflowElementActionCombination> events = new HashMap<>();

    private Md2WorkflowEventRegistry() {
        // Singleton constructor
    }

    /**
     * Gets instance of the Md2WorkflowEventRegistry.
     * Implemented as a singleton.
     *
     * @return the instance
     */
    public static synchronized Md2WorkflowEventRegistry getInstance() {
        if (Md2WorkflowEventRegistry.instance == null)

        {
            Md2WorkflowEventRegistry.instance = new Md2WorkflowEventRegistry();
        }
        return Md2WorkflowEventRegistry.instance;
    }

    /**
     * Add WorkflowEvent.
     *
     * @param name the event name
     * @param workflowElement the targeted element
     * @param workflowAction the action (start/end)
     */
    public void addWorkflowEvent(String name, Md2WorkflowElement workflowElement, Md2WorkflowAction workflowAction) {
        if (events.containsKey(name))
            return;

        events.put(name, new Md2WorkflowElementActionCombination(workflowElement, workflowAction));
    }

    /**
     * Get targeted workflow element for WorkflowEvent.
     *
     * @param name the event name
     */
    public Md2WorkflowElement getWorkflowEventTarget(String name) {
        return events.get(name).getTarget();
    }

    /**
     * Get targeted workflow action for WorkflowEvent.
     *
     * @param name the event name
     */
    public Md2WorkflowAction getWorkflowEventAction(String name) {
        return events.get(name).getAction();
    }

    @Override
    public String toString() {
        StringBuffer result = new StringBuffer();
        result.append("Md2WorkflowEventRegistry: ");
        for (Map.Entry entry : events.entrySet()) {
            result.append("(Key: " + entry.getKey() + ", Value: " + entry.getValue() + ");");
        }

        return result.toString();
    }

    private class Md2WorkflowElementActionCombination {
        protected Md2WorkflowElement element;
        protected Md2WorkflowAction action;

        public Md2WorkflowElementActionCombination(Md2WorkflowElement element, Md2WorkflowAction action){
            this.element = element;
            this.action = action;
        }

        public Md2WorkflowElement getTarget(){
            return element;
        }

        public Md2WorkflowAction getAction(){
            return action;
        }
    }
}
