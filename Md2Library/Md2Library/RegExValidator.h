// static: Validators
//
//  RegExValidator.h
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Validator.h"

@interface RegExValidator : Validator

-(id) initWithPattern: (NSString *) _pattern;
-(id) initWithPattern: (NSString *) _pattern message: (NSString *) msg;

@end