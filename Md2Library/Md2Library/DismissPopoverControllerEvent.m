// static: Events
//
//  DismissPopoverControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "DismissPopoverControllerEvent.h"

@implementation DismissPopoverControllerEvent

@synthesize tabBarController, popoverController, controller;

+(id) eventWithTabBarController: (UITabBarController *) tabBarController popoverController: (UIPopoverController *) popoverController controller: (Controller *) controller
{
    DismissPopoverControllerEvent *event = [[DismissPopoverControllerEvent alloc] init];
    event.tabBarController = tabBarController;
    event.popoverController = popoverController;
    event.controller = controller;
    return event;
}

@end