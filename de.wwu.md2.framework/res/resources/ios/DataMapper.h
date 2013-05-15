// static: DataMappers
//
//  DataMapper.h
//  TariffCalculator
//
//  Created by Uni Münster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ContentProvider.h"

@interface DataMapper : NSObject
{
    NSMutableDictionary *identifierDataKeyMapping;
    NSMutableDictionary *dataKeyContentProviderMapping;
}

-(void) registerDataKeyForIdentifier: (NSString *) dateKey identifier: (NSString *) identifier contentProvider: (ContentProvider *) contentProvider;
-(void) unregisterDataKeyForIdentifier: (NSString *) identifier;

-(id) getCurrentDataObjectByIdentifier: (NSString *) identifier;
-(id) getDataByIdentifier: (NSString *) identifier;
-(void) setDataByIdentifier: (id) data identifier: (NSString *) identifier;

-(NSString *) getEnumStringByIdentifier: (NSString *) identifier value: (NSNumber *) value;
-(NSArray *) getAllEnumValuesByIdentifier: (NSString *) identifier;

-(void) writeDataObject;

@end