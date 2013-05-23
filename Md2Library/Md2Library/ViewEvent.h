// static: Events
//
//  ViewEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

typedef enum
{
    OnTouch = 1,
    LeftSwipe = 2,
    RightSwipe = 3
} EventType;

#import "Event.h"

@interface ViewEvent : Event
{
    NSString *identifier;
    EventType eventType;
}

@property (retain, nonatomic) NSString *identifier;
@property (assign, nonatomic) EventType eventType;

+(id) eventWithIdentifier: (NSString *) identifier eventType: (EventType) eventType;

@end