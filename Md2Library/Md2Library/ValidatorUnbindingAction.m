// static: Actions
//
//  ValidatorUnbindingAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ValidatorUnbindingAction.h"

@implementation ValidatorUnbindingAction

+(void) performAction: (Event *) event
{
    ValidatorUnbindingEvent *_event = (ValidatorUnbindingEvent *) event;
    
    if (isDebug)
        NSLog(@"_event.identifier=%@", _event.identifier);
    Widget *widget = (Widget *) [_event.controller getViewByIdentifier: _event.identifier];
    if (isDebug)
        NSLog(@"widget=%@", widget);
    [widget.validation removeValidator: _event.validator];
}

@end