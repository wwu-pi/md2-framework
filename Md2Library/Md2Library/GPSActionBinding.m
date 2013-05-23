// static: Bindings
//
//  GPSActionBinding.m
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GPSActionBinding.h"

@implementation GPSActionBinding

@synthesize contentProvider, dataKey, formattedString, identifiers;

#pragma mark Initialization Methods

/*
 *	Initializes this container object.
 */
+(id) bindingWithContentProvider: (ContentProvider *) contentProvider dataKey: (NSString *) dataKey formattedString: (NSString *) formattedString identifiers: (NSArray *) identifiers
{
    GPSActionBinding *binding = [[GPSActionBinding alloc] init];
    binding.contentProvider = contentProvider;
    binding.dataKey = dataKey;
    binding.formattedString = formattedString;
    binding.identifiers = identifiers;
    return binding;
}

@end