// static: Events
//
//  RemoveEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 04.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "ContentProvider.h"

@interface RemoveEvent : Event
{
    ContentProvider *contentProvider;
}

@property (retain, nonatomic) ContentProvider *contentProvider;

+(id) eventWithContentProvider: (ContentProvider *) contentProvider;

@end