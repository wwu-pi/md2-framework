// static: Events
//
//  AssignObjectAtContentProviderEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 29.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "ContentProvider.h"

@interface AssignObjectAtContentProviderEvent : Event
{
    NSDictionary *bindings;
}

@property (retain, nonatomic) NSDictionary *bindings;

+(id) eventWithBindings: (NSDictionary *)bindings;

@end