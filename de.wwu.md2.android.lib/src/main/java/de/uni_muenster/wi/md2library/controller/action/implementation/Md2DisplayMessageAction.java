package de.uni_muenster.wi.md2library.controller.action.implementation;

import android.app.AlertDialog;
import android.content.DialogInterface;

import de.uni_muenster.wi.fabian.md2library.R;
import de.uni_muenster.wi.md2library.view.management.implementation.Md2ViewManager;

/**
 * Used to display a message.
 * A AlertDilaog is created with the message as content.
 * Represents DisplayMessageAction element in MD2-DSL
 * <p/>
 * Created on 12/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2DisplayMessageAction extends AbstractMd2Action {
    /**
     * The Message.
     */
    String message;

    /**
     * Instantiates a new Md2 display message action.
     *
     * @param message the message
     */
    public Md2DisplayMessageAction(String message) {
        super("Md2DisplayMessageAction" + message);
        this.message = message;
    }

    @Override
    public void execute() {
        new AlertDialog.Builder(Md2ViewManager.getInstance().getActiveView())
                .setMessage(message)
                .setNeutralButton(R.string.ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // window is dismissed automatically
                    }
                })
                .show();
    }
}
