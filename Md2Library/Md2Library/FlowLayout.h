// static: Layouts
//
//  FlowLayout.h
//  Tarifrechner
//
//  Created by Uni Münster on 22.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Layout.h"

typedef enum
{
    Horizontal = 1,
    Vertical = 2
} FlowLayoutDirection;


@interface FlowLayout : Layout

-(id) initWithFrame: (CGRect) frame numberElements: (int) elements direction: (FlowLayoutDirection) direction identifier: (NSString *) layoutIdentifier;

@end