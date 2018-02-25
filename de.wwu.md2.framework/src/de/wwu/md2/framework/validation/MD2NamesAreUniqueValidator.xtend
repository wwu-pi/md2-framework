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

class MD2NamesAreUniqueValidator extends NamesAreUniqueValidator {
	
	@Inject
	private IResourceServiceProvider.Registry resourceServiceProviderRegistry = IResourceServiceProvider.Registry.INSTANCE;
	
	@Inject
	private MD2NamesAreUniqueValidationHelper helper;
	
	@Inject
	private MD2Util util;
	
	@Check
	override def checkUniqueNamesInResourceOf(EObject eObject) {
		val context = getContext();
		val res = eObject.eResource();
		
		if (res === null)
			return;
		var CancelIndicator cancelIndicator = null;
		if (context !== null) {
			if (context.containsKey(res))
				return; // resource was already validated
			context.put(res, this);
			cancelIndicator = context.get(CancelableDiagnostician.CANCEL_INDICATOR) as CancelIndicator;
		}
		
		doCheckUniqueNames(util.getAllResources(res), cancelIndicator, res.getURI());
	}
	
	def doCheckUniqueNames(Collection<Resource> resources, CancelIndicator cancelIndicator, URI uri) {
		
		val descriptions = newArrayList();
		
		for(Resource resource : resources) {
			val resourceServiceProvider = resourceServiceProviderRegistry.getResourceServiceProvider(resource.getURI());
			if (resourceServiceProvider === null)
				return;
			val manager = resourceServiceProvider.getResourceDescriptionManager();
			if (manager !== null) {
				val description = manager.getResourceDescription(resource);
				if (description !== null) {
					descriptions.addAll(description.getExportedObjects())
				}
			}
		}
		
		helper.checkUniqueNames(descriptions, cancelIndicator, this, uri);
	}
}
	