// static: Actions
//
//  WriteComboBoxSelectionAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WriteComboBoxSelectionAction.h"

@implementation WriteComboBoxSelectionAction

+(void) performAction: (Event *) event
{
    WriteComboBoxSelectionEvent *_event = (WriteComboBoxSelectionEvent *) event;
    
    [_event.controller writeComboBoxSelection: _event.pickerSelectionChangedEvent.selection identifier: _event.pickerSelectionChangedEvent.identifier];
}

@end