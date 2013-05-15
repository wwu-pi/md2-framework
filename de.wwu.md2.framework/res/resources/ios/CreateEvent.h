// static: Events
//
//  CreateEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "ContentProvider.h"

@interface CreateEvent : Event
{
    ContentProvider *contentProvider;
}

@property (retain, nonatomic) ContentProvider *contentProvider;

+(id) eventWithContentProvider: (ContentProvider *) contentProvider;

@end