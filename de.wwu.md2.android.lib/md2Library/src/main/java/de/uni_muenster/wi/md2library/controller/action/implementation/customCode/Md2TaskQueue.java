package de.uni_muenster.wi.md2library.controller.action.implementation.customCode;

import java.util.ArrayList;
import java.util.HashSet;

import de.uni_muenster.wi.md2library.controller.action.implementation.customCode.interfaces.Md2CustomCodeTask;
import de.uni_muenster.wi.md2library.exception.Md2WidgetNotCreatedException;

/**
 * Used to queue tasks that cannot be executed. For example if a widget is not yet created.
 *
 * @author Fabian Wrede
 * @version 1.0
 * @see Md2WidgetNotCreatedException
 * <p/>
 * <p/>
 * Created on 11/09/2015
 * @since 1.0
 */
public class Md2TaskQueue {

    private static Md2TaskQueue instance;
    /**
     * The Pending tasks.
     */
    protected ArrayList<Md2CustomCodeTask> pendingTasks;

    private Md2TaskQueue() {
        pendingTasks = new ArrayList<Md2CustomCodeTask>();
    }

    /**
     * Gets instance.
     *
     * @return the instance
     */
    public static synchronized Md2TaskQueue getInstance() {
        if (Md2TaskQueue.instance == null) {
            Md2TaskQueue.instance = new Md2TaskQueue();
        }
        return Md2TaskQueue.instance;
    }

    /**
     * Add pending task.
     *
     * @param task the task
     */
    public void addPendingTask(Md2CustomCodeTask task) {
        this.pendingTasks.add(task);
    }

    /**
     * Try execute pending tasks.
     * Called by Activities in their onStart lifecycle method.
     */
    public void tryExecutePendingTasks() {
        HashSet<Md2CustomCodeTask> remove = new HashSet<>();
        for (Md2CustomCodeTask task : pendingTasks) {
            try {
                task.execute();
                remove.add(task);
            } catch (Md2WidgetNotCreatedException e) {
                // do nothing --> task remains in list
            }
        }
        pendingTasks.removeAll(remove);
    }
}
