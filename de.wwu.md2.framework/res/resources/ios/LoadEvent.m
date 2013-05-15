// static: Events
//
//  LoadEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 02.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "LoadEvent.h"

@implementation LoadEvent

@synthesize contentProvider;

+(id) eventWithContentProvider: (ContentProvider *) contentProvider
{
    LoadEvent *event = [[LoadEvent alloc] init];
    event.contentProvider = contentProvider;
    return event;
}

@end