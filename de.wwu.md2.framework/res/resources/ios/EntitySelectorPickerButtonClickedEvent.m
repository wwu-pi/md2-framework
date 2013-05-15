// static: Events
//
//  EntitySelectorPickerButtonClickedEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EntitySelectorPickerButtonClickedEvent.h"

@implementation EntitySelectorPickerButtonClickedEvent

@synthesize sender, comboboxWidget;

+(id) eventWithSender: (id) _sender widget: (ComboboxWidget *) _comboboxWidget
{
    EntitySelectorPickerButtonClickedEvent *event = [[EntitySelectorPickerButtonClickedEvent alloc] init];
    event.sender = _sender;
    event.comboboxWidget = _comboboxWidget;
    return event;
}

@end