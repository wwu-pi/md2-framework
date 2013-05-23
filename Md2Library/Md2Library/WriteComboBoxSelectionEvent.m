// static: Events
//
//  WriteComboBoxSelectionEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WriteComboBoxSelectionEvent.h"

@implementation WriteComboBoxSelectionEvent

@synthesize pickerSelectionChangedEvent, tabBarController, controller;

+(id) eventWithEvent: (ComboboxSelectionChangedEvent *) pickerSelectionChangedEvent tabBarController: (UITabBarController *) tabBarController controller: (Controller *) controller
{
    WriteComboBoxSelectionEvent *event = [[WriteComboBoxSelectionEvent alloc] init];
    event.pickerSelectionChangedEvent = pickerSelectionChangedEvent;
    event.tabBarController = tabBarController;
    event.controller = controller;
    return event;
}

@end