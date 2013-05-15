// static: Validation
//
//  WidgetValidation.h
//  TariffCalculator
//
//	Represents a validation component that can be added to widgets
//	in order to check them syntactically
//
//  Created by Uni Muenster on 22.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Validator.h"

@interface WidgetValidation : NSObject
{
    NSMutableArray *validators;
    NSMutableString *errorMessage;
}

/*
*	Declaration of the getters and setters for the instance attributes.
*/
@property (retain, nonatomic) NSMutableArray *validators;
@property (retain, nonatomic) NSMutableString *errorMessage;

-(void) addValidator: (Validator *) validation;
-(void) removeValidator: (Validator *) validation;
-(void) removeValidatorOfClass: (Class) validationClass;
-(BOOL) checkAllValidatorsByStringData: (NSString *) data;

@end