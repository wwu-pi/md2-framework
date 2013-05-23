// static: Conditions
//
//  Condition.h
//  TariffCalculator
//
//  Created by Uni Münster on 20.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "AppData.h"

@interface Condition : NSObject
{
    NSMutableArray *identifiers;
}

+(id) condition;

-(BOOL) containsIdentifier: (NSString *) identifier;
-(BOOL) checkCondition;

@end