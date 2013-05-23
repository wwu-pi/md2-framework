// static: Strings
//
//  LocalizedStringAccess.m
//  TariffCalculator
//
//  Created by Uni Münster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

@implementation LocalizedStringAccess

NSString *const seperator = @"_";
NSString *const table = @"de";

+(NSString *) getStringByIdentifier: (NSString *) identifier appendix: (NSString *) appendix
{
    NSString *key =  [NSString stringWithFormat: @"%@%@%@", identifier, seperator, appendix];
    return [self getStringByKey: key];
}

+(NSString *) getStringByKey: (NSString *) key
{
    NSString *file = [NSString stringWithFormat: @"Localizable%@%@", seperator, table];
    return NSLocalizedStringFromTable(key, file, nil);
}

@end