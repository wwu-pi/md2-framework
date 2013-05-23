// static: Events
//
//  WriteComboBoxSelectionEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "ComboboxSelectionChangedEvent.h"
#import "Controller.h"

@interface WriteComboBoxSelectionEvent : Event
{
    ComboboxSelectionChangedEvent *pickerSelectionChangedEvent;
    UITabBarController *tabBarController;
    Controller *controller;
}

@property (retain, nonatomic) ComboboxSelectionChangedEvent *pickerSelectionChangedEvent;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithEvent: (ComboboxSelectionChangedEvent *) pickerSelectionChangedEvent tabBarController: (UITabBarController *) tabBarController controller: (Controller *) controller;

@end