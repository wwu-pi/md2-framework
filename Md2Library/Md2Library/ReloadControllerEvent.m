// static: Events
//
//  ReloadControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ReloadControllerEvent.h"

@implementation ReloadControllerEvent

@synthesize controller;

+(id) eventWithController: (Controller *) controller
{
    ReloadControllerEvent *event = [[ReloadControllerEvent alloc] init];
    event.controller = controller;
    return event;
}

@end