package de.wwu.md2.framework.validation;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.resource.IResourceDescription;
import org.eclipse.xtext.resource.IResourceServiceProvider;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.CancelableDiagnostician;
import org.eclipse.xtext.validation.Check;
import org.eclipse.xtext.validation.NamesAreUniqueValidator;

import com.google.inject.Inject;

import de.wwu.md2.framework.util.MD2Util;

public class MD2NamesAreUniqueValidator extends NamesAreUniqueValidator {
	
	@Inject
	private IResourceServiceProvider.Registry resourceServiceProviderRegistry = IResourceServiceProvider.Registry.INSTANCE;
	
	@Inject
	private MD2NamesAreUniqueValidationHelper helper;
	
	@Inject
	private MD2Util util;
	
	@Check
	@Override
	public void checkUniqueNamesInResourceOf(EObject eObject) {
		Map<Object, Object> context = getContext();
		Resource res = eObject.eResource();
		
		if (res == null)
			return;
		CancelIndicator cancelIndicator = null;
		if (context != null) {
			if (context.containsKey(res))
				return; // resource was already validated
			context.put(res, this);
			cancelIndicator = (CancelIndicator) context.get(CancelableDiagnostician.CANCEL_INDICATOR);
		}
		
		doCheckUniqueNames(util.getAllResources(res), cancelIndicator, res.getURI());
	}
	
	public void doCheckUniqueNames(Collection<Resource> resources, CancelIndicator cancelIndicator, URI uri) {
		
		ArrayList<IEObjectDescription> descriptions = new ArrayList<IEObjectDescription>();
		
		for(Resource resource : resources) {
			final IResourceServiceProvider resourceServiceProvider = resourceServiceProviderRegistry.getResourceServiceProvider(resource.getURI());
			if (resourceServiceProvider==null)
				return;
			IResourceDescription.Manager manager = resourceServiceProvider.getResourceDescriptionManager();
			if (manager != null) {
				IResourceDescription description = manager.getResourceDescription(resource);
				if (description != null) {
					 for(IEObjectDescription od : description.getExportedObjects()) {
						 descriptions.add(od);
					 }
				}
			}
		}
		
		helper.checkUniqueNames(descriptions, cancelIndicator, this, uri);
	}
	
}
