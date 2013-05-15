// static: Validation
//
//  WidgetValidation.m
//  TariffCalculator
//
//	Represents a validation component that can be added to widgets
//	in order to check them syntactically
//
//  Created by Uni Muenster on 22.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WidgetValidation.h"

@implementation WidgetValidation

/*
*	Implementation of the getters and setters for the instance attributes.
*/
@synthesize validators, errorMessage;

/*
*	Initializes the WidgetValidation object.
*/
-(id) init
{
    validators = [[NSMutableArray alloc] init];
    errorMessage = [[NSMutableString alloc] init];
    return [super init];
}

/*
*	Adds a validator to be checked to the WidgetValidation.
*/
-(void) addValidator: (Validator *) validation
{
    [validators addObject: validation];
}

/*
*	Removes a validator to be checked from the WidgetValidation.
*/
-(void) removeValidator: (Validator *) validation
{
    [validators removeObject: validation];
}

/*
*	Removes a validator to be checked from the WidgetValidation of a specific class.
*/
-(void) removeValidatorOfClass: (Class) validationClass
{
    for (Validator *validator in validators)
        if ([validator class] == validationClass)
            [validators removeObject: validator];
}

/*
*	Checks all validators of the WidgetValidation by the given NSString data.
*/
-(BOOL) checkAllValidatorsByStringData: (NSString *) data
{
    BOOL validatorCheck = YES;
    errorMessage = [[NSMutableString alloc] init];
    for (Validator *validator in validators)
    {
        if (![validator checkValidatorByStringData: data])
        {
            [errorMessage appendString: validator.message];
            [errorMessage appendString: @"\n"];
            validatorCheck = NO;
        }
    }
    return validatorCheck;
}

@end