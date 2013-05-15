// static: Widgets
//
//  SpacerWidget.m
//  TariffCalculator
//
//  Created by Uni Münster on 01.09.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "SpacerWidget.h"
#import "InfoWidget.h"

@implementation SpacerWidget

-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
        [self loadWidget];
    return self;
}

-(void) loadWidget
{
    [super loadWidget];
    [self loadInfoButton];
}

-(void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    [label setFrame: LabelWidgetFrame(frame)];
}

-(void) setData: (NSString *) _data {}

@end