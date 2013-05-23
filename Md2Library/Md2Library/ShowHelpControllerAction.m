// static: Actions
//
//  ShowHelpControllerAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ShowHelpControllerAction.h"

@implementation ShowHelpControllerAction

+(void) performAction: (Event *) event
{
    ShowHelpControllerEvent *_event = (ShowHelpControllerEvent *) event;
    
    [AppData setHelpController: [[HelpController alloc] init]];
    [[AppData helpController] loadView];
    [[AppData helpController] setHelpText: _event.infoButtonClickedEvent.infoText];
    [AppData helpController].modalPresentationStyle = UIModalPresentationPageSheet;
    
    if (isPad)
    {
        UIButton *button = ((UIButton *) _event.infoButtonClickedEvent.sender);
        [AppData setPopoverController: [[AppData popoverController] initWithContentViewController: [AppData helpController]]];
        [[AppData popoverController] presentPopoverFromRect: PopoverPositionFrame inView: _event.infoButtonClickedEvent.sender permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
    }
    else if (isPhone)
        [[AppData currentController] presentModalViewController: [AppData helpController] animated: YES];
}

@end