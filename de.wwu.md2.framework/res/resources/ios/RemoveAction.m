// static: Actions
//
//  RemoveAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 04.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RemoveAction.h"
#import "ReloadControllerAction.h"

@implementation RemoveAction

+(void) performAction: (Event *) event
{
    RemoveEvent *_event = (RemoveEvent *) event;
    [_event.contentProvider removeDataObject];
    [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: [AppData currentController]]];
}

@end