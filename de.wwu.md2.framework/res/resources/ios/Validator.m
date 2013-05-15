// static: Validators
//
//  Validator.m
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//4

#import "Validator.h"

@implementation Validator

@synthesize regularExpression, pattern, message, isValid;

-(id) init
{
    regularExpression = [[NSRegularExpression alloc] init];
    pattern = @"";
    message = @"";
    isValid = NO;
    return self;
}

-(id) initWithMessage: (NSString *) msg
{
    regularExpression = [[NSRegularExpression alloc] init];
    pattern = @"";
    message = msg;
    isValid = NO;
    return self;
}

-(BOOL) checkValidatorByStringData: (NSString *) data
{
    if (data != nil)
    {
        regularExpression = [NSRegularExpression regularExpressionWithPattern: pattern options: NSRegularExpressionCaseInsensitive error: nil];
        NSUInteger match = [regularExpression numberOfMatchesInString: data options: 0 range: NSMakeRange(0, data.length)];
        isValid = (match ==  data.length);
        return isValid;
    }
    return NO;
}

@end