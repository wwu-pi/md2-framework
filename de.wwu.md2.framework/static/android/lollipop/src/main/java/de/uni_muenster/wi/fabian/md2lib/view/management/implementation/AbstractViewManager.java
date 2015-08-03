package de.uni_muenster.wi.fabian.md2lib.view.management.implementation;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import java.util.HashMap;
import java.util.List;

import de.uni_muenster.wi.fabian.md2lib.view.management.interfaces.ViewManager;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;

/**
 * Created by Fabian on 10/07/2015.
 */
public abstract class AbstractViewManager implements ViewManager {

    protected Activity activeView;

    protected List<String> views;

    //protected HashMap<String, Activity> views;



    /*protected Context appContext;

    public void initialize(Context appContext){
        this.appContext = appContext;
    }

    protected Activity getView(String viewName){
        return views.get(viewName);
    }

    protected void putView(String viewName, Activity view){
        views.put(viewName, view);
    }

    protected Context getAppContext(){
        return this.appContext;
    }
*/
    @Override
    public void goTo(String viewName){

    }

    @Override
    public void setupView(String viewName){
        views.add(viewName);
    }
}
