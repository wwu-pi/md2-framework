// static: Actions
//
//  EventUnbindingAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 25.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EventUnbindingAction.h"

@implementation EventUnbindingAction

+(void) performAction: (Event *) event
{
    EventUnbindingEvent *_event = (EventUnbindingEvent *) event;
    
    id key = @"";
    if (_event.viewEvent != nil)
        key = [NSString stringWithFormat: @"%@_%i", _event.viewEvent.identifier, _event.viewEvent.eventType];
    else if (_event.action != nil)
        key = [_event.action.event class];
    
    NSMutableArray *actions = [NSMutableArray arrayWithArray: [_event.eventActionMapping objectForKey: key]];
    [actions removeObject: _event.action];
    if (actions.count == 0)
        [_event.eventActionMapping removeObjectForKey: key];
    else
        [_event.eventActionMapping setObject: actions forKey: key];
}

@end