//
//  AppData.m
//
//  Generated by MD2 framework on Fri May 17 11:44:44 CEST 2013.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "AppData.h"
@implementation AppData

static AppData *instance;

@synthesize window, tabBarController, popoverController;
@synthesize currentController, controllers, pickerController, helpController;
@synthesize simpleViewController;
@synthesize localTestStoreContentProvider;
@synthesize workflowManagement;
@synthesize eventActionMapping, gpsContentProvider;

#pragma mark Initialization Methods

+(AppData *) instance
{
	@synchronized([AppData class])
	{
		if (!instance)
			instance = [[self alloc] init];
		return instance;
	}
	return nil;
}

+(id) alloc
{
	@synchronized([AppData class])
	{
		NSAssert(instance == nil, @"Attempted to allocate a second instance of a singleton.");
		instance = [super alloc];
		return instance;
	}
	return nil;
}

+(id) init
{
    return [self init];
}

#pragma mark Static Accessor Methods

+(UIWindow *) window
{
    return [[AppData instance] window];
}

+(UITabBarController *) tabBarController
{
    return [[AppData instance] tabBarController];
}

+(UIPopoverController *) popoverController
{
    return [[AppData instance] popoverController];
}

+(NSArray *) controllers
{
    return [[AppData instance] controllers];
}

+(Controller *) currentController
{
    return [[AppData instance] currentController];
}

+(PickerController *) pickerController
{
    return [[AppData instance] pickerController];
}

+(HelpController *) helpController
{
    return [AppData instance].helpController;
}

+(SimpleViewController *) simpleViewController
{
    return [AppData instance].simpleViewController;
}


+(LocalTestStoreContentProvider *) localTestStoreContentProvider
{
    return [AppData instance].localTestStoreContentProvider;
}


+(WorkflowManagement *) workflowManagement
{
	return [AppData instance].workflowManagement;
}

+(NSMutableDictionary *) eventActionMapping
{
    return [AppData instance].eventActionMapping;
}

+(GPSContentProvider *) gpsContentProvider
{
    return [AppData instance].gpsContentProvider;
}

#pragma mark Static Manipulation Methods

+(void) setWindow: (UIWindow *) window
{
    [AppData instance].window = window;
}

+(void) setTabBarController: (UITabBarController *) tabBarController
{
    [AppData instance].tabBarController = tabBarController;
}

+(void) setPopoverController: (UIPopoverController *) popoverController
{
    [AppData instance].popoverController = popoverController;
}

+(void) setControllers: (NSArray *) controllers
{
    [AppData instance].controllers = [NSMutableArray arrayWithArray: controllers];
}

+(void) setCurrentController: (Controller *) currentController
{
    [AppData instance].currentController = currentController;
}

+(void) setPickerController: (PickerController *) pickerController
{
    [AppData instance].pickerController = pickerController;
}

+(void) setHelpController: (HelpController *) helpController
{
    [AppData instance].helpController = helpController;
}

+(void) setSimpleViewController: (SimpleViewController *) simpleViewController
{
    [AppData instance].simpleViewController = simpleViewController;
}


+(void) setLocalTestStoreContentProvider: (LocalTestStoreContentProvider *) localTestStoreContentProvider
{
    [AppData instance].localTestStoreContentProvider = localTestStoreContentProvider;
}


+(void) setWorkflowManagement: (WorkflowManagement *) workflowManagement
{
	[AppData instance].workflowManagement = workflowManagement;
}

+(void) setEventActionMapping: (NSMutableDictionary *) eventActionMapping
{
    [AppData instance].eventActionMapping = eventActionMapping;
}

+(void) setGPSContentProvider: (GPSContentProvider *) gpsContentProvider
{
    [AppData instance].gpsContentProvider = gpsContentProvider;
}

@end