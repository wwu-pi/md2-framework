package de.wwu.md2.framework.validation;

import com.google.inject.Inject
import de.wwu.md2.framework.util.MD2Util
import java.util.Collection
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.IResourceServiceProvider
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.validation.CancelableDiagnostician
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.NamesAreUniqueValidator

import static extension de.wwu.md2.framework.util.IterableExtensions.*

/**
 * General validator that checks for duplicate names in all model elements. 
 */
class MD2NamesAreUniqueValidator extends NamesAreUniqueValidator {
	
	@Inject
	IResourceServiceProvider.Registry resourceServiceProviderRegistry = IResourceServiceProvider.Registry.INSTANCE;
	
	@Inject
	MD2NamesAreUniqueValidationHelper helper;
	
	@Inject
	MD2Util util;
	
	@Check
	override checkUniqueNamesInResourceOf(EObject eObject) {
		val res = eObject.eResource();
		
		if (res === null)
			return;
		if (getContext() !== null) {
			if (context.containsKey(res))
				return; // resource was already validated
			context.put(res, this);
			val cancelIndicator = context.get(CancelableDiagnostician.CANCEL_INDICATOR) as CancelIndicator;
			
			doCheckUniqueNames(util.getAllResources(res), cancelIndicator, res.getURI());
		}
	}
	
	def doCheckUniqueNames(Collection<Resource> resources, CancelIndicator cancelIndicator, URI uri) {
		val descriptions = newArrayList();
		
		resources.forEach[
			descriptions.addAllIfNotNull(
				resourceServiceProviderRegistry.getResourceServiceProvider(it.getURI())?.
					getResourceDescriptionManager()?.getResourceDescription(it)?.getExportedObjects().toList)
		]
		
		helper.checkUniqueNames(descriptions, cancelIndicator, this, uri);
	}
}
	