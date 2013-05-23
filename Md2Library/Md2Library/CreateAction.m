// static: Actions
//
//  CreateAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "CreateAction.h"
#import "ReloadControllerAction.h"

@implementation CreateAction

+(void) performAction: (Event *) event
{
    CreateEvent *_event = (CreateEvent *) event;
    [_event.contentProvider createNewDataObject];
    [ReloadControllerAction performAction: [ReloadControllerEvent eventWithController: [AppData currentController]]];
}

@end