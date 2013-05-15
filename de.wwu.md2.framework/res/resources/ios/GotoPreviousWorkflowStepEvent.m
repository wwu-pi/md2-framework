// static: Events
//
//  ForwardsToNextControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoPreviousWorkflowStepEvent.h"

@implementation GotoPreviousWorkflowStepEvent

@synthesize tabBarController, controller;

+(id) eventWithTabBarController: (UITabBarController *) tabBarController controller: (Controller *) controller
{
    GotoPreviousWorkflowStepEvent *event = [[GotoPreviousWorkflowStepEvent alloc] init];
    event.tabBarController = tabBarController;
    event.controller = controller;
    return event;
}

@end