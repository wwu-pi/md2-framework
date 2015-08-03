package de.uni_muenster.wi.fabian.md2lib.model.dataStore.implementation;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.lang.String;

import de.uni_muenster.wi.fabian.md2lib.model.dataStore.interfaces.DataStore;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.*;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Entity;

/**
 * Created by Fabian on 14.07.2015.
 */
public class SQLiteDataStore extends SQLiteOpenHelper implements DataStore{

    protected String databaseName;
    protected int databaseVersion;

    public SQLiteDataStore(Context context, String databaseName, int databaseVersion){
        super(context, databaseName, null, databaseVersion);
        this.databaseName = databaseName;
        this.databaseVersion = databaseVersion;
    }

    @Override
    public Entity query() {
        return null;
    }

    @Override
    public void put(Entity entity) {

    }

    @Override
    public void remove(de.uni_muenster.wi.fabian.md2lib.model.type.implementation.Integer id) {

    }

    @Override
    public void onCreate(SQLiteDatabase db) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
