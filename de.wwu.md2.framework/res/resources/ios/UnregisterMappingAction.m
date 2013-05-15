// static: Actions
//
//  UnregisterMappingAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "UnregisterMappingAction.h"

@implementation UnregisterMappingAction

+(void) performAction: (Event *) event
{
    UnregisterMappingEvent *_event = (UnregisterMappingEvent *) event;
    
    [_event.dataMapper unregisterDataKeyForIdentifier: _event.identifier];
}

@end