// static: Events
//
//  ExitApplicationEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ExitApplicationEvent.h"

@implementation ExitApplicationEvent

@synthesize controller;

+(id) eventWithController: (Controller *) controller
{
    ExitApplicationEvent *event = [[ExitApplicationEvent alloc] init];
    event.controller = controller;
    return event;
}

@end