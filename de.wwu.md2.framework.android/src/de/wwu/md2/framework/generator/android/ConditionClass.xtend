package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.generator.android.util.JavaClassDef
import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.Boolean
import de.wwu.md2.framework.mD2.BooleanExpression
import de.wwu.md2.framework.mD2.CheckBox
import de.wwu.md2.framework.mD2.Condition
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.EqualsExpression
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.GuiElementStateExpression
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TextInput
import java.util.Set

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static de.wwu.md2.framework.mD2.ViewElementState.*

class ConditionClass {
	private DataContainer dataContainer
	private Set<ContainerElement> topLevelViewContainers
	
	private Set<TextInput> textInputRefs
	private Set<CheckBox> checkBoxRefs
	private Set<ContainerElement> containerRefs
	private Set<ContentElement> contentRefs
	
	
	new (DataContainer dataContainer, Set<ContainerElement> topLevelViewContainers) {
		this.dataContainer = dataContainer
		this.topLevelViewContainers = topLevelViewContainers
		
		textInputRefs = newHashSet
		checkBoxRefs = newHashSet
		containerRefs = newHashSet
		contentRefs = newHashSet
	}
	
	def public generateCondition(JavaClassDef classDef, Condition condition) '''
		«val checkConditionBody = createCheckConditionBody(condition)»
		package «classDef.fullPackage»;
		
		import java.util.HashMap;
		import java.util.HashSet;
		import java.util.Map;
		
		import android.view.View;
		import android.view.ViewGroup;
		import android.widget.CheckBox;
		import android.widget.TextView;
		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.controller.condition.Condition;
		import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
		import «classDef.basePackage».R;
		
		public class «classDef.simpleName» extends Condition {
			
			private MD2Application app;
			
			«FOR viewElemRef : textInputRefs»
				private TextView «getName(viewElemRef)»;
			«ENDFOR»
			«FOR viewElemRef : checkBoxRefs»
				private CheckBox «getName(viewElemRef)»;
			«ENDFOR»
			«FOR viewElemRef : containerRefs»
				private ViewGroup «getName(viewElemRef)»;
			«ENDFOR»
			«FOR viewElemRef : contentRefs»
				private View «getName(viewElemRef)»;
			«ENDFOR»
			
			public «classDef.simpleName»(MD2Application app) {
				super(app);
				
				this.app = app;
				
				registerSetViewEvents();
			}
			
			public Iterable<String> getContentElements() {
				HashSet<String> contentElements = new HashSet<String>();
				«FOR viewElemRef : textInputRefs»
					contentElements.add("«getName(viewElemRef)»");
				«ENDFOR»
				«FOR viewElemRef : checkBoxRefs»
					contentElements.add("«getName(viewElemRef)»");
				«ENDFOR»
				«FOR viewElemRef : contentRefs»
					contentElements.add("«getName(viewElemRef)»");
				«ENDFOR»
				return contentElements;
			}
			
			public Map<Integer, String> getContainerElements() {
				Map<Integer, String> containerElements = new HashMap<Integer, String>();
				«FOR viewElemRef : containerRefs»
					«val topLevelView = getViewOfGUIElement(topLevelViewContainers, viewElemRef)»
					«IF topLevelView != null»
						containerElements.put(R.id.«getName(viewElemRef)», "«getName(viewElemRef)»");
					«ENDIF»
				«ENDFOR»
				return containerElements;
			}
		
			public void registerSetViewEvents () {
				
				«FOR viewElemRef : textInputRefs»
					«val topLevelView = getViewOfGUIElement(topLevelViewContainers, viewElemRef)»
					«IF topLevelView != null»
						«val viewElemName = getName(viewElemRef)»
						«val eventName = getName(topLevelView).toFirstUpper + "_Activated"»
						«val eventHandlerName = eventName + "_" + classDef.simpleName + "_" + viewElemName»
						app.getEventBus().subscribe("«eventName»", "«eventHandlerName»", new MD2EventHandler() {
							
							@Override
							public void eventOccured() {
								«viewElemName» = (TextView)app.getActiveActivity().findViewById(R.id.«viewElemName»);
								app.getEventBus().unsubscribe("«eventName»", "«eventHandlerName»");
							}
							
						});
						
					«ENDIF»
				«ENDFOR»
				
				«FOR viewElemRef : checkBoxRefs»
					«val topLevelView = getViewOfGUIElement(topLevelViewContainers, viewElemRef)»
					«IF topLevelView != null»
						«val viewElemName = getName(viewElemRef)»
						«val eventName = getName(topLevelView).toFirstUpper + "_Activated"»
						«val eventHandlerName = eventName + "_" + classDef.simpleName + "_" + viewElemName»
						app.getEventBus().subscribe("«eventName»", "«eventHandlerName»", new MD2EventHandler() {
							
							@Override
							public void eventOccured() {
								«viewElemName» = (CheckBox)app.getActiveActivity().findViewById(R.id.«viewElemName»);
								app.getEventBus().unsubscribe("«eventName»", "«eventHandlerName»");
							}
							
						});
						
					«ENDIF»
				«ENDFOR»
				
				«FOR viewElemRef : containerRefs»
					«val topLevelView = getViewOfGUIElement(topLevelViewContainers, viewElemRef)»
					«IF topLevelView != null»
						«val viewElemName = getName(viewElemRef)»
						«val eventName = getName(topLevelView).toFirstUpper + "_Activated"»
						«val eventHandlerName = eventName + "_" + classDef.simpleName + "_" + viewElemName»
						app.getEventBus().subscribe("«eventName»", "«eventHandlerName»", new MD2EventHandler() {
							
							@Override
							public void eventOccured() {
								«viewElemName» = (ViewGroup)app.getActiveActivity().findViewById(R.id.«viewElemName»);
								app.getEventBus().unsubscribe("«eventName»", "«eventHandlerName»");
							}
							
						});
						
					«ENDIF»
				«ENDFOR»
				
				«FOR viewElemRef : contentRefs»
					«val topLevelView = getViewOfGUIElement(topLevelViewContainers, viewElemRef)»
					«IF topLevelView != null»
						«val viewElemName = getName(viewElemRef)»
						«val eventName = getName(topLevelView).toFirstUpper + "_Activated"»
						«val eventHandlerName = eventName + "_" + classDef.simpleName + "_" + viewElemName»
						app.getEventBus().subscribe("«eventName»", "«eventHandlerName»", new MD2EventHandler() {
							
							@Override
							public void eventOccured() {
								«viewElemName» = (View)app.getActiveActivity().findViewById(R.id.«viewElemName»);
								app.getEventBus().unsubscribe("«eventName»", "«eventHandlerName»");
							}
							
						});
						
					«ENDIF»
				«ENDFOR»
			}
			
			@Override
			public boolean checkCondition() {
				return «checkConditionBody»;
			}
		}
		
	'''
	def private String createCheckConditionBody(Condition condition) {
		val StringBuilder str = new StringBuilder
		var i = 0
		
		for(subCondition : condition.subConditions) {
			// Not operator
			if(condition.ops.size > i && condition.ops.get(i).equals("not")) {
				str.append("!")
				i = i + 1
			}
			
			// Conditional expression
			str.append("(")
			switch subCondition {
				Condition: {
					str.append(subCondition.createCheckConditionBody)
				}
				
				BooleanExpression: {
					if(subCondition.value.equals(Boolean::TRUE)) {
						str.append("true")
					}
					else {
						str.append("false")
					}
				}
				
				EqualsExpression: {
					if(subCondition.not) {
						str.append("!")
					}
					str.append("(")
					str.append(subCondition.createEqualsCondition)
					str.append(")")
				}
				
				GuiElementStateExpression: {
					if(subCondition.not) {
						str.append("!")
					}
					str.append("(")
					str.append(subCondition.createViewElementStateCondition)
					str.append(")")
				}
			}
			str.append(")")
			
			// and / or operator
			if(condition.ops.size > i) {
				switch condition.ops.get(i) {
					case "and": str.append(" && ")
					case "or": str.append(" || ")
				}
				i = i + 1
			}
		}
		str.toString
	}
	
	def private createEqualsCondition(EqualsExpression expression) {
		// Not null checks
		var prefix = ""
		
		// left operand is always an AbstractViewGuiElementRef
		{
			val referencedViewElem = resolveViewGUIElement(expression.eqLeft)
			if(!(referencedViewElem instanceof TextInput)) {
				return '''/* // TODO Handle equals condition for type «referencedViewElem.eClass.name» (ignore them?)'''
			}
			textInputRefs.add(referencedViewElem as TextInput)
			prefix = prefix + getName(resolveViewGUIElement(expression.eqLeft)) + " != null &&"
		}
		
		if(expression.eqRight instanceof AbstractViewGUIElementRef) {
			val referencedViewElem = resolveViewGUIElement(expression.eqRight as AbstractViewGUIElementRef)
			if(!(referencedViewElem instanceof TextInput)) {
				return '''/* // TODO Handle equals condition for type «referencedViewElem.eClass.name» (ignore them?)'''
			}
			textInputRefs.add(referencedViewElem as TextInput)
			if(prefix.length > 0) {
				prefix = prefix + " "
			}
			prefix = prefix + getName(resolveViewGUIElement(expression.eqRight as AbstractViewGUIElementRef)) + " != null &&"
		}
		
		// Actual condition
		if(expression.eqLeft instanceof IntVal || expression.eqRight instanceof IntVal ||
			expression.eqLeft instanceof FloatVal || expression.eqRight instanceof FloatVal) {
			// Number condition
			'''«prefix» «expression.eqLeft.createSimpleExpression» == «expression.eqRight.createSimpleExpression»'''
		}
		else {
			// String condition
			'''«prefix» «expression.eqLeft.createSimpleExpression».equals(«expression.eqRight.createSimpleExpression»)'''
		}
	}
	
	def private dispatch createSimpleExpression(StringVal expression)
		'''"«expression.value»"'''
	
	def private dispatch createSimpleExpression(IntVal expression)
		'''«expression.value»'''
	
	def private dispatch createSimpleExpression(FloatVal expression)
		'''«expression.value»'''
	
	def private dispatch createSimpleExpression(AbstractViewGUIElementRef expression)
		'''«getName(resolveViewGUIElement(expression))».getText().toString()'''
	
	def private createViewElementStateCondition(GuiElementStateExpression expression) {
		val viewElem = resolveViewGUIElement(expression.reference)
		val name = getName(viewElem)
		
		// Not null checks
		var prefix = name + " != null &&"
		
		switch expression.isState
		{
			case VALID: {
				if(viewElem instanceof ContainerElement) {
					containerRefs.add(viewElem as ContainerElement)
					'''«prefix» checkValidity((ViewGroup)«getName(viewElem)»)'''
				}
				else {
					if(viewElem instanceof TextInput) {
						textInputRefs.add(viewElem as TextInput)
					}
					else if (viewElem instanceof CheckBox) {
						checkBoxRefs.add(viewElem as CheckBox)
					}
					else {
						contentRefs.add(viewElem as ContentElement)
					}
					'''«prefix» checkValidity(«getName(viewElem)».getId())'''
				}
			}
			case EMPTY: {
				if(viewElem instanceof TextInput) {
					textInputRefs.add(viewElem as TextInput)
					'''«prefix» «name».getText().length() == 0'''
				}
				else {
					'''// TODO Handle Empty check for type «viewElem.eClass.name» (ignore them?)'''
				}
			}
			case CHECKED: {
				if(viewElem instanceof CheckBox) {
					checkBoxRefs.add(viewElem as CheckBox)
					'''«prefix» «name».getText().isChecked()'''
				}
				else {
					'''// TODO Handle Checked check for type «viewElem.eClass.name» (ignore them?)'''
				}
			}
			case FILLED: {
				if(viewElem instanceof TextInput) {
					textInputRefs.add(viewElem as TextInput)
					'''«prefix» «name».getText().length() != 0'''
				}
				else {
					'''// TODO Handle Filled check for type «viewElem.eClass.name» (ignore them?)'''
				}
			}
		}
	}

}