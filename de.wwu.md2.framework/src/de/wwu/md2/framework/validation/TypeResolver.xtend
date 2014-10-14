package de.wwu.md2.framework.validation

import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.AbstractProviderReference
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.mD2.BooleanInput
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.ConcatenatedString
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.DateInput
import de.wwu.md2.framework.mD2.DateTimeInput
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.Div
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.LocationProviderPath
import de.wwu.md2.framework.mD2.LocationProviderReference
import de.wwu.md2.framework.mD2.Minus
import de.wwu.md2.framework.mD2.Mult
import de.wwu.md2.framework.mD2.NumberInput
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.PathTail
import de.wwu.md2.framework.mD2.Plus
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.SimpleType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TimeInput
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference

/**
 * Helper class to resolve the data type of a SimpleExpression.
 */
class TypeResolver {
	
	/**
	 * Resolves the data type of a simple expression and returns a string representation
	 * of the type.
	 */
	def static getExpressionType(SimpleExpression expr) {
		
		switch expr {
			StringVal: "string"
			BooleanVal: "boolean"
			DateVal: "date"
			TimeVal: "time"
			DateTimeVal: "datetime"
			IntVal: "integer"
			FloatVal: "float"
			
			AbstractContentProviderPath: expr.abstractContentProviderPathType
			AbstractProviderReference: expr.abstractContentProviderType
			AbstractViewGUIElementRef: expr.abstractViewGUIElementType
			
			ConcatenatedString: "string"
			Plus: "float"
			Minus: "float"
			Div: "float"
			Mult: "float"
		}
		
	}
	
	/**
	 * Recursively resolve last attribute of a path and return its attribute type name.
	 */
	def static AttributeType resolveAttribute(PathTail pathTail) {
		
		if (pathTail.tail == null) {
			return pathTail.attributeRef.type
		}
		return pathTail.tail.resolveAttribute
		
	}
	
	def static boolean isValidEnumType(SimpleExpression lhs, SimpleExpression rhs) {
		
		val lhsIsEnum = switch lhs {
			ContentProviderPath: lhs.tail.resolveAttribute instanceof ReferencedType
					&& (lhs.tail.resolveAttribute as ReferencedType).element instanceof Enum
			AbstractViewGUIElementRef: lhs.path.tail.resolveAttribute instanceof ReferencedType
					&& (lhs.path.tail.resolveAttribute as ReferencedType).element instanceof Enum
			default: false
		}
		
		val rhsIsEnum = switch rhs {
			ContentProviderPath: rhs.tail.resolveAttribute instanceof ReferencedType
					&& (rhs.tail.resolveAttribute as ReferencedType).element instanceof Enum
			AbstractViewGUIElementRef: rhs.path.tail.resolveAttribute instanceof ReferencedType
					&& (rhs.path.tail.resolveAttribute as ReferencedType).element instanceof Enum
			default: false
		}
		
		lhsIsEnum && rhs.expressionType.equals("string") || rhsIsEnum && lhs.expressionType.equals("string")
	}
	
	def static getAttributeTypeName(AttributeType type) {
		
		switch type {
			IntegerType: "integer"
			FloatType: "float"
			StringType: "string"
			BooleanType: "boolean"
			DateType: "date"
			TimeType: "time"
			DateTimeType: "datetime"
			ReferencedType: type.element.name
			EnumType: "Enum"
			default: System::err.println("Unexpected AttributeType found: " + type.eClass.name)
		}
		
	}
	
	def private static String getAbstractViewGUIElementType(AbstractViewGUIElementRef ref) {
		
		if (ref.path != null) {
			return ref.path.tail.resolveAttribute.attributeTypeName
		} else if (ref.simpleType != null) {
			return ref.simpleType.type.toString
		} else if (ref.tail == null) {
			return ref.ref.viewElementTypeName
		}
		ref.tail.abstractViewGUIElementType
		
	}
	
	def private static getAbstractContentProviderPathType(AbstractContentProviderPath path) {
		
		switch path {
			LocationProviderPath: "string"
			ContentProviderPath: path.tail.resolveAttribute.attributeTypeName
		}
		
	}
	
	def private static getAbstractContentProviderType(AbstractProviderReference ref) {
		
		switch ref {
			LocationProviderReference: "Location"
			ContentProviderReference: {
				val providerType = ref.contentProvider.type
				switch providerType {
					SimpleType: providerType.type.toString
					ReferencedModelType: providerType.entity.name
				}
			}
		}
		
	}
	
	def private static getViewElementTypeName(ViewElementType elementType) {
		
		val viewGUIElement = switch elementType {
			ViewGUIElement: elementType
			ViewGUIElementReference: elementType.value
		}
		
		switch viewGUIElement {
			BooleanInput: "boolean"
			TextInput: "string"
			IntegerInput: "integer"
			NumberInput: "float"
			DateInput: "date"
			TimeInput: "Time"
			DateTimeInput: "datetime"
			OptionInput: viewGUIElement.enumReference?.name ?: "string"
			Tooltip: "string"
			Label: "string"
			default: "undefined"
		}
		
	}
	
}
