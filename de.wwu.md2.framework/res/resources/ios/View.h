// static: Views
//
//  View.h
//  TariffCalculator
//
//	The View represents the superclass for all full-screen UIViews.
//	Therefore, the needed methods will be defined.
//
//  Created by Uni Muenster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Widget.h"
#import "Layout.h"
#import "EventTrigger.h"
#import "EventHandlerProtocols.h"
@class EventHandler;

@interface View : UIView
{
    NSString *identifier;
    
    Layout *defaultLayout;
    NSMutableSet *layouts;
    NSMutableSet *widgets;
    
    BOOL hasContentInsets;
    UIScrollView *contentView;
    
    EventHandler *eventHandler;
}

@property (retain, nonatomic) NSString *identifier;

-(void) loadView;

-(void) addWidget: (Widget *) widget;
-(void) addWidget: (Widget *) widget toLayout: (Layout *) layout;
-(void) addView: (UIView *) view identifier: (NSString *) viewIdentifier;
-(void) addView: (UIView *) view identifier: (NSString *) viewIdentifier toLayout: (Layout *) layout;
-(void) addView: (UIView *) view identifier: (NSString *) viewIdentifier rowSpan: (NSUInteger) rowSpan;
-(void) addView: (UIView *) view identifier: (NSString *) viewIdentifier rowSpan: (NSUInteger) rowSpan toLayout: (Layout *) layout;

-(id) createCombobox: (NSString *) widgetIdentifier hasDatePicker: (BOOL) hasDatePicker hasTimePicker: (BOOL) hasTimePicker hasInfoButton: (BOOL) hasInfoButton;
-(id) createCombobox: (NSString *) widgetIdentifier options: (NSArray *) options hasInfoButton: (BOOL) hasInfoButton;
-(id) createComboboxWidget: (NSString *) widgetIdentifier hasDatePicker: (BOOL) hasDatePicker hasTimePicker: (BOOL) hasTimePicker hasInfoButton: (BOOL) hasInfoButton;
-(id) createComboboxWidget: (NSString *) widgetIdentifier options: (NSArray *) options hasInfoButton: (BOOL) hasInfoButton;
-(id) createTextInput: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton;
-(id) createTextFieldWidget: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton;
-(id) createCheckboxWidget: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButto;
-(id) createEntitySelectorWidget: (NSString *) widgetIdentifier textProposition: (NSString *) textProposition hasInfoButton: (BOOL) hasInfoButton;
-(id) createLabelWidget: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton;
-(id) createSpacerWidget: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton;
-(id) createButtonWidget: (NSString *) widgetIdentifier;
-(id) createImageWidget: (NSString *) widgetIdentifier imageName: (NSString *) imagePath;

-(void) replaceView: (NSString *) oldIdentifier newView: (UIView *) newView newIdentifier: (NSString *) newIdentifier;

-(NSSet *) getAllWidgets;
-(NSSet *) getAllNonComboboxWidgets;
-(NSSet *) getAllComboboxWidgets;
-(NSSet *) getAllTextFieldWidgets;
-(NSSet *) getAllCheckboxWidgets;
-(NSSet *) getAllEntitySelectorWidgets;
-(NSSet *) getAllLabelWidgets;

-(NSSet *) getWidgetByIdentifier: (NSString *) identifier;
-(UIView *) getViewByIdentifier: (NSString *) identifier;

@end