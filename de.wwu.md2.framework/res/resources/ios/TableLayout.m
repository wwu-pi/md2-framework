// static: Layouts
//
//  TableView.m
//  TariffCalculator
//
//  Created by Uni Münster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "TableLayout.h"

@implementation TableLayout

-(id) initWithFrame: (CGRect) frame numberRows: (int) rows numberColumns: (int) columns identifier: (NSString *) layoutIdentifier
{
    self = [super initWithFrame: frame numberRows: rows numberColumns: columns identifier: layoutIdentifier];
    if (self)
    {
        hasCellBorders = YES;
        rowSpacing = 0;
        columnSpacing = 0;
    }
    return self;
}

@end