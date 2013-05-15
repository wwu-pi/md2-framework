// static: Events
//
//  WriteEntitySelectorSelectionEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "EntitySelectorSelectionChangedEvent.h"
#import "Controller.h"

@interface WriteEntitySelectorSelectionEvent : Event
{
    EntitySelectorSelectionChangedEvent *entitySelectorSelectionChangedEvent;
    UITabBarController *tabBarController;
    Controller *controller;
}

@property (retain, nonatomic) EntitySelectorSelectionChangedEvent *entitySelectorSelectionChangedEvent;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithEvent: (EntitySelectorSelectionChangedEvent *) entitySelectorSelectionChangedEvent tabBarController: (UITabBarController *) tabBarController controller: (Controller *) controller;

@end