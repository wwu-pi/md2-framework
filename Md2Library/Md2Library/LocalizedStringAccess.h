// static: Strings
//
//  LocalizedStringAccess.h
//  TariffCalculator
//
//  Created by Uni Münster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#define LocalizedString(identifier, key) [LocalizedStringAccess getStringByIdentifier: identifier appendix: key]
#define LocalizedKeyString(key) [LocalizedStringAccess getStringByKey: key]

@interface LocalizedStringAccess : NSObject

extern NSString *const seperator;
extern NSString *const language;

+(NSString *) getStringByIdentifier: (NSString *) identifier appendix: (NSString *) appendix;
+(NSString *) getStringByKey: (NSString *) key;

@end