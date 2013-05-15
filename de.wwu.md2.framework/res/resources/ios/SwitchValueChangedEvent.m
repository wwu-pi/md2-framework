// static: Events
//
//  SwitchValueChangedEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "SwitchValueChangedEvent.h"

@implementation SwitchValueChangedEvent

@synthesize identifier, isEnabled;

+(id) eventWithIdentifier: (NSString *) _identifier isEnabled: (BOOL) _isEnabled
{
    SwitchValueChangedEvent *event = [[SwitchValueChangedEvent alloc] init];
    event.identifier = _identifier;
    event.isEnabled = _isEnabled;
    return event;
}

@end