package de.wwu.md2.framework.generator.android.wearable.model

import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.WhereClauseCondition
import de.wwu.md2.framework.mD2.impl.StringValImpl
import de.wwu.md2.framework.mD2.impl.IntValImpl
import de.wwu.md2.framework.mD2.WhereClauseOr
import de.wwu.md2.framework.mD2.WhereClauseAnd
import de.wwu.md2.framework.mD2.WhereClauseNot
import de.wwu.md2.framework.mD2.WhereClauseCompareExpression
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.EntityPath
import de.wwu.md2.framework.mD2.SimpleExpression
import de.wwu.md2.framework.mD2.impl.WhereClauseAndImpl
import de.wwu.md2.framework.mD2.impl.WhereClauseOrImpl
import de.wwu.md2.framework.mD2.impl.FloatValImpl
import de.wwu.md2.framework.mD2.impl.SensorValImpl
import de.wwu.md2.framework.mD2.impl.WhereClauseNotImpl

/**
 * Die Klasse FilterGen dient zur Erstellung der Filter, die bei einem ContenProvider definierte werden
 * könnnen. Es wird der JavaCode zur Generierung des FilterTrees zurückgegeben. 
 */

class FilterGen {
	def static String generateFilter(ContentProvider contentProvider){
				println(genWhereFilter(contentProvider.whereClause))
				return genWhereFilter(contentProvider.whereClause)
	}

	def private static String genWhereFilter(WhereClauseCondition condition){
		switch (condition) {
			WhereClauseOr:{
				return ("new CombinedExpression(" + genWhereFilter((condition as WhereClauseOrImpl).leftExpression) + "," + "OR" + "," + genWhereFilter((condition as WhereClauseOrImpl).rightExpression)+")")
			}
			WhereClauseAnd:{
				return("new CombinedExpression(" + genWhereFilter((condition as WhereClauseAndImpl).leftExpression) + "," + "AND" + "," + genWhereFilter((condition as WhereClauseAndImpl).rightExpression)+")")
			}
			WhereClauseNot:{
				println("NOT:")
				println(condition.toString)
				println((condition as WhereClauseNotImpl).expression.toString)
				return "!" + genWhereFilter((condition as WhereClauseNotImpl).expression)
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
		var right = genSimpleExpr(expr)
		
		var result = "(new AtomicExpression(\"" + left + "\"," + op + ",\"" + right + "\"))"
		return result
	}
	
	def private static String genSimpleExpr(SimpleExpression expr){
		var result = "";
		switch (expr) {
			IntValImpl:result = (expr as IntValImpl).value.toString
			FloatValImpl:result = (expr as FloatValImpl).value.toString
			StringValImpl:result = (expr as StringValImpl).value
			SensorValImpl:result = (expr as SensorValImpl).value.toString
			}
		return result
	}
	
	def private static String genEntity(EntityPath EntityPath){
		return EntityPath.tail.attributeRef.name
	}
}