// static: Converters
//
//  DataConverter.m
//  Tarifrechner
//
//  Created by Uni Münster on 16.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "DataConverter.h"

@implementation DataConverter

static NSDateFormatter *dateFormatter;
static NSNumberFormatter *numberFormatter;

static NSString *timeFormat = @"HH:mm:ss";
static NSString *dateFormat = @"dd.MM.yyyy";
static NSString *dateTimeFormat = @"dd.MM.yyyy HH:mm:ss";
static NSString *timeZoneName = @"GMT";

+(NSString *) getDateStringByString: (NSString *) string
{
    return [string substringToIndex: dateFormat.length];
}

+(NSString *) getTimeStringByString: (NSString *) string
{
    return [string substringFromIndex: (dateFormat.length + 1)];
}

+(NSString *) getStringByDate:(NSDate *) date
{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: dateTimeFormat];
    [dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation: timeZoneName]];
    return [dateFormatter stringFromDate: date];
}

+(NSDate *) getTimeByString: (NSString *) string
{
    return [self getDateByString: string format: timeFormat];
}

+(NSDate *) getDateByString: (NSString *) string
{
    return [self getDateByString: string format: dateFormat];
}

+(NSDate *) getDateTimeByString: (NSString *) string
{
    return [self getDateByString: string format: dateTimeFormat];
}

+(NSDate *) getDateByString: (NSString *) string format: (NSString *) format
{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    [dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation: timeZoneName]];
    NSDate *date = [dateFormatter dateFromString: string];
    
    return date;
}

+(NSString *) getStringByNumber: (NSNumber *) number
{
    numberFormatter = [[NSNumberFormatter alloc] init];
    return [numberFormatter stringFromNumber: number];
}

+(NSNumber *) getNumberByString: (NSString *) string
{
    numberFormatter = [[NSNumberFormatter alloc] init];
    return [numberFormatter numberFromString: string];
}

+(NSString*) getStringByEnumValue: (int) type enumString: (NSString *) enumString
{
    NSString *key = [NSString stringWithFormat: @"%i", type];
    return LocalizedString(enumString, key);
}

@end