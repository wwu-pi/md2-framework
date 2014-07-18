package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.AlternativesPane
import de.wwu.md2.framework.mD2.BooleanInput
import de.wwu.md2.framework.mD2.BooleanVal
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ConcatenatedString
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.DateInput
import de.wwu.md2.framework.mD2.DateTimeInput
import de.wwu.md2.framework.mD2.DateTimeVal
import de.wwu.md2.framework.mD2.DateVal
import de.wwu.md2.framework.mD2.EntitySelector
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPaneColumnsParam
import de.wwu.md2.framework.mD2.HexColorDef
import de.wwu.md2.framework.mD2.Image
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.IntegerInput
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.LocationProviderPath
import de.wwu.md2.framework.mD2.NumberInput
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.Spacer
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.StyleAssignment
import de.wwu.md2.framework.mD2.StyleDefinition
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.TimeInput
import de.wwu.md2.framework.mD2.TimeVal
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.WhereClauseAnd
import de.wwu.md2.framework.mD2.WhereClauseCompareExpression
import de.wwu.md2.framework.mD2.WhereClauseCondition
import de.wwu.md2.framework.mD2.WhereClauseNot
import de.wwu.md2.framework.mD2.WhereClauseOr
import de.wwu.md2.framework.mD2.WidthParam
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.xbase.lib.Pair

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.DateISOFormatter.*
import static extension de.wwu.md2.framework.util.StringExtensions.*

class ManifestJson {
	
	def static generateManifestJson(DataContainer dataContainer, ResourceSet processedInput) '''
		{
			"Bundle-SymbolicName": "md2_«processedInput.getBasePackageName.split("\\.").reduce[ s1, s2 | s1 + "_" + s2]»",
			"Bundle-Version": "«dataContainer.main.appVersion»",
			"Bundle-Name": "Generated MD2 bundle: «dataContainer.main.appName»",
			"Bundle-Localization": [],
			"Bundle-Main": "",
			"Require-Bundle": [],
			"Components": [
				«val snippets = newArrayList(
					generateConfigurationSnippet(dataContainer, processedInput),
					generateCustomActionsSnippet(dataContainer),
					generateEntitiesSnippet(dataContainer)
				)»
				«FOR snippet : snippets.filter(s | !s.toString.trim.empty) SEPARATOR ","»
					«snippet»
				«ENDFOR»
			]
		}
	'''
	
	def private static String generateConfigurationSnippet(DataContainer dataContainer, ResourceSet processedInput) '''
		{
			"name": "MD2«processedInput.getBasePackageName.split("\\.").last.toFirstUpper»",
			"impl": "ct/Stateful",
			"provides": ["md2.app.AppDefinition"],
			"propertiesConstructor": true,
			"properties": {
				"windowTitle": "«dataContainer.main.appName»",
				"serviceUri": «dataContainer.main.defaultConnection?.uri.quotify ?: "null"»,
				"onInitialized": "«dataContainer.main.onInitializedEvent.name»",
				"contentProviders": [
					«FOR contentProvider : dataContainer.contentProviders SEPARATOR ","»
						{
							"name": "«contentProvider.name»",
							"configuration": {
								"entityName": "«(contentProvider.type as ReferencedModelType).entity.name»",
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
								"type": "«IF contentProvider.local»local«ELSE»remote«ENDIF»"
							}
						}
					«ENDFOR»
				],
				"views": [
					«FOR view : dataContainer.rootViewContainers SEPARATOR ","»
						{
							"name": "«view.name»",
							"dataForm": {
								"dataform-version": "1.0.0",
								"size": {
									"h": "400",
									"w": "550"
								},
								«getViewElement(view)»
							}
						}
					«ENDFOR»
				]
			}
		}
	'''
	
	def static generateCustomActionsSnippet(DataContainer dataContainer) '''
		«FOR customAction : dataContainer.customActions SEPARATOR ","»
			{
				"name": "«customAction.name.toFirstUpper»",
				"impl": "./actions/«customAction.name.toFirstUpper»",
				"provides": ["md2.app.CustomAction"]
			}
		«ENDFOR»
	'''
	
	def static generateEntitiesSnippet(DataContainer dataContainer) '''
		«FOR entity : dataContainer.entities SEPARATOR ","»
			{
				"name": "«entity.name.toFirstUpper»",
				"impl": "./entities/«entity.name.toFirstUpper»",
				"provides": ["md2.app.Entity"]
			}
		«ENDFOR»
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
			ContentProviderPath: '''//TODO'''
			LocationProviderPath: '''//TODO'''
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
		"valueClass": "layoutCell",
		«generateStyle(null, "width" -> '''«gridLayout.params.filter(typeof(WidthParam)).head.width»%''')»,
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
		«generateStyle(null, "width" -> '''«spacer.width»%''')»
	'''
	
	def private static dispatch getViewElement(Button button) '''
		"type": "button",
		"title": "«button.text.escape»",
		"field": "«getName(button)»",
		«generateStyle(button.style, "width" -> '''«button.width»%''')»
	'''
	
	def private static dispatch getViewElement(Label label) '''
		"type": "textoutput",
		"datatype": "string",
		"field": "«getName(label)»",
		"defaultText": "«label.text.escape»",
		«generateStyle(label.style, "width" -> '''«label.width»%''')»
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
		«generateStyle(null, "width" -> '''«input.width»%''')»
	'''
	
	def private static dispatch getViewElement(TextInput input) '''
		"type": "textbox",
		"datatype": "string",
		"field": "«getName(input)»",
		«generateStyle(null, "width" -> '''«input.width»%''')»
	'''
	
	def private static dispatch getViewElement(IntegerInput input) '''
		"type": "numberspinner",
		"datatype": "integer",
		"field": "«getName(input)»",
		«generateStyle(null, "width" -> '''«input.width»%''')»
	'''
	
	def private static dispatch getViewElement(NumberInput input) '''
		"type": "numbertextbox",
		"datatype": "float",
		"field": "«getName(input)»",
		«generateStyle(null, "width" -> '''«input.width»%''')»
	'''
	
	def private static dispatch getViewElement(DateInput input) '''
		"type": "datetextbox",
		"datatype": "date",
		"field": "«getName(input)»",
		«generateStyle(null, "width" -> '''«input.width»%''')»
	'''
	
	def private static dispatch getViewElement(TimeInput input) '''
		"type": "timetextbox",
		"datatype": "time",
		"field": "«getName(input)»",
		«generateStyle(null, "width" -> '''«input.width»%''')»
	'''
	
	def private static dispatch getViewElement(DateTimeInput input) '''
		// TODO
	'''
	
	def private static dispatch getViewElement(OptionInput input) '''
		"type": "selectbox",
		"field": "«getName(input)»",
		«generateStyle(null, "width" -> '''«input.width»%''')»
	'''
	
	def private static dispatch getViewElement(EntitySelector input) '''
		// TODO
	'''
	
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// Generate Styles
	////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static generateStyle(StyleAssignment styleAssignment, Pair<String, String>... additionalValues) {
		
		val values = newArrayList(additionalValues)
		
		// all style references were replaced by the actual definitions during pre-processing
		val style = (styleAssignment as StyleDefinition)?.definition
		
		if (style != null && style.bold) {
			values.add("font-weight" -> "bold")
		}
		
		if (style != null && style.italic) {
			values.add("font-style" -> "italic")
		}
		
		if (style?.color != null) {
			// after pre-processing all colors are in hex format
			values.add("color" -> (style.color as HexColorDef).color)
		}
		
		if (style != null && style.fontSize != 0d) {
			values.add("font-size" -> '''«style.fontSize»em''')
		}
		
		'''
			"cellStyle": {
				«FOR value : values SEPARATOR ","»
					"«value.key»": "«value.value»"
				«ENDFOR»
			}
		'''
	}
	
}