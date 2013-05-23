// static: Bindings
//
//  GPSActionBinding.h
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentProvider.h"

@interface GPSActionBinding : NSObject
{
    ContentProvider *contentProvider;
    NSString *dataKey;
    NSString *formattedString;
    NSArray *identifiers;
}

@property (retain, nonatomic) ContentProvider *contentProvider;
@property (retain, nonatomic) NSString *dataKey;
@property (retain, nonatomic) NSString *formattedString;
@property (retain, nonatomic) NSArray *identifiers;

+(id) bindingWithContentProvider: (ContentProvider *) contentProvider dataKey: (NSString *) dataKey formattedString: (NSString *) formattedString identifiers: (NSArray *) identifiers;

@end