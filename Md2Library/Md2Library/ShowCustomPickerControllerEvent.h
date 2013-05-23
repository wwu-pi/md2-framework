// static: Events
//
//  ShowCustomPickerControllerEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "CustomPickerButtonClickedEvent.h"
#import "PickerController.h"
#import "Controller.h"

@interface ShowCustomPickerControllerEvent : Event
{
    CustomPickerButtonClickedEvent *customPickerButtonClickedEvent;
    UIPopoverController *popoverController;
    PickerController *pickerController;
    Controller *controller;
}

@property (retain, nonatomic) CustomPickerButtonClickedEvent *customPickerButtonClickedEvent;
@property (retain, nonatomic) UIPopoverController *popoverController;
@property (retain, nonatomic) PickerController *pickerController;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithEvent: (CustomPickerButtonClickedEvent *) customPickerButtonClickedEvent popoverController: (UIPopoverController *) popoverController pickerController: (PickerController *) pickerController controller: (Controller *) controller;

@end