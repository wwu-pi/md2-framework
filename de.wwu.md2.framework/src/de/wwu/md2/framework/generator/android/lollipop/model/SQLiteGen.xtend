package de.wwu.md2.framework.generator.android.lollipop.model

import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Main
import de.wwu.md2.framework.generator.android.lollipop.Settings
import de.wwu.md2.framework.mD2.ReferencedType
import java.util.ArrayList
import java.util.List
import de.wwu.md2.framework.generator.android.common.model.ForeignObject

class SQLiteGen {
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
					public static final String COLUMN_NAME_«a.name.toUpperCase» = "«a.name»";
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
		
		import «Settings.MD2LIBRARY_PACKAGE» model.dataStore.interfaces.Md2SQLiteHelper;
		
		public class Md2SQLiteHelperImpl extends SQLiteOpenHelper implements Md2SQLiteHelper {
			private static final String DATABASE_NAME = "«app.name.toLowerCase».db";
			private static final int DATABASE_VERSION = (int) «main.appVersion»;
			private static final String TEXT_TYPE = " TEXT";
			private static final String COMMA_SEP = ",";
			«FOR e : entities»
			private static final String SQL_CREATE_«e.name.toUpperCase»_ENTRIES =
				"CREATE TABLE " + «e.name.toFirstUpper»Entry.TABLE_NAME + " (" +
				«e.name.toFirstUpper»Entry._ID + " INTEGER PRIMARY KEY" +
				«IF e.attributes.size > 0»COMMA_SEP +«ENDIF»
				«FOR a : e.attributes SEPARATOR " + TEXT_TYPE + COMMA_SEP +" AFTER " + TEXT_TYPE +"»
					«e.name.toFirstUpper»Entry.COLUMN_NAME_«a.name.toUpperCase»
				«ENDFOR»
				" )";
										
				private static final String SQL_DELETE_«e.name.toUpperCase»_ENTRIES =
					"DROP TABLE IF EXISTS " + «e.name.toFirstUpper»Entry.TABLE_NAME;
								
				private final String[] all«e.name.toFirstUpper»Columns = {
				«FOR a : e.attributes SEPARATOR ", "»
					«e.name.toFirstUpper»Entry.COLUMN_NAME_«a.name.toUpperCase»
				«ENDFOR»
				};
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
				if(typeName == null) return null;
				switch (typeName) {
					«FOR e : entities»
					case "«e.name.toFirstUpper»": {
						return this.all«e.name.toFirstUpper»Columns;
					}
					«ENDFOR»
				}
				return null;
			}
		}
	'''
	
	def static generateOrmLiteConfig(String mainPackage, Iterable<Entity> entities){
'''
«var List<ForeignObject> foreignReferences= new ArrayList<ForeignObject>()»
«FOR entity : entities»
# --table-start--
# --table-fields-start--
# --field-start--
fieldName=id
columnName=id
generatedId=true
# --field-end--	
«FOR attribute :entity.attributes »
«IF attribute.type instanceof ReferencedType»
«IF attribute.type.many»
«var boolean b=foreignReferences.add(new ForeignObject(entity.name, attribute.name, EntityGen.getMd2TypeStringForAttributeType(attribute.type)))»
foreignCollectionFieldName=«attribute.name»
columnName=«entity.name.toFirstLower»_«attribute.name.toFirstLower»
«ELSE»
# --field-start--
fieldName=«attribute.name»
columnName=«entity.name.toFirstLower»_«attribute.name.toFirstLower»
foreign=true
# --field-end--		
«ENDIF»
«ELSE»
# --field-start--
fieldName=«attribute.name»
columnName=«entity.name.toFirstLower»_«attribute.name.toFirstLower»
# --field-end--	
«ENDIF»	
«ENDFOR»
«FOR element : foreignReferences»
«IF element.targetClass.equals(entity.name)»
# --field-start--
fieldName=«element.attributeName»
columnName=«entity.name.toFirstLower»_«element.attributeName.toFirstLower»
foreign=true
# --field-end--		
«ENDIF»	
«ENDFOR»
# --table-fields-end--
# --table-end--	
«ENDFOR»
'''
	
}


def static generateOrmLiteDatabaseConfigUtil(String mainPackage, Iterable<Entity> entities){'''
package «mainPackage».md2.model.sqlite;
import java.io.IOException;
import java.sql.SQLException;
import com.j256.ormlite.android.apptools.OrmLiteConfigUtil;
 
 
public class DatabaseConfigUtil extends OrmLiteConfigUtil {
 
	public static void main(String[] args) throws SQLException, IOException {
		
		// Provide the name of .txt file which you have already created and kept in res/raw directory
		writeConfigFile("ormlite_config.txt");
	}
}	
'''	
}




def static generateDataBaseHelper(String mainPackage,  App app, Iterable<Entity> entities){
'''
	package «mainPackage».md2.model.sqlite;

import java.sql.SQLException;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Entity;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;
import «mainPackage».R;

«FOR element : entities»
	import «mainPackage».md2.model.«element.name»;
«ENDFOR»

 
import com.j256.ormlite.android.apptools.OrmLiteSqliteOpenHelper;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;
 
/**
 * Database helper which creates and upgrades the database and provides the DAOs for the app.
 * 
 * 
 */
public class DatabaseHelper extends OrmLiteSqliteOpenHelper {
 
 
	private static final String DATABASE_NAME = "«app.name».db";
	private static final int DATABASE_VERSION = 1; 
 
	
	«FOR element : entities»
	private Dao<«element.name», Integer> «element.name»Dao;	
	«ENDFOR»
	
 
	public DatabaseHelper(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION, R.raw.ormlite_config);
	}
 
 
	@Override
	public void onCreate(SQLiteDatabase sqliteDatabase, ConnectionSource connectionSource) {
		try {
			
			// Create tables. This onCreate() method will be invoked only once of the application life time i.e. the first time when the application starts.
			«FOR element : entities»
			TableUtils.createTable(connectionSource, «element.name».class);	
			«ENDFOR»
			
		} catch (SQLException e) {
			Log.e(DatabaseHelper.class.getName(), "Unable to create datbases", e);
		}
	}
 
	@Override
	public void onUpgrade(SQLiteDatabase sqliteDatabase, ConnectionSource connectionSource, int oldVer, int newVer) {
		try {
			
			// In case of change in database of next version of application, please increase the value of DATABASE_VERSION variable, then this method will be invoked 
			//automatically. Developer needs to handle the upgrade logic here, i.e. create a new table or a new column to an existing table, take the backups of the
			// existing database etc.
			
			//TableUtils.dropTable(connectionSource, TeacherDetails.class, true);
			//TableUtils.dropTable(connectionSource, StudentDetails.class, true);
			//onCreate(sqliteDatabase, connectionSource);
			
		} catch (Exception e) {
			Log.e(DatabaseHelper.class.getName(), "Unable to upgrade database from version " + oldVer + " to new "
					+ newVer, e);
		}
	}
	
	
	// Create the getDao methods of all database tables to access those from android code.
	// Insert, delete, read, update everything will be happened through DAOs
 
«FOR element : entities»
public Dao<«element.name», Integer> get«element.name»Dao() throws SQLException {
		if («element.name»Dao == null) {
			«element.name»Dao = getDao(«element.name».class);
		}
		return «element.name»Dao;
	}	
«ENDFOR»
	
 
 public <T extends Md2Entity> Dao<T, Integer> getDaoByName(String entity){
 final String entityType= entity;
 try{
 switch(entityType){
 «FOR element : entities»
 case "«element.name»": 	if («element.name»Dao == null) {
 			«element.name»Dao =  getDao(«element.name».class);
 		}
 		return (Dao<T, Integer>) «element.name»Dao;
 «ENDFOR»
 default: return null;	
 } 	}
 catch(SQLException e){
 e.printStackTrace();	
 return null;
 }
 
 }
 
 

}
'''	
}


def static generateOrmLiteDatastore(String mainPackage,  App app, Iterable<Entity> entities){
'''
	package «mainPackage».md2.model.sqlite;
	//package «mainPackage».«app.name»;

import android.content.Context;
import com.j256.ormlite.android.apptools.OpenHelperManager;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.Where;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.TimeZone;
import java.text.SimpleDateFormat;

import de.uni_muenster.wi.md2library.model.dataStore.AtomicExpression;
import de.uni_muenster.wi.md2library.model.dataStore.CombinedExpression;
import de.uni_muenster.wi.md2library.model.dataStore.Expression;
import de.uni_muenster.wi.md2library.model.dataStore.implementation.AbstractMd2OrmLiteDatastore;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Entity;

import «mainPackage».«app.name»;

public  class Md2OrmLiteDatastore<T extends  Md2Entity> extends AbstractMd2OrmLiteDatastore<T> {

	private String entityType;
	private DatabaseHelper databaseHelper;
	
		Dao<T , Integer> myDao;
		   private  SimpleDateFormat simpleDateFormat;
	
		public Md2OrmLiteDatastore(String entity){
		this.entityType=entity;
			initDatabaseHelper(«app.name».getAppContext());
			 this.simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				this.simpleDateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
		}
	
	public void initDatabaseHelper(Context context){
		databaseHelper = OpenHelperManager.getHelper(context,DatabaseHelper.class);
	}
	
	public DatabaseHelper getHelper() {
		return databaseHelper;
	}
	
	public Dao<T, Integer> getMyDao(){
		if(myDao==null) {
			myDao= this.getHelper().getDaoByName(entityType);
		}
		return myDao;	   
	}
	
	public List<T> loadAll(){
		List<T> all= new ArrayList<T>();
		try {
		   all=  getMyDao().queryForAll();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return all;
	}
	
	@Override
	public Where<T, Integer> whereBuilder(Expression exp, Where<T, Integer> where ){
		if (exp != null) {
	
			if (exp instanceof AtomicExpression) {
				AtomicExpression aexp = (AtomicExpression) exp;
			  switch (aexp.getOperator()) {
				  case EQUAL:
					  try {
						  where.eq((aexp).getLeftOperand(), aexp.getRightOperand());
					  } catch (SQLException e) {
						  e.printStackTrace();
					  }
					  break;
				  case GREATEREQUAL:
					  try {
						  where.ge((aexp).getLeftOperand(), aexp.getRightOperand());
					  } catch (SQLException e) {
						  e.printStackTrace();
					  }
					  break;
				  case LESSEQUAL:
					  try {
						  where.le((aexp).getLeftOperand(), aexp.getRightOperand());
					  } catch (SQLException e) {
						  e.printStackTrace();
					  }
					  break;
				  case LESS:
					  try {
						  where.lt((aexp).getLeftOperand(), aexp.getRightOperand());
					  } catch (SQLException e) {
						  e.printStackTrace();
					  }
					  break;
				  case GREATER:
					  try {
						  where.gt((aexp).getLeftOperand(), aexp.getRightOperand());
					  } catch (SQLException e) {
						  e.printStackTrace();
					  }
					  break;
				}
			} else {
				CombinedExpression cexp = (CombinedExpression) exp;
				whereBuilder(cexp.getLeftExpression(),where);
				whereBuilder(cexp.getRightExpression(),where);
				switch (cexp.getJunction()) {
					case AND:
						where.and(2);
						break;
					case OR:
						where.or(2);
						break;
				}
			}
		}
		return where;
	}
}

'''		
}

def static generateMd2LocalStoreFactory(String mainPackage,  App app, Iterable<Entity> entities)'''
	package «mainPackage».md2.model.sqlite;
	import de.uni_muenster.wi.md2library.model.dataStore.interfaces.Md2DataStore;
	import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Entity;
	import de.uni_muenster.wi.md2library.controller.interfaces.Md2Controller;
	import de.uni_muenster.wi.md2library.model.dataStore.implementation.AbstractMd2LocalStoreFactory;
	import de.uni_muenster.wi.md2library.model.dataStore.interfaces.Md2LocalStore;
	«FOR element : entities»
		import «mainPackage».md2.model.«element.name»;
	«ENDFOR»
	
	
	public class Md2LocalStoreFactory extends AbstractMd2LocalStoreFactory{
		
	public Md2LocalStoreFactory(Md2Controller controller){
		super(controller);
	
	}	
	
	 public <T extends Md2Entity>  Md2DataStore getDataStore(String entity){
	final String entityName= entity;
	switch(entity){
		«FOR element : entities»
		case "«element.name»": return new Md2OrmLiteDatastore<«element.name»>(entity); 	
		«ENDFOR»
	default: throw new IllegalArgumentException("Unknown Entity Type: "+ entity); 
	} 	
	 	
	 }
	}
'''
}