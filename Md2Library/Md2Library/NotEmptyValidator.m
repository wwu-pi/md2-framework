// static: Validators
//
//  NotEmptyValidator.m
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "NotEmptyValidator.h"

@implementation NotEmptyValidator

-(id) init
{
    return [self initWithMessage: LocalizedKeyString(@"val_notEmpty")];
}

-(id) initWithMessage: (NSString *) msg
{
    return [super initWithMessage: msg];
}

-(BOOL) checkValidatorByStringData: (NSString *) data
{
    isValid = (data.length > 0);
    return isValid;
}

@end