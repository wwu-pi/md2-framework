// static: Views
//
//  PickerView.h
//  TariffCalculator
//
//	The PickerView represents the data or custom picker for comboboxes and combobox widgets.
//
//  Created by Uni Muenster on 30.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "View.h"
#import "ComboboxWidget.h"

@interface PickerView : View <UIPickerViewDataSource, UIPickerViewDelegate, ComboboxWidgetPickerDelegate, EventHandlerPopoverDelegate>
{
    UIView *pickerMainView;
    UIPickerView *pickerView;
    UIDatePicker *datePickerView;
    
    UINavigationBar *navigationBar;
    UINavigationItem *navigationBarItem;
    UIBarButtonItem *editButton;
    UIBarButtonItem *backButton;
    
    BOOL isEditable;
    
    NSMutableArray *pickerOptions;
    NSDate *date;
    
    EventHandler *popoverEventHandler;
    ComboboxWidget *comboboxWidget;
}

@property (assign, nonatomic) BOOL isEditable;

-(void) setComboboxWidget: (ComboboxWidget *) comboboxWidget;

@end