// static: EventHandling
//
//  EventHandler.m
//  Tarifrechner
//
//  Created by Uni Münster on 18.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EventHandler.h"
#import "AppDelegate.h"
#import "ViewEvent.h"

@implementation EventHandler

@synthesize eventHandlerComboboxDelegate, eventHandlerEntitySelectorDelegate, eventHandlerCheckboxDelegate, eventHandlerInfoButtonDelegate, eventHandlerPopoverDelegate, eventHandlerTextFieldDelegate;

static EventHandler *instance;

+(EventHandler *) instance
{
    if (!instance)
        instance = [[EventHandler alloc] init];
    return instance;
}

-(id) init
{
    self =  [super init];
    if (self)
    {
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setAppDelegateWidgetDelegate: self];
    }
    return self;
}

#pragma mark - AppDelegateWidgetDelegate Methods

-(void) customPickerButtonClicked: (CustomPickerButtonClickedEvent *) event
{
    [appDelegate showCustomPickerControllerWithEvent: event];
}

-(void) datePickerButtonClicked: (DatePickerButtonClickedEvent *) event
{
    [appDelegate showDatePickerControllerWithEvent: event];
}

-(void) pickerSelectionChanged: (ComboboxSelectionChangedEvent *) event
{
    [appDelegate writeComboBoxSelection: event];
}

-(void) entitySelectorPickerButtonClicked: (EntitySelectorPickerButtonClickedEvent *) event
{
    [appDelegate showEntitySelectorPickerControllerWithEvent: event];
}

-(void) checkboxSwitchValueChanged: (SwitchValueChangedEvent *) event
{
    [appDelegate writeCheckboxValue: event];
}

-(void) entitySelectorPickerSelectionChanged: (EntitySelectorSelectionChangedEvent *) event
{
    [appDelegate writeEntitySelectorSelection: event];
}

-(void) textFieldEditingChanged: (TextFieldEditingChangedEvent *) event
{
    [appDelegate writeTextFieldText: event];
}

-(void) infoWidgetButtonClicked: (InfoButtonClickedEvent *) event
{
    [appDelegate showHelpControllerWithEvent: event];
}

-(void) dismissPopoverController
{
    [appDelegate dismissPopoverController];
}

-(void) eventTriggered: (ViewEvent *) event
{
    [appDelegate triggerAction: event];
}

@end