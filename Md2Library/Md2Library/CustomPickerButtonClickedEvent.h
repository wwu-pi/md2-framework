// static: Events
//
//  ComboboxCustomPickerButtonClickedEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
@class ComboboxWidget;

@interface CustomPickerButtonClickedEvent : Event
{
    id sender;
    ComboboxWidget *comboboxWidget;
}

@property (retain, nonatomic) id sender;
@property (retain, nonatomic) ComboboxWidget *comboboxWidget;

+(id) eventWithSender: (id) _sender widget: (ComboboxWidget *) _comboboxWidget;

@end