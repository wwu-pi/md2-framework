// static: Workflows
//
//  Workflow.h
//  TariffCalculator
//
//  Created by Uni Münster on 09.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WorkflowStep.h"

@interface Workflow : NSObject
{
    NSString *name;
    NSMutableArray *workflowSteps;
    int currentWorkflowStepIndex;
}

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSMutableArray *workflowSteps;

+(id) workflowWithName: (NSString *) name workflowSteps: (NSArray *) workflowSteps;

-(WorkflowStep *) getCurrentWorkflowStep;

-(BOOL) switchToWorkflowStepByController: (Controller *) controller;
-(BOOL) switchToWorkflowStepByName: (NSString *) name;
-(BOOL) switchToNextWorkflowStep;
-(BOOL) switchToPreviousWorkflowStep;

@end