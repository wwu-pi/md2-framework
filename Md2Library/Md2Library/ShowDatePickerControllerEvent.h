// static: Events
//
//  ShowDatePickerControllerEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "DatePickerButtonClickedEvent.h"
#import "PickerController.h"
#import "Controller.h"

@interface ShowDatePickerControllerEvent : Event
{
    DatePickerButtonClickedEvent *datePickerButtonClickedEvent;
    UIPopoverController *popoverController;
    PickerController *pickerController;
    Controller *controller;
}

@property (retain, nonatomic)  DatePickerButtonClickedEvent *datePickerButtonClickedEvent;
@property (retain, nonatomic) UIPopoverController *popoverController;
@property (retain, nonatomic) PickerController *pickerController;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithEvent: (DatePickerButtonClickedEvent *) datePickerButtonClickedEvent popoverController: (UIPopoverController *) popoverController pickerController: (PickerController *) pickerController controller: (Controller *) controller;

@end