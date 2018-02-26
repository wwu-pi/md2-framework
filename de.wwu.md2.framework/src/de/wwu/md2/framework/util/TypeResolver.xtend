package de.wwu.md2.framework.util

import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.AbstractProviderReference
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.Attribute
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
import de.wwu.md2.framework.mD2.FileType
import de.wwu.md2.framework.mD2.FileUpload
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
import de.wwu.md2.framework.mD2.SensorType
import de.wwu.md2.framework.mD2.SensorVal
import de.wwu.md2.framework.mD2.SimpleDataType
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.SimpleType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TimeInput
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.UploadedImageOutput
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.ViewGUIElementReference

/**
 * Helper class to resolve the data type of a SimpleExpression.
 */
class TypeResolver {
	/**
	 * Recursively resolve last attribute of a path and return its attribute.
	 */
	def static Attribute resolveAttribute(PathTail pathTail) {
		
		if (pathTail.tail === null) {
			return pathTail.attributeRef
		}
		return pathTail.tail.resolveAttribute
		
	}
	
	def static boolean isValidEnumType(SimpleExpression lhs, SimpleExpression rhs) {		
		return lhs.calculateType instanceof Enum && rhs.calculateType === MD2Type.STRING 
			|| rhs.calculateType instanceof Enum && lhs.calculateType === MD2Type.STRING
	}
	
	/**
	 * Resolves the data type of a simple expression and returns a string representation
	 * of the type.
	 */
	def static getJavaExpressionType(SimpleExpression expr) {
		expr.calculateType.javaType
	}
	
	static dispatch def MD2Type calculateType(IntVal expr){
		return MD2Type.INT
	}
	
	static dispatch def MD2Type calculateType(FloatVal expr){
		return MD2Type.FLOAT
	}
	
	static dispatch def MD2Type calculateType(StringVal expr){
		return MD2Type.STRING
	}
	
	static dispatch def MD2Type calculateType(BooleanVal expr){
		return MD2Type.BOOL
	}
	
	static dispatch def MD2Type calculateType(DateVal expr){
		return MD2Type.DATE
	}
	
	static dispatch def MD2Type calculateType(TimeVal expr){
		return MD2Type.TIME
	}
	
	static dispatch def MD2Type calculateType(DateTimeVal expr){
		return MD2Type.DATETIME
	}
	
	static dispatch def MD2Type calculateType(SensorVal expr){
		return MD2Type.SENSOR
	}
	
	static dispatch def MD2Type calculateType(ConcatenatedString expr){
		return MD2Type.STRING
	}
	
	static dispatch def MD2Type calculateType(Plus expr){
		return MD2Type.FLOAT
	}
	
	static dispatch def MD2Type calculateType(Minus expr){
		return MD2Type.FLOAT
	}
	
	static dispatch def MD2Type calculateType(Div expr){
		return MD2Type.FLOAT
	}
	
	static dispatch def MD2Type calculateType(Mult expr){
		return MD2Type.FLOAT
	}
	
	/**
	 * Recursively resolve last attribute of a path and return its attribute type name.
	 */
	static dispatch def MD2Type calculateType(PathTail pathTail){
		if (pathTail.tail === null) {
			return pathTail.attributeRef.type.calculateType
		}
		return pathTail.tail.calculateType
	}
	
	static dispatch def MD2Type calculateType(AbstractViewGUIElementRef ref){
		if (ref.path !== null) {
			return ref.path.tail.calculateType
		} else if (ref.simpleType !== null) {
			return ref.simpleType.type.calculateType
		} else if (ref.tail === null) {
			return ref.ref.calculateType
		}
		ref.tail.calculateType
	}

	static dispatch def MD2Type calculateType(LocationProviderReference p){
		return MD2Type.LOCATION
	}
	
	static dispatch def MD2Type calculateType(ContentProviderReference ref){
		val providerType = ref.contentProvider.type
		switch providerType {
			SimpleType: return providerType.type.calculateType
			ReferencedModelType: return new MD2Type(providerType.entity)
		}
	}
	
	static dispatch def MD2Type calculateType(AbstractProviderReference p){
		System::err.println("Unexpected AbstractProviderReference found: " + p.eClass.name)
		return null
	}
	
	static dispatch def MD2Type calculateType(ViewElementType elementType){	
		switch elementType {
			ViewGUIElement: return elementType.calculateType
			ViewGUIElementReference: elementType.value.calculateType
		}
	}
	
	static dispatch def MD2Type calculateType(IntegerInput t){
		return MD2Type.INT
	}
	
	static dispatch def MD2Type calculateType(NumberInput t){
		return MD2Type.FLOAT
	}
	
	static dispatch def MD2Type calculateType(TextInput t){
		return MD2Type.STRING
	}
	
	static dispatch def MD2Type calculateType(BooleanInput t){
		return MD2Type.BOOL
	}
	
	static dispatch def MD2Type calculateType(DateInput t){
		return MD2Type.DATE
	}
	
	static dispatch def MD2Type calculateType(TimeInput t){
		return MD2Type.TIME
	}
	
	static dispatch def MD2Type calculateType(DateTimeInput t){
		return MD2Type.DATETIME
	}
	
	static dispatch def MD2Type calculateType(FileUpload t){
		return MD2Type.STRING // really?
	}
	
	static dispatch def MD2Type calculateType(UploadedImageOutput t){
		return MD2Type.STRING // really?
	}
	
	static dispatch def MD2Type calculateType(Tooltip t){
		return MD2Type.STRING
	}
	
	static dispatch def MD2Type calculateType(Label t){
		return MD2Type.STRING
	}
	
	static dispatch def MD2Type calculateType(OptionInput t){
		if(t.enumReference !== null){
			return new MD2Type(t.enumReference)
		}
		return MD2Type.STRING
	}
			
	static dispatch def MD2Type calculateType(LocationProviderPath p){
		return MD2Type.LOCATION
	}
	
	static dispatch def MD2Type calculateType(ContentProviderPath p){
		return p.tail.calculateType
	}
	
	static dispatch def MD2Type calculateType(AbstractContentProviderPath p){
		System::err.println("Unexpected AbstractContentProviderPath found: " + p.eClass.name)
		return null
	}
	
	static dispatch def MD2Type calculateType(IntegerType t){
		return MD2Type.INT
	}
	
	static dispatch def MD2Type calculateType(FloatType t){
		return MD2Type.FLOAT
	}
	
	static dispatch def MD2Type calculateType(StringType t){
		return MD2Type.STRING
	}
	
	static dispatch def MD2Type calculateType(BooleanType t){
		return MD2Type.BOOL
	}
	
	static dispatch def MD2Type calculateType(DateType t){
		return MD2Type.DATE
	}
	
	static dispatch def MD2Type calculateType(TimeType t){
		return MD2Type.TIME
	}
	
	static dispatch def MD2Type calculateType(DateTimeType t){
		return MD2Type.DATETIME
	}
	
	static dispatch def MD2Type calculateType(SensorType t){
		return MD2Type.SENSOR
	}
	
	static dispatch def MD2Type calculateType(FileType t){
		return MD2Type.FILE
	}
	
	static dispatch def MD2Type calculateType(ReferencedType t){
		return new MD2Type(t.element)
	}
	
	static dispatch def MD2Type calculateType(SimpleDataType t){
		return new MD2Type(t)
	}
	
	static def dispatch MD2Type calculateType(AttributeType t){
		System::err.println("Unexpected AttributeType found: " + t.eClass.name)
		return null
	}
}
