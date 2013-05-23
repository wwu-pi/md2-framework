// static: Validators
//
//  NumberRangeValidator.h
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Validator.h"

@interface NumberRangeValidator : Validator
{
    float minimum;
    float maximum;
}

@property (assign, nonatomic) float minimum;
@property (assign, nonatomic) float maximum;

-(id) initWithMinimum: (float) min maximum: (float) max;
-(id) initWithMinimum: (float) min maximum: (float) max message: (NSString *) msg;
-(BOOL) checkValidatorByStringData: (NSString *) data;

@end