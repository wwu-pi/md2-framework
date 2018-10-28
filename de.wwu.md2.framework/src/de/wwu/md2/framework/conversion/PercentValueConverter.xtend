package de.wwu.md2.framework.conversion;

import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.conversion.impl.AbstractNullSafeConverter;
import org.eclipse.xtext.nodemodel.INode;

/**
 * String - Percent converter. Converts input of the pattern ###% to integer values.
 */
class PercentValueConverter extends AbstractNullSafeConverter<Integer> {
	
	override protected internalToString(Integer value) {
		return value.toString() + "%";
	}
	
	override protected internalToValue(String percentString, INode node) throws ValueConverterException {
		
		val index = percentString.indexOf("%");
		
		if(index == -1) {
			throw new ValueConverterException("No valid percentage value format: Expects \"###%\".", node, null);
		} else {
			return Integer.parseInt(percentString.substring(0, index));
		}
	}
	
}
