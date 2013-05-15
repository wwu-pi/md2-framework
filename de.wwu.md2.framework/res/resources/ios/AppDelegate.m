// static: ActionHandling
//
//  AppDelegate.m
//  TariffCalculator
//
//	The AppDelegate represents the central hub for the whole application.
//
//  Created by Uni Muenster on 30.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "AppDelegate.h"
#import "InitializeApplicationAction.h"
#import "ShowHelpControllerAction.h"
#import "ShowCustomPickerControllerAction.h"
#import "ShowDatePickerControllerAction.h"
#import "DismissPopoverControllerAction.h"
#import "GotoPreviousWorkflowStepAction.h"
#import "GotoNextWorkflowStepAction.h"
#import "WriteComboBoxSelectionAction.h"
#import "WriteEntitySelectorSelectionAction.h"
#import "WriteTextFieldTextAction.h"
#import "WriteCheckboxValueAction.h"
#import "ReloadControllerAction.h"
#import "ExitApplicationAction.h"
#import "GotoControllerAction.h"
#import "InitializeApplicationEvent.h"
#import "OnConditionEvent.h"
#import "AppData.h"

@implementation AppDelegate

@synthesize appDelegateWidgetDelegate;

#pragma mark UIApplicationDelegate Methods

/*
*	Will be called if the application is initialized and initializes the instance attributes.
*/

-(BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
    [InitializeApplicationAction performAction: [InitializeApplicationEvent eventWithWindow: [AppData window] appDelegate: self tabBarController: [AppData tabBarController] popoverController: [AppData popoverController] pickerController: [AppData pickerController] helpController: [AppData helpController] controller: [AppData currentController] eventActionMapping: [AppData eventActionMapping]]];
    return YES;
}

/*
*	Will be called if the application is resigned active.
*/
- (void)applicationWillResignActive:(UIApplication *)application {}

/*
*	Will be called if the application is entering the background.
*/
- (void)applicationDidEnterBackground:(UIApplication *)application {}

/*
*	Will be called if the application is entering the foreground.
*/
- (void)applicationWillEnterForeground:(UIApplication *)application {}

/*
*	Will be called if the application is becoming active.
*/
- (void)applicationDidBecomeActive:(UIApplication *)application {}

/*
*	Will be called if the application is terminated and exits the application.
*/
- (void)applicationWillTerminate:(UIApplication *)application
{
    [ExitApplicationAction performAction: [ExitApplicationEvent eventWithController: [AppData currentController]]];
}

#pragma mark UIPopoverControllerDelegate Methods

/*
*	Will be called if the popover controller is dismissed.
*/
-(void) popoverControllerDidDismissPopover: (UIPopoverController *) _popoverController
{
    [DismissPopoverControllerAction performAction: [DismissPopoverControllerEvent eventWithTabBarController: [AppData tabBarController] popoverController: [AppData popoverController] controller: [AppData currentController]]];
}

#pragma mark UITabBarControllerDelegate Methods

/*
*	Will be called if a tab item is selected from the tab bar controller.
*/
-(void) tabBarController: (UITabBarController *) _tabBarController didSelectViewController: (UIViewController *) viewController
{
    Controller *nextController = ((Controller *) viewController);
    [GotoControllerAction performAction: [GotoControllerEvent eventWithWindow: [AppData window] tabBarController: [AppData tabBarController] currentController: [AppData currentController] nextController: nextController]];
    [AppData tabBarController].selectedViewController = [AppData currentController];
}

#pragma mark Action Methods

/*
*	Shows a custom picker with the help of the appropriate action.
*/
-(void) showCustomPickerControllerWithEvent: (CustomPickerButtonClickedEvent *) event
{
    [ShowCustomPickerControllerAction performAction: [ShowCustomPickerControllerEvent eventWithEvent: event popoverController: [AppData popoverController] pickerController: [AppData pickerController] controller: [AppData currentController]]];
}

/*
*	Shows a date picker with the help of the appropriate action.
*/
-(void) showDatePickerControllerWithEvent: (DatePickerButtonClickedEvent *) event
{
    [ShowDatePickerControllerAction performAction: [ShowDatePickerControllerEvent eventWithEvent: event popoverController: [AppData popoverController] pickerController: [AppData pickerController] controller: [AppData currentController]]];
}

-(void) showHelpControllerWithEvent: (InfoButtonClickedEvent *) event
{
    [ShowHelpControllerAction performAction: [ShowHelpControllerEvent eventWithEvent: event popoverController: [AppData popoverController] helpController: [AppData helpController] controller: [AppData currentController]]];
}

-(void) showEntitySelectorPickerControllerWithEvent: (EntitySelectorPickerButtonClickedEvent *) event
{
    [ShowCustomPickerControllerAction performAction: [ShowCustomPickerControllerEvent eventWithEvent: [CustomPickerButtonClickedEvent eventWithSender: event.sender widget: event.comboboxWidget] popoverController: [AppData popoverController] pickerController: [AppData pickerController] controller: [AppData currentController]]];
}

/*
*	Writes the combobox selection with the help of the appropriate action.
*/
-(void) writeComboBoxSelection: (ComboboxSelectionChangedEvent *) event
{
    [WriteComboBoxSelectionAction performAction: [WriteComboBoxSelectionEvent eventWithEvent: event tabBarController: [AppData tabBarController] controller: [AppData currentController]]];
    [self checkOnConditionEventsByIdentifier: event.identifier];
}
/*
 *	Writes the combobox selection with the help of the appropriate action.
 */
-(void) writeEntitySelectorSelection: (EntitySelectorSelectionChangedEvent *) event
{
    [WriteEntitySelectorSelectionAction performAction: [WriteEntitySelectorSelectionEvent eventWithEvent: event tabBarController: [AppData tabBarController] controller: [AppData currentController]]];
    [self checkOnConditionEventsByIdentifier: event.identifier];
}

/*
*	Writes the text field text with the help of the appropriate action.
*/
-(void) writeTextFieldText: (TextFieldEditingChangedEvent *) event
{
    [WriteTextFieldTextAction performAction: [WriteTextFieldTextEvent eventWithEvent: event controller: [AppData currentController]]];
    [self checkOnConditionEventsByIdentifier: event.identifier];
}

/*
*	Writes the checkbox value with the help of the appropriate action.
*/
-(void) writeCheckboxValue: (SwitchValueChangedEvent *) event
{
    [WriteCheckboxValueAction performAction: [WriteCheckboxValueEvent eventWithEvent: event controller: [AppData currentController]]];
    [self checkOnConditionEventsByIdentifier: event.identifier];
}

/*
*	Dismisses the popover controller with the help of the appropriate action.
*/
-(void) dismissPopoverController
{
    [DismissPopoverControllerAction performAction: [DismissPopoverControllerEvent eventWithTabBarController: [AppData tabBarController] popoverController: [AppData popoverController] controller: [AppData currentController]]];
}

/*
*	Reloads the current controller with the help of the appropriate action.
*/
-(void) reloadCurrentController
{
    [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: [AppData currentController]]];
}

#pragma mark Action Methods

/*
 *	Triggers on an event the appropriate action.
 */
-(void) triggerAction: (ViewEvent *) event
{
    NSMutableArray *actions = [NSMutableArray arrayWithArray: [[AppData eventActionMapping] objectForKey: [NSString stringWithFormat: @"%@_%i", event.identifier, event.eventType]]];
    if (actions != nil && actions.count > 0)
        for (Action *action in actions)
            [[action class] performAction: action.event];
}

/*
*	Checks the condition of the on condition events registered by identifier.
*/
-(void) checkOnConditionEventsByIdentifier: (NSString *) identifier
{
    for (id key in [AppData eventActionMapping].keyEnumerator)
    {
        if (![[key class] isSubclassOfClass: [NSString class]])     //Not bind to view event
        {
            if ([key isSubclassOfClass: [OnConditionEvent class]])  //Only consider onConditionEvents here
            {
                id event = [[key alloc] init];
                if ([event containsIdentifier: identifier])         //Check if event is relevant to changes
                {
                    if ([event checkCondition])                     //Check the result of the condition
                    {
                        NSMutableArray *actions = [NSMutableArray arrayWithArray: [[AppData eventActionMapping] objectForKey: key]];
                        if (actions != nil && actions.count > 0)
                            for (Action *action in actions)
                                [[action class] performAction: action.event];
                    }
                }
            }
        }
    }
}

@end