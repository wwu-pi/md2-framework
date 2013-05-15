package de.wwu.md2.framework.generator.backend

import de.wwu.md2.framework.generator.util.DataContainer

class CommonClasses {
	
	def static createConfig(String basePackageName, DataContainer dataContainer) '''
		package «basePackageName»;
		
		import java.util.List;
		
		import com.google.common.collect.Lists;
		
		/**
		 * This class allows to define the current model version as well as all model versions that can be handled by this
		 * backend module.
		 */
		public class Config {
			
			/**
			 * Define a string that represents the current version of the backend model.
			 */
			public final static String MODEL_VERSION = "«dataContainer.main.modelVersion»";
			
			/**
			 * Define a list of all model versions that are supported by this backend implementation
			 * to allow backward compatibility.
			 */
			public final static List<String> SUPPORTED_MODEL_VERSIONS = Lists.newArrayList("«dataContainer.main.modelVersion»");
			
		}
	'''
	
	def static createUtils(String basePackageName) '''
		package «basePackageName»;
		
		import java.util.regex.Matcher;
		import java.util.regex.Pattern;
		
		/**
		 * Common functionality that is used throughout the project.
		 */
		public class Utils {
			
			/**
			 * Converts the standardized filter string received from the frontend to a valid
			 * WHERE clause that can be interpreted by the SQL parser
			 * 
			 * Assumes an incoming string with conditions connected by 'and', 'or' and 'not'. Each
			 * condition may be an atomic boolean value 'true' or 'false' or a condition of the form
			 * fully.qualified.attribute.name (equals|greater|smaller|>=|<=) anyValue
			 * 
			 * @param filter Filter string from the frontend.
			 * @return String in the common format for WHERE clauses that can be interpreted by the SQL parser.
			 */
			public static String buildWhereParameterFromFilterString(String filter) {
				
				if(filter == null)
					return "";
				
				// add one whitespace at the end of the filter string to facilitate the patterns in the
				// following steps
				filter = "(" + filter + ")";
				
				// replace all double quotes by single quotes
				filter = filter.replace("\"", "'");
				
				// replace true by (1 = 1)
				filter = filter.replaceAll("(\\s+|\\()true(\\s+|\\))", "$1(1 = 1)$2");
				
				// replace false by (1 <> 1)
				filter = filter.replaceAll("(\\s+|\\()false(\\s+|\\))", "$1(1 <> 1)$2");
				
				// add a t. to all attributes and replace operators by internal ones
				Pattern p = Pattern.compile("(\\s+|\\()(\\w+)\\s*(equals|greater|smaller|>=|<=)\\s*(\\S+)(\\s+|\\))");
				Matcher m = p.matcher(filter);
				StringBuffer s = new StringBuffer();
				while(m.find()) {
					m.appendReplacement(s, "$1 t.$2 " + transformOperator(m.group(3)) + " $4$5");
				}
				m.appendTail(s);
				
				//System.out.println("WHERE clause: " + s.toString());
				
				return "WHERE " + s.toString();
			}
			
			private static String transformOperator(String op) {
				if(op.equals("greater")) {
					return ">";
				}
				
				if(op.equals("smaller")) {
					return "<";
				}
				
				if(op.equals(">=")) {
					return ">=";
				}
				
				if(op.equals("<=")) {
					return "<=";
				}
				
				// default: equals
				return "=";
			}
		}
	'''
	
}