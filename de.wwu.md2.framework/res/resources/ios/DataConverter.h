// static: Converters
//
//  DataConverter.h
//  Tarifrechner
//
//  Created by Uni Münster on 16.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

@interface DataConverter : NSObject

+(NSString *) getStringByDate:(NSDate *) date;
+(NSString *) getDateStringByString: (NSString *) string;
+(NSString *) getTimeStringByString: (NSString *) string;
+(NSDate *) getTimeByString: (NSString *) string;
+(NSDate *) getDateByString: (NSString *) string;
+(NSDate *) getDateTimeByString: (NSString *) string;
+(NSDate *) getDateByString:(NSString *) string;
+(NSString *) getStringByNumber: (NSNumber *) number;
+(NSNumber *) getNumberByString: (NSString *) string;
+(NSString*) getStringByEnumValue: (int) type enumString: (NSString *) enumString;

@end