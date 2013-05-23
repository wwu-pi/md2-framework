package de.wwu.md2.framework.generator.ios

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.AttributeEqualsExpression
import de.wwu.md2.framework.mD2.BooleanExpression
import de.wwu.md2.framework.mD2.CheckBox
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.FilterType
import de.wwu.md2.framework.mD2.WhereClauseCondition
import java.util.Date
import java.util.List

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class FilterClass
{
	def static createFilterH(ContentProvider cp) '''
		//
		//  «cp.name.toFirstUpper»Filter.h
		//  TariffCalculator
		//
		//  Created by Uni Münster on «new Date()».
		//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
		//
		
		#import "«IOSGenerator::md2LibraryImport»/Filter.h"
		
		@interface «cp.name.toFirstUpper»Filter : Filter
		@end'''
	
	def static createFilterM(ContentProvider cp, DataContainer dataContainer) '''
		//
		//  «cp.name.toFirstUpper»Filter.m
		//  TariffCalculator
		//
		//  Created by Uni Münster on «new Date()».
		//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
		//
		
		#import "SpecificAppData.h"
		#import "«cp.name.toFirstUpper»Filter.h"
		
		@implementation «cp.name.toFirstUpper»Filter
		
		-(id) init
		{
			self = [super init];
			if (self)
				filterType = «IF cp.filterType.equals(FilterType::ALL) && cp.type.many»ALL«ELSE»FIRST«ENDIF»;
			return self;
		}
		
		-(NSPredicate *) getReplacedPredicate
		{
			NSMutableString *localString = [NSMutableString stringWithFormat: @"«generateLocalFilterString(cp.whereClause, [ "%@" ])»"«FOR filterParameter : generateViewElementList(cp.whereClause, dataContainer) BEFORE "," SEPARATOR ","» «filterParameter»«ENDFOR»];
			return [NSPredicate predicateWithFormat: localString];
		}
		
		-(NSString *) getRemotePredicate
		{
			NSMutableString *remoteString = [NSMutableString stringWithFormat: @"«IF cp.filterType.equals(FilterType::FIRST) || !cp.type.many»first«ENDIF»?filter="];
			[remoteString appendString: [[NSMutableString stringWithFormat: @"«generateRemoteFilterString(cp.whereClause, [ "%@" ])»"«FOR filterParameter : generateViewElementList(cp.whereClause, dataContainer) BEFORE "," SEPARATOR ","» «filterParameter»«ENDFOR»] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];
			return remoteString;
		}
		
		@end'''
	
	def private static List<String> generateViewElementList(WhereClauseCondition cond, DataContainer dataContainer)
	{
		val parameters = <String>newArrayList
		for(subCondition : cond.subConditions)
		{
			switch (subCondition)
			{
				AttributeEqualsExpression:
				{
					if(subCondition.eqRight instanceof AbstractViewGUIElementRef)
					{
						val viewElem = resolveViewGUIElement(subCondition.eqRight as AbstractViewGUIElementRef)
						val str = switch (viewElem)
						{
							CheckBox: '''([[[SpecificAppData «getName(getViewOfGUIElement(dataContainer.viewContainers, viewElem)).toFirstLower»Controller] getWidgetDataByIdentifier: @"«getName(viewElem)»"] isEqualToString: @"1"]? @"true": @"false")'''
							default: '''[[SpecificAppData «getName(getViewOfGUIElement(dataContainer.viewContainers, viewElem)).toFirstLower»Controller] getWidgetDataByIdentifier: @"«getName(viewElem)»"]'''
						}.toString
						
						parameters.add(str)
					}
				}
				BooleanExpression: { }
				WhereClauseCondition: parameters.addAll(generateViewElementList(subCondition, dataContainer))
			}
		}
		parameters
	}
}