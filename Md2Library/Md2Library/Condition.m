// static: Conditions
//
//  Condition.m
//  TariffCalculator
//
//  Created by Uni Münster on 20.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Condition.h"

@implementation Condition

+(id) condition
{
    return [[self alloc] init];
}

-(id) init
{
    self = [super init];
    if (self)
        identifiers = [[NSMutableArray alloc] init];
    return self;
}

-(BOOL) containsIdentifier: (NSString *) identifier
{
    return [identifiers containsObject: identifier];
}

-(BOOL) checkCondition
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

@end