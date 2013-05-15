// static: Actions
//
//  AssignObjectAtContentProviderAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 29.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "AssignObjectAtContentProviderAction.h"
#import "RegisterMappingAction.h"

@implementation AssignObjectAtContentProviderAction

+(void) performAction: (Event *) event
{
    AssignObjectAtContentProviderEvent *_event = (AssignObjectAtContentProviderEvent *) event;
    
    for (NSString *key in _event.bindings)
        [[_event.bindings valueForKey: key] addLinkedContentProvider: [_event.bindings valueForKey: key] forKey: key];
}

@end