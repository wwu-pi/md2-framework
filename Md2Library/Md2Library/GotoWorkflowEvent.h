// static: Events
//
//  GotoWorkflowEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 29.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"

@interface GotoWorkflowEvent : Event
{
    NSString *workflowName;
}

@property (retain, nonatomic) NSString *workflowName;

+(id) eventWithWorkflowName: (NSString *) workflowName;

@end