// static: Workflows
//
//  WorkflowStep.m
//  TariffCalculator
//
//  Created by Uni Münster on 09.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WorkflowStep.h"

@implementation WorkflowStep

@synthesize name, controller, forwardCondition, backwardCondition;

+(id) stepWithName: (NSString *) name controller: (Controller *) controller forwardCondition: (Condition *) fwdCondition backwardCondition: (Condition *) bwdCondition
{
    WorkflowStep *step = [[WorkflowStep alloc] init];
    step.name = name;
    step.controller = controller;
    step.forwardCondition = fwdCondition;
    step.backwardCondition = bwdCondition;
    return step;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        name = [NSString stringWithFormat: @""];
        controller = [[Controller alloc] init];
        forwardCondition = [[Condition alloc] init];
        backwardCondition = [[Condition alloc] init];
    }
    return self;
}

-(BOOL) checkForwardCondition
{
    if (forwardCondition != nil)
        return [forwardCondition checkCondition];
    return YES;
}

-(BOOL) checkBackwardCondition
{
    if (backwardCondition != nil)
        return [backwardCondition checkCondition];
    return YES;
}

@end