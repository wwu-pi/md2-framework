// static: Events
//
//  InitializeApplicationEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 21.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Controller.h"
#import "HelpController.h"
#import "PickerController.h"
#import "AppDelegate.h"

@interface InitializeApplicationEvent : Event
{
    UIWindow *window;
    UITabBarController *tabBarController;
    UIPopoverController *popoverController;
    
    AppDelegate *appDelegate;
    
    PickerController *pickerController;
    HelpController *helpController;
    Controller *controller;
    
    NSMutableDictionary *eventActionMapping;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) AppDelegate *appDelegate;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) UIPopoverController *popoverController;
@property (retain, nonatomic) PickerController *pickerController;
@property (retain, nonatomic) HelpController *helpController;
@property (retain, nonatomic) Controller *controller;

@property (retain, nonatomic) NSMutableDictionary *eventActionMapping;

+(id) eventWithWindow: (UIWindow *) window appDelegate: (AppDelegate *) appDelegate tabBarController: (UITabBarController *) tabBarController popoverController: (UIPopoverController *) popoverController pickerController: (PickerController *) pickerController helpController: (HelpController *) helpController controller: (Controller *) controller eventActionMapping: (NSMutableDictionary *) eventActionMapping;

@end