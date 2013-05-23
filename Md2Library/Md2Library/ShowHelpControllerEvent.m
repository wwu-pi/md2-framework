// static: Events
//
//  ShowHelpControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ShowHelpControllerEvent.h"

@implementation ShowHelpControllerEvent

@synthesize infoButtonClickedEvent, popoverController, helpController, controller;

+(id) eventWithEvent: (InfoButtonClickedEvent *) infoButtonClickedEvent popoverController: (UIPopoverController *) popoverController helpController: (HelpController *) helpController controller: (Controller *) controller
{
    ShowHelpControllerEvent *event = [[ShowHelpControllerEvent alloc] init];
    event.infoButtonClickedEvent = infoButtonClickedEvent;
    event.popoverController = popoverController;
    event.helpController = helpController;
    event.controller = controller;
    return event;
}

@end