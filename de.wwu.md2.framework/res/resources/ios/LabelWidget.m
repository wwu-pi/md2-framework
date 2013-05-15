// static: Widgets
//
//  LabelWidget.m
//  TariffCalculator
//
//  Created by Uni Münster on 05.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "LabelWidget.h"
#import "InfoWidget.h"

@implementation LabelWidget

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
    [self setData: displayText];
    [self loadInfoButton];
}

-(void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    [label setFrame: LabelWidgetFrame(frame)];
}

-(void) setData: (NSString *) _data
{
    [super setData: _data];
    displayText = data;
    NSString *title = LocalizedString(identifier, @"Label");
    if (displayText != nil)
        [label setText: displayText];
    else
        [label setText: ([title hasSuffix: @"Label"])? @"": title];
}

@end