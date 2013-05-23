// static: Events
//
//  WriteEntitySelectorSelectionEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WriteEntitySelectorSelectionEvent.h"

@implementation WriteEntitySelectorSelectionEvent

@synthesize entitySelectorSelectionChangedEvent, tabBarController, controller;

+(id) eventWithEvent: (EntitySelectorSelectionChangedEvent *) entitySelectorSelectionChangedEvent tabBarController: (UITabBarController *) tabBarController controller: (Controller *) controller
{
    WriteEntitySelectorSelectionEvent *event = [[WriteEntitySelectorSelectionEvent alloc] init];
    event.entitySelectorSelectionChangedEvent = entitySelectorSelectionChangedEvent;
    event.tabBarController = tabBarController;
    event.controller = controller;
    return event;
}

@end