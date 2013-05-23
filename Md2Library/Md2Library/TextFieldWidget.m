// static: Widgets
//
//  TextFieldWidget.m
//  Tarifrechner
//
//  Created by Uni Münster on 17.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "TextFieldWidget.h"
#import "InfoWidget.h"

@implementation TextFieldWidget

@synthesize textField, isPartOfCombobox;

-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        eventHandler = [EventHandler instance];
        [eventHandler setEventHandlerTextFieldDelegate: self];
        
        [self loadWidget];
    }
    return self;
}

-(void) loadWidget
{
    [super loadWidget];
    
    textField = [[UITextField alloc] initWithFrame: TextFieldWidgetFrame(self.frame)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize: 15];
    textField.placeholder = displayText;
    textField.text = displayText;
    textField.textColor = [UIColor blackColor];
    textField.backgroundColor = [UIColor whiteColor];
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [textField setUserInteractionEnabled: YES];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [textField addTarget: self action: @selector(editingDidChanged:) forControlEvents: UIControlEventEditingChanged];
    [textField addTarget: self action: @selector(editingDidEnd:) forControlEvents: UIControlEventEditingDidEnd];
    
    [self addSubview: textField];
    
    [self loadInfoButton];
}

-(void) setData: (NSString *) _data
{
    [super setData: _data];
    displayText = data;
    [textField setText: data];
    
    if (!isPartOfCombobox)
    {
        NSNumber *number = [DataConverter getNumberByString: data];
        if (number != nil)
            textField.keyboardType = UIKeyboardTypeNumberPad;
        else
            textField.keyboardType = UIKeyboardTypeDefault;
    }
}

-(void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    if (!isPartOfCombobox)
    {
        [textField setFrame: TextFieldFrame(frame)];
        if (isLabelDisabled)
            [self setLabelDisabled: isLabelDisabled];
    }
    else
    {
        [textField setFrame: ComboboxTextFieldFrame(frame)];
        [self setLabelHidden: YES];
    }
}

-(void) setLabelDisabled: (BOOL) _isLabelDisabled
{
    isLabelDisabled = _isLabelDisabled;
    if (_isLabelDisabled)
    {
        [textField setFrame: TextFieldDisabledLabelFrame(self.frame)];
        label = nil;
    }
}

-(void) setEnabled: (BOOL) isEnabled
{
    [super setEnabled: isEnabled];
    [textField setEnabled: isEnabled];
    textField.textColor = (isEnabled)? [UIColor blackColor]: [UIColor lightGrayColor];
}

#pragma mark EventHandlerTextFieldDelegate Methods

-(void) textFieldEditingChanged: (TextFieldEditingChangedEvent *) event
{
    [eventHandler textFieldEditingChanged: event];
}

#pragma mark - Actions

-(IBAction) editingDidChanged: (UITextField *) _textField
{
    data = textField.text;
}

-(IBAction) editingDidEnd: (UITextField *) _textField
{
    if (!isPartOfCombobox)
    {
        BOOL validatorCheck = [validation checkAllValidatorsByStringData: textField.text];
        [self setData: textField.text];
        if (!validatorCheck)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: LocalizedKeyString(@"val_failed") message: validation.errorMessage delegate: nil cancelButtonTitle: LocalizedKeyString(@"val_button_failed") otherButtonTitles: nil];
            [alert show];
            textField.backgroundColor = [UIColor redColor];
        }
        else
        {
            [self persistData];
        }
    }
}

-(void) persistData
{
    [super persistData];
    textField.backgroundColor = [UIColor whiteColor];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *textFieldNumberText = [numberFormatter numberFromString: textField.text];
    BOOL isDecimal = (textFieldNumberText != nil);
    
    if (isDecimal)
        [self textFieldEditingChanged: [TextFieldEditingChangedEvent eventWithIdentifier: identifier text: textFieldNumberText]];
    else
        [self textFieldEditingChanged: [TextFieldEditingChangedEvent eventWithIdentifier: identifier text: textField.text]];
}

@end