// static: Views
//
//  PickerView.m
//  TariffCalculator
//
//	The PickerView represents the data or custom picker for comboboxes and combobox widgets.
//
//  Created by Uni Muenster on 30.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

@synthesize isEditable;

/*
*	Initializes the PickerView.
*/
-(id) init
{
    self = [super init];
    if (self)
    {
        popoverEventHandler = [EventHandler instance];
        [popoverEventHandler setEventHandlerPopoverDelegate: self];
        
        hasContentInsets = NO;
        identifier = @"picker";
    }
    return self;
}

/*
*	Loads the PickerView.
*/
-(void) loadView
{
    [super loadView];
    contentView.frame = HelpPickerViewFrame;
    
    navigationBar = [[UINavigationBar alloc] initWithFrame: NavigationBarFrame];
    navigationBar.tintColor = [UIColor blackColor];
    NSString *key = [NSString stringWithFormat: @"NB_%@", identifier];
    navigationBarItem = [[UINavigationItem alloc] initWithTitle: LocalizedKeyString(key)];
    
    contentView.scrollEnabled = NO;
    navigationBar.frame = PickerViewNavigationBarFrame(navigationBar.frame);
    backButton = [[UIBarButtonItem alloc] initWithTitle: LocalizedKeyString(@"BT_done") style: UIBarButtonItemStylePlain target: self action: @selector(doneButtonClicked:)];
    navigationBarItem.leftBarButtonItem = backButton;
    
    if (isEditable)
    {
        editButton = [[UIBarButtonItem alloc] initWithTitle: LocalizedKeyString(@"BT_add") style: UIBarButtonItemStylePlain target: self action: @selector(editButtonClicked:)];
        NSMutableArray *rightBarButtonItems = [NSMutableArray arrayWithArray: navigationBarItem.rightBarButtonItems];
        [rightBarButtonItems addObject: editButton];
        navigationBarItem.rightBarButtonItems  = rightBarButtonItems;
    }
    
    [navigationBar pushNavigationItem: navigationBarItem animated: NO];
    
    pickerView = [[UIPickerView alloc] initWithFrame: PopoverFrame];
    datePickerView = [[UIDatePicker alloc] initWithFrame: PopoverFrame];
    datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    [datePickerView addTarget: self action: @selector(datePickerValueChanged:) forControlEvents: UIControlEventValueChanged];
    
    pickerView.showsSelectionIndicator = YES;
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    
    [self addSubview: navigationBar];
    [contentView addSubview: datePickerView];
    [contentView addSubview: pickerView];
}

/*
*	Sets the combobox widget of the PickerView.
*/
-(void) setComboboxWidget: (ComboboxWidget *) widget
{
    comboboxWidget = widget;
    [comboboxWidget setComboboxWidgetPickerDelegate: self];
    
    widgets = [NSArray array];
    date = [NSDate date];
    if (widget.options.count > 0)
        pickerOptions = widget.options;
    if (widget.date != nil)
        date = widget.date;
    
    if(widget.hasDatePicker || widget.hasTimePicker)
    {
        pickerView.hidden = YES;
        datePickerView.hidden = NO;
        
        if (widget.hasDatePicker && !widget.hasTimePicker)
            datePickerView.datePickerMode = UIDatePickerModeDate;
        else if (widget.hasTimePicker && !widget.hasDatePicker)
            datePickerView.datePickerMode = UIDatePickerModeTime;
        else if (widget.hasTimePicker && widget.hasDatePicker)
            datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
        
        [datePickerView setDate: date];
        
        if (isEditable)
            [[NSMutableArray arrayWithArray: navigationBarItem.rightBarButtonItems] removeObject: editButton];
    }
    else
    {
        pickerView.hidden = NO;
        datePickerView.hidden = YES;
        [pickerView selectRow: [pickerOptions indexOfObject: widget.data] inComponent: 0 animated: NO];
        if (isEditable)
            [[NSMutableArray arrayWithArray: navigationBarItem.rightBarButtonItems] addObject: editButton];
    }
}

#pragma mark Action Methods

/*
*	Calls an input for the new option if the edit button was clicked.
*/
-(IBAction) editButtonClicked: (id) sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: LocalizedKeyString(@"inf_new_option") message: LocalizedKeyString(@"inf_new_option_message") delegate: self cancelButtonTitle: LocalizedKeyString(@"inf_new_option_button") otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
}

/*
*	Responds to the dismiss of the input and adds the new option to the picker view.
*/
-(void) alertView: (UIAlertView *) alertView willDismissWithButtonIndex: (NSInteger) buttonIndex
{
    NSString *newOption = [[alertView textFieldAtIndex: 0] text];
    if (![newOption isEqualToString: @""])
        [pickerOptions addObject: newOption];
    [pickerView reloadAllComponents];
}

/*
*	Dismisses the PickerView if the edit button was clicked.
*/
-(IBAction) doneButtonClicked: (id) sender
{
    [self dismissPopoverController];
}

/*
*	Writes the changed data picker value if the edit button was clicked.
*/
-(IBAction) datePickerValueChanged: (id) sender
{
    NSString *data = [DataConverter getStringByDate: datePickerView.date];
    if (comboboxWidget.hasDatePicker && !comboboxWidget.hasTimePicker)
        [comboboxWidget comboboxPickerSelectionChanged: [DataConverter getDateStringByString: data]];
    else if (!comboboxWidget.hasDatePicker && comboboxWidget.hasTimePicker)
        [comboboxWidget comboboxPickerSelectionChanged: [DataConverter getTimeStringByString: data]];
    else if (comboboxWidget.hasDatePicker && comboboxWidget.hasTimePicker)
        [comboboxWidget comboboxPickerSelectionChanged: data];
}

#pragma mark EventHandlerPickerDelegate Methods

/*
*	Dismisses the PickerView with the help of the popover event handler.
*/
-(void) dismissPopoverController
{
    [popoverEventHandler dismissPopoverController];
}

#pragma mark ComboboxWidget Methods

/*
*	Writes the change custom picker value with the help of the combobox widget.
*/
-(void) comboboxPickerSelectionChanged: (id) selection
{
    [comboboxWidget comboboxPickerSelectionChanged: selection];
}

#pragma mark UIPickerView Methods

/*
*	Determines the number of components.
*/
-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *) thePickerView
{
    return 1;
}

/*
*	Determines the number of rows for a single component.
*/
-(NSInteger) pickerView: (UIPickerView *) thePickerView numberOfRowsInComponent: (NSInteger) component
{
    return [pickerOptions count];
}

/*
*	Determines the title in the custom picker view for a single a single component.
*/
-(NSString *) pickerView: (UIPickerView *) thePickerView titleForRow: (NSInteger) row forComponent: (NSInteger) component
{
    return [pickerOptions objectAtIndex: row];
}

/*
*	Determines the selected row in the custom picker view for a single a single component.
*/
-(void) pickerView: (UIPickerView *) thePickerView didSelectRow: (NSInteger) row inComponent: (NSInteger) component
{
    [self comboboxPickerSelectionChanged: [NSNumber numberWithInteger: row]];
}

@end