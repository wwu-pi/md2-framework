// static: Events
//
//  PersistEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 02.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "PersistEvent.h"

@implementation PersistEvent

@synthesize contentProvider;

+(id) eventWithContentProvider: (ContentProvider *) contentProvider
{
    PersistEvent *event = [[PersistEvent alloc] init];
    event.contentProvider = contentProvider;
    return event;
}

@end