// static: Widgets
//
//  WidgetFactory.m
//  TariffCalculator
//
//	The WidgetFactory is used to handle and encapsulate the creation of widgets.
//
//  Created by Uni Münster on 31.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WidgetFactory.h"

@implementation WidgetFactory

#pragma mark ComboboxWidget Factory Methods

/*
 *	Creates a combobox (no label) by the given identifier, that can have an info button attached and a fixed options array.
 */
+(ComboboxWidget *) createComboboxWithIdentifier: (NSString *) identifier options: (NSArray *) options hasInfoButton: (BOOL) hasInfoButton
{
    ComboboxWidget *comboboxWidget = [self createComboboxWithIdentifier: identifier hasDatePicker: NO hasTimePicker: NO hasInfoButton: hasInfoButton];
    [comboboxWidget setHasStaticContent: YES];
    [comboboxWidget setOptions: [NSMutableArray arrayWithArray: options]];
    
    return comboboxWidget;
}

/*
*	Creates a combobox (no label) by the given identifier, that can have a data or time picker and info button attached.
*/
+(ComboboxWidget *) createComboboxWithIdentifier: (NSString *) identifier hasDatePicker: (BOOL) hasDatePicker hasTimePicker: (BOOL) hasTimePicker hasInfoButton: (BOOL) hasInfoButton
{
    ComboboxWidget *comboboxWidget = [self createComboboxWidgetWithIdentifier: identifier hasDatePicker: hasDatePicker hasTimePicker: hasTimePicker hasInfoButton: hasInfoButton];
    [comboboxWidget setLabelDisabled: YES];
    
    return comboboxWidget;
}

/*
 *	Creates a combobox widget by the given identifier, that can have an info button attached and a fixed options array.
 */
+(ComboboxWidget *) createComboboxWidgetWithIdentifier: (NSString *) identifier options: (NSArray *) options hasInfoButton: (BOOL) hasInfoButton
{
    ComboboxWidget *comboboxWidget = [self createComboboxWidgetWithIdentifier: identifier hasDatePicker: NO hasTimePicker: NO hasInfoButton: hasInfoButton];
    [comboboxWidget setHasStaticContent: YES];
    [comboboxWidget setOptions: [NSMutableArray arrayWithArray: options]];
    
    return comboboxWidget;
}

/*
*	Creates a combobox widget by the given identifier, that can have a data or time picker and info button attached.
*/
+(ComboboxWidget *) createComboboxWidgetWithIdentifier: (NSString *) identifier hasDatePicker: (BOOL) hasDatePicker hasTimePicker: (BOOL) hasTimePicker hasInfoButton: (BOOL) hasInfoButton
{
    ComboboxWidget *comboboxWidget = [[ComboboxWidget alloc] init];
    
    comboboxWidget.identifier = identifier;
    [comboboxWidget setLabelDisabled: NO];
    comboboxWidget.hasInfoButton = hasInfoButton;
    if (hasInfoButton)
        comboboxWidget.infoText = LocalizedString(identifier, @"Info");
    comboboxWidget.hasDatePicker = hasDatePicker;
    comboboxWidget.hasTimePicker = hasTimePicker;
    
    return comboboxWidget;
}

#pragma mark TextFieldWidget Factory Methods

/*
*	Creates a text input (no label) by the given identifier, that can have an info button attached.
*/
+(TextFieldWidget *) createTextInputWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton
{
    TextFieldWidget *textFieldWidget = [self createTextFieldWidgetWithIdentifier: identifier hasInfoButton: hasInfoButton];
    [textFieldWidget setLabelDisabled: YES];
    return textFieldWidget;
}

/*
*	Creates a text input widget by the given identifier, that can have an info button attached.
*/
+(TextFieldWidget *) createTextFieldWidgetWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton
{
    TextFieldWidget *textFieldWidget = [[TextFieldWidget alloc] init];
    
    textFieldWidget.identifier = identifier;
    textFieldWidget.hasInfoButton = hasInfoButton;
    if (hasInfoButton)
        textFieldWidget.infoText = LocalizedString(identifier, @"Info");
    
    textFieldWidget.validation = [[WidgetValidation alloc] init];
    
    return textFieldWidget;
}

#pragma mark CheckboxWidget Factory Methods

/*
*	Creates an checkbox widget by the given identifier and sub-widgets, that can have an info button attached.
*/
+(CheckboxWidget *) createCheckboxWidgetWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton
{
    CheckboxWidget *checkboxWidget = [[CheckboxWidget alloc] init];
    
    checkboxWidget.identifier = identifier;
    checkboxWidget.hasInfoButton = hasInfoButton;
    if (hasInfoButton)
        checkboxWidget.infoText = LocalizedString(identifier, @"Info");
    
    return checkboxWidget;
}

#pragma mark EntitySelectorWidget Factory Methods

/*
 *	Creates an entity selector widget by the given identifier and sub-widgets, that can have an info button attached.
 */
+(EntitySelectorWidget *) createEntitySelectorWidgetWithIdentifier: (NSString *) identifier textProposition: (NSString *) textProposition hasInfoButton: (BOOL) hasInfoButton
{
    EntitySelectorWidget *entitySelectorWidget = [[EntitySelectorWidget alloc] init];
    
    entitySelectorWidget.identifier = identifier;
    entitySelectorWidget.comboboxWidget.identifier = identifier;
    entitySelectorWidget.textProposition = textProposition;
    entitySelectorWidget.hasInfoButton = hasInfoButton;
    if (hasInfoButton)
        entitySelectorWidget.infoText = LocalizedString(identifier, @"Info");
    
    return entitySelectorWidget;
}

#pragma mark LabelWidget Factory Methods

/*
*	Creates a label widget by the given identifier, that can have an info button attached.
*/
+(LabelWidget *) createLabelWidgetWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton
{
    LabelWidget *labelWidget = [[LabelWidget alloc] init];
    
    labelWidget.identifier = identifier;
    labelWidget.hasInfoButton = hasInfoButton;
    if (hasInfoButton)
        labelWidget.infoText = LocalizedString(identifier, @"Info");
    
    return labelWidget;
}

/*
*	Creates a spacer by the given identifier, that can have an info button attached.
*/
+(SpacerWidget *) createSpacerWidgetWithIdentifier: (NSString *) identifier hasInfoButton: (BOOL) hasInfoButton
{
    SpacerWidget *spacerWidget = [[SpacerWidget alloc] init];
    spacerWidget.identifier = identifier;
    spacerWidget.hasInfoButton = hasInfoButton;
    if (hasInfoButton)
        spacerWidget.infoText = LocalizedString(identifier, @"Info");
    
    return spacerWidget;
}

/*
 *	Creates a button widget by the given identifier.
 */
+(ButtonWidget *) createButtonWidgetWithIdentifier: (NSString *) identifier
{
    ButtonWidget *buttonWidget = [[ButtonWidget alloc] init];
    buttonWidget.identifier = identifier;
    
    return buttonWidget;
}

/*
 *	Creates a button widget by the given identifier.
 */
+(ImageWidget *) createImageWidgetWithIdentifier: (NSString *) identifier imageName: (NSString *) imageName
{
    ImageWidget *imageWidget = [[ImageWidget alloc] init];
    imageWidget.identifier = identifier;
    imageWidget.imageName = imageName;
    
    return imageWidget;
}

@end