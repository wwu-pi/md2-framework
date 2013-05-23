// static: Widgets
//
//  Widget.m
//  TariffCalculator
//
//	The Widget represents the superclass for most GUI components that are presented.
//	Therefore, the needed methods will be defined.
//
//  Created by Uni Muenster on 18.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Widget.h"
#import "EventHandler.h"
#import "EventTrigger.h"
#import "StylesheetCategory.h"

@implementation Widget

/*
*	Implementation of the getters and setters for the instance attributes.
*/
@synthesize identifier, data, validation, hasInfoButton, infoButton, infoText;

/*
*	Initializes the Widget object.
*/
-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        validation = [[WidgetValidation alloc] init];
        [self initializeTriggers];
        [self loadWidget];
    }
    return self;
}

/*
*	Loads the Widget and sets the instance variables appropriately.
*/
-(void) loadWidget
{
    label = [[UILabel alloc] initWithFrame: WidgetLabelFrame(self.frame)];
    
    NSString *title = LocalizedString(identifier, @"Label");
    [label setText: ([title hasSuffix: @"Label"])? @"": title];
    label.font = [UIFont systemFontOfSize: 15];
    label.textAlignment = UITextAlignmentLeft;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.numberOfLines = 0;
    
    [self addSubview: label];
}

/*
*	Sets the data of the widget.
*/
-(void) setData: (NSString *) _data
{
    data = _data;
}

-(void) persistData {}

/*
*	Sets the frame of the widget appropriately.
*/
-(void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    [label setFrame: WidgetLabelFrame(frame)];
    [infoButton setFrame: InfoButtonFrame(frame)];
    
    [self styleByIdentifier: identifier];
    [label styleByIdentifier: identifier];
}

/*
*	Sets the widget either enabled or disabled.
*/
-(void) setEnabled: (BOOL) isEnabled
{
    [infoButton setEnabled: isEnabled];
    label.textColor = (isEnabled)? [UIColor blackColor]: [UIColor lightGrayColor];
}

/*
*	Hides the label of the widget.
*/
-(void) setLabelHidden: (BOOL) isLabelHidden
{
    label.hidden = isLabelHidden;
    label.userInteractionEnabled = isLabelHidden;
    label = nil;
}

@end