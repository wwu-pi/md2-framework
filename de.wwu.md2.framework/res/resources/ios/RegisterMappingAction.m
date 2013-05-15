// static: Actions
//
//  RegisterMappingAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RegisterMappingAction.h"

@implementation RegisterMappingAction

+(void) performAction: (Event *) event
{
    RegisterMappingEvent *_event = (RegisterMappingEvent *) event;
    
    [_event.dataMapper registerDataKeyForIdentifier: _event.dataKey identifier: _event.identifier contentProvider: _event.contentProvider];
}

@end