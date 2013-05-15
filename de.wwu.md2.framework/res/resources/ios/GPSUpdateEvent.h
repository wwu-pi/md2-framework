// static: Events
//
//  GPSUpdateEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "GPSActionBinding.h"

@interface GPSUpdateEvent : Event
{
    NSArray *bindings;
}

@property (retain, nonatomic) NSArray *bindings;

+(id) eventWithBindings: (NSArray *) bindings;

@end