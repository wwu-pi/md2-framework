// static: Validators
//
//  FloatValidator.m
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "FloatValidator.h"

@implementation FloatValidator

-(id) init
{
    return [self initWithMessage: LocalizedKeyString(@"val_float")];
}

-(id) initWithMessage: (NSString *) msg
{
    self = [super initWithMessage: msg];
    if (self)
    {
        pattern = @"[0-9.]";
    }
    return self;
}
    

@end