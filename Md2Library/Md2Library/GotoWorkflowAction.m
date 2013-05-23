// static: Actions
//
//  GotoWorkflowAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 29.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoWorkflowAction.h"
#import "WorkflowManagement.h"

@implementation GotoWorkflowAction

+(void) performAction: (Event *) event
{
    GotoWorkflowEvent *_event = (GotoWorkflowEvent *) event;
    
    [[AppData workflowManagement] switchToWorkflowByName: _event.workflowName];
}

@end