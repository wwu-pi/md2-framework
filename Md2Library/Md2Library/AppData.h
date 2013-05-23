//
//  AppData.h
//
//  Generated by MD2 framework on Fri May 17 11:44:44 CEST 2013.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#define ModelVersion @"0.1"

#import "Event.h"
#import "Controller.h"
#import "PickerController.h"
#import "HelpController.h"
#import "SimpleViewController.h"
#import "LocalTestStoreContentProvider.h"
@class Workflow;
@class WorkflowManagement;
#import "GPSContentProvider.h"

@interface AppData : NSObject
{
    UIWindow *window;
    UITabBarController *tabBarController;
    UIPopoverController *popoverController;
	
    Controller *currentController;
    PickerController *pickerController;
    HelpController *helpController;
	SimpleViewController *simpleViewController;
	
	LocalTestStoreContentProvider *localTestStoreContentProvider;
	
	WorkflowManagement *workflowManagement;
	
	NSMutableDictionary *eventActionMapping;
	GPSContentProvider *gpsContentProvider;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) UIPopoverController *popoverController;

@property (retain, nonatomic) NSMutableArray *controllers;
@property (retain, nonatomic) Controller *currentController;
@property (retain, nonatomic) PickerController *pickerController;
@property (retain, nonatomic) HelpController *helpController;
@property (retain, nonatomic) SimpleViewController *simpleViewController;

@property (retain, nonatomic) LocalTestStoreContentProvider *localTestStoreContentProvider;

@property (retain, nonatomic) WorkflowManagement *workflowManagement;

@property (retain, nonatomic) NSMutableDictionary *eventActionMapping;
@property (retain, nonatomic) GPSContentProvider *gpsContentProvider;

+(UIWindow *) window;
+(UITabBarController *) tabBarController;
+(UIPopoverController *) popoverController;
+(NSArray *) controllers;
+(Controller *) currentController;
+(PickerController *) pickerController;
+(HelpController *) helpController;
+(SimpleViewController *) simpleViewController;
+(LocalTestStoreContentProvider *) localTestStoreContentProvider;
+(WorkflowManagement *) workflowManagement;
+(NSMutableDictionary *) eventActionMapping;
+(GPSContentProvider *) gpsContentProvider;

+(void) setWindow: (UIWindow *) window;
+(void) setTabBarController: (UITabBarController *) tabBarController;
+(void) setPopoverController: (UIPopoverController *) popoverController;
+(void) setControllers: (NSArray *) controllers;
+(void) setCurrentController: (Controller *) currentController;
+(void) setPickerController: (PickerController *) pickerController;
+(void) setHelpController: (HelpController *) helpController;
+(void) setSimpleViewController: (SimpleViewController *) simpleViewController;
+(void) setLocalTestStoreContentProvider: (LocalTestStoreContentProvider *) localTestStoreContentProvider;
+(void) setWorkflowManagement: (WorkflowManagement *) workflowManagement;
+(void) setEventActionMapping: (NSMutableDictionary *) eventActionMapping;
+(void) setGPSContentProvider: (GPSContentProvider *) gpsContentProvider;

@end