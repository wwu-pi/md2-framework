package de.wwu.md2.framework.generator.android.lollipop.model

import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.Main

class SQLite {
	def static generateDataContract(String mainPackage, Iterable<Entity> entities)'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.SQLite.generateDataContract()
		package «mainPackage».md2.model.sqlite;

		import android.provider.BaseColumns;
		
		public class Md2DataContract {
		
		    public Md2DataContract() {
		    }
		
		«FOR e : entities»
			public static abstract class «e.name.toFirstUpper»Entry implements BaseColumns {
				public static final String TABLE_NAME = "«e.name.toLowerCase»";
				«FOR a : e.attributes»
				public static final String COLUMN_NAME_«a.name.toUpperCase» = "«a.name.toLowerCase»";
				«ENDFOR»
			}
		«ENDFOR»
		}
	'''
	
	def static generateSQLiteHelper(String mainPackage, App app, Main main, Iterable<Entity> entities)'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.model.SQLite.generateSQLiteHelper()
		package «mainPackage».md2.model.sqlite;
		
		import android.content.Context;
		import android.database.sqlite.SQLiteDatabase;
		import android.database.sqlite.SQLiteOpenHelper;
		
		«FOR e : entities»
			import «mainPackage».md2.model.sqlite.Md2DataContract.«e.name.toFirstUpper»Entry;
		«ENDFOR»
		
		import de.uni_muenster.wi.fabian.md2library.model.dataStore.interfaces.Md2SQLiteHelper;
		
		public class Md2SQLiteHelperImpl extends SQLiteOpenHelper implements Md2SQLiteHelper {
			private static final String DATABASE_NAME = "«app.name.toLowerCase».db";
			private static final int DATABASE_VERSION = «main.appVersion»;
			private static final String TEXT_TYPE = " TEXT";
			private static final String COMMA_SEP = ",";
			«FOR e : entities»
			private static final String SQL_CREATE_«e.name.toUpperCase»_ENTRIES =
				"CREATE TABLE " + «e.name.toFirstUpper»Entry.TABLE_NAME + " (" +
				«e.name.toFirstUpper»Entry._ID + " INTEGER PRIMARY KEY," +
				«FOR a : e.attributes SEPARATOR " + TEXT_TYPE + COMMA_SEP +" AFTER " + TEXT_TYPE +"»
					«e.name.toFirstUpper»Entry.COLUMN_NAME_«a.name.toUpperCase»
				«ENDFOR»
				" )";
										
				private static final String SQL_DELETE_«e.name.toUpperCase»_ENTRIES =
					"DROP TABLE IF EXISTS " + «e.name.toFirstUpper»Entry.TABLE_NAME;
								
				private final String[] all«e.name.toFirstUpper»Columns = {
				«FOR a : e.attributes SEPARATOR ", " AFTER "};"»
					«e.name.toFirstUpper»Entry.COLUMN_NAME_«a.name.toUpperCase»
				«ENDFOR»
			«ENDFOR»

		    public Md2SQLiteHelperImpl(Context context) {
		        super(context, DATABASE_NAME, null, DATABASE_VERSION);
		    }
		
		
		    @Override
		    public void onCreate(SQLiteDatabase database) {
		    	«FOR e : entities»
		    		database.execSQL(SQL_CREATE_«e.name.toUpperCase»_ENTRIES);
				«ENDFOR»
		    }
		
		    @Override
		    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		    	«FOR e : entities»
		    		db.execSQL(SQL_DELETE_«e.name.toUpperCase»_ENTRIES);
				«ENDFOR»
		        onCreate(db);		
		    }
		
		    @Override
		    public SQLiteDatabase open(boolean writeAccess) {
		        return (writeAccess) ? this.getWritableDatabase() : this.getReadableDatabase();
		    }
		
		    @Override
		    public String[] getAllColumns(String typeName) {
		        switch (typeName) {
		        	«FOR e : entities»
		        	case "«e.name.toLowerCase»": {
		        		return this.all«e.name.toFirstUpper»Columns;
		        	}
					«ENDFOR»
		        }
		        return null;
		    }
		}
	'''
}