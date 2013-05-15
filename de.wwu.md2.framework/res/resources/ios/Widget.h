// static: Widgets
//
//  Widget.h
//  TariffCalculator
//
//	The Widget represents the superclass for most GUI components that are presented.
//	Therefore, the needed methods will be defined.
//
//  Created by Uni Muenster on 18.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WidgetValidation.h"
#import "EventTrigger.h"
@class EventHandler;

@interface Widget : UIView
{
    NSString *identifier;
    NSString *data;
    UILabel *label;
    WidgetValidation *validation;
    
    BOOL hasInfoButton;
    UIButton *infoButton;
    NSString *infoText;
    
    EventHandler *infoButtonEventHandler;
}

@property (retain, nonatomic) NSString *identifier;
@property (retain, nonatomic) NSString *data;
@property (retain, nonatomic) WidgetValidation *validation;

@property (assign, nonatomic) BOOL hasInfoButton;
@property (retain, nonatomic) UIButton *infoButton;
@property (retain, nonatomic) NSString *infoText;

-(void) loadWidget;
-(void) setFrame: (CGRect) frame;
-(void) persistData;
-(void) setData: (NSString *) data;
-(void) setEnabled: (BOOL) isEnabled;
-(void) setLabelHidden: (BOOL) isHidden;

@end