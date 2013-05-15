// static: Events
//
//  ValidatorBindingEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "WidgetValidation.h"
#import "Validator.h"
#import "Controller.h"

@interface ValidatorBindingEvent : Event
{
    Validator *validator;
    Controller *controller;
    NSString *identifier;
}

@property (retain, nonatomic) Controller *controller;
@property (retain, nonatomic) Validator *validator;
@property (retain, nonatomic) NSString *identifier;

+(id) eventWithController: (Controller *) controller validator: (Validator *) validator identifier: (NSString *) identifier;

@end