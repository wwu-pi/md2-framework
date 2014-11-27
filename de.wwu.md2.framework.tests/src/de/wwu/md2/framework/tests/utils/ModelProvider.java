package de.wwu.md2.framework.tests.utils;

import java.io.FileInputStream;
import java.io.IOException;

import org.apache.commons.io.IOUtils;

/**
 * In this class all MD2 models should be listed. Their path should be inserted
 * as a static string with a '/' separator for the packages. Using it as a
 * static extension the models can me loaded into the tests using
 * STATIC_MODEL_STRING.load;
 * 
 * @author Tobias Reischmann
 * 
 */
public class ModelProvider {

	private static String BASE_URI = System.getProperty("user.dir")
			+ "/models/de/wwu/md2/framework/tests/";

	public static String SIMPLE_MAIN_MODEL_C = "dsl/controller/main/Controller.md2";

	public static String CONTROLLER_TESTS_V = "dsl/controller/View.md2";
	
	public static String COMPLETE_MODEL_M = "dsl/model/complete/Model.md2";
	
	
	
	//***Controller***//
	
	public static final String BASIC_CONTROLLER_M = "dsl/controller/Model.md2";
	
	public static final String BASIC_CONTROLLER_V = "dsl/controller/View.md2";
	
	public static final String FILTERED_CONTENTPROVIDER_C = "dsl/controller/contentProvider/Filtered.md2";
	
	public static final String WHERE_CONTENTPROVIDER_C = "dsl/controller/contentProvider/Where.md2";
	
	public static final String SIMPLE_CONTENTPROVIDER_C = "dsl/controller/contentProvider/Simple.md2";
	
	/**
	 * Load the model from file
	 * @param modelUri the model URIs are listed in the ModelProvider as static Strings.
	 * @return md2 model as a string.
	 * @throws IOException
	 */
	public static String load(String modelUri) throws IOException {
		String model;
		FileInputStream inputStream = new FileInputStream(BASE_URI + modelUri);
		try {
			model = IOUtils.toString(inputStream);
		} finally {
			inputStream.close();
		}
		return model;
	}

}
