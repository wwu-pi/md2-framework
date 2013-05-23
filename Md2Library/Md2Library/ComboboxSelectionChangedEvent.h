// static: Events
//
//  ComboboxSelectionChangedEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"

@interface ComboboxSelectionChangedEvent : Event
{
    NSString *identifier;
    id selection;
}

@property (retain, nonatomic) NSString *identifier;
@property (retain, nonatomic) id selection;

+(id) eventWithIdentifier: (NSString *) identifier selection: (id) selection;

@end