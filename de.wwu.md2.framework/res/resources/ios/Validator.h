// static: Validators
//
//  Validator.h
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

@interface Validator : NSObject
{
    NSRegularExpression *regularExpression;
    NSString *pattern;
    NSString *message;
    BOOL isValid;
}

@property (retain, nonatomic) NSRegularExpression *regularExpression;
@property (retain, nonatomic) NSString *pattern;
@property (retain, nonatomic) NSString *message;
@property (assign, nonatomic) BOOL isValid;

-(id) initWithMessage: (NSString *) msg;
-(BOOL) checkValidatorByStringData: (NSString *) data;

@end