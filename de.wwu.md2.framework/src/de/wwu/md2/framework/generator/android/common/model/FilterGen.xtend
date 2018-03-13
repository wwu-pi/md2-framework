package de.wwu.md2.framework.generator.android.common.model

import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.EntityPath
import de.wwu.md2.framework.mD2.FloatVal
import de.wwu.md2.framework.mD2.IntVal
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.SensorVal
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.StringVal
import de.wwu.md2.framework.mD2.WhereClauseAnd
import de.wwu.md2.framework.mD2.WhereClauseCompareExpression
import de.wwu.md2.framework.mD2.WhereClauseCondition
import de.wwu.md2.framework.mD2.WhereClauseNot
import de.wwu.md2.framework.mD2.WhereClauseOr
import de.wwu.md2.framework.generator.android.lollipop.controller.ActionGen
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef

/**
 * Die Klasse FilterGen dient zur Erstellung der Filter, die bei einem ContenProvider definierte werden
 * könnnen. Es wird der JavaCode zur Generierung des FilterTrees zurückgegeben. 
 */

class FilterGen {
	def static String generateFilter(ContentProvider contentProvider){
				return genWhereFilter(contentProvider.whereClause)
	}

	def private static String genWhereFilter(WhereClauseCondition condition){
		switch (condition) {
			WhereClauseOr:{
				return ("new CombinedExpression(" + genWhereFilter(condition.leftExpression) + "," + "OR" + "," + genWhereFilter(condition.rightExpression)+")")
			}
			WhereClauseAnd:{
				return("new CombinedExpression(" + genWhereFilter(condition.leftExpression) + "," + "AND" + "," + genWhereFilter(condition.rightExpression)+")")
			}
			WhereClauseNot:{
				return "!" + genWhereFilter(condition.expression)
			}
			WhereClauseCompareExpression:{
				//Vergleich auflösen
				return genCompare(condition.op, condition.eqLeft, condition.eqRight)
				}
			}
		}
	
	def private static String genCompare(Operator operator, EntityPath Entity, SimpleExpression expr){
		var op = "" 
		switch (operator.toString) {
			case "equals":{op = "Operator.EQUAL";}
			case ">":{op = "Operator.GREATER"}
			case "<":{op = "Operator.LESS"}
			case ">=":{op = "Operator.GREATEREQUAL"}
			case "<=":{op = "Operator.LESSEQUAL"}
		}
		
		var left = genEntity(Entity)
		var right = ActionGen.generateSimpleExpression(expr)//genSimpleExpr(expr)
		if(expr instanceof AbstractViewGUIElementRef) right = right + ".toString()"
		
		var result = "(new AtomicExpression(\"" + left + "\"," + op + "," + right + "))"
		return result
	}
	
	// TODO replace by ActionGen.generateSimpleExpression
	def private static String genSimpleExpr(SimpleExpression expr){
		switch (expr) {
			IntVal: return expr.value.toString
			FloatVal: return expr.value.toString
			StringVal: return expr.value
			SensorVal: return expr.value.toString
			}
		return ""
	}
	
	def private static String genEntity(EntityPath EntityPath){
		return EntityPath.tail.attributeRef.name
	}
}