package de.wwu.md2.framework.generator.ios

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.AllowedOperation
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType
import java.util.Date

class ContentProviderClass
{
	def static createContentProviderH(ContentProvider cp) '''
		//
		//  «cp.name.toFirstUpper»ContentProvider.h
		//
		//  Created by Uni Münster on «new Date()».
		//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
		//
		
		#import "«IOSGenerator::md2LibraryImport»/ContentProvider.h"
		
		@interface «cp.name.toFirstUpper»ContentProvider : ContentProvider
		@end'''
		
	def static createContentProviderM(ContentProvider cp, DataContainer dataContainer) '''
		//
		//  «cp.name.toFirstUpper»ContentProvider.m
		//
		//  Created by Uni Münster on «new Date()».
		//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
		//
		
		#import "«cp.name.toFirstUpper»ContentProvider.h"
		«IF cp.whereClause != null»#import "«cp.name.toFirstUpper»Filter.h"«ENDIF»
		
		@implementation «cp.name.toFirstUpper»ContentProvider
		
		-(id) init
		{
			self = [super init];
			if (self)
			{
				dataObjectName = @"«(cp.type as ReferencedModelType).entity.name.toFirstUpper»Entity";
				isLocal = «IF isLocal(cp, dataContainer)»YES«ELSE»NO«ENDIF»;
				remoteURL = [NSURL URLWithString: @"«getConnection(cp, dataContainer)»"];
				isCacheEnabled = NO;
				isLoadAllowed = «IF cp.allowedOperations.empty || cp.allowedOperations.exists(op | op.equals(AllowedOperation::READ))»YES«ELSE»NO«ENDIF»;
				isSaveAllowed = «IF cp.allowedOperations.empty || cp.allowedOperations.exists(op | op.equals(AllowedOperation::CREATE_OR_UPDATE))»YES«ELSE»NO«ENDIF»;
				«IF cp.whereClause != null»filter = [[«cp.name.toFirstUpper»Filter alloc] init];«ENDIF»
			}
			return self;
		}
		
		@end'''
	
	def private static isLocal(ContentProvider cp, DataContainer dataContainer)
	{
		cp.local || (cp.^default && dataContainer.main.defaultConnection == null)
	}
	
	def private static getConnection(ContentProvider cp, DataContainer dataContainer)
	{
		if(cp.connection != null)
			cp.connection.uri
		else if(cp.^default && dataContainer.main.defaultConnection != null)
			dataContainer.main.defaultConnection.uri
		else
			""
	}
}