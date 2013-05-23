// static: Events
//
//  SwitchValueChangedEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"

@interface SwitchValueChangedEvent : Event
{
    NSString *identifier;
    BOOL isEnabled;
}

@property (retain, nonatomic) NSString *identifier;
@property (assign, nonatomic) BOOL isEnabled;

+(id) eventWithIdentifier: (NSString *) _identifier isEnabled: (BOOL) _isEnabled;

@end