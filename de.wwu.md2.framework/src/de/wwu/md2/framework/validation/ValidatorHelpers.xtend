package de.wwu.md2.framework.validation;

import com.google.common.collect.Sets
import java.lang.reflect.InvocationTargetException
import java.util.HashMap
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.validation.ValidationMessageAcceptor
import java.util.Set
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.ListView
import de.wwu.md2.framework.mD2.DataType
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.SimpleType
import de.wwu.md2.framework.mD2.AttrIsOptional
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FileType

/**
 * This class provides helper methods for the MD2 validators. The easiest way to
 * use them is by injecting this helper class, e.g.
 * <pre>
 * @Inject
 * private ValidatorHelpers helper;
 * </pre>
 */
class ValidatorHelpers {
	
	/**
	 * This method is a short cut for the method {@code repeatedParamsError(EObject element, EAttribute literal, HashMap<String, String> eClassToNameMapping)}.
	 * 
	 * <p>A helper method to check whether a certain parameter has been defined multiple times. To use this method, the parameters have to be 
	 * implemented as an own EClass in the Ecore model and they have to be assigned using an EReference with the name <tt>params</tt>.</p>
	 * 
	 * <p>Example of such a parameter definition in Xtext:</p>
	 * <pre>
	 * GridLayoutPane:
	 *    'GridLayoutPane' name = ID '(' (params += GridLayoutPaneParam (',' params += GridLayoutPaneParam)*)? ')' '{'
	 *       elements += ViewElementType*
	 *    '}'
	 * ;
	 * 
	 * GridLayoutPaneParam:
	 *    {Columns} 'columns' value = INT | {Rows} 'rows' value = INT
	 * ; 
	 * </pre>
	 * 
	 * Besides the element and literal attribute an even number of strings is expected that represent key-value-pairs for each defined parameter for which
	 * duplicity has to be checked. As the n-th parameter the EClass name of the parameter (e.g. "Columns") has to be set, as the n+1st parameter of this method
	 * the parameter name in the defined language is expected (e.g. "rows").
	 * 
	 * @param element The element for which the params have been defined. It is expected that the element contains an EReference with the name <tt>params</tt>.
	 * @param literal The structural feature in the defined language on which the validation error should be marked.
	 * @param acceptor Instance of the validator that calls this method.
	 * @param mappings An even number of strings is expected that represent key-value-pairs for each defined parameter for which duplicity has to be checked.
	 */
	def repeatedParamsError(EObject element, EStructuralFeature literal, ValidationMessageAcceptor acceptor, String ... mappings) {
		
		if(!(mappings.length % 2 == 0)) new RuntimeException("Expects an even number of mapping strings")
		
		val eClassToNameMapping = new HashMap<String, String>();
		for(var i = 0; i < mappings.length - 1; i += 2) {
			eClassToNameMapping.put(mappings.get(i), mappings.get(i + 1));
		}
		
		repeatedParamsError(element, literal, acceptor, eClassToNameMapping);
	}
	
	/**
	 * A helper method to check whether a certain parameter has been defined multiple times. To use this method, the parameters have to be 
	 * implemented as an own EClass in the Ecore model and they have to be assigned using an EReference with the name <tt>params</tt>.
	 * 
	 * <p>Example of such a parameter definition in Xtext:</p>
	 * <pre>
	 * GridLayoutPane:
	 *    'GridLayoutPane' name = ID '(' (params += GridLayoutPaneParam (',' params += GridLayoutPaneParam)*)? ')' '{'
	 *       elements += ViewElementType*
	 *    '}'
	 * ;
	 * 
	 * GridLayoutPaneParam:
	 *    {Columns} 'columns' value = INT | {Rows} 'rows' value = INT
	 * ; 
	 * </pre>
	 * 
	 * As the last parameter <tt>eClassToNameMapping</tt> of this method a HashMap is needed that contains key-value-pairs for each defined parameter for which
	 * duplicity has to be checked. As key the EClass name of the parameter (e.g. "Columns") has to be set, as the value the parameter name in the defined
	 * language is expected (e.g. "rows").
	 * 
	 * @param element The element for which the params have been defined. It is expected that the element contains an EReference with the name <tt>params</tt>.
	 * @param literal The structural feature in the defined language on which the validation error should be marked.
	 * @param acceptor Instance of the validator that calls this method.
	 * @param eClassToNameMapping A HashMap that contains key-value-pairs for each defined parameter for which duplicity has to be checked.
	 */
	def repeatedParamsError(EObject element, EStructuralFeature literal, ValidationMessageAcceptor acceptor, HashMap<String, String> eClassToNameMapping) {
		
		val set = Sets.newHashSet();
		
		try {
			val m = element.getClass().getMethod("getParams");
			val params = m.invoke(element);
			
			if(!(params instanceof EList<?>)) new RuntimeException("Expects params to be an instance of EList")
			
			EList.cast(params).forEach[param |
				val name = (param as EObject).eClass().getName();
				if(set.contains(name)) {
					acceptor.acceptError("Parameter \"" + eClassToNameMapping.get(name)
							+ "\" has been defined multiple times", element, literal, -1, ModelValidator.REPEATEDPARAMS);
				} else {
					set.add(name);
				}
			]
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
	}
	
	def Set<EObject> getElementsOfContainerElement(ContainerElement container) {

		val elements = newHashSet();

		if(container instanceof GridLayoutPane) {
			elements.addAll(container.getElements());
		} else if(container instanceof FlowLayoutPane) {
			elements.addAll(container.getElements());
		} else if(container instanceof AlternativesPane) {
			elements.addAll(container.getElements());
		} else if(container instanceof TabbedAlternativesPane) {
			elements.addAll(container.getElements());
		} else if(container instanceof ListView){
			elements.addAll(container.getElements());
		} else {
			System.err.println("Unexpected ContainerElement subtype found: " + container.getClass().getName());
		}

		return elements;
	}

	
	def Set<EObject> getParametersOfContainerElement(ContainerElement container) {

		val parameters = newHashSet();

		if(container instanceof GridLayoutPane) {
			parameters.addAll(container.getParams());
		} else if(container instanceof FlowLayoutPane) {
			parameters.addAll(container.getParams());
		} else if(container instanceof AlternativesPane) {
			parameters.addAll(container.getParams());
		} else if(container instanceof TabbedAlternativesPane) {
			// has no parameters
		} else if(container instanceof ListView) {
			// has no used parameters
		} else {
			System.err.println("Unexpected ContainerElement subtype found: " + container.getClass().getName());
		}

		return parameters;
	}
	
	def String getDataTypeName(DataType dataType) {

		var str = "";

		if(dataType instanceof ReferencedModelType) {
			str = dataType.getEntity().getName();
		} else if(dataType instanceof SimpleType) {
			str = dataType.getType().getLiteral();
		} else {
			System.err.println("Unexpected DataType found: " + dataType.getClass().getName());
		}

		return str;
	}
	
	/**
	 * Retrieve all required attributes of a list of attributes
	 */
	def Set<Attribute> getRequiredAttributes(Iterable<Attribute> attributes) {
		attributes.filter [
			var type = it.type
			var params = switch (type) {
				ReferencedType: type.params
				IntegerType: type.params
				FloatType: type.params
				StringType: type.params
				BooleanType: type.params
				DateType: type.params
				TimeType: type.params
				DateTimeType: type.params
				EnumType: type.params
				FileType: type.params
				default: throw new RuntimeException("The attribute type is not registered in this method.")
			}
			params.filter(AttrIsOptional).size == 0
		].toSet
	}
}
