// static: Actions
//
//  GotoWorkflowStepAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 23.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoWorkflowStepAction.h"
#import "WorkflowManagement.h"
#import "ReloadControllerAction.h"

@implementation GotoWorkflowStepAction

+(void) performAction: (Event *) event
{
    GotoWorkflowStepEvent *_event = (GotoWorkflowStepEvent *) event;
    [[AppData currentController] persistData];
    
    if ([[[AppData workflowManagement] getCurrentWorkflow] switchToWorkflowStepByName: _event.workflowStepName])
    {
        NSUInteger currentControllerIndex = [AppData tabBarController].selectedIndex;
        if (currentControllerIndex > 0)
        {
            [AppData window].rootViewController = [AppData tabBarController];
            [AppData setCurrentController: [[AppData tabBarController].viewControllers objectAtIndex: --currentControllerIndex]];
            [AppData tabBarController].selectedViewController = [AppData currentController];
        }
        else if (currentControllerIndex < [AppData tabBarController].viewControllers.count - 1)
        {
            [AppData window].rootViewController = [AppData tabBarController];
            [AppData setCurrentController: [[AppData tabBarController].viewControllers objectAtIndex: ++currentControllerIndex]];
            [AppData tabBarController].selectedViewController = [AppData currentController];
        }
        else
            [AppData window].rootViewController = [[[AppData workflowManagement] getCurrentWorkflow] getCurrentWorkflowStep].controller;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: LocalizedKeyString(@"err_title_workflow_forwards") message: LocalizedKeyString(@"err_workflow_forwards") delegate: nil cancelButtonTitle: LocalizedKeyString(@"err_button_workflow_forwards") otherButtonTitles: nil];
        [alert show];
    }
    [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: [AppData currentController]]];
}

@end