// static: Filters
//
//  Filter.h
//  TariffCalculator
//
//  Created by Uni Münster on 24.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "AppData.h"

typedef enum
{
    ALL = 1,
    FIRST = 2
} FilterType;

@interface Filter : NSObject
{
    FilterType filterType;
    NSString *predicateString;
}

@property (assign, nonatomic) FilterType filterType;
@property (retain, nonatomic) NSString *predicateString;

-(NSPredicate *) getPredicate;
-(NSPredicate *) getReplacedPredicate;
-(NSString *) getRemotePredicate;
-(NSString *) getFilterType;

@end