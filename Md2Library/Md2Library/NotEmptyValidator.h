// static: Validators
//
//  NotEmptyValidator.h
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Validator.h"

@interface NotEmptyValidator : Validator

-(BOOL) checkValidatorByStringData: (NSString *) data;

@end