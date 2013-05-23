// static: Events
//
//  TextFieldEditingChangedEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"

@interface TextFieldEditingChangedEvent : Event
{
    NSString *identifier;
    id text;
}

@property (retain, nonatomic) NSString *identifier;
@property (retain, nonatomic) id text;

+(id) eventWithIdentifier: (NSString *) identifier text: (id) text;

@end