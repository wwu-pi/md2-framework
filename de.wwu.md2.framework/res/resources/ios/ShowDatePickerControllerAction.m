// static: Actions
//
//  ShowDatePickerControllerAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ShowDatePickerControllerAction.h"

@implementation ShowDatePickerControllerAction

+(void) performAction: (Event *) event
{
    ShowDatePickerControllerEvent *_event = (ShowDatePickerControllerEvent *) event;
    
    [AppData setPickerController: [[PickerController alloc] init]];
    [[AppData pickerController] loadView];
    [[AppData pickerController] setComboboxWidget: _event.datePickerButtonClickedEvent.comboboxWidget];
    [AppData pickerController].modalPresentationStyle = UIModalPresentationPageSheet;
    
    if (isPad)
    {
        UIButton *button = ((UIButton *) _event.datePickerButtonClickedEvent.sender);
        [AppData setPopoverController: [[AppData popoverController] initWithContentViewController: [AppData pickerController]]];
        [[AppData popoverController] presentPopoverFromRect: PopoverPositionFrame inView: _event.datePickerButtonClickedEvent.sender permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
    }
    else if (isPhone)
        [[AppData currentController] presentModalViewController: [AppData pickerController] animated: YES];
}

@end