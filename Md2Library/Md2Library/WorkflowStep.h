// static: Workflows
//
//  WorkflowStep.h
//  TariffCalculator
//
//  Created by Uni Münster on 09.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Condition.h"
#import "Controller.h"

@interface WorkflowStep : NSObject
{
    NSString *name;
    Controller *controller;
    Condition *forwardCondition;
    Condition *backwardCondition;
}

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) Controller *controller;
@property (retain, nonatomic) Condition *forwardCondition;
@property (retain, nonatomic) Condition *backwardCondition;

+(id) stepWithName: (NSString *) name controller: (Controller *) controller forwardCondition: (Condition *) fwdCondition backwardCondition: (Condition *) bwdCondition;
-(BOOL) checkForwardCondition;
-(BOOL) checkBackwardCondition;

@end