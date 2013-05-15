// static: Events
//
//  ShowCustomPickerControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ShowCustomPickerControllerEvent.h"

@implementation ShowCustomPickerControllerEvent

@synthesize customPickerButtonClickedEvent, popoverController, pickerController, controller;

+(id) eventWithEvent: (CustomPickerButtonClickedEvent *) customPickerButtonClickedEvent popoverController: (UIPopoverController *) popoverController pickerController: (PickerController *) pickerController controller: (Controller *) controller
{
    ShowCustomPickerControllerEvent *event = [[ShowCustomPickerControllerEvent alloc] init];
    event.customPickerButtonClickedEvent = customPickerButtonClickedEvent;
    event.popoverController = popoverController;
    event.pickerController = pickerController;
    event.controller = controller;
    return event;
}

@end