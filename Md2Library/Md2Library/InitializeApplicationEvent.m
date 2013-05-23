// static: Events
//
//  InitializeApplicationEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 21.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "InitializeApplicationEvent.h"

@implementation InitializeApplicationEvent

@synthesize window, appDelegate, tabBarController, popoverController, pickerController, helpController, controller;
@synthesize eventActionMapping;

+(id) eventWithWindow: (UIWindow *) window appDelegate: (AppDelegate *) appDelegate tabBarController: (UITabBarController *) tabBarController popoverController: (UIPopoverController *) popoverController pickerController: (PickerController *) pickerController helpController: (HelpController *) helpController controller: (Controller *) controller eventActionMapping: (NSMutableDictionary *) eventActionMapping
{
    InitializeApplicationEvent *event = [[InitializeApplicationEvent alloc] init];
    
    event.window = window;
    event.appDelegate = appDelegate;
    event.tabBarController = tabBarController;
    event.popoverController = popoverController;
    event.pickerController = pickerController;
    event.helpController = helpController;
    event.controller = controller;
    
    event.eventActionMapping = eventActionMapping;
    
    return event;
}

@end