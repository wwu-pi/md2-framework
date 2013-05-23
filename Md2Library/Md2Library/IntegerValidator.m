// static: Validators
//
//  NumberValidator.m
//  Tarifrechner
//
//  Created by Uni Münster on 22.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "IntegerValidator.h"

@implementation IntegerValidator

-(id) init
{
    return [self initWithMessage: LocalizedKeyString(@"val_integer")];
}

-(id) initWithMessage: (NSString *) msg
{
    self = [super initWithMessage: msg];
    if (self)
    {
        pattern = @"[0-9]";
    }
    return self;
}

@end