// static: Actions
//
//  GPSAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GPSUpdateAction.h"
#import "ReloadControllerAction.h"
#import "PersistAction.h"
#import "LoadAction.h"

@implementation GPSUpdateAction

+(void) performAction: (Event *) event
{
    GPSUpdateEvent *_event = (GPSUpdateEvent *) event;
    
    // fetch current GPS data
    [[AppData gpsContentProvider] fetchLocationInformation];
    
    // handle all bindings of this GPSUpdateAction
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    for (GPSActionBinding *binding in _event.bindings)
    {
        // replace all identifier strings by actual information
        for(NSString *identifier in binding.identifiers)
            [arguments addObject: [[AppData gpsContentProvider] getDataObjectValueForKey: identifier]];
        
        // get formatted string with the actual values
        if (arguments.count > 0)
        {
            NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [arguments count]];
            [arguments getObjects: (__unsafe_unretained id *) data.mutableBytes range: NSMakeRange(0, [arguments count])];
            binding.formattedString = [[NSString alloc] initWithFormat: binding.formattedString  arguments: data.mutableBytes];
        }
        
        // set string to the model in content provider
        [binding.contentProvider setDataObjectValue: binding.formattedString forKey: binding.dataKey];
        [PersistAction performAction: [PersistEvent eventWithContentProvider: binding.contentProvider]];
    }
}

@end