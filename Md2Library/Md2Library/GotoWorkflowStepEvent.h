// static: Events
//
//  GotoWorkflowStepEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 23.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"

@interface GotoWorkflowStepEvent : Event
{
    NSString *workflowStepName;
}

@property (retain, nonatomic) NSString *workflowStepName;

+(id) eventWithWorkflowStepName: (NSString *) workflowStepName;

@end