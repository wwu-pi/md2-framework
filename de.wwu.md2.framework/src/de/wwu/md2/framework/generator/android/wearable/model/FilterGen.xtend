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

class FilterGen {
	def static String generateFilter(Iterable<ContentProvider> contentProviders){
		//WhereClauseConditionalExpression WhereExpression
		for (cp : contentProviders) {
			if(cp.filter){
				println(genWhereFilter(cp.whereClause))
			}

		}
		return ""
	}

	def private static String genWhereFilter(WhereClauseCondition condition){
		switch (condition) {
			WhereClauseOr:{
//				println("OR::")
//				println(condition.toString)
				return ("new CombinedExpression(" + genWhereFilter((condition as WhereClauseOrImpl).leftExpression) + "," + "or" + "," + genWhereFilter((condition as WhereClauseOrImpl).rightExpression)+")")
			}
			WhereClauseAnd:{
//				println("AND:")
//				println(condition.toString)
//				println((condition as WhereClauseAndImpl).leftExpression.toString)
//				println((condition as WhereClauseAndImpl).rightExpression.toString)
//CombinedExpression(Expression leftExpression,  Junction junction, Expression rightExpression)

				return("new CombinedExpression(" + genWhereFilter((condition as WhereClauseAndImpl).leftExpression) + "," + "and" + "," + genWhereFilter((condition as WhereClauseAndImpl).rightExpression)+")")
				//println(genWhereFilter((condition as WhereClauseAndImpl).rightExpression))
			}
			WhereClauseNot:{
				println("NOT:")
				println(condition.toString)
			}
			WhereClauseCompareExpression:{
//				println("CompareExpression:")
//				println(condition.toString)
//				println(condition.eqLeft.toString)
//				println(condition.eqRight.toString)
//				
				//Vergleich auflösen
				return genCompare(condition.op, condition.eqLeft, condition.eqRight)
				}
			}
	
		}
	
	def private static String genTrav(){
		
	}
	
	def private static String genCompare(Operator operator, EntityPath Entity, SimpleExpression expr){
		var op = "" 
		switch (operator.toString) {
			case "equals":{op = "equals";}
			case ">":{op = "GREATER"}
			case "<":{op = "LESS"}
			case ">=":{op = "GREATEREQUAL"}
			case "<=":{op = "LESSEQUAL"}
		}
		
		var left = genEntity(Entity)
		var right = genSimpleExpr(expr)
		
		var result = "(new AtomicExpression(" + left + "," + op + "," + right + "))"
		//println(result)
		return result
	}
	
	def private static String genSimpleExpr(SimpleExpression expr){
		var result = "";
		switch (expr) {
			IntValImpl:result = (expr as IntValImpl).value.toString
			StringValImpl:result = (expr as StringValImpl).value
			}
		//println(result)
		return result
	}
	
	def private static String genEntity(EntityPath EntityPath){
		//println(EntityPath.tail.attributeRef.name)
		return EntityPath.tail.attributeRef.name
	}
}