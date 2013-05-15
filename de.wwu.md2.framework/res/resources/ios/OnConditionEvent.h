// static: Events
//
//  OnConditionEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 25.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Controller.h"
#import "Condition.h"

@interface OnConditionEvent : Event
{
    BOOL wasPerformed;
    Condition *condition;
}

-(BOOL) containsIdentifier: (NSString *) identifier;
-(BOOL) checkCondition;

@end