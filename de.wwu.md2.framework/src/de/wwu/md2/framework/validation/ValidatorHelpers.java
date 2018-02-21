package de.wwu.md2.framework.validation;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Set;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.xtext.validation.ValidationMessageAcceptor;

import com.google.common.collect.Sets;

/**
 * This class provides helper methods for the MD2 validators. The easiest way to
 * use them is by injecting this helper class, e.g.
 * <pre>
 * @Inject
 * private ValidatorHelpers helper;
 * </pre>
 */
public class ValidatorHelpers {
	
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
	public void repeatedParamsError(EObject element, EStructuralFeature literal, ValidationMessageAcceptor acceptor, String ... mappings) {
		
		assert mappings.length % 2 == 0 : "Expects an even number of mapping strings";
		
		HashMap<String, String> eClassToNameMapping = new HashMap<String, String>();
		for(int i = 0; i < mappings.length - 1; i += 2) {
			eClassToNameMapping.put(mappings[i], mappings[i + 1]);
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
	public void repeatedParamsError(EObject element, EStructuralFeature literal, ValidationMessageAcceptor acceptor, HashMap<String, String> eClassToNameMapping) {
		
		Set<String> set = Sets.newHashSet();
		
		try {
			Method m = element.getClass().getMethod("getParams");
			Object params = m.invoke(element);
			
			assert params instanceof EList : "Expects params to be an instance of EList";
			
			for(Object param : EList.class.cast(params)) {
				String name = ((EObject)param).eClass().getName();
				if(set.contains(name)) {
					acceptor.acceptError("Parameter \"" + eClassToNameMapping.get(name)
							+ "\" has been defined multiple times", element, literal, -1, ModelValidator.REPEATEDPARAMS);
					break;
				} else {
					set.add(name);
				}
			}
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
	}
}
