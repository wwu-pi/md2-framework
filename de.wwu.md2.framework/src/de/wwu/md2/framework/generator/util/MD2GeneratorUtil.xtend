package de.wwu.md2.framework.generator.util

import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.Action
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.AttributeEqualsExpression
import de.wwu.md2.framework.mD2.BooleanExpression
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.CombinedAction
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentProviderPathDefinition
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.EntityPathDefinition
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.Main
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.PathDefinition
import de.wwu.md2.framework.mD2.PathTail
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.SimpleType
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TabTitleParam
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.WhereClauseCondition
import java.util.Collection
import java.util.HashMap
import java.util.LinkedList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.IQualifiedNameProvider

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class MD2GeneratorUtil {
		
	private static IQualifiedNameProvider qualifiedNameProvider
	private static HashMap<String, String> qualifiedNameToNameMapping
	private static int anonymousNameCounter = 0
	
	/**
	 * Get the base package name of the current project.
	 */
	def static getBasePackageName(ResourceSet input) {
		val model = input.resources.map(r|r.allContents.toIterable.filter(typeof(MD2Model))).flatten.last
		var packageName = model.getPackage().pkgName;
		switch model.modelLayer {
			// Xtend resolves runtime argument type for modelLayer
			View : packageName.substring(0, packageName.indexOf(".view") )
			Model : packageName.substring(0, packageName.indexOf(".model"))
			Controller : packageName.substring(0, packageName.indexOf(".controller"))
		}
	}
	
	/**
	 * Creates a camelCase string from the app name declared in the main block of the app.
	 */
	def static createAppName(DataContainer dataContainer) '''«FOR part : dataContainer.main.appName.split(" ")»«part.toFirstUpper»«ENDFOR»'''
	
	def static createAppClassName(DataContainer dataContainer) {
		createAppName(dataContainer) + "Application"
	}
	
	/**
	 * Returns the name of the given EObject. In case that there is a second EObject with the
	 * same name in another scope (the element has another fully qualified name), the name is extended
	 * by a number.
	 * 
	 * If obj is null, the result of this method is null
	 */
	def static getName(EObject obj) {
		
		if(obj == null) return null
		if(obj instanceof AbstractViewGUIElementRef) System::err.println("Unwanted behavior: Name resolver was invoked with AbstractViewGUIElementRef instead of ViewGUIElement.")
		
		if(qualifiedNameProvider == null) qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider()
		if(qualifiedNameToNameMapping == null) qualifiedNameToNameMapping = newHashMap
		
		var name = obj.getClass.getMethod("getName").invoke(obj) as String
		val qualifiedName = qualifiedNameProvider.getFullyQualifiedName(obj).toString
		
		if(!qualifiedNameToNameMapping.containsKey(qualifiedName)) {
			var int i = 0
			while(qualifiedNameToNameMapping.containsValue(name + if(i != 0) i else "")) {
				i = i + 1
			}
			qualifiedNameToNameMapping.put(qualifiedName, name + if(i != 0) i else "")
		}
		
		qualifiedNameToNameMapping.get(qualifiedName)
	}
	
	/**
	 * Creates an anonymous ID that can be used for elements that expect an ID in the target
	 * source code, but do not have any name in the MD2 language
	 */
	def static getAnonymousName() {
		anonymousNameCounter = anonymousNameCounter + 1
		"__anonymousName" + anonymousNameCounter
	}
	
	/**
	 * Takes a list of all views and a GUI element.
	 * Returns the view to which the given guiElement belongs.
	 */
	def static getViewOfGUIElement(Collection<ContainerElement> views, ViewGUIElement guiElement) {
		var EObject obj = guiElement
		while(!views.contains(obj) && obj != null) { obj = obj.eContainer }
		obj as ContainerElement
	}
	
	def static Attribute getReferencedAttribute(PathDefinition pathDefinition) {
		val PathTail lastPathTail = getLastPathTail(pathDefinition)
		if (lastPathTail == null) throw new IllegalArgumentException("Missing Attribute in PathDefinition")
		lastPathTail.attributeRef
	}
	
	def static PathTail getLastPathTail(PathDefinition pathDefinition) {
		var PathTail lastPathTail = pathDefinition.getTail()
		while (lastPathTail?.getTail() != null) {
			lastPathTail = lastPathTail.getTail()
		}
		lastPathTail
	}
	
	def static equals(PathDefinition p1, PathDefinition p2) {
		if (p1 == p2) return true
		if (p1 == null || p2 == null) return false
		if (p1 instanceof ContentProviderPathDefinition && p2 instanceof ContentProviderPathDefinition) {
			val contentProvider1 = (p1 as ContentProviderPathDefinition).contentProviderRef
			val contentProvider2 = (p2 as ContentProviderPathDefinition).contentProviderRef
			if (contentProvider1.type instanceof SimpleType || contentProvider2.type instanceof SimpleType) {
				return contentProvider2.type == contentProvider2.type
			}
		}		
		var ModelElement model1
		var ModelElement model2
		if (p1 instanceof EntityPathDefinition) {
			model1 = (p1 as EntityPathDefinition).entityRef
		} else if (p1 instanceof ContentProviderPathDefinition) {
			model1 = ((p1 as ContentProviderPathDefinition).contentProviderRef.type as ReferencedModelType).entity
		}
		if (p2 instanceof EntityPathDefinition) {
			model2 = (p2 as EntityPathDefinition).entityRef
		} else if (p2 instanceof ContentProviderPathDefinition) {
			model2 = ((p2 as ContentProviderPathDefinition).contentProviderRef.type as ReferencedModelType).entity
		}
		if (model1 != model2) return false
		var tail1 = p1.tail
		var tail2 = p2.tail		
		while (true) {
			if (tail1 == null && tail2 == null) return true
			if (tail1 == null || tail2 == null) return false
			if (tail1.attributeRef != tail2.attributeRef) return false
			tail1 = tail1.tail
			tail2 = tail2.tail			
		}
	}
	
	/**
	 * Recursive: Formats the path tail as a dot-separated string
	 */
	def static String getPathTailAsString(PathTail pathTail) {
		if(pathTail == null) return ""
		pathTail.attributeRef.name + if(pathTail.tail != null) '''.«getPathTailAsString(pathTail.tail)»'''.toString else ""
	}
	
	def static List<Attribute> getPathTailAsList(PathTail pathTail) {
		val result = new LinkedList<Attribute>
		var part = pathTail
		while (part != null) {
			result.add(part.attributeRef)
			part = part.tail
		}
		return result
	}

	// Relies on simplified AbstractViewGUIElementRef from Preprocessing
	def static ViewGUIElement resolveViewGUIElement(AbstractViewGUIElementRef abstractRef) {
		if (abstractRef == null) return null
		// @TODO Implement some checking and error handling
		return abstractRef.ref as ViewGUIElement
	}

	def static ContainerElement resolveContainerElement(AbstractViewGUIElementRef abstractRef) {
		if (abstractRef == null) return null
		// @TODO Implement some checking and error handling
		return abstractRef.ref as ContainerElement
	}

	def static ContainerElement resolveElementContainerElement(AbstractViewGUIElementRef abstractRef) {
		if (abstractRef == null) return null
		// @TODO Implement some checking and error handling
		return abstractRef.ref as ContainerElement
	}
	
	def static isCalledAtStartup(CustomCodeFragment codeFragment) {
		if ((codeFragment.eContainer as CustomAction).name == PreprocessModel::autoGenerationActionName) return true		
		val Action startupAction = codeFragment.eResource.allContents.filter(typeof(Main)).last.onInitializedEvent
		if (startupAction == null) return false
		return traverseAction(startupAction).filter(typeof(CustomAction)).exists(customAction | customAction.codeFragments.contains(codeFragment))
	}
	
	def static Iterable<Action> traverseAction(Action action) {
		val hashSet = newHashSet(action)
		hashSet.addAll(switch (action) {
			CombinedAction: action.actions.map([traverseAction(it)]).flatten
			CustomAction: action.codeFragments.filter(typeof(CallTask)).map([it.action]).filter(typeof(ActionReference)).map([traverseAction(it.actionRef)]).flatten			
		})
		return hashSet
	}
	
	def static getTabName(ContainerElement container) {
		val param = switch container {
			AlternativesPane: container.params
			GridLayoutPane: container.params
			FlowLayoutPane: container.params
		}.filter([it instanceof TabTitleParam]).head
		if (param != null) (param as TabTitleParam).tabTitle else container.name.toFirstUpper
	}
	
	def static String generateRemoteFilterString(WhereClauseCondition cond, (ViewGUIElement)=>String resolveFieldContentStrategy)
	{
		if (cond == null)
			return null;
		val StringBuilder str = new StringBuilder
		var opsPosition = 0
		
		if(opsPosition < cond.ops.size && cond.ops.get(opsPosition).equals("not"))
		{
			str.append("not ")
			opsPosition = opsPosition + 1
		}
		
		for(subCondition : cond.subConditions)
		{
			// sub condition
			switch (subCondition)
			{
				BooleanExpression: str.append(subCondition.value)
				AttributeEqualsExpression: str.append(getPathTailAsString(subCondition.eqLeft.tail) + " " + subCondition.op.literal + " " + getSimpleExpression(subCondition.eqRight, resolveFieldContentStrategy))
				default: str.append("(" + generateRemoteFilterString(subCondition, resolveFieldContentStrategy) + ")")
			}
			str.append(" ")
			
			// operator
			if(opsPosition < cond.ops.size)
			{
				str.append(cond.ops.get(opsPosition) + " ")
				opsPosition = opsPosition + 1
				
				if(opsPosition < cond.ops.size && cond.ops.get(opsPosition).equals("not"))
				{
					str.append("not ")
					opsPosition = opsPosition + 1
				}
			}
		}
		str.toString.trim
	}
	
	def static generateLocalFilterString(WhereClauseCondition cond, (ViewGUIElement)=>String resolveFieldContentStrategy)
	{
		if (cond == null)
			return null;
		val StringBuilder str = new StringBuilder
		var opsPosition = 0
		
		if(opsPosition < cond.ops.size && cond.ops.get(opsPosition).equals("!"))
		{
			str.append("! ")
			opsPosition = opsPosition + 1
		}
		
		for(subCondition : cond.subConditions)
		{
			// sub condition
			switch (subCondition)
			{
				BooleanExpression: str.append(subCondition.value)
				AttributeEqualsExpression:
				{
					val op = subCondition.op
					var String opString
					switch op
					{
						case Operator::EQUALS: opString = "="
						case Operator::GREATER: opString = ">"
						case Operator::SMALLER: opString = "<"
						case Operator::GREATER_OR_EQUAL: opString = ">="
						case Operator::SMALLER_OR_EQUAL: opString = "<="
					}
					str.append(getPathTailAsString(subCondition.eqLeft.tail) + opString + getSimpleExpression(subCondition.eqRight, resolveFieldContentStrategy))
				}
				default: str.append("(" + generateRemoteFilterString(subCondition, resolveFieldContentStrategy) + ")")
			}
			str.append(" ")
			
			// operator
			if(opsPosition < cond.ops.size)
			{
				str.append(cond.ops.get(opsPosition) + " ")
				opsPosition = opsPosition + 1
				
				if(opsPosition < cond.ops.size && cond.ops.get(opsPosition).equals("!"))
				{
					str.append("! ")
					opsPosition = opsPosition + 1
				}
			}
		}
		str.toString.trim
	}
	
	def private static getSimpleExpression(SimpleExpression expr, (ViewGUIElement)=>String resolveFieldContentStrategy)
	{
		switch expr
		{
			StringVal: "'" + expr.value + "'"
			IntVal: expr.value.toString
			FloatVal: expr.value.toString
			AbstractViewGUIElementRef: resolveFieldContentStrategy.apply(resolveViewGUIElement(expr))
		}
	}
}