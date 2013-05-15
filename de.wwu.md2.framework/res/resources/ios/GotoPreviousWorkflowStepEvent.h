// static: Events
//
//  ForwardsToNextControllerEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Controller.h"

@interface GotoPreviousWorkflowStepEvent : Event
{
    UITabBarController *tabBarController;
    Controller *controller;
}

@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithTabBarController: (UITabBarController *) tabBarController controller: (Controller *) controller;

@end