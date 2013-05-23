// static: Events
//
//  BackwardsToLastControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoNextWorkflowStepEvent.h"

@implementation GotoNextWorkflowStepEvent

@synthesize tabBarController, controller;

+(id) eventWithTabBarController: (UITabBarController *) tabBarController controller: (Controller *) controller
{
    GotoNextWorkflowStepEvent *event = [[GotoNextWorkflowStepEvent alloc] init];
    event.tabBarController = tabBarController;
    event.controller = controller;
    return event;
}

@end