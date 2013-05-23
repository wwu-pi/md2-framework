// static: Events
//
//  EventBindingEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Action.h"
#import "Controller.h"

@interface EventBindingEvent : Event
{
    NSMutableDictionary *eventActionMapping;
    ViewEvent *viewEvent;
    Action *action;
}

@property (retain, nonatomic) NSMutableDictionary *eventActionMapping;
@property (retain, nonatomic) ViewEvent *viewEvent;
@property (retain, nonatomic) Action *action;

+(id) eventWithMapping: (NSMutableDictionary *) eventActionMapping action: (Action *) action;
+(id) eventWithMapping: (NSMutableDictionary *) eventActionMapping viewEvent: (ViewEvent *) viewEvent action: (Action *) action;

@end