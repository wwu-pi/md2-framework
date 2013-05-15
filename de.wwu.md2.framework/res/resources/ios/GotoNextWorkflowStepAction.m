// static: Actions
//
//  ForwardsToNextControllerAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoNextWorkflowStepAction.h"
#import "ReloadControllerAction.h"
#import "WorkflowManagement.h"

@implementation GotoNextWorkflowStepAction

+(void) performAction: (Event *) event
{
    [[AppData currentController] persistData];
    
    if ([[[AppData workflowManagement] getCurrentWorkflow] switchToNextWorkflowStep])
    {
        NSInteger currentControllerIndex = [AppData tabBarController].selectedIndex;
        if (currentControllerIndex < [AppData tabBarController].viewControllers.count - 1)
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: LocalizedKeyString(@"err_title_workflow_backwards") message: LocalizedKeyString(@"err_workflow_backwards") delegate: nil cancelButtonTitle: LocalizedKeyString(@"err_button_workflow_backwards") otherButtonTitles: nil];
        [alert show];
    }
    [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: [AppData currentController]]];
}

@end