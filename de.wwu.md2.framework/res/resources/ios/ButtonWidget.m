// static: Widgets
//
//  ButtonWidget.m
//  TariffCalculator
//
//  Created by Uni Münster on 01.09.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ButtonWidget.h"
#import "StylesheetCategory.h"

@implementation ButtonWidget

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
    [self initializeTriggers];
    
    button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [button.titleLabel styleByIdentifier: identifier];
    [self setFrame: ButtonWidgetFrame];
    
    [button addTarget: self action: @selector(buttonTouched:) forControlEvents: UIControlEventTouchDown];
    [self addSubview: button];
}

-(void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    NSString *key = [NSString stringWithFormat: @"BT_%@", identifier];
    [button setTitle: LocalizedKeyString(key) forState: UIControlStateNormal];
    button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

-(void) setData: (NSString *) _data {}

@end