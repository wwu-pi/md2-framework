// static: Actions
//
//  PersistAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 02.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "PersistAction.h"
#import "ReloadControllerAction.h"

@implementation PersistAction

+(void) performAction: (Event *) event
{
    PersistEvent *_event = (PersistEvent *) event;
    [_event.contentProvider persistDataObject];
    [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: [AppData currentController]]];
}

@end