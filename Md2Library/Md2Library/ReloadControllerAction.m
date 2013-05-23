// static: Actions
//
//  ReloadControllerEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ReloadControllerAction.h"

@implementation ReloadControllerAction

+(void) performAction: (Event *) event
{
    ReloadControllerEvent *_event = (ReloadControllerEvent *) event;
    
    [_event.controller loadData];
}

@end