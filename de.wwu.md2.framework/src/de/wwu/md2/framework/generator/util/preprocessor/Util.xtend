package de.wwu.md2.framework.generator.util.preprocessor

import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil

class Util {
	
	def static ResourceSet copyModel(ResourceSet input) {
		val ResourceSet workingInput = new ResourceSetImpl()
		val copier = new EcoreUtil.Copier()
		for (resource : input.resources) {
			val workingInputResource = workingInput.createResource(resource.URI)
			workingInputResource.contents.addAll((copier.copyAll(resource.contents)))
			workingInput.resources.add(workingInputResource)
		}
		copier.copyReferences()
		workingInput
	}
	
	def static EObject copyElement(EObject elem) {
		return copyElement(elem, null);
	}
	
	def static EObject copyElement(EObject elem, HashMap<EObject, EObject> map) {
		val copier = new EcoreUtil.Copier()
		val newElem = copier.copy(elem)
		copier.copyReferences
		if (map != null) {
			// Get all copied elements in a HashSet with the copied element as key
			for (entry : copier.entrySet) {
				map.put(entry.value, entry.key)
			}	
		}		
		newElem
	}
	
	def static int countContainers(EObject obj, int i) {
		if (obj.eContainer != null) {
			countContainers(obj.eContainer, i+1)
		} else {
			return i;
		} 
	}
	
}