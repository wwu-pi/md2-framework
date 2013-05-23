// static: Actions
//
//  WriteCheckboxValueAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WriteCheckboxValueAction.h"

@implementation WriteCheckboxValueAction

+(void) performAction: (Event *) event
{
    WriteCheckboxValueEvent *_event = (WriteCheckboxValueEvent *) event;
    
    [_event.controller writeCheckboxValue: _event.switchValueChangedEvent.isEnabled identifier: _event.switchValueChangedEvent.identifier];
}

@end