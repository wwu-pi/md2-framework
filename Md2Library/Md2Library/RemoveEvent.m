// static: Events
//
//  RemoveEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 04.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RemoveEvent.h"

@implementation RemoveEvent

@synthesize contentProvider;

+(id) eventWithContentProvider: (ContentProvider *) contentProvider
{
    RemoveEvent *event = [[RemoveEvent alloc] init];
    event.contentProvider = contentProvider;
    return event;
}

@end