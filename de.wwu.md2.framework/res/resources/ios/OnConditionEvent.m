// static: Events
//
//  OnConditionEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 25.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "OnConditionEvent.h"

@implementation OnConditionEvent

-(id) initWithCondition: (Condition *) cond
{
    self = [super init];
    if (self)
    {
        condition = cond;
    }
    return self;
}

-(BOOL) containsIdentifier: (NSString *) identifier
{
    if (!wasPerformed)
        return [condition containsIdentifier: identifier];
    return NO;
}

-(BOOL) checkCondition
{
    if (!wasPerformed)
        return [condition checkCondition];
    return NO;
}

@end