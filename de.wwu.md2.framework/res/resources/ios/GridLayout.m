// static: Layouts
//
//  GridLayout.m
//  TariffCalculator
//
//  Created by Uni Münster on 15.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GridLayout.h"

@implementation GridLayout

-(id) initWithFrame: (CGRect) frame numberRows: (int) rows numberColumns: (int) columns identifier: (NSString *) layoutIdentifier
{
    self = [super initWithFrame: frame numberRows: rows numberColumns: columns identifier: layoutIdentifier];
    if (self)
    {
        hasCellBorders = NO;
    }
    return self;
}

@end