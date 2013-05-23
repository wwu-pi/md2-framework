// static: Widgets
//
//  WidgetFactory.h
//  TariffCalculator
//
//	The WidgetFactory is used to handle and encapsulate the creation of widgets.
//
//  Created by Uni Münster on 31.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ComboboxWidget.h"
#import "TextFieldWidget.h"
#import "LabelWidget.h"
#import "SpacerWidget.h"
#import "ButtonWidget.h"
#import "ImageWidget.h"
#import "CheckboxWidget.h"
#import "EntitySelectorWidget.h"

@interface WidgetFactory : NSObject
	
+(ComboboxWidget *) createComboboxWithIdentifier: (NSString *) identifier hasDatePicker: (BOOL) hasDatePicker hasTimePicker: (BOOL) hasTimePicker hasInfoButton: (BOOL) hasInfoButton;
+(ComboboxWidget *) createComboboxWithIdentifier: (NSString *) identifier options: (NSArray *) options hasInfoButton: (BOOL) hasInfoButton;
+(ComboboxWidget *) createComboboxWidgetWithIdentifier: (NSString *) identifier hasDatePicker: (BOOL) hasDatePicker hasTimePicker: (BOOL) hasTimePicker hasInfoButton: (BOOL) hasInfoButton;
+(ComboboxWidget *) createComboboxWidgetWithIdentifier: (NSString *) identifier options: (NSArray *) options hasInfoButton: (BOOL) hasInfoButton;
+(TextFieldWidget *) createTextInputWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton;
+(TextFieldWidget *) createTextFieldWidgetWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton;
+(CheckboxWidget *) createCheckboxWidgetWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton;
+(EntitySelectorWidget *) createEntitySelectorWidgetWithIdentifier: (NSString *) identifier textProposition: (NSString *) textProposition hasInfoButton: (BOOL) hasInfoButton;
+(LabelWidget *) createLabelWidgetWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton;
+(LabelWidget *) createSpacerWidgetWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton;
+(ButtonWidget *) createButtonWidgetWithIdentifier: (NSString *) identifier;
+(ImageWidget *) createImageWidgetWithIdentifier: (NSString *) identifier imageName: (NSString *) imageName;

@end