// static: Events
//
//  GotoControllerEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Controller.h"
#import "Workflow.h"

@interface GotoControllerEvent : Event
{
    UIWindow *window;
    UITabBarController *tabBarController;
    Controller *currentController;
    Controller *nextController;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) Controller *currentController;
@property (retain, nonatomic) Controller *nextController;

+(id) eventWithWindow: (UIWindow *) window tabBarController: (UITabBarController *) tabBarController currentController: (Controller *) currentController nextController: (Controller *) nextController;

@end