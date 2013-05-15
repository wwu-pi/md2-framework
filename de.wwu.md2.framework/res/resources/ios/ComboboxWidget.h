// static: Widgets
//
//  ComboboxWidget.h
//  TariffCalculator
//
//	The ComboboxWidget encapsulates the display of enum and date values.
//
//  Created by Uni Muenster on 17.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "TextFieldWidget.h"
#import "Widget.h"
#import "EventHandler.h"

@protocol ComboboxWidgetPickerDelegate <NSObject>
-(void) comboboxPickerSelectionChanged: (id) selection;
@end

@interface ComboboxWidget : Widget <EventHandlerComboboxDelegate>
{
    TextFieldWidget *textFieldWidget;
    UIButton *pickerButton;
    BOOL isLabelDisabled;
    
    NSMutableArray *options;
    NSDate *date;
    
    BOOL hasDatePicker;
    BOOL hasTimePicker;
    
    BOOL hasStaticContent;
    
	id <ComboboxWidgetPickerDelegate> comboboxWidgetPickerDelegate;
    EventHandler *eventHandler;
}

@property (retain, nonatomic) UIButton *pickerButton;

@property (retain, nonatomic) NSMutableArray *options;
@property (retain, nonatomic) NSDate *date;

@property (assign, nonatomic) BOOL hasDatePicker;
@property (assign, nonatomic) BOOL hasTimePicker;
@property (assign, nonatomic) BOOL hasStaticContent;

@property (retain, nonatomic) id <ComboboxWidgetPickerDelegate> comboboxWidgetPickerDelegate;

-(void) setLabelDisabled: (BOOL) _isLabelDisabled;
-(void) comboboxPickerSelectionChanged: (id) selectedRow;

@end