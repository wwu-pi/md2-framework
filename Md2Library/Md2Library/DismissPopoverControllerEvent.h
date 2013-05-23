// static: Events
//
//  DismissPopoverControllerEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Controller.h"

@interface DismissPopoverControllerEvent : Event
{
    UITabBarController *tabBarController;
    UIPopoverController *popoverController;
    Controller *controller;
}

@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) UIPopoverController *popoverController;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithTabBarController: (UITabBarController *) tabBarController popoverController: (UIPopoverController *) popoverController controller: (Controller *) controller;

@end