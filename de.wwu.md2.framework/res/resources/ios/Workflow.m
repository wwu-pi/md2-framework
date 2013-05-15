// static: Workflows
//
//  Workflow.m
//  TariffCalculator
//
//  Created by Uni Münster on 09.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Workflow.h"

@implementation Workflow

@synthesize name, workflowSteps;

+(id) workflowWithName: (NSString *) name workflowSteps: (NSArray *) workflowSteps
{
    Workflow *workflow = [[Workflow alloc] init];
    workflow.workflowSteps = [NSMutableArray arrayWithArray: workflowSteps];
    return workflow;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        name = [NSString stringWithFormat: @""];
        workflowSteps = [[NSMutableArray alloc] init];
        currentWorkflowStepIndex = 0;
    }
    return self;
}

-(WorkflowStep *) getCurrentWorkflowStep
{
    if (workflowSteps.count > 0)
        return [workflowSteps objectAtIndex: currentWorkflowStepIndex];
    return nil;
}
-(BOOL) switchToWorkflowStepByController: (Controller *) controller
{
    for (WorkflowStep *step in workflowSteps)
        if ([step.controller isEqual: controller])
            return [self switchToWorkflowStepByName: step.name];
    return YES;
}

-(BOOL) switchToWorkflowStepByName: (NSString *) _name
{
    if (currentWorkflowStepIndex < workflowSteps.count - 1)
    {
        int i;
        for (i = 0; i < workflowSteps.count - 1; i++)
            if ([[[workflowSteps objectAtIndex: i] name] isEqualToString: _name])
                break;
        
        int curIndex = currentWorkflowStepIndex;
        BOOL isSwitchAllowed = NO;
        if (i < currentWorkflowStepIndex)
            for (int j = currentWorkflowStepIndex; j > i; j--)
                isSwitchAllowed = [self switchToPreviousWorkflowStep];
        else if (i > currentWorkflowStepIndex)
            for (int j = currentWorkflowStepIndex; j < i; j++)
                isSwitchAllowed = [self switchToNextWorkflowStep];
        if (!isSwitchAllowed)
            currentWorkflowStepIndex = curIndex;
        return isSwitchAllowed;
    }
    return YES;
}

-(BOOL) switchToNextWorkflowStep
{
    if (currentWorkflowStepIndex < workflowSteps.count - 1)
    {
        if ([[workflowSteps objectAtIndex: currentWorkflowStepIndex] checkForwardCondition])
        {
            currentWorkflowStepIndex++;
            return YES;
        }
        return NO;
    }
    return YES;
}

-(BOOL) switchToPreviousWorkflowStep
{
    if (currentWorkflowStepIndex > 0)
    {
        if ([[workflowSteps objectAtIndex: currentWorkflowStepIndex] checkBackwardCondition])
        {
            currentWorkflowStepIndex--;
            return YES;
        }
        return NO;
    }
    return YES;
}

@end