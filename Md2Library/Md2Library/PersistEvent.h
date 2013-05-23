// static: Events
//
//  PersistEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 02.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "ContentProvider.h"

@interface PersistEvent : Event
{
    ContentProvider *contentProvider;
}

@property (retain, nonatomic) ContentProvider *contentProvider;

+(id) eventWithContentProvider: (ContentProvider *) contentProvider;

@end