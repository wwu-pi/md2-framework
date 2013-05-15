// static: Layouts
//
//  FlowLayout.m
//  Tarifrechner
//
//  Created by Uni Münster on 22.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "FlowLayout.h"

@implementation FlowLayout

-(id) initWithFrame: (CGRect) frame numberElements: (int) elements direction: (FlowLayoutDirection) direction identifier: (NSString *) layoutIdentifier
{
    self = [super initWithFrame: frame identifier: layoutIdentifier];
    if (self)
    {
        if (direction == Vertical)
        {
            numberColumns = 1;
            numberRows = elements;
        }
        else
        {
            numberColumns = elements;
            numberRows = 1;
        }
    }
    return self;
}

@end