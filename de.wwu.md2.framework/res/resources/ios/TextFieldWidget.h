// static: Widgets
//
//  TextFieldWidget.h
//  Tarifrechner
//
//  Created by Uni Münster on 17.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Widget.h"
#import "EventHandler.h"

@interface TextFieldWidget : Widget <EventHandlerTextFieldDelegate>
{
    UITextField *textField;
    NSString *displayText;
    
    BOOL isLabelDisabled;
    BOOL isPartOfCombobox;
    
    EventHandler *eventHandler;
}

@property (retain, nonatomic) UITextField *textField;
@property (assign, nonatomic) BOOL isPartOfCombobox;

-(void) setLabelDisabled: (BOOL) _isLabelDisabled;

@end