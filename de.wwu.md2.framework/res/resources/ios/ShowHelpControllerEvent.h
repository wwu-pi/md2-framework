// static: Events
//
//  ShowHelpControllerEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "HelpController.h"
#import "Controller.h"

@interface ShowHelpControllerEvent : Event
{
    InfoButtonClickedEvent *infoButtonClickedEvent;
    UIPopoverController *popoverController;
    HelpController *helpController;
    Controller *controller;
}

@property (retain, nonatomic) InfoButtonClickedEvent *infoButtonClickedEvent;
@property (retain, nonatomic) UIPopoverController *popoverController;
@property (retain, nonatomic) HelpController *helpController;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithEvent: (InfoButtonClickedEvent *) infoButtonClickedEvent popoverController: (UIPopoverController *) popoverController helpController: (HelpController *) helpController controller: (Controller *) controller;

@end