package de.wwu.md2.framework.validation

import com.google.common.collect.Maps
import com.google.common.collect.Sets
import com.google.inject.Inject
import de.wwu.md2.framework.mD2.BooleanInput
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContainerElementReference
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.DateInput
import de.wwu.md2.framework.mD2.DateTimeInput
import de.wwu.md2.framework.mD2.EntitySelector
import de.wwu.md2.framework.mD2.FileUpload
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.GridLayoutPaneParam
import de.wwu.md2.framework.mD2.GridLayoutPaneRowsParam
import de.wwu.md2.framework.mD2.InputType
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.ListView
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.NumberInput
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.TabSpecificParam
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TimeInput
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewFrame
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WidthParam
import java.util.Map
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.validation.Check

/**
 * Valaidators for all view elements of MD2.
 */
class ViewValidator extends AbstractMD2Validator {
	
	public static final String LAYOUT_PARAMS_MISSING = "layout_params_missing";

	@Inject
	ValidatorHelpers helper;

	/**
	 * Prevent from defining parameters multiple times in any of the view ContainerElements.
	 *
	 * @param containerElement
	 */
	@Check
	def checkRepeatedParams(ContainerElement containerElement) {
		
		// TabbedAlternativesPane and ListView are container elements without parameters
		if(containerElement instanceof TabbedAlternativesPane || containerElement instanceof ListView) {

			return;
		}

		helper.repeatedParamsError(containerElement, MD2Package.eINSTANCE.getViewElement_Name(), this,
				"GridLayoutPaneRowsParam", "rows", "GridLayoutPaneColumnsParam", "columns",
				"FlowLayoutPaneFlowDirectionParam", "horizontal | vertical",
				"MultiPaneObjectParam", "object", "MultiPaneTextPropositionParam", "textProposition",
				"MultiPaneDisplayAllParam", "displayAll",
				"TabTitleParam", "tabTitle", "TabIconParam", "tabIcon", "TabStaticParam", "static");
	}

	/**
	 * Ensure that tab-specific parameters are only assigned to elements within a tabbed pane.
	 *
	 * @param tabSpecificParam
	 */
	@Check
	def ensureThatTabParamsOnlyInTabContainer(TabSpecificParam tabSpecificParam) {

		var obj = tabSpecificParam.eContainer();
		while (!(obj instanceof TabbedAlternativesPane) && obj !== null) {
			obj = obj.eContainer()
		}

		// if no parent container of type tabbed pane found
		if(obj === null) {
			warning("Specifiying a tab-specific parameter outside of a tabbed pane has no effect.", 
				tabSpecificParam, null, -1, null
			);
		}
	}

	/**
	 * Prevent from defining parameters multiple times in any of the references.
	 *
	 * @param containerRef
	 */
	@Check
	def checkRepeatedParams(ContainerElementReference containerRef) {
		helper.repeatedParamsError(containerRef, null, this, "TabTitleParam", "tabTitle", "TabIconParam", "tabIcon");
	}

	/**
	 * Checks whether a grid layout defines at least the 'rows' or the 'columns' parameter.
	 *
	 * @param gridLayoutPane GridLayout to be checked.
	 */
	@Check
	def checkThatRowsOrColumnsParamIsSet(GridLayoutPane gridLayoutPane) {

		for(GridLayoutPaneParam param : gridLayoutPane.getParams()) {
			if(param instanceof GridLayoutPaneColumnsParam || param instanceof GridLayoutPaneRowsParam) {
				return;
			}
		}

		error("At least the 'rows' or the 'columns' parameter has to be specified.",
				MD2Package.eINSTANCE.gridLayoutPane_Params, 
				LAYOUT_PARAMS_MISSING);
	}

	/**
	 * Checks if the grid layout contains more than 'rows'x'columns' elements.
	 *
	 * @param gridLayoutPane GridLayout to be checked.
	 */
	@Check
	def checkWhetherGridLayoutSizeFits(GridLayoutPane gridLayoutPane) {

		var columns = -1;
		var rows = -1;

		for(GridLayoutPaneParam param : gridLayoutPane.getParams()) {
			if(param instanceof GridLayoutPaneColumnsParam) {
				columns = param.getValue();
			}
			else if(param instanceof GridLayoutPaneRowsParam) {
				rows = param.getValue();
			}
		}

		// calculate total number of elements in grid layout
		var size = 0;
		for(ViewElementType e : gridLayoutPane.getElements()) {
			if(e instanceof Spacer && (e as Spacer).getNumber() > 1) {
				size += (e as Spacer).getNumber();
			} else {
				size++;
			}
		}

		// both parameters are set and there are too few cells for all elements to fit in
		if(columns != -1 && rows != -1 && size > columns * rows) {
			warning("The grid layout contains more than 'rows'x'columns' elements: " +
					"The grid has " + columns * rows +" cells, but contains " + size + " elements. " +
					"All elements that do not fit in the grid will be omitted.",
					MD2Package.eINSTANCE.gridLayoutPane_Params, 
					LAYOUT_PARAMS_MISSING);
		}
	}

	/**
	 * This validator avoids the reuse of an element (via reference) multiple times without renaming.
	 *
	 * @param ref
	 */
	@Check
	def avoidReuseOfElementWithoutRenamingGeneric(ContainerElement container) {

		val Map<String, Map<Boolean, Set<EObject>>> refrencedObjName = Maps.newHashMap();

		// iterate over all references in the container and store their names in a hash map
		// collect duplicate elements
		val Set<EObject> elements = helper.getElementsOfContainerElement(container)
		elements.filter(ViewGUIElementReference).forEach[elem | 
			var guiElement = elem.getValue();
			var isRenamed = elem.isRename();
			var renameName = elem.getName();

			// remember all objects in corresponding sets (name -> isRename => set of corresponding elements)
			val name = if(isRenamed) { renameName } else { guiElement.getName() }
			if(!refrencedObjName.keySet().contains(name)) {
				val Map<Boolean, Set<EObject>> map = Maps.newHashMapWithExpectedSize(2);
				map.put(true, Sets.<EObject>newHashSet());
				map.put(false, Sets.<EObject>newHashSet());
				refrencedObjName.put(name, map);
			}
			refrencedObjName.get(name).get(isRenamed).add(elem);
		]

		// generate errors if more than one object for a certain name is stored
		for (Map<Boolean, Set<EObject>> map : refrencedObjName.values()) {
			if(map.get(false).size() + map.get(true).size() > 1) {
				for (EObject obj : map.get(false)) {
					error("The same reference has been used multiple times without renaming (use '->' operator).",
						obj, null, -1, null
					);
				}
				for (EObject obj : map.get(true)) {
					error("The renamed GUI element has the same name as a referenced GUI element in the same scope.", 
						obj, null, -1, null
					);
				}
			}
		}
	}

	@Check
	def checkEntitySelectorContentProviderIsMany(ContentProviderPath contentProviderPathDefinition) {
		if (contentProviderPathDefinition.eContainer() instanceof EntitySelector) {
			if (contentProviderPathDefinition.getContentProviderRef() !== null) {
				val cp =  contentProviderPathDefinition.getContentProviderRef();
				if (!cp.getType().isMany()) {
					error("The selected ContentProvider is not compatible. Check multiplicities!", 
						MD2Package.eINSTANCE.contentProviderPath_ContentProviderRef
					);
				}
			}
		}
	}

	/**
	 * Checks the width attribute of all GUI elements. If the value is 0% or greater than 100% an error is thrown. The default value for the width as
	 * specified in the model (via MD2PostProcessor) is -1, so that the error is only shown if the user set this optional attribute explicitly.
	 *
	 * @param guiElement
	 */
	@Check
	def checkViewGUIElementWidthIsGreaterZeroAndLessOrEqualThanHundret(ContentElement guiElement) {
		val width = guiElement.getWidth();
		if (width < 0 || width > 100) {
			error("The width parameter may not be " + width + "%. Please set a value between 1% and 100%.", 
				MD2Package.eINSTANCE.contentElement_Width
			);
		}
	}
	
	@Check
	def checkViewGUIElementWidthIsGreaterZeroAndLessOrEqualThanHundret(WidthParam param) {
		// width parameters from container elements
		val width = param.getWidth();
		if (width == 0 || width > 100) {
			error("The width parameter may not be " + width + "%. Please set a value between 1% and 100%.", 
				MD2Package.eINSTANCE.widthParam_Width
			);
		}
	}
	
	/**
	 * Ensures only one default proceed/back action exists per ViewFrame
	 */
	@Check
	def checkViewActions(ViewFrame frame){
		if(frame.viewActions.filter[va | va.defaultBack === true].length > 1){
			acceptWarning("More than one default back action specified",
				frame.viewActions.filter[va | va.defaultBack === true].get(1), MD2Package.VIEW_ACTION__DEFAULT_BACK, -1, null);
		}

		if(frame.viewActions.filter[va | va.defaultProceed === true].length > 1){
			acceptWarning("More than one default back action specified",
				frame.viewActions.filter[va | va.defaultProceed === true].get(1), MD2Package.VIEW_ACTION__DEFAULT_PROCEED, -1, null);
		}
	}

	@Check
	def checkInputType(TextInput input){
		if(input.type !== InputType.DEFAULT && 
			input.type !== InputType.INPUT && 
			input.type !== InputType.TEXTAREA && 
			input.type !== InputType.PASSWORD)
		
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	}   
	
	@Check
	def checkInputType(OptionInput input){
		if(input.type !== InputType.DEFAULT)
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	} 
	
	@Check
	def checkInputType(DateTimeInput input){
		if(input.type !== InputType.DEFAULT)
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	} 
	
	@Check
	def checkInputType(TimeInput input){
		if(input.type !== InputType.DEFAULT)
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	} 
	
	@Check
	def checkInputType(DateInput input){
		if(input.type !== InputType.DEFAULT)
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	} 
	
	@Check
	def checkInputType(NumberInput input){
		if(input.type !== InputType.DEFAULT &&
			input.type !== InputType.INPUT)
	
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	} 
	
	@Check
	def checkInputType(IntegerInput input){
		if(input.type !== InputType.DEFAULT &&
			input.type !== InputType.INPUT)
			
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	} 
	
	@Check
	def checkInputType(BooleanInput input){
		if(input.type !== InputType.DEFAULT)
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	} 
	
	@Check
	def checkInputType(FileUpload input){
		if(input.type !== InputType.DEFAULT)
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	} 
	
	@Check
	def checkInputType(EntitySelector input){
		if(input.type !== InputType.DEFAULT)
			error("'" + input.type + "' is not a valid input type for this field.", MD2Package.eINSTANCE.inputElement_Type);
	}
}
