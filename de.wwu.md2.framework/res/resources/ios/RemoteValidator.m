// static: Validators
//
//  RemoteValidator.m
//  TariffCalculator
//
//  Created by Uni Münster on 05.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RemoteValidator.h"

@implementation RemoteValidator

-(id) init
{
    return [self initWithName: @"" remoteURL: @"http://localhost" contentProvider: [[ContentProvider alloc] init] attributes: [[NSDictionary alloc] init]];
}

-(id) initWithName: (NSString *) _name remoteURL: (NSString *) remoteUrl contentProvider: (ContentProvider *) contentProv attributes: (NSDictionary *) _attributes
{
    self = [super init];
    if (self)
    {
        pattern = @"";
        message = @"";
        name = _name;
        remoteURL = remoteUrl;
        contentProvider =contentProv;
        attributes = _attributes;
    }
    return self;
}

-(BOOL) checkValidatorByStringData: (NSString *) data
{
    NSError *error = nil;
    NSMutableString *attributeString = [NSString stringWithFormat: @""];
    for (NSString *attribute in attributes.keyEnumerator)
        [attributeString appendString: [NSString stringWithFormat: @"%@=%@", attribute, [attributes objectForKey: attribute]]];
    
    NSURL *remoteValidatorURL = [NSURL URLWithString: [NSString stringWithFormat: @"%@/md2_validator/%@/?%@", remoteURL.description, name, attributeString]];
    NSData* resultData = [NSData dataWithContentsOfURL: remoteValidatorURL];
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData: resultData options: kNilOptions error: &error];
    
    NSMutableString *msg = [NSMutableString stringWithFormat: @""];;
    NSArray *errors = [jsonData valueForKey: @"error"];
    for (NSDictionary *dict in errors)
        [msg appendFormat: @"Fehlermeldung (Attribute: %@): %@", [dict valueForKey: @"attributes"], [dict valueForKey: @"message"]];
    
    message = msg;
    isValid = [[jsonData valueForKey: @"ok"] isEqualToString: @"true"];
    
    return isValid;
}

@end