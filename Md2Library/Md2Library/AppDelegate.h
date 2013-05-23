// static: ActionHandling
//
//  AppDelegate.h
//  TariffCalculator
//
//	The AppDelegate represents the central hub for the whole application.
//
//  Created by Uni Muenster on 30.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "PickerController.h"
#import "HelpController.h"
#import "AppDelegateProtocols.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIPopoverControllerDelegate, UITabBarControllerDelegate>
{
    id<AppDelegateWidgetDelegate> appDelegateWidgetDelegate;
}

@property (retain, nonatomic) id<AppDelegateWidgetDelegate> appDelegateWidgetDelegate;

-(void) showCustomPickerControllerWithEvent: (CustomPickerButtonClickedEvent *) event;
-(void) showDatePickerControllerWithEvent: (DatePickerButtonClickedEvent *) event;
-(void) showHelpControllerWithEvent: (InfoButtonClickedEvent *) event;
-(void) showEntitySelectorPickerControllerWithEvent: (EntitySelectorPickerButtonClickedEvent *) event;

-(void) writeComboBoxSelection: (ComboboxSelectionChangedEvent *) event;
-(void) writeEntitySelectorSelection: (EntitySelectorSelectionChangedEvent *) event;
-(void) writeCheckboxValue: (SwitchValueChangedEvent *) event;
-(void) writeTextFieldText: (TextFieldEditingChangedEvent *) event;

-(void) reloadCurrentController;
-(void) dismissPopoverController;

-(void) triggerAction: (Event *) event;

@end