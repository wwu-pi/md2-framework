// static: DataMappers
//
//  DataMapper.m
//  TariffCalculator
//
//  Created by Uni Münster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "DataMapper.h"

@implementation DataMapper

-(id) init
{
    self = [super init];
    if (self)
    {
        identifierDataKeyMapping = [[NSMutableDictionary alloc] init];
        dataKeyContentProviderMapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) registerDataKeyForIdentifier: (NSString *) dataKey identifier: (NSString *) identifier contentProvider: (ContentProvider *) contentProvider
{
    [identifierDataKeyMapping setObject: dataKey forKey: identifier];
    [dataKeyContentProviderMapping setObject: contentProvider forKey: [identifier stringByAppendingFormat: @"_%@", dataKey]];
}

-(void) unregisterDataKeyForIdentifier: (NSString *) identifier
{
    [identifierDataKeyMapping removeObjectForKey: identifier];
    NSString *dataKey = [identifier stringByAppendingFormat: @"_%@", [identifierDataKeyMapping objectForKey: identifier]];
    [dataKeyContentProviderMapping removeObjectForKey: dataKey];
}

-(id) getCurrentDataObjectByIdentifier: (NSString *) identifier
{
    if ([identifierDataKeyMapping objectForKey: identifier] != nil)
        return [[dataKeyContentProviderMapping objectForKey: [identifier stringByAppendingFormat: @"_%@", [identifierDataKeyMapping objectForKey: identifier]]] getDataObject];
    return nil;
}

-(id) getDataByIdentifier: (NSString *) identifier
{
    NSString *dataKeyId = @"";
    NSString *dataKey = [identifierDataKeyMapping objectForKey: identifier];
    if ([identifierDataKeyMapping objectForKey: identifier] != nil)
        dataKeyId = [identifier stringByAppendingFormat: @"_%@", [identifierDataKeyMapping objectForKey: identifier]];
    id value = [[dataKeyContentProviderMapping objectForKey: dataKeyId] getDataObjectValueForKey: dataKey];
    if (isDebug)
        NSLog(@"identifier=%@, value=%@", identifier, value);
    if (value != nil)
    {
        NSString *numberString = [DataConverter getStringByNumber: value];
        if (numberString != nil)
            value = numberString;
        else
        {
            NSString *dateString = [DataConverter getStringByDate: value];
            if (dateString != nil)
                value = dateString;
        }
        return value;
    }
    return nil;
}

-(void) setDataByIdentifier: (id) data identifier: (NSString *) identifier
{
    NSString *dataKeyId = @"";
    NSString *dataKey = [identifierDataKeyMapping objectForKey: identifier];
    if ([identifierDataKeyMapping objectForKey: identifier] != nil)
        dataKeyId = [identifier stringByAppendingFormat: @"_%@", [identifierDataKeyMapping objectForKey: identifier]];
    if (isDebug)
        NSLog(@"identifier=%@, data=%@", identifier, data);
    [((ContentProvider *) [dataKeyContentProviderMapping objectForKey: dataKeyId]) setDataObjectValue: data forKey: dataKey];
}

-(NSString *) getEnumStringByIdentifier: (NSString *) identifier value: (NSNumber *) value
{
    NSString *dataKey = [identifierDataKeyMapping objectForKey: identifier];
    if ([dataKey rangeOfString: @"."].length != 0)
    {
        NSArray *pathComponents = [dataKey componentsSeparatedByString: @"."];
        dataKey = [pathComponents objectAtIndex: (pathComponents.count - 1)];
    }
    return [DataConverter getStringByEnumValue: value.intValue enumString: dataKey];
}

-(NSArray *) getAllEnumValuesByIdentifier: (NSString *) identifier
{
    NSString *dataKey = [identifierDataKeyMapping objectForKey: identifier];
    if ([dataKey rangeOfString: @"."].length != 0)
    {
        NSArray *pathComponents = [dataKey componentsSeparatedByString: @"."];
        dataKey = [pathComponents objectAtIndex: (pathComponents.count - 1)];
    }
    
    NSMutableArray *enumValues = [[NSMutableArray alloc] init];
    for (int i = 0;; i++)
    {
        NSString *value = [DataConverter getStringByEnumValue: i enumString: dataKey];
        if (![value isEqualToString: [NSString stringWithFormat: @"%@_%i", dataKey, i]])
            [enumValues addObject: value];
        else
            break;
    }
    return enumValues;
}

-(void) reloadDataObject
{
    for (NSString * key in dataKeyContentProviderMapping.keyEnumerator)
        [((ContentProvider *) [dataKeyContentProviderMapping objectForKey: key]) getDataObject];
}

-(void) writeDataObject
{
    for (NSString * key in dataKeyContentProviderMapping.keyEnumerator)
        [((ContentProvider *) [dataKeyContentProviderMapping objectForKey: key]) persistDataObject];
}

@end