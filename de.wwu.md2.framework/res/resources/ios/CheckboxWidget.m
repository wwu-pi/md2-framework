// static: Widgets
//
//  CheckboxWidget.m
//  Tarifrechner
//
//  Created by Uni Münster on 18.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "CheckboxWidget.h"
#import "InfoWidget.h"

@implementation CheckboxWidget

-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        eventHandler = [EventHandler instance];
        [eventHandler setEventHandlerCheckboxDelegate: self];
        
        [self loadWidget];
    }
    return self;
}

-(void) loadWidget
{
    [super loadWidget];
    
    viewSwitch = [[UISwitch alloc] initWithFrame: CheckboxSwitchFrame];
    [viewSwitch addTarget: self action: @selector(viewSwitchValueChanged:) forControlEvents: UIControlEventValueChanged];
    [self setEnabled: isEnabled];
    [self addSubview: viewSwitch];
    
    [self loadInfoButton];
}

-(void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    [viewSwitch setFrame: CheckboxSwitchFrame];
    [label setFrame: CheckboxWidgetAdjustedLabelFrame(label)];
    [infoButton setFrame: CheckboxInfoButtonFrame];
}

-(void) setData: (NSString *) _data
{
    if (_data && ([_data isEqualToString: @"0"] || [_data isEqualToString: @"1"]))
    {
        [super setData: _data];
        [self setEnabled: ([data isEqualToString: @"1"])? YES: NO];
    }
}

-(void) setEnabled: (BOOL) _isEnabled
{
    [super setEnabled: _isEnabled];
    [viewSwitch setOn: _isEnabled];
    [infoButton setEnabled: YES];
    isEnabled = _isEnabled;
}

-(void) checkboxSwitchValueChanged: (SwitchValueChangedEvent *) event
{
    [eventHandler checkboxSwitchValueChanged: event];
}

#pragma mark - Actions

-(IBAction) viewSwitchValueChanged: (id) sender
{
    [self setData: [NSString stringWithFormat: @"%i", viewSwitch.on]];
    [self checkboxSwitchValueChanged: [SwitchValueChangedEvent eventWithIdentifier: self.identifier isEnabled: isEnabled]];
}

@end