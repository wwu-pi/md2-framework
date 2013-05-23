// static: Actions
//
//  WriteEntitySelectorSelectionAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WriteEntitySelectorSelectionAction.h"

@implementation WriteEntitySelectorSelectionAction

+(void) performAction: (Event *) event
{
    WriteEntitySelectorSelectionEvent *_event = (WriteEntitySelectorSelectionEvent *) event;
    
    [_event.controller writeComboBoxSelection: _event.entitySelectorSelectionChangedEvent.selection identifier: _event.entitySelectorSelectionChangedEvent.identifier];
}

@end