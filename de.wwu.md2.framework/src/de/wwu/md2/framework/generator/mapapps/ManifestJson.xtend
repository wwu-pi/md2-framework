package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.AttrBooleanDefault
import de.wwu.md2.framework.mD2.AttrDateDefault
import de.wwu.md2.framework.mD2.AttrDateTimeDefault
import de.wwu.md2.framework.mD2.AttrEnumDefault
import de.wwu.md2.framework.mD2.AttrFloatDefault
import de.wwu.md2.framework.mD2.AttrIntDefault
import de.wwu.md2.framework.mD2.AttrStringDefault
import de.wwu.md2.framework.mD2.AttrTimeDefault
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.BooleanInput
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.DateInput
import de.wwu.md2.framework.mD2.DateTimeInput
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.EntitySelector
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.NumberInput
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TimeInput
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewElementDef
import java.util.Collection

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.WhereClauseCondition
import de.wwu.md2.framework.mD2.AttributeEqualsExpression

class ManifestJson {
	
	def static generateManifestJson(DataContainer dataContainer, Collection<String> requiredBundles) '''
		{
			"Bundle-SymbolicName": "md2_«dataContainer.createAppName.toString.toFirstLower»",
			"Bundle-Version": "«dataContainer.main.appVersion»",
			"Bundle-Name": "«dataContainer.main.appName»",
			"Bundle-Localization": [],
			"Bundle-Main": "",
			"Require-Bundle": [],
			"Components": [{
					"name": "MD2«dataContainer.createAppName»",
					"impl": "ct/Stateful",
					"provides": ["md2.app.AppDefinition"],
					"propertiesConstructor": true,
					"properties": {
						"windowTitle": "«dataContainer.main.appName»",
						"serviceUri": "«dataContainer.main.defaultConnection.uri»",
						"onInitialized": "«dataContainer.main.onInitializedEvent.name»",
						"contentProviders": [
							«FOR contentProvider : dataContainer.contentProviders SEPARATOR ","»
								{
									"name": "«contentProvider.name»",
									"configuration": {
										"entity": "«(contentProvider.type as ReferencedModelType).entity.name»",
										«IF !contentProvider.local»
											"serviceUri": "«contentProvider.connection.uri»",
										«ENDIF»
										«IF contentProvider.filter»
											"filter": {
												«IF contentProvider.whereClause != null»
													"query": {
														"customerId": { "$lt": 50 },
														"firstName": "@startView$outerPanel$firstName"
													},
												«ENDIF»
												"count": "«contentProvider.filterType.toString»"
											},
										«ENDIF»
										"type": "«if (contentProvider.local) "local" else "remote"»"
									}
								}
							«ENDFOR»
						],
						"entities": {
							«FOR entity : dataContainer.entities SEPARATOR ","»
								"«entity.name»": {
									«FOR attribute : entity.attributes SEPARATOR ","»
										"«attribute.name»": «attribute.attributeDefaultValue»
									«ENDFOR»
								}
							«ENDFOR»
						},
						"views": [
							«FOR view : dataContainer.rootViewContainers SEPARATOR ","»
								{
									"name": "«view.name»",
									"dataForm": {
										"dataform-version": "1.0.0",
										"size": {
											"h": 200,
											"w": 500
										},
										«getViewElement(view)»
									}
								}
							«ENDFOR»
						]
					}
				},
				«FOR customAction : dataContainer.customActions SEPARATOR ","»
					{
						"name": "«customAction.name.toFirstUpper»",
						"impl": "./actions/«customAction.name.toFirstUpper»",
						"provides": ["md2.app.CustomAction"]
					}
				«ENDFOR»
			]
		}
	'''
	
	/**
	 * Creates a query in MongoDB syntax from specified whereCondition in MD2.
	 */
	def private static buildContentProviderQuery(WhereClauseCondition condition) {
		
		val str = new StringBuilder
		var opsPosition = 0
		
		for(subCondition : condition.subConditions) {
			
			val conditionalExpression = subCondition.condition
			
			// has not operator?
			if (subCondition.not) {
				str.append("!")
			}
			
			// sub condition
			switch (conditionalExpression) {
				AttributeEqualsExpression: {
					val op = conditionalExpression.op
					var opString = switch op {
						case Operator::EQUALS: "="
						case Operator::GREATER: ">"
						case Operator::SMALLER: "<"
						case Operator::GREATER_OR_EQUAL: ">="
						case Operator::SMALLER_OR_EQUAL: "<="
					}
					str.append("(")
					str.append(getPathTailAsString(conditionalExpression.eqLeft.tail))
					str.append(opString)
					str.append(getSimpleExpression(conditionalExpression.eqRight, resolveFieldContentStrategy))
					str.append(")")
				}
				WhereClauseCondition: {
					str.append("(")
					str.append(generateLocalFilterString(conditionalExpression, resolveFieldContentStrategy))
					str.append(")")
				}
			}
			str.append(" ")
			
			// operator
			if (opsPosition < cond.ops.size) {
				str.append(cond.ops.get(opsPosition).toString + " ")
				opsPosition = opsPosition + 1
			}
		}
		
		return str.toString.trim
	}
	
	/**
	 * Get a string representation of the default value for each attribute
	 */
	def private static getAttributeDefaultValue(Attribute attribute) {
		val type = attribute.type
		switch (type) {
			ReferencedType: {
				'''null'''
			}
			IntegerType: {
				val defaultValue = type.params.filter(typeof(AttrIntDefault)).head
				if (defaultValue != null) '''«defaultValue.value»''' else '''null'''
			}
			FloatType: {
				val defaultValue = type.params.filter(typeof(AttrFloatDefault)).head
				if (defaultValue != null) '''«defaultValue.value»''' else '''null'''
			}
			StringType: {
				val defaultValue = type.params.filter(typeof(AttrStringDefault)).head
				if (defaultValue != null) '''"«defaultValue.value»"''' else '''null'''
			}
			BooleanType: {
				val defaultValue = type.params.filter(typeof(AttrBooleanDefault)).head
				if (defaultValue != null) '''«defaultValue.value.toString»''' else '''false'''
			}
			DateType: {
				val defaultValue = type.params.filter(typeof(AttrDateDefault)).head
				if (defaultValue != null) '''"«defaultValue.value»"''' else '''null'''
			}
			TimeType: {
				val defaultValue = type.params.filter(typeof(AttrTimeDefault)).head
				if (defaultValue != null) '''"«defaultValue.value»"''' else '''null'''
			}
			DateTimeType: {
				val defaultValue = type.params.filter(typeof(AttrDateTimeDefault)).head
				if (defaultValue != null) '''"«defaultValue.value»"''' else '''null'''
			}
			EnumType: {
				val defaultValue = type.params.filter(typeof(AttrEnumDefault)).head
				if (defaultValue != null) '''"«defaultValue.value»"''' else '''null'''
			}
		}
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// Dispatch: All ViewGUIElements
	////////////////////////////////////////////////////////////////////////////////////////////
	
	
	/***************************************************************
	 * Container Elements
	 ***************************************************************/
	
	def private static dispatch getViewElement(GridLayoutPane gridLayout) '''
		"type": "md2gridpanel",
		"cols": "«gridLayout.params.filter(typeof(GridLayoutPaneColumnsParam)).head.value»",
		"children": [
			«FOR element : gridLayout.elements.filter(typeof(ViewElementDef)).map(e | e.value) SEPARATOR ","»
				{
					«getViewElement(element)»
				}
			«ENDFOR»
		]
	'''
	
	def private static dispatch getViewElement(TabbedAlternativesPane tabbedPane) '''
		// TODO
	'''
	
	/**
	 * TODO If there is a warning "Cannot infer type from recursive usage. Type 'Object' is used.", this is related to
	 *      Eclipse Bug 404817 (https://bugs.eclipse.org/bugs/show_bug.cgi?id=404817).
	 *      This todo can be removed when the bug is fixed!
	 */
	def private static dispatch getViewElement(AlternativesPane alternativesPane) '''
		// TODO
	'''
	
	
	/***************************************************************
	 * Content Elements => Various
	 ***************************************************************/
	 
	 def private static dispatch getViewElement(Image image) '''
		// TODO
	'''
	
	def private static dispatch getViewElement(Spacer spacer) '''
		"type": "spacer",
		"cellStyle": {
			"width": "«spacer.width»%"
		}
	'''
	
	def private static dispatch getViewElement(Button button) '''
		"type": "button",
		"title": "«button.text»",
		"field": "«getName(button)»",
		"cellStyle": {
			"width": "«button.width»%"
		}
	'''
	
	def private static dispatch getViewElement(Label label) '''
		"type": "textoutput",
		"field": "«getName(label)»",
		"defaultText": "«label.text»",
		"cellStyle": {
			"width": "«label.width»%"
		}
	'''
	
	def private static dispatch getViewElement(Tooltip tooltip) '''
		// TODO
	'''
	
	
	/***************************************************************
	 * Content Elements => Input
	 ***************************************************************/
	
	def private static dispatch getViewElement(BooleanInput input) '''
		"type": "checkbox",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(TextInput input) '''
		"type": "textbox",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(IntegerInput input) '''
		"type": "numberspinner",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(NumberInput input) '''
		"type": "numbertextbox",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(DateInput input) '''
		"type": "datetextbox",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(TimeInput input) '''
		"type": "timetextbox",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(DateTimeInput input) '''
		// TODO
	'''
	
	def private static dispatch getViewElement(OptionInput input) '''
		"type": "selectbox",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(EntitySelector input) '''
		// TODO
	'''
	
}