package de.wwu.md2.framework.validation;

import com.google.common.collect.Maps
import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClass
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.validation.NamesAreUniqueValidationHelper
import org.eclipse.xtext.validation.ValidationMessageAcceptor

/**
 * <p>The three methods implemented in this helper class are almost a copy of the corresponding
 * methods implemented in the super class {@code NamesAreUniqueValidationHelper}, but they extend their
 * parameter set by the parameter {@code uri} that stores the resource URI of the calling model.</p>
 * 
 * <p>The {@code createDuplicateNameError} has been extended on a check whether the found duplicate object
 * belongs to the currently checked model (based on the passed URI).</p>
 * 
 * <p>These extensions became necessary, because the default implementation of the NamesAreUniqueValidator
 * does not support multiple models.</p>
 */
class MD2NamesAreUniqueValidationHelper extends NamesAreUniqueValidationHelper {
	
	def checkUniqueNames(Iterable<IEObjectDescription> descriptions, 
			CancelIndicator cancelIndicator, ValidationMessageAcceptor acceptor, URI uri) {
		val Map<EClass, Map<QualifiedName, IEObjectDescription>> clusterToNames = Maps.newHashMap();
		descriptions.forEach[description |
			checkDescriptionForDuplicatedName(description, clusterToNames, acceptor, uri);
			if (cancelIndicator !== null && cancelIndicator.isCanceled())
				return;
		]
	}
	
	def checkDescriptionForDuplicatedName(
			IEObjectDescription description,
			Map<EClass, Map<QualifiedName, IEObjectDescription>> clusterTypeToName,
			ValidationMessageAcceptor acceptor, URI uri) {
		val qualifiedName = description.getName();
		val clusterType = getAssociatedClusterType(description.getEObjectOrProxy().eClass());
		
		var nameToDescription = clusterTypeToName.get(clusterType);
		if (nameToDescription === null) {
			nameToDescription = Maps.newHashMap();
			nameToDescription.put(qualifiedName, description);
			clusterTypeToName.put(clusterType, nameToDescription);
		} else {
			if (nameToDescription.containsKey(qualifiedName)) {
				val prevDescription = nameToDescription.get(qualifiedName);
				if (prevDescription !== null) {
					createDuplicateNameError(prevDescription, clusterType, acceptor, uri);
					nameToDescription.put(qualifiedName, null);
				}
				createDuplicateNameError(description, clusterType, acceptor, uri);
			} else {
				nameToDescription.put(qualifiedName, description);
			}
		}
	}
	
	protected def createDuplicateNameError(IEObjectDescription description, EClass clusterType, ValidationMessageAcceptor acceptor, URI uri) {
		val object = description.getEObjectOrProxy();
		val feature = getNameFeature(object);
		
		if(object.eResource().getURI().equals(uri)) {
			acceptor.acceptError(
					getDuplicateNameErrorMessage(description, clusterType, feature), 
					object, 
					feature,
					ValidationMessageAcceptor.INSIGNIFICANT_INDEX,
					getErrorCode());
		}
	}
}
