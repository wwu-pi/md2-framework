// static: Events
//
//  ComboboxDatePickerButtonClickedEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "DatePickerButtonClickedEvent.h"

@implementation DatePickerButtonClickedEvent

@synthesize sender, comboboxWidget;

+(id) eventWithSender: (id) _sender widget: (ComboboxWidget *) _comboboxWidget
{
    DatePickerButtonClickedEvent *event = [[DatePickerButtonClickedEvent alloc] init];
    event.sender = _sender;
    event.comboboxWidget = _comboboxWidget;
    return event;
}

@end