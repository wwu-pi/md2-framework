// static: Events
//
//  ShowDatePickerControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ShowDatePickerControllerEvent.h"

@implementation ShowDatePickerControllerEvent

@synthesize datePickerButtonClickedEvent, popoverController, pickerController, controller;

+(id) eventWithEvent: (DatePickerButtonClickedEvent *) datePickerButtonClickedEvent popoverController: (UIPopoverController *) popoverController pickerController: (PickerController *) pickerController controller: (Controller *) controller
{
    ShowDatePickerControllerEvent *event = [[ShowDatePickerControllerEvent alloc] init];
    event.datePickerButtonClickedEvent = datePickerButtonClickedEvent;
    event.popoverController = popoverController;
    event.pickerController = pickerController;
    event.controller = controller;
    return event;
}

@end