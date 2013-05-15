// static: Actions
//
//  WriteTextFieldTextAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WriteTextFieldTextAction.h"

@implementation WriteTextFieldTextAction

+(void) performAction: (Event *) event
{
    WriteTextFieldTextEvent *_event = (WriteTextFieldTextEvent *) event;
    
    [_event.controller writeTextFieldText: _event.textFieldEditingChangedEvent.text identifier: _event.textFieldEditingChangedEvent.identifier];
}

@end