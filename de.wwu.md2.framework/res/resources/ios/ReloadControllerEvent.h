// static: Events
//
//  ReloadControllerEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Controller.h"

@interface ReloadControllerEvent : Event
{
    Controller *controller;
}

@property (retain, nonatomic) Controller *controller;

+(id) eventWithController: (Controller *) controller;

@end