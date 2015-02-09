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
	
	public static String COMPLETE_MODEL_M = "dsl/model/complete/Model.md2";
	
	public static String VALIDATOR_MODEL_M = "dsl/model/validator/Model.md2";
	
	
	//***Project***//
	
	public static String PROJECT_VALIDATOR_MEC_CIW = "dsl/project/validator/modelElementPackageCongruence/controllerInWorkflow.md2";
	public static String PROJECT_VALIDATOR_MEC_MIW = "dsl/project/validator/modelElementPackageCongruence/modelInWorkflow.md2";
	public static String PROJECT_VALIDATOR_MEC_VIM = "dsl/project/validator/modelElementPackageCongruence/viewInModel.md2";
	public static String PROJECT_VALIDATOR_MEC_WIM = "dsl/project/validator/modelElementPackageCongruence/workflowInModel.md2";
	public static String PROJECT_VALIDATOR_MEC_CIC = "dsl/project/validator/modelElementPackageCongruence/controllerInController.md2";
	
	//***Workflow***//
	
	public static String WORKFLOW_FUNCTION_W = "dsl/workflow/functionTest/workflow.md2";
	public static String WORKFLOW_FUNCTION_C = "dsl/workflow/functionTest/controller.md2";
	public static String WORKFLOW_FUNCTION_V = "dsl/workflow/functionTest/view.md2";
	public static String WORKFLOW_FUNCTION_M = "dsl/workflow/functionTest/model.md2";

	public static String WORKFLOW_VALIDATOR_W = "dsl/workflow/validator/workflow.md2";
	public static String WORKFLOW_VALIDATOR_C = "dsl/workflow/validator/controller.md2";
	public static String WORKFLOW_VALIDATOR_V = "dsl/workflow/validator/view.md2";
	public static String WORKFLOW_VALIDATOR_M = "dsl/workflow/validator/model.md2";

	
	//***Controller***//
	
	public static final String BASIC_CONTROLLER_M = "dsl/controller/Model.md2";
	
	public static final String BASIC_CONTROLLER_V = "dsl/controller/View.md2";
	
	public static final String FILTERED_CONTENTPROVIDER_C = "dsl/controller/contentProvider/Filtered.md2";
	
	public static final String WHERE_CONTENTPROVIDER_C = "dsl/controller/contentProvider/Where.md2";
	
	public static final String SIMPLE_CONTENTPROVIDER_C = "dsl/controller/contentProvider/Simple.md2";
	
	public static final String VALIDATOR_COMPONENT_C = "dsl/controller/validator/RootValidators.md2";

	public static final String INPUT_FIELD_VALIDATOR_COMPONENT_C = "dsl/controller/validator/InputFieldValidators.md2";
	
	public static final String EMPTY_PROCESS_CHAIN_C = "dsl/controller/validator/EmptyProcessChain.md2";

	//********Validator*****//
	
	public static final String FILTER_MULTIPLIZITY_C = "dsl/controller/contentProvider/validator/FilterMultiplizity.md2";
	
	// Model Validators
	
	public static final String MODEL_VALIDATOR_LOWERCASE_ATTRIBUTE = "dsl/model/validator/LowercaseAttribute.md2";
	public static final String MODEL_VALIDATOR_REPEATED_PARAMETERS = "dsl/model/validator/RepeatedParameters.md2";
	public static final String MODEL_VALIDATOR_UNSUPPORTED_FEATURES = "dsl/model/validator/UnsupportedFeatures.md2";
	public static final String MODEL_VALIDATOR_UPPERCASE_ENTITY = "dsl/model/validator/UppercaseEntity.md2";
	
	public static final String MODEL_VALIDATOR_UNDERSCORE_ENTITY = "dsl/model/validator/ENameUnderscoreValidatorModel.md2";
	public static final String MODEL_VALIDATOR_RESERVEDNAME_ENTITY = "dsl/model/validator/ENameReservedNameValidatorModel.md2";

	/** views **/
	public static final String CONTENT_CONTAINER_FLOW_LAYOUT_V = "dsl/view/viewGuiElement/containerElement/contentContainer/flowLayoutPane.md2";
	public static final String CONTENT_CONTAINER_GRID_LAYOUT_V = "dsl/view/viewGuiElement/containerElement/contentContainer/gridLayoutPane.md2";
	public static final String SUB_VIEW_CONTAINER_ALTERNATIVE_LAYOUT_V = "dsl/view/viewGuiElement/containerElement/subViewContainer/alternativePane.md2";
	public static final String SUB_VIEW_CONTAINER_ALTERNATIVE_TABBED_LAYOUT_V = "dsl/view/viewGuiElement/containerElement/subViewContainer/tabbedPane.md2";
	public static final String VIEW_INPUT_ELEMENTS_ENTITY = "dsl/view/viewGuiElement/contentElement/inputElement/viewEntity.md2";
	public static final String VIEW_INPUT_ELEMENTS_CONTROLLER = "dsl/view/viewGuiElement/contentElement/inputElement/viewController.md2";
	public static final String VIEW_INPUT_ELEMENTS_V = "dsl/view/viewGuiElement/contentElement/inputElement/inputElements.md2";
	
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
