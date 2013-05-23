// static: Widgets
//
//  ComboboxWidget.m
//  TariffCalculator
//
//	The ComboboxWidget encapsulates the display of enum and date values.
//
//  Created by Uni Muenster on 17.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ComboboxWidget.h"
#import "TextFieldWidget.h"
#import "InfoWidget.h"

@implementation ComboboxWidget

/*
*	Implementation of the getters and setters of the instance attributes.
*/
@synthesize pickerButton, options, date, hasDatePicker, hasTimePicker, hasStaticContent, comboboxWidgetPickerDelegate;

/*
*	Initializes the ComboboxWidget object with a frame.
*/
-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        eventHandler = [EventHandler instance];
        [eventHandler setEventHandlerComboboxDelegate: self];
        
        [self loadWidget];
    }
    return self;
}

/*
*	Loads the combobox widget appropriately.
*/
-(void) loadWidget
{
    [super loadWidget];
    
    textFieldWidget = [TextFieldWidget alloc];
    textFieldWidget.identifier = identifier;
    textFieldWidget = [[TextFieldWidget alloc] initWithFrame: TextFieldWidgetFrame(self.frame)];
    textFieldWidget.isPartOfCombobox = YES;
    textFieldWidget.hasInfoButton = NO;
    textFieldWidget.textField.text = @"";
    textFieldWidget.textField.userInteractionEnabled = NO;
    textFieldWidget.textField.backgroundColor = [UIColor lightGrayColor];
    textFieldWidget.textField.textColor = [UIColor whiteColor];
    textFieldWidget.textField.textAlignment = UITextAlignmentCenter;
    [self addSubview: textFieldWidget];
    
    UIImage* pickerImage = [UIImage imageNamed: @"arrow2.png"];
    pickerButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [pickerButton setImage: pickerImage forState: UIControlStateNormal];
    pickerButton.frame = ComboboxPickerButtonFrame(self.frame);
    [pickerButton addTarget: self action: @selector(pickerButtonClicked:) forControlEvents: UIControlEventTouchDown];
    [self addSubview: pickerButton];
    
    [self loadInfoButton];
}

/*
*	Sets the data of the combobox widget.
*/
-(void) setData: (NSString *) _data
{
    [super setData: _data];
    
    if (hasDatePicker || hasTimePicker)
    {
        if (hasDatePicker && !hasTimePicker)
            date = [DataConverter getDateByString: data];
        else if (!hasDatePicker && hasTimePicker)
            date = [DataConverter getTimeByString: data];
        else if (hasDatePicker && hasTimePicker)
            date = [DataConverter getDateTimeByString: data];
    }
    [textFieldWidget setData: data];
}

/*
*	Sets the frame of the combobox widget.
*/
-(void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    [textFieldWidget setFrame: TextFieldWidgetFrame(frame)];
    [pickerButton setFrame: ComboboxPickerButtonFrame(self.frame)];
    if (isLabelDisabled)
        [self setLabelDisabled: isLabelDisabled];
}

/*
*	Sets the label of the combobox widget disabled.
*/
-(void) setLabelDisabled: (BOOL) _isLabelDisabled
{
    isLabelDisabled = _isLabelDisabled;
    [textFieldWidget setLabelDisabled: isLabelDisabled];
    if (isLabelDisabled)
        [pickerButton setFrame: ComboboxLabelDisabledFrame(textFieldWidget.frame)];
}

/*
*	Sets the combobox widget either enabled or disabled.
*/
-(void) setEnabled: (BOOL) isEnabled
{
    [super setEnabled: isEnabled];
    [pickerButton setEnabled: isEnabled];
    [textFieldWidget setEnabled: isEnabled];
    textFieldWidget.textField.textColor = (isEnabled)? [UIColor blackColor]: [UIColor lightTextColor];
}

#pragma mark EventHandlerComboboxDelegate Methods

/*
*	Writes the selection of the custom picker with the help of te event handler.
*/
-(void) customPickerButtonClicked: (CustomPickerButtonClickedEvent *) event
{
    [eventHandler customPickerButtonClicked: event];
}

/*
*	Writes the selection of the date picker with the help of te event handler.
*/
-(void) datePickerButtonClicked: (DatePickerButtonClickedEvent *) event;
{
    [eventHandler datePickerButtonClicked: event];
}

/*
*	Writes the selection of the picker with the help of te event handler.
*/
-(void) pickerSelectionChanged: (ComboboxSelectionChangedEvent *) event
{
    [eventHandler pickerSelectionChanged: event];
}

#pragma mark - PickerViewControllerDelegate

/*
*	Will be called by the PickerView to set the new value of the pickers.
*/
-(void) comboboxPickerSelectionChanged: (id) _selection
{
    if (hasDatePicker || hasTimePicker)
    {
        [self setData: _selection];
        [self pickerSelectionChanged: [ComboboxSelectionChangedEvent eventWithIdentifier: self.identifier selection: date]];
    }
    else
    {
        NSNumber *selectedRow = (NSNumber *) _selection;
        NSString *selectedString = [options objectAtIndex: selectedRow.integerValue];
        [self setData: selectedString];
        if (!hasStaticContent)
            [self pickerSelectionChanged: [ComboboxSelectionChangedEvent eventWithIdentifier: self.identifier selection: [NSNumber numberWithInt: (selectedRow.intValue + 1)]]];
    }
}

#pragma mark - Actions

/*
*	Will be called if the picker button was clicked and calls a PickerView.
*/
-(IBAction) pickerButtonClicked: (id) sender
{
    if (hasDatePicker || hasTimePicker)
    {
        if (hasDatePicker && !hasTimePicker)
            date = [DataConverter getDateByString: data];
        else if (!hasDatePicker && hasTimePicker)
            date = [DataConverter getTimeByString: data];
        else if (hasDatePicker && hasTimePicker)
        {
            //TODO: Fix memory leakage and remove following line
            data = [DataConverter getStringByDate: [NSDate date]];
            date = [DataConverter getDateTimeByString: data];
        }
        [self datePickerButtonClicked: [DatePickerButtonClickedEvent eventWithSender: sender widget: self]];
    }
    else
        [self customPickerButtonClicked: [CustomPickerButtonClickedEvent eventWithSender: sender widget: self]];
}

@end