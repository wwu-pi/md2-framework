package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
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
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ConcatenatedString
import de.wwu.md2.framework.mD2.ContentProviderPathDefinition
import de.wwu.md2.framework.mD2.DateInput
import de.wwu.md2.framework.mD2.DateTimeInput
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.EntitySelector
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.LocationProvider
import de.wwu.md2.framework.mD2.MathExpression
import de.wwu.md2.framework.mD2.NumberInput
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TimeInput
import de.wwu.md2.framework.mD2.TimeType
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.WhereClauseAnd
import de.wwu.md2.framework.mD2.WhereClauseCompareExpression
import de.wwu.md2.framework.mD2.WhereClauseCondition
import de.wwu.md2.framework.mD2.WhereClauseNot
import de.wwu.md2.framework.mD2.WhereClauseOr

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.DateISOFormatter.*

class ManifestJson {
	
	def static generateManifestJson(DataContainer dataContainer) '''
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
													"query": «contentProvider.whereClause.buildContentProviderQuery»,
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
										"«attribute.attributeDataType» «attribute.name»": «attribute.attributeDefaultValue»
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
	def private static String buildContentProviderQuery(WhereClauseCondition condition) {
		
		switch (condition) {
			WhereClauseOr: '''
				{
					$or: [
						«IF condition.leftExpression instanceof WhereClauseCompareExpression»
							{ «buildContentProviderQuery(condition.leftExpression)» },
						«ELSE»
							«buildContentProviderQuery(condition.leftExpression)»,
						«ENDIF»
						«IF condition.rightExpression instanceof WhereClauseCompareExpression»
							{ «buildContentProviderQuery(condition.rightExpression)» }
						«ELSE»
							«buildContentProviderQuery(condition.rightExpression)»
						«ENDIF»
					]
				}'''
			WhereClauseAnd: '''
				{
					«buildContentProviderQuery(condition.leftExpression)»,
					«buildContentProviderQuery(condition.rightExpression)»
				}'''
			WhereClauseNot: '''
				{
					$not: «buildContentProviderQuery(condition.expression)»
				}'''
			WhereClauseCompareExpression: {
				val simpleExpression = condition.eqRight.resolveSimpleExpression
				val attribute = getPathTailAsString(condition.eqLeft.tail)
				val rightHand = switch condition.op {
					case Operator::EQUALS: '''«simpleExpression»'''
					case Operator::GREATER: '''{ $gt: «simpleExpression» }'''
					case Operator::SMALLER: '''{ $lt: «simpleExpression» }'''
					case Operator::GREATER_OR_EQUAL: '''{ $gte: «simpleExpression» }'''
					case Operator::SMALLER_OR_EQUAL: '''{ $lte: «simpleExpression» }'''
				}
				'''«attribute»: «rightHand»'''
			}
		}
	}
	
	def private static resolveSimpleExpression(SimpleExpression expression) {
		switch (expression) {
			StringVal: '''"«expression.value»"'''
			IntVal: '''«expression.value»'''
			FloatVal: '''«expression.value»'''
			BooleanVal: '''«expression.value.toString»'''
			DateVal: '''"«expression.value.toISODate»"'''
			TimeVal: '''"«expression.value.toISOTime»"'''
			DateTimeVal: '''"«expression.value.toISODateTime»"'''
			AbstractViewGUIElementRef: '''"@«getName(expression.ref)»"'''
			ConcatenatedString: '''//TODO'''
			ContentProviderPathDefinition: '''//TODO'''
			LocationProvider: '''//TODO'''
			MathExpression: '''//TODO'''
		}
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
	
	def private static getAttributeDataType(Attribute attribute) {
		val type = attribute.type
		switch (type) {
			ReferencedType: '''«type.entity.name»'''
			IntegerType: '''integer'''
			FloatType: '''float'''
			StringType: '''string'''
			BooleanType: '''boolean'''
			DateType: '''date'''
			TimeType: '''time'''
			DateTimeType: '''datetime'''
			EnumType: '''string'''
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
			«FOR element : gridLayout.elements.filter(typeof(ViewGUIElement)) SEPARATOR ","»
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
		"datatype": "string",
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
		"datatype": "boolean",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(TextInput input) '''
		"type": "textbox",
		"datatype": "string",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(IntegerInput input) '''
		"type": "numberspinner",
		"datatype": "integer",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(NumberInput input) '''
		"type": "numbertextbox",
		"datatype": "float",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(DateInput input) '''
		"type": "datetextbox",
		"datatype": "date",
		"field": "«getName(input)»",
		"cellStyle": {
			"width": "«input.width»%"
		}
	'''
	
	def private static dispatch getViewElement(TimeInput input) '''
		"type": "timetextbox",
		"datatype": "time",
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