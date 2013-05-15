// static: Validators
//
//  StringRangeValidator.h
//  Tarifrechner
//
//  Created by Uni Münster on 24.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Validator.h"

@interface StringRangeValidator : Validator
{
    NSUInteger minimum;
    NSUInteger maximum;
}

@property (assign, nonatomic) NSUInteger minimum;
@property (assign, nonatomic) NSUInteger maximum;

-(id) initWithMinimum: (NSUInteger) min maximum: (NSUInteger) max;
-(id) initWithMinimum: (NSUInteger) min maximum: (NSUInteger) max message: (NSString *) msg;
-(BOOL) checkValidatorByStringData: (NSString *) data;

@end