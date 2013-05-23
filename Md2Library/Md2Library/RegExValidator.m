// static: Validators
//
//  RegExValidator.m
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RegExValidator.h"

@implementation RegExValidator

-(id) init
{
    return [self initWithPattern: @"" message: LocalizedKeyString(@"val_regEx")];
}

-(id) initWithMessage: (NSString *) msg
{
    return [self initWithPattern: @"" message: msg];
}

-(id) initWithPattern: (NSString *) _pattern
{
    return [self initWithPattern: _pattern message: LocalizedKeyString(@"val_regEx")];
}

-(id) initWithPattern: (NSString *) _pattern message: (NSString *) msg
{
    self = [super initWithMessage: msg];
    if (self)
    {
        pattern = _pattern;
    }
    return self;
}

-(BOOL) checkValidatorByStringData: (NSString *) data
{
    NSString *newPattern = [NSString stringWithFormat: @"^%@$", pattern];
    regularExpression = [NSRegularExpression regularExpressionWithPattern: newPattern options: NSRegularExpressionCaseInsensitive error: nil];
    NSTextCheckingResult *match = [regularExpression firstMatchInString: data options: 0 range: NSMakeRange(0, data.length)];
    isValid = (match.range.length != 0);
    return isValid;
}

@end