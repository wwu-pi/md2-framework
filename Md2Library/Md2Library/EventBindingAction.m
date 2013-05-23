// static: Actions
//
//  EventBindingAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EventBindingAction.h"

@implementation EventBindingAction

+(void) performAction: (Event *) event
{
    EventBindingEvent *_event = (EventBindingEvent *) event;
    
    id key = @"";
    if (_event.viewEvent != nil)
        key = [NSString stringWithFormat: @"%@_%i", _event.viewEvent.identifier, _event.viewEvent.eventType];
    else if (_event.action != nil)
        key = [_event.action.event class];
    
    NSMutableArray *actions = nil;
    if ([_event.eventActionMapping objectForKey: key] == nil)
        actions = [[NSMutableArray alloc] init];
    actions = [NSMutableArray arrayWithArray: [_event.eventActionMapping objectForKey: key]];
    [actions addObject: _event.action];
    
    [_event.eventActionMapping setObject: actions forKey: key];
}

@end