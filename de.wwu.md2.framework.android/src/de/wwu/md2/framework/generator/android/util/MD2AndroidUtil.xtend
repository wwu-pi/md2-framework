package de.wwu.md2.framework.generator.android.util

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.Condition
import de.wwu.md2.framework.mD2.ConditionalEventRef
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.ElementEventType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.EventDef
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.GlobalEventRef
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.ViewGUIElement
import java.util.Set

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class MD2AndroidUtil {
	def static attributeTypeName(Attribute attribute) {
		var baseName = switch attribute.type {
			ReferencedType : (attribute.type as ReferencedType).entity.name
			IntegerType : "Integer"
			FloatType : "Float"
			StringType : "String"
			BooleanType : "Boolean"
			DateType : "java.util.Date"
			TimeType : "java.util.Date"
			DateTimeType : "java.util.Date"
			default: ""
		}
//		if (attribute.type.many) '''java.util.List<«baseName»>''' else baseName
		baseName
	}
	
	def static attributeTypeName(Entity entity, Attribute attribute) {
		var typeName = attributeTypeName(attribute) 
		if (typeName.length() > 1) {
			if (attribute.type instanceof EnumType) typeName = entity.name + "_" + attribute.name.toFirstUpper
		}
		typeName
	}

	/**
	 * Helper to write a java file to disk
	 * 
	 * @param fsa The file system access used
	 * @param classDef The data container specifying the java file
	 */
	def static writeJavaFile(IExtendedFileSystemAccess fsa, JavaClassDef classDef) {
		fsa.generateFile(classDef.fileName, classDef.contents)
	}
	
	def static getConditionName(DataContainer dataContainer, Condition condition) {
		dataContainer.conditions.filter[conditionName, currentCondition | condition == currentCondition].keySet.last.toFirstUpper
	}
	
	def static getGoToViewCode(ViewGUIElement view, String appObjectName, String basePackage, DataContainer dataContainer, Set<ContainerElement> activities, Set<ContainerElement> fragments) '''
		«IF activities.contains(view)»
			Intent intent = new Intent(«appObjectName».getActiveActivity(), «basePackage».controller.«getName(view).toFirstUpper»Activity.class);
			«appObjectName».getActiveActivity().startActivity(intent);
		«ELSEIF fragments.contains(view)»
			if(«appObjectName».getActiveActivity() instanceof TabbedActivity) {
				((TabbedActivity)«appObjectName».getActiveActivity()).setSelectedTab("«getName(view)»");
			}
			else {
				Intent intent = new Intent(«appObjectName».getActiveActivity(), «basePackage».controller.«getName(dataContainer.tabbedAlternativesPane).toFirstUpper»Activity.class);
				intent.putExtra("tabToShow", "«getName(view)»");
				«appObjectName».getActiveActivity().startActivity(intent);
			}
		«ELSE»
			// TODO Target view cannot be allocated to either activity or fragment
		«ENDIF»
	'''
	
	def static getEventName(EventDef event) {
		switch event {
			ViewElementEventRef: {
				val viewName = getName(resolveViewGUIElement(event.referencedField))
				val eventType = getEventType(event.event)
				viewName + "_" + eventType
			}				
			GlobalEventRef: "Connection_Lost"
			ConditionalEventRef: event.eventReference.name.toFirstUpper  + "_OnConditionEvent"
		}
	}
	
	def private static getEventType(ElementEventType type) {
		switch type {
			case ElementEventType::ON_CLICK: "Touched"
			case ElementEventType::ON_LEFT_SWIPE: "LeftSwipe"
			case ElementEventType::ON_RIGHT_SWIPE: "RightSwipe"
			case ElementEventType::ON_WRONG_VALIDATION: "WrongValidation"
		}
	}
	
}