package de.wwu.md2.framework.conversion;

import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.conversion.impl.AbstractNullSafeConverter;
import org.eclipse.xtext.nodemodel.INode;

/**
 * String - Percent converter. Converts input of the pattern ###% to integer values.
 */
public class PercentValueConverter extends AbstractNullSafeConverter<Integer> {
	
	@Override
	protected String internalToString(Integer value) {
		return value.toString() + "%";
	}
	
	@Override
	protected Integer internalToValue(String percentString, INode node) throws ValueConverterException {
		
		int index = percentString.indexOf("%");
		
		if(index == -1) {
			throw new ValueConverterException("No valid percentage value format: Expects \"###%\".", node, null);
		} else {
			return Integer.parseInt(percentString.substring(0, index));
		}
	}
	
}
