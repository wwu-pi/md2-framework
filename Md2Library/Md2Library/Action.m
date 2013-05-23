// static: Actions
//
//  Action.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Action.h"

@implementation Action

@synthesize event;

+(id) action
{
    Action *action = [[self alloc] init];
    action.event = [Event event];
    return action;
}

+(id) actionWithEvent: (Event *) event
{
    Action *action = [[self alloc] init];
    action.event = event;
    return action;
}

//Dummy method
+(void) performAction {}

//Should be overridden by subclass
+(void) performAction: (Event *) event
{
    [self doesNotRecognizeSelector:_cmd];
}

//Should be overridden by subclass
+(void) performCustomAction
{
    [self doesNotRecognizeSelector:_cmd];
}

@end