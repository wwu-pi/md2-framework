// static: EventHandling
//
//  EventHandlerProtocols.h
//  TariffCalculator
//
//  Created by Uni Muenster on 16.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "CustomPickerButtonClickedEvent.h"
#import "DatePickerButtonClickedEvent.h"
#import "ComboboxSelectionChangedEvent.h"
#import "SwitchValueChangedEvent.h"
#import "InfoButtonClickedEvent.h"
#import "TextFieldEditingChangedEvent.h"
#import "EntitySelectorPickerButtonClickedEvent.h"
#import "EntitySelectorSelectionChangedEvent.h"

/*
*	Protocol to be used for combobox event handling.
*/
@protocol EventHandlerComboboxDelegate <NSObject>

-(void) customPickerButtonClicked: (CustomPickerButtonClickedEvent *) event;
-(void) datePickerButtonClicked: (DatePickerButtonClickedEvent *) event;
-(void) pickerSelectionChanged: (ComboboxSelectionChangedEvent *) event;

@end

/*
 *	Protocol to be used for entity selector event handling.
 */
@protocol EventHandlerEntitySelectorDelegate <NSObject>

-(void) entitySelectorPickerButtonClicked: (EntitySelectorPickerButtonClickedEvent *) event;
-(void) entitySelectorPickerSelectionChanged: (EntitySelectorSelectionChangedEvent *) event;

@end

/*
*	Protocol to be used for checkbox event handling.
*/
@protocol EventHandlerCheckboxDelegate <NSObject>

-(void) checkboxSwitchValueChanged: (SwitchValueChangedEvent *) event;

@end

/*
*	Protocol to be used for info button event handling.
*/
@protocol EventHandlerInfoButtonDelegate <NSObject>

-(void) infoWidgetButtonClicked: (InfoButtonClickedEvent *) event;

@end

/*
*	Protocol to be used for text field event handling.
*/
@protocol EventHandlerTextFieldDelegate <NSObject>

-(void) textFieldEditingChanged: (TextFieldEditingChangedEvent *) event;

@end

/*
*	Protocol to be used for popover event handling.
*/
@protocol EventHandlerPopoverDelegate <NSObject>

-(void) dismissPopoverController;

@end