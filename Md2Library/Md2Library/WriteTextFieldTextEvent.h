// static: Events
//
//  WriteTextFieldTextEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "SwitchValueChangedEvent.h"
#import "Controller.h"

@interface WriteTextFieldTextEvent : Event
{
    TextFieldEditingChangedEvent *textFieldEditingChangedEvent;
    Controller *controller;
}

@property (retain, nonatomic) TextFieldEditingChangedEvent *textFieldEditingChangedEvent;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithEvent: (TextFieldEditingChangedEvent *) textFieldEditingChangedEvent controller: (Controller *) controller;

@end