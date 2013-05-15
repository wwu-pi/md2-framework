// static: ActionHandling
//
//  AppDelegateProtocols.h
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ViewEvent.h"

@protocol AppDelegateWidgetDelegate <NSObject>

-(void) customPickerButtonClicked: (CustomPickerButtonClickedEvent *) event;
-(void) datePickerButtonClicked: (DatePickerButtonClickedEvent *) event;
-(void) pickerSelectionChanged: (ComboboxSelectionChangedEvent *) event;
-(void) entitySelectorPickerButtonClicked: (EntitySelectorPickerButtonClickedEvent *) event;
-(void) entitySelectorPickerSelectionChanged: (EntitySelectorSelectionChangedEvent *) event;
-(void) checkboxSwitchValueChanged: (SwitchValueChangedEvent *) event;
-(void) infoWidgetButtonClicked: (InfoButtonClickedEvent *) event;
-(void) textFieldEditingChanged: (TextFieldEditingChangedEvent *) event;
-(void) dismissPopoverController;
-(void) eventTriggered: (ViewEvent *) event;

@end