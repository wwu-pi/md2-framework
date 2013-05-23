// static: Events
//
//  CreateEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "CreateEvent.h"

@implementation CreateEvent

@synthesize contentProvider;

+(id) eventWithContentProvider: (ContentProvider *) contentProvider
{
    CreateEvent *event = [[CreateEvent alloc] init];
    event.contentProvider = contentProvider;
    return event;
}

@end