// static: Filters
//
//  Filter.m
//  TariffCalculator
//
//  Created by Uni Münster on 24.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Filter.h"

@implementation Filter

@synthesize predicateString, filterType;

-(id) init
{
    self = [super init];
    if (self)
    {
        filterType = ALL;
        predicateString = [NSString stringWithFormat: @"identifier=0"];
    }
    return self;
}

-(NSPredicate *) getPredicate
{
    if (![predicateString isEqualToString: @""])
        return [NSPredicate predicateWithFormat: predicateString];
    return nil;
}

-(NSPredicate *) getReplacedPredicate
{
    if (![predicateString isEqualToString: @""])
        return [NSPredicate predicateWithFormat: predicateString];
    return nil;
}

-(NSString *) getRemotePredicate
{
    return [self getFilterType];
}

-(NSString *) getFilterType
{
    return (filterType == ALL)? @"": @"first";
}

@end