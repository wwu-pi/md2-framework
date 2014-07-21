package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.WhereClauseAnd
import de.wwu.md2.framework.mD2.WhereClauseCompareExpression
import de.wwu.md2.framework.mD2.WhereClauseCondition
import de.wwu.md2.framework.mD2.WhereClauseNot
import de.wwu.md2.framework.mD2.WhereClauseOr
import java.util.LinkedHashMap
import org.eclipse.emf.ecore.resource.ResourceSet

import static de.wwu.md2.framework.generator.mapapps.Expressions.*

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class ContentProviderClass {
	
	def static generateContentProvider(ContentProvider contentProvider, ResourceSet processedInput) '''
		define([
			"dojo/_base/declare",
			"../../md2_runtime/contentprovider/ContentProvider"
		],
		function(declare, ContentProvider) {
			
			/**
			 * ContentProvider Factory
			 */
			return declare([], {
				
				create: function(typeFactory, $) {
					
					«IF contentProvider.local»
						«generateLocalBody(contentProvider)»
					«ELSE»
						«generateRemoteBody(contentProvider)»
					«ENDIF»
					var appId = "md2_«processedInput.getBasePackageName.replace(".", "_")»";
					
					«IF contentProvider.filter»
						var filter = function() {
							this.$ = $;
							«IF contentProvider.whereClause != null»
								«val expressionVars = newLinkedHashMap»
								«val query = contentProvider.whereClause.buildContentProviderQuery(expressionVars)»
								
								«FOR expressionVar : expressionVars.keySet»
									var «expressionVar» = «expressionVars.get(expressionVar)»;
								«ENDFOR»
								return {
									query: {
										«query»
									},
									"count": "«contentProvider.filterType.toString»"
								};
							«ELSE»
								return {
									"count": "«contentProvider.filterType.toString»"
								};
							«ENDIF»
						};
					«ENDIF»
					
					return new ContentProvider("«contentProvider.name.toFirstLower»", appId, store, «IF contentProvider.type.many»true«ELSE»false«ENDIF»«IF contentProvider.filter», filter«ENDIF»);
				}
				
			});
		});
	'''
	
	def static generateRemoteBody(ContentProvider contentProvider) '''
		if (!this._remoteFactory) {
			throw new Error("[«contentProvider.name.toFirstUpper»] No store factory of type 'remote' found! "
					+ "Check whether bundle is missing.");
		}
		
		var properties = this._properties;
		var entityFactory = typeFactory.getEntityFactory("«(contentProvider.type as ReferencedModelType).entity.name»");
		var store = this._remoteFactory.create(properties.uri, entityFactory);
	'''
	
	def static generateLocalBody(ContentProvider contentProvider) '''
		// TODO Local Content Provider
	'''
	
	/**
	 * Creates a query in MongoDB syntax from specified whereCondition in MD2.
	 */
	def private static String buildContentProviderQuery(WhereClauseCondition condition, LinkedHashMap<String, String> expressionVars) {
		
		switch (condition) {
			WhereClauseOr: '''
				$or: [
					{ «buildContentProviderQuery(condition.leftExpression, expressionVars)» },
					{ «buildContentProviderQuery(condition.rightExpression, expressionVars)» }
				]'''
			WhereClauseAnd: '''
				«buildContentProviderQuery(condition.leftExpression, expressionVars)»,
				«buildContentProviderQuery(condition.rightExpression, expressionVars)»'''
			WhereClauseNot: '''
				$not: { «buildContentProviderQuery(condition.expression, expressionVars)» }'''
			WhereClauseCompareExpression: {
				val simpleExpressionVar = getUnifiedName("expr")
				expressionVars.put(simpleExpressionVar, generateSimpleExpression(condition.eqRight))
				val attribute = getPathTailAsString(condition.eqLeft.tail)
				val rightHand = switch condition.op {
					case Operator::EQUALS: '''«simpleExpressionVar»'''
					case Operator::GREATER: '''{ $gt: «simpleExpressionVar» }'''
					case Operator::SMALLER: '''{ $lt: «simpleExpressionVar» }'''
					case Operator::GREATER_OR_EQUAL: '''{ $gte: «simpleExpressionVar» }'''
					case Operator::SMALLER_OR_EQUAL: '''{ $lte: «simpleExpressionVar» }'''
				}
				'''«attribute»: «rightHand»'''
			}
		}
	}
	
}
