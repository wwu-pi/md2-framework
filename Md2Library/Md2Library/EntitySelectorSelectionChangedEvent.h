// static: Events
//
//  EntitySelectorSelectionChangedEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"

@interface EntitySelectorSelectionChangedEvent : Event
{
    NSString *identifier;
    id selection;
}

@property (retain, nonatomic) NSString *identifier;
@property (retain, nonatomic) id selection;

+(id) eventWithIdentifier: (NSString *) identifier selection: (id) selection;

@end