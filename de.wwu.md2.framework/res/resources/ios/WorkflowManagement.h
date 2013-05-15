// static: Workflows
//
//  WorkflowManagement.h
//  TariffCalculator
//
//  Created by Uni Münster on 23.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Workflow.h"

@interface WorkflowManagement : NSObject
{
    NSMutableArray *workflows;
    int currentWorkflowIndex;
}

@property (retain, nonatomic) NSMutableArray *workflows;

+(id) workflowManagementWithWorkflows: (NSArray *) workflows;

-(Workflow *) getCurrentWorkflow;

-(BOOL) switchToWorkflowByName: (NSString *) name;
-(BOOL) switchToNextWorkflow;
-(BOOL) switchToPreviousWorkflow;

@end