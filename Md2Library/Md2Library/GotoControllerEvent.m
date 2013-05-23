// static: Events
//
//  GotoControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoControllerEvent.h"

@implementation GotoControllerEvent

@synthesize window, tabBarController, currentController, nextController;

+(id) eventWithWindow: (UIWindow *) window tabBarController: (UITabBarController *) tabBarController currentController: (Controller *) currentController nextController: (Controller *) nextController
{
    GotoControllerEvent *event = [[GotoControllerEvent alloc] init];
    event.window = window;
    event.tabBarController = tabBarController;
    event.currentController = currentController;
    event.nextController = nextController;
    return event;
}

@end