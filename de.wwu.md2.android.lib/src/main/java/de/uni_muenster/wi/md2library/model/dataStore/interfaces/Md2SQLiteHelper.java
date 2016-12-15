package de.uni_muenster.wi.md2library.model.dataStore.interfaces;

import android.database.sqlite.SQLiteDatabase;

/**
 * Glue interface for SQLite helper.
 * The SQLite helper supports the access to the local SQLite in Android.
 * The implementation is generated in the MD2 application.
 * <p/>
 * Created on 13/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2SQLiteHelper {
    /**
     * Open sqlite database.
     *
     * @param getWriteAccess the get write access
     * @return the sq lite database
     */
    SQLiteDatabase open(boolean getWriteAccess);

    /**
     * Close.
     */
    void close();

    /**
     * Get all columns string [ ].
     *
     * @param typeName the type name
     * @return the string [ ]
     */
    String[] getAllColumns(String typeName);
}
