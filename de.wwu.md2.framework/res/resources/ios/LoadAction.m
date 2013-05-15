// static: Actions
//
//  LoadAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 02.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "LoadAction.h"
#import "ReloadControllerAction.h"

@implementation LoadAction

+(void) performAction: (Event *) event
{
    LoadEvent *_event = (LoadEvent *) event;
    [_event.contentProvider fetchDataObject];
    [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: [AppData currentController]]];
}

@end