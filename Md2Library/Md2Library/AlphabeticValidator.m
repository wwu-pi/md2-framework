// static: Validators
//
//  AlphabeticValidator.m
//  TariffCalculator
//
//	The AlphabeticValidator encapsulates the validation of alphabetic strings.
//
//  Created by Uni Muenster on 22.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "AlphabeticValidator.h"

@implementation AlphabeticValidator

/*
*	Initializes the AlphabeticValidator object.
*/
-(id) init
{
    return [self initWithMessage: LocalizedKeyString(@"val_alphabetic")];
}

/*
*	Initializes the AlphabeticValidator object with a message.
*/
-(id) initWithMessage: (NSString *) msg
{
    self = [super initWithMessage: msg];
    if (self)
    {
        pattern = @"[A-Za-züäö?ß]";
    }
    return self;
}

@end