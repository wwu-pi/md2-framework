// static: Events
//
//  GotoWorkflowStepEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 23.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoWorkflowStepEvent.h"

@implementation GotoWorkflowStepEvent

@synthesize workflowStepName;

+(id) eventWithWorkflowStepName: (NSString *) workflowStepName
{
    GotoWorkflowStepEvent *event = [[GotoWorkflowStepEvent alloc] init];
    event.workflowStepName = workflowStepName;
    return event;
}

@end