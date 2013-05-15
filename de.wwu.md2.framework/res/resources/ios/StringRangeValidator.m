// static: Validators
//
//  StringRangeValidator.m
//  Tarifrechner
//
//  Created by Uni Münster on 22.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "StringRangeValidator.h"

@implementation StringRangeValidator

@synthesize minimum, maximum;

-(id) init
{
//    return [self initWithMessage: LocalizedKeyString(@"val_stringRange")];
    return [self initWithMessage: @"Bitte geben Sie die richtige Anzahl von Zeichen ein."];
}

-(id) initWithMessage: (NSString *) msg
{
    return [self initWithMinimum: 0 maximum: INT_MAX message: msg];
}

-(id) initWithMinimum: (NSUInteger) min maximum: (NSUInteger) max
{
//    return [self initWithMinimum: min maximum: max message: [NSString stringWithFormat: LocalizedKeyString(@"val_stringRange"), min, max]];
    return [self initWithMinimum: min maximum: max message: @"Bitte geben Sie die richtige Anzahl von Zeichen ein."];
}

-(id) initWithMinimum: (NSUInteger) min maximum: (NSUInteger) max message: (NSString *) msg
{
    self = [super initWithMessage: msg];
    if (self)
    {
        minimum = min;
        maximum = max;
    }
    return self;
}

-(BOOL) checkValidatorByStringData: (NSString *) data
{
    isValid = ((minimum <= data.length) && (data.length <= maximum));
    return isValid;
}

@end