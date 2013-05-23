// static: Workflows
//
//  WorkflowManagement.m
//  TariffCalculator
//
//  Created by Uni Münster on 23.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WorkflowManagement.h"

@implementation WorkflowManagement

@synthesize workflows;

+(id) workflowManagementWithWorkflows: (NSArray *) workflows
{
    WorkflowManagement *workflowManagement = [[WorkflowManagement alloc] init];
    workflowManagement.workflows = [NSMutableArray arrayWithArray: workflows];
    return workflowManagement;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        workflows = [[NSMutableArray alloc] init];
        currentWorkflowIndex = 0;
    }
    return self;
}

-(Workflow *) getCurrentWorkflow
{
    if (workflows.count > 0)
        return [workflows objectAtIndex: currentWorkflowIndex];
    return nil;
}

-(BOOL) switchToWorkflowByName: (NSString *) name
{
    if (currentWorkflowIndex < workflows.count - 1 && currentWorkflowIndex > 0)
    {
        int i;
        for (i = 0; i < workflows.count - 1; i++)
            if ([[[workflows objectAtIndex: i] name] isEqualToString: name])
                break;
        
        if (i < currentWorkflowIndex)
            for (int j = currentWorkflowIndex; j > i; j--)
                [[workflows objectAtIndex: i] switchToPreviousWorkflowStep];
        else if (i > currentWorkflowIndex)
            for (int j = currentWorkflowIndex; j < i; j++)
                [[workflows objectAtIndex: i] switchToNextWorkflowStep];
        else
            return NO;
        return YES;
    }
    return NO;
}

-(BOOL) switchToNextWorkflow
{
    if (currentWorkflowIndex < workflows.count - 1)
    {
        if ([[workflows objectAtIndex: currentWorkflowIndex] checkForwardCondition])
        {
            currentWorkflowIndex++;
            return YES;
        }
    }
    return NO;
}

-(BOOL) switchToPreviousWorkflow
{
    if (currentWorkflowIndex < workflows.count - 1)
    {
        if ([[workflows objectAtIndex: currentWorkflowIndex] checkBackwardCondition])
        {
            currentWorkflowIndex--;
            return YES;
        }
    }
    return NO;
}

@end