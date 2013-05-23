// static: Actions
//
//  ValidatorBindingAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ValidatorBindingAction.h"

@implementation ValidatorBindingAction

+(void) performAction: (Event *) event
{
    ValidatorBindingEvent *_event = (ValidatorBindingEvent *) event;
    
    Widget *widget = (Widget *) [_event.controller getViewByIdentifier: _event.identifier];
    [widget.validation addValidator: _event.validator];
}

@end