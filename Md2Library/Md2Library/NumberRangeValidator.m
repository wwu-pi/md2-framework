// static: Validators
//
//  NumberRangeValidator.m
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "NumberRangeValidator.h"

@implementation NumberRangeValidator

@synthesize minimum, maximum;

-(id) init
{
//    return [self initWithMinimum: 0 maximum: FLT_MAX message: [NSString stringWithFormat: LocalizedKeyString(@"val_numberRange"), minimum, maximum]];
    return [self initWithMinimum: 0 maximum: FLT_MAX message: @"Bitte geben Sie die korrekten Daten ein."];
}

-(id) initWithMessage: (NSString *) msg
{
    return [self initWithMinimum: 0 maximum: FLT_MAX message: msg];
}

-(id) initWithMinimum: (float) min maximum: (float) max
{
//    return [self initWithMinimum: min maximum: max message: [NSString stringWithFormat: LocalizedKeyString(@"val_numberRange"), minimum, maximum]];
    return [self initWithMinimum: min maximum: max message: @"Bitte geben Sie die korrekten Daten ein."];
}

-(id) initWithMinimum: (float) min maximum: (float) max message: (NSString *) msg
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
    isValid = ((minimum <= data.floatValue) && (data.floatValue <= maximum));
    return isValid;
}

@end