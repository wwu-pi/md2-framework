// static: Events
//
//  GotoWorkflowEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 29.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GotoWorkflowEvent.h"

@implementation GotoWorkflowEvent

@synthesize workflowName;

+(id) eventWithWorkflowName: (NSString *) workflowName
{
    GotoWorkflowEvent *event = [[GotoWorkflowEvent alloc] init];
    event.workflowName = workflowName;
    return event;
}

@end