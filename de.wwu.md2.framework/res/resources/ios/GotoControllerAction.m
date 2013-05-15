// static: Actions
//
//  GotoControllerAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoControllerAction.h"
#import "ReloadControllerAction.h"
#import "WorkflowManagement.h"

@implementation GotoControllerAction

+(void) performAction: (Event *) event
{
    GotoControllerEvent *_event = (GotoControllerEvent *) event;
    [[AppData currentController] persistData];
    
    if ([[AppData currentController] isEqual: [[[AppData workflowManagement] getCurrentWorkflow] getCurrentWorkflowStep].controller])
    {
        if ([[[AppData workflowManagement] getCurrentWorkflow] switchToWorkflowStepByController: _event.nextController])
        {
            if ([AppData tabBarController] != nil)
            {
                [AppData window].rootViewController = [AppData tabBarController];
                [AppData tabBarController].selectedViewController = _event.nextController;
            }
            else
                [AppData window].rootViewController = _event.nextController;
            [AppData setCurrentController: _event.nextController];
            [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: _event.nextController]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: LocalizedKeyString(@"err_title_workflow_backwards") message: LocalizedKeyString(@"err_workflow_backwards") delegate: nil cancelButtonTitle: LocalizedKeyString(@"err_button_workflow_backwards") otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        if ([AppData tabBarController] != nil)
        {
            [AppData window].rootViewController = [AppData tabBarController];
            [AppData tabBarController].selectedViewController = _event.nextController;
        }
        else
            [AppData window].rootViewController = _event.nextController;
        [AppData setCurrentController: _event.nextController];
        [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: _event.nextController]];
    }
}

@end