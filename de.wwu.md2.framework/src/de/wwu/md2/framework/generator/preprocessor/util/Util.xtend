package de.wwu.md2.framework.generator.preprocessor.util

import java.util.HashMap
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EObjectContainmentEList
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension de.wwu.md2.framework.generator.preprocessor.util.Helper.*

/**
 * Provides utility methods to operate on EMF models.
 */
class Util {
	
	def static ResourceSet copyModel(ResourceSet input) {
		val ResourceSet workingInput = new ResourceSetImpl
		val copier = new EcoreUtil.Copier
		for (resource : input.resources) {
			val workingInputResource = workingInput.createResource(resource.URI)
			workingInputResource.contents.addAll((copier.copyAll(resource.contents)))
			workingInput.resources.add(workingInputResource)
		}
		copier.copyReferences
		workingInput
	}
	
	def static <T extends EObject> T copyElement(T elem) {
		val copier = new EcoreUtil.Copier
		val newElem = copier.copy(elem) as T
		copier.copyReferences
		return newElem
	}
	
	def static int countContainers(EObject obj, int i) {
		if (obj.eContainer !== null) {
			countContainers(obj.eContainer, i+1)
		} else {
			return i;
		} 
	}
	
	/**
	 * Create a string representation for a given EObject. All features (attributes and cross-references) of the EObject itself
	 * and all contained EObjects is calculated.
	 */
	def static String eObjectRecursiveStringRepresentation(EObject eObject) {
		
		val signature = new StringBuilder
		eObject.eAllContents.forEach[ o |
			signature.append(o.eClass.name).append("(")
			val features = newArrayList
			o.eClass.getEAllStructuralFeatures.forEach[ a |
				val value = switch (a) {
					EAttribute: o.eGet(a)
					EReference: {
					    val eRef = o.eGet(a)
					    val _value = switch(eRef) {
					        EObject: {
                                if (eRef !== null) {
                                    val className = eRef.eClass.name
                                    val name = if (eRef.eClass.EAllAttributes.exists[ x | x.name.equals("name") ])
                                                 "[" + eRef.eGet(eRef.eClass.EAllAttributes.filter[ x | x.name.equals("name") ].last) + "]"
                                               else "[]"
                                    className + name
                                }
					        }
					        EObjectContainmentEList<Object>: {
					            eRef.eObjectContainmentEListRecursiveStringRepresentation
					        }
					    }
						_value
					}
				}
				features.add(a.name + "=" + value)
			]
			signature.append(features.toArray().join(",")).append("); ")
		]
		
		return signature.toString
	}
	
	def static String eObjectContainmentEListRecursiveStringRepresentation(EObjectContainmentEList<Object> eList) {
	    val signature = new StringBuilder
	    for(Object o : eList){
	        switch(o){
	            EObject: signature.append(o.eObjectRecursiveStringRepresentation)
	            EObjectContainmentEList<Object>: o.eObjectContainmentEListRecursiveStringRepresentation
	        }
	    }
        return signature.toString
    }
    
    private static HashMap<EObject, String> uniqueParameterSignatures = newHashMap
	
	/**
	 * Calculate a SHA1 hash of the string representation (@see eObjectRecusriveStringRepresentation) of an EObject.
	 * This is for example useful to generate unique names for different SimpleActions or Validators. If an EObject (e.g.
	 * a Validator with the same message as parameter) exists multiple times it gets assigned the same hash value and thus
	 * has to be generated only once.
	 */
	def static String calculateParameterSignature(EObject eObject) {
		if (!uniqueParameterSignatures.keySet.contains(eObject)) {
			uniqueParameterSignatures.put(eObject, eObjectRecursiveStringRepresentation(eObject).sha1Hex)
		}
		return uniqueParameterSignatures.get(eObject)	
	}
	
}
