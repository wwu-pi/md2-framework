// static: Actions
//
//  ShowCustomPickerControllerAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ShowCustomPickerControllerAction.h"

@implementation ShowCustomPickerControllerAction

+(void) performAction: (Event *) event
{
    ShowCustomPickerControllerEvent *_event = (ShowCustomPickerControllerEvent *) event;
    
    [AppData setPickerController: [[PickerController alloc] init]];
    [[AppData pickerController] loadView];
    [[AppData pickerController] setComboboxWidget: _event.customPickerButtonClickedEvent.comboboxWidget];
    [AppData pickerController].modalPresentationStyle = UIModalPresentationPageSheet;
    
    if (isPad)
    {
        UIButton *button = ((UIButton *) _event.customPickerButtonClickedEvent.sender);
        [AppData setPopoverController: [[AppData popoverController] initWithContentViewController: [AppData pickerController]]];
        [[AppData popoverController] presentPopoverFromRect: PopoverPositionFrame inView: _event.customPickerButtonClickedEvent.sender permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
    }
    else if (isPhone)
        [[AppData currentController] presentModalViewController: [AppData pickerController] animated: YES];
}

@end