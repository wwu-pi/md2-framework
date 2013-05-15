// static: Style
//
//  NSObject+Stylesheet.m
//  TariffCalculator
//
//  Created by Uni Münster on 20.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "StylesheetCategory.h"

@implementation NSObject (Style)

@dynamic stylesheet;

-(void) styleByIdentifier: (NSString *) identifier
{
    return [[Stylesheet style] applyToObject: self idenfier: identifier];
}

-(void) setStyle: (Stylesheet *) stylesheet
{
    [stylesheet applyToObject: self];
}

-(id) style
{
    return [Stylesheet style];
}

@end