// static: Widgets
//
//  EntitySelectorWidget.m
//  TariffCalculator
//
//  Created by Uni Münster on 23.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EntitySelectorWidget.h"
#import "InfoWidget.h"

@implementation EntitySelectorWidget

@synthesize textProposition, comboboxWidget;

-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        eventHandler = [EventHandler instance];
        [eventHandler setEventHandlerEntitySelectorDelegate: self];
        
        [self loadWidget];
    }
    return self;
}

-(void) loadWidget
{
    [super loadWidget];
    
    comboboxWidget = [[ComboboxWidget alloc] initWithFrame: EntitySelectorComboboxFrame(self.frame)];
    comboboxWidget.identifier = identifier;
    [comboboxWidget.pickerButton removeTarget: comboboxWidget action: @selector(pickerButtonClicked:) forControlEvents: UIControlEventTouchDown]; //if this is not done, a freeze after popover dismiss occurs
    [comboboxWidget.pickerButton addTarget: self action: @selector(entitySelectorComboboxPickerButtonClicked:) forControlEvents: UIControlEventTouchDown];
    [self addSubview: comboboxWidget];
    
    [self loadInfoButton];
}

-(void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    [comboboxWidget setFrame: EntitySelectorComboboxFrame(frame)];
    [comboboxWidget setLabelDisabled: YES];
}

-(void) setData: (NSString *) _data
{
    if (_data != nil)
        [comboboxWidget setData: _data];
}

-(void) setOptions: (NSArray *) options
{
    if (options != nil)
        [comboboxWidget setOptions: [NSMutableArray arrayWithArray: options]];
}    

-(void) setEnabled: (BOOL) _isEnabled
{
    [super setEnabled: _isEnabled];
    [comboboxWidget setEnabled: _isEnabled];
    [infoButton setEnabled: YES];
    isEnabled = _isEnabled;
}

#pragma mark EventHandlerEntitySelectorDelegate Methods

-(void) entitySelectorPickerButtonClicked: (EntitySelectorPickerButtonClickedEvent *) event
{
    [eventHandler entitySelectorPickerButtonClicked: event];
}

-(void) entitySelectorPickerSelectionChanged: (EntitySelectorSelectionChangedEvent *) event
{
    [eventHandler entitySelectorPickerSelectionChanged: event];
}

#pragma mark - PickerViewControllerDelegate

-(void) pickerSelectionChanged: (id) _selection
{
    NSString *selectedString = [comboboxWidget.options objectAtIndex: ((NSNumber *) _selection).integerValue];
    [self setData: selectedString];
    [self entitySelectorPickerSelectionChanged: [EntitySelectorSelectionChangedEvent eventWithIdentifier: self.identifier selection: selectedString]];
}

#pragma mark - Actions

/*
 *	Will be called id the picker button was clicked and calls a PickerView.
 */
-(IBAction) entitySelectorComboboxPickerButtonClicked: (id) sender
{
    [self entitySelectorPickerButtonClicked: [EntitySelectorPickerButtonClickedEvent eventWithSender: sender widget: comboboxWidget]];
}

@end